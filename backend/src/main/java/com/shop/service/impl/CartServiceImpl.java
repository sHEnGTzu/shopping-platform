package com.shop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shop.dto.CartAddDTO;
import com.shop.dto.CartUpdateDTO;
import com.shop.entity.Cart;
import com.shop.entity.Product;
import com.shop.exception.BusinessException;
import com.shop.mapper.CartMapper;
import com.shop.mapper.ProductMapper;
import com.shop.service.CartService;
import com.shop.vo.CartVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CartServiceImpl extends ServiceImpl<CartMapper, Cart> implements CartService {

    private final ProductMapper productMapper;

    @Override
    public List<CartVO> getCartList(Long userId) {
        List<Cart> carts = list(new LambdaQueryWrapper<Cart>()
                .eq(Cart::getUserId, userId));
        return carts.stream().map(this::toCartVO).collect(Collectors.toList());
    }

    @Override
    public CartVO addCart(Long userId, CartAddDTO dto) {
        Product product = productMapper.selectById(dto.getProductId());
        if (product == null) {
            throw BusinessException.notFound("商品不存在");
        }
        if (product.getStock() <= 0) {
            throw BusinessException.badRequest("商品已售罄");
        }

        Cart existing = getOne(new LambdaQueryWrapper<Cart>()
                .eq(Cart::getUserId, userId)
                .eq(Cart::getProductId, dto.getProductId()));
        if (existing != null) {
            existing.setQuantity(existing.getQuantity() + dto.getQuantity());
            if (existing.getQuantity() > product.getStock()) {
                throw BusinessException.badRequest("超出商品库存");
            }
            updateById(existing);
            return toCartVO(existing);
        }

        if (dto.getQuantity() > product.getStock()) {
            throw BusinessException.badRequest("超出商品库存");
        }

        Cart cart = new Cart();
        cart.setUserId(userId);
        cart.setProductId(dto.getProductId());
        cart.setQuantity(dto.getQuantity());
        save(cart);
        return toCartVO(cart);
    }

    @Override
    public CartVO updateCart(Long userId, Long cartId, CartUpdateDTO dto) {
        Cart cart = getById(cartId);
        if (cart == null || !cart.getUserId().equals(userId)) {
            throw BusinessException.notFound("购物车记录不存在");
        }
        Product product = productMapper.selectById(cart.getProductId());
        if (dto.getQuantity() > product.getStock()) {
            throw BusinessException.badRequest("超出商品库存");
        }
        cart.setQuantity(dto.getQuantity());
        updateById(cart);
        return toCartVO(cart);
    }

    @Override
    public void removeCart(Long userId, Long cartId) {
        Cart cart = getById(cartId);
        if (cart == null || !cart.getUserId().equals(userId)) {
            throw BusinessException.notFound("购物车记录不存在");
        }
        removeById(cartId);
    }

    private CartVO toCartVO(Cart cart) {
        Product product = productMapper.selectById(cart.getProductId());
        CartVO vo = new CartVO();
        vo.setId(cart.getId());
        vo.setProductId(cart.getProductId());
        vo.setQuantity(cart.getQuantity());
        if (product != null) {
            vo.setProductName(product.getName());
            vo.setProductImage(product.getImage());
            vo.setPrice(product.getPrice());
            vo.setStock(product.getStock());
        }
        return vo;
    }
}
