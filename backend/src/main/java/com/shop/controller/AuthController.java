package com.shop.controller;

import com.shop.common.result.Result;
import com.shop.dto.LoginDTO;
import com.shop.dto.RegisterDTO;
import com.shop.service.UserService;
import com.shop.vo.LoginVO;
import com.shop.vo.UserVO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;

    @PostMapping("/login")
    public Result<LoginVO> login(@Valid @RequestBody LoginDTO dto) {
        return Result.success(userService.login(dto));
    }

    @PostMapping("/register")
    public Result<UserVO> register(@Valid @RequestBody RegisterDTO dto) {
        return Result.success(userService.register(dto));
    }
}
