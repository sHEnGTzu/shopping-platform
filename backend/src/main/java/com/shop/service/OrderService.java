package com.shop.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.shop.dto.OrderCreateDTO;
import com.shop.entity.Order;
import com.shop.vo.OrderVO;

public interface OrderService extends IService<Order> {
    OrderVO createOrder(Long userId, OrderCreateDTO dto);
    IPage<OrderVO> getOrderPage(Long userId, Integer pageNum, Integer pageSize, Integer status);
    OrderVO getOrderDetail(Long userId, Long orderId);
    void cancelOrder(Long userId, Long orderId);
    void payOrder(Long userId, Long orderId);
    void confirmReceipt(Long userId, Long orderId);
    IPage<OrderVO> getAdminPage(String role, Long userId, Integer pageNum, Integer pageSize, Integer status);
    IPage<OrderVO> getMerchantOrderPage(Long userId, Integer pageNum, Integer pageSize, Integer status);
    OrderVO getMerchantOrderDetail(Long userId, Long orderId);
    void shipOrder(Long userId, Long orderId);
    void updateOrderStatus(String role, Long orderId, Integer status);
    OrderVO getAdminOrderDetail(String role, Long orderId);
}
