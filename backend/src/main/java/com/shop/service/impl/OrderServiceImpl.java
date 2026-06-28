package com.shop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shop.dto.OrderCreateDTO;
import com.shop.entity.Cart;
import com.shop.entity.Order;
import com.shop.entity.OrderItem;
import com.shop.entity.Product;
import com.shop.enums.OrderStatus;
import com.shop.exception.BusinessException;
import com.shop.mapper.CartMapper;
import com.shop.mapper.OrderItemMapper;
import com.shop.mapper.OrderMapper;
import com.shop.mapper.ProductMapper;
import com.shop.service.OrderService;
import com.shop.vo.OrderItemVO;
import com.shop.vo.OrderVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class OrderServiceImpl extends ServiceImpl<OrderMapper, Order> implements OrderService {

    private final CartMapper cartMapper;
    private final ProductMapper productMapper;
    private final OrderItemMapper orderItemMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public OrderVO createOrder(Long userId, OrderCreateDTO dto) {
        List<Cart> carts = cartMapper.selectBatchIds(dto.getCartItemIds());
        if (carts.isEmpty()) {
            throw BusinessException.badRequest("购物车记录不存在");
        }

        for (Cart cart : carts) {
            if (!cart.getUserId().equals(userId)) {
                throw BusinessException.badRequest("购物车记录不属于当前用户");
            }
        }

        BigDecimal totalAmount = BigDecimal.ZERO;
        for (Cart cart : carts) {
            Product product = productMapper.selectById(cart.getProductId());
            if (product == null) {
                throw BusinessException.notFound("商品不存在: " + cart.getProductId());
            }
            if (product.getStock() < cart.getQuantity()) {
                throw BusinessException.badRequest("商品库存不足: " + product.getName());
            }
            totalAmount = totalAmount.add(product.getPrice().multiply(BigDecimal.valueOf(cart.getQuantity())));
        }

        String orderNo = generateOrderNo();

        Order order = new Order();
        order.setOrderNo(orderNo);
        order.setUserId(userId);
        order.setTotalAmount(totalAmount);
        order.setStatus(OrderStatus.PENDING_PAYMENT.getCode());
        order.setAddress(dto.getAddress());
        order.setRemark(dto.getRemark());
        save(order);

        for (Cart cart : carts) {
            Product product = productMapper.selectById(cart.getProductId());

            product.setStock(product.getStock() - cart.getQuantity());
            product.setSales(product.getSales() + cart.getQuantity());
            productMapper.updateById(product);

            OrderItem item = new OrderItem();
            item.setOrderId(order.getId());
            item.setProductId(product.getId());
            item.setProductName(product.getName());
            item.setProductImage(product.getImage());
            item.setPrice(product.getPrice());
            item.setQuantity(cart.getQuantity());
            orderItemMapper.insert(item);

            cartMapper.deleteById(cart.getId());
        }

        return toOrderVO(order);
    }

    @Override
    public IPage<OrderVO> getOrderPage(Long userId, Integer pageNum, Integer pageSize, Integer status) {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<Order>()
                .eq(Order::getUserId, userId)
                .eq(status != null, Order::getStatus, status)
                .orderBy(true, false, Order::getCreatedAt);

        IPage<Order> page = page(new Page<>(pageNum, pageSize), wrapper);
        return page.convert(this::toOrderVO);
    }

    @Override
    public OrderVO getOrderDetail(Long userId, Long orderId) {
        Order order = getById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw BusinessException.notFound("订单不存在");
        }
        return toOrderVO(order);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancelOrder(Long userId, Long orderId) {
        Order order = getById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw BusinessException.notFound("订单不存在");
        }
        if (order.getStatus() != OrderStatus.PENDING_PAYMENT.getCode()) {
            throw BusinessException.badRequest("只能取消待支付的订单");
        }
        order.setStatus(OrderStatus.CANCELLED.getCode());
        updateById(order);

        restoreStock(orderId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void payOrder(Long userId, Long orderId) {
        Order order = getById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw BusinessException.notFound("订单不存在");
        }
        if (order.getStatus() != OrderStatus.PENDING_PAYMENT.getCode()) {
            throw BusinessException.badRequest("只能支付待支付的订单");
        }
        order.setStatus(OrderStatus.PAID.getCode());
        updateById(order);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void confirmReceipt(Long userId, Long orderId) {
        Order order = getById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw BusinessException.notFound("订单不存在");
        }
        if (order.getStatus() != OrderStatus.SHIPPED.getCode()) {
            throw BusinessException.badRequest("只能确认已发货的订单");
        }
        order.setStatus(OrderStatus.COMPLETED.getCode());
        updateById(order);
    }

    @Override
    public IPage<OrderVO> getAdminPage(String role, Long userId, Integer pageNum, Integer pageSize, Integer status) {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<Order>()
                .orderBy(true, false, Order::getCreatedAt);

        if (!"admin".equals(role)) {
            throw BusinessException.forbidden("无权限查看所有订单");
        }

        if (status != null) {
            wrapper.eq(Order::getStatus, status);
        }

        IPage<Order> page = page(new Page<>(pageNum, pageSize), wrapper);
        return page.convert(this::toOrderVO);
    }

    @Override
    public IPage<OrderVO> getMerchantOrderPage(Long userId, Integer pageNum, Integer pageSize, Integer status) {
        List<Long> productIds = productMapper.selectList(
                new LambdaQueryWrapper<Product>().eq(Product::getUserId, userId))
                .stream().map(Product::getId).collect(Collectors.toList());

        if (productIds.isEmpty()) {
            return new Page<>(pageNum, pageSize);
        }

        List<Long> orderIds = orderItemMapper.selectList(
                new LambdaQueryWrapper<OrderItem>().in(OrderItem::getProductId, productIds))
                .stream().map(OrderItem::getOrderId).distinct().collect(Collectors.toList());

        if (orderIds.isEmpty()) {
            return new Page<>(pageNum, pageSize);
        }

        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<Order>()
                .in(Order::getId, orderIds)
                .eq(status != null, Order::getStatus, status)
                .orderBy(true, false, Order::getCreatedAt);

        IPage<Order> page = page(new Page<>(pageNum, pageSize), wrapper);
        return page.convert(this::toOrderVO);
    }

    @Override
    public OrderVO getMerchantOrderDetail(Long userId, Long orderId) {
        Order order = getById(orderId);
        if (order == null) {
            throw BusinessException.notFound("订单不存在");
        }
        boolean hasProduct = orderItemMapper.selectList(
                new LambdaQueryWrapper<OrderItem>()
                        .eq(OrderItem::getOrderId, orderId)
                        .inSql(OrderItem::getProductId,
                                "SELECT id FROM products WHERE user_id = " + userId))
                .size() > 0;
        if (!hasProduct) {
            throw BusinessException.forbidden("无权查看此订单");
        }
        return toOrderVO(order);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void shipOrder(Long userId, Long orderId) {
        Order order = getById(orderId);
        if (order == null) {
            throw BusinessException.notFound("订单不存在");
        }
        if (order.getStatus() != OrderStatus.PAID.getCode()) {
            throw BusinessException.badRequest("只能发货已支付的订单");
        }
        boolean hasProduct = orderItemMapper.selectList(
                new LambdaQueryWrapper<OrderItem>()
                        .eq(OrderItem::getOrderId, orderId)
                        .inSql(OrderItem::getProductId,
                                "SELECT id FROM products WHERE user_id = " + userId))
                .size() > 0;
        if (!hasProduct) {
            throw BusinessException.forbidden("无权发货此订单");
        }
        order.setStatus(OrderStatus.SHIPPED.getCode());
        updateById(order);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateOrderStatus(String role, Long orderId, Integer status) {
        if (!"admin".equals(role)) {
            throw BusinessException.forbidden("无权限修改订单状态");
        }
        Order order = getById(orderId);
        if (order == null) {
            throw BusinessException.notFound("订单不存在");
        }
        order.setStatus(status);
        updateById(order);
    }

    @Override
    public OrderVO getAdminOrderDetail(String role, Long orderId) {
        if (!"admin".equals(role)) {
            throw BusinessException.forbidden("无权限查看");
        }
        Order order = getById(orderId);
        if (order == null) {
            throw BusinessException.notFound("订单不存在");
        }
        return toOrderVO(order);
    }

    private void restoreStock(Long orderId) {
        List<OrderItem> items = orderItemMapper.selectList(
                new LambdaQueryWrapper<OrderItem>().eq(OrderItem::getOrderId, orderId));
        for (OrderItem item : items) {
            Product product = productMapper.selectById(item.getProductId());
            if (product != null) {
                product.setStock(product.getStock() + item.getQuantity());
                product.setSales(product.getSales() - item.getQuantity());
                productMapper.updateById(product);
            }
        }
    }

    private OrderVO toOrderVO(Order order) {
        OrderVO vo = new OrderVO();
        vo.setId(order.getId());
        vo.setOrderNo(order.getOrderNo());
        vo.setTotalAmount(order.getTotalAmount());
        vo.setStatus(order.getStatus());
        vo.setStatusDesc(OrderStatus.fromCode(order.getStatus()).getDesc());
        vo.setAddress(order.getAddress());
        vo.setRemark(order.getRemark());
        vo.setCreatedAt(order.getCreatedAt());

        List<OrderItem> items = orderItemMapper.selectList(
                new LambdaQueryWrapper<OrderItem>().eq(OrderItem::getOrderId, order.getId()));
        vo.setItems(items.stream().map(item -> {
            OrderItemVO itemVO = new OrderItemVO();
            itemVO.setId(item.getId());
            itemVO.setProductId(item.getProductId());
            itemVO.setProductName(item.getProductName());
            itemVO.setProductImage(item.getProductImage());
            itemVO.setPrice(item.getPrice());
            itemVO.setQuantity(item.getQuantity());
            return itemVO;
        }).collect(Collectors.toList()));

        return vo;
    }

    private String generateOrderNo() {
        LocalDateTime now = LocalDateTime.now();
        String datePart = now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        int rand = new Random().nextInt(10000);
        return "ORD" + datePart + String.format("%04d", rand);
    }
}
