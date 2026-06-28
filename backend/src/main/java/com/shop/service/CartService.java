package com.shop.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.shop.dto.CartAddDTO;
import com.shop.dto.CartUpdateDTO;
import com.shop.entity.Cart;
import com.shop.vo.CartVO;

import java.util.List;

public interface CartService extends IService<Cart> {
    List<CartVO> getCartList(Long userId);
    CartVO addCart(Long userId, CartAddDTO dto);
    CartVO updateCart(Long userId, Long cartId, CartUpdateDTO dto);
    void removeCart(Long userId, Long cartId);
}
