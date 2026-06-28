package com.shop.controller;

import com.shop.common.result.Result;
import com.shop.dto.CartAddDTO;
import com.shop.dto.CartUpdateDTO;
import com.shop.service.CartService;
import com.shop.vo.CartVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/cart")
@RequiredArgsConstructor
public class CartController {

    private final CartService cartService;

    @GetMapping
    public Result<List<CartVO>> list(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(cartService.getCartList(userId));
    }

    @PostMapping
    public Result<CartVO> add(HttpServletRequest request, @Valid @RequestBody CartAddDTO dto) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(cartService.addCart(userId, dto));
    }

    @PutMapping("/{id}")
    public Result<CartVO> update(HttpServletRequest request, @PathVariable Long id, @Valid @RequestBody CartUpdateDTO dto) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(cartService.updateCart(userId, id, dto));
    }

    @DeleteMapping("/{id}")
    public Result<Void> remove(HttpServletRequest request, @PathVariable Long id) {
        Long userId = (Long) request.getAttribute("userId");
        cartService.removeCart(userId, id);
        return Result.success();
    }
}
