package com.shop.controller;

import com.shop.common.result.Result;
import com.shop.dto.UserUpdateDTO;
import com.shop.service.UserService;
import com.shop.vo.UserVO;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/me")
    public Result<UserVO> getProfile(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(userService.getUserInfo(userId));
    }

    @PutMapping("/me")
    public Result<UserVO> updateProfile(HttpServletRequest request, @RequestBody UserUpdateDTO dto) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(userService.updateUser(userId, dto));
    }
}
