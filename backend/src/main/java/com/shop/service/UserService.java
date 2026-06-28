package com.shop.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.shop.dto.LoginDTO;
import com.shop.dto.RegisterDTO;
import com.shop.dto.UserUpdateDTO;
import com.shop.entity.User;
import com.shop.vo.LoginVO;
import com.shop.vo.UserVO;

public interface UserService extends IService<User> {
    LoginVO login(LoginDTO dto);
    UserVO register(RegisterDTO dto);
    UserVO getUserInfo(Long userId);
    UserVO updateUser(Long userId, UserUpdateDTO dto);
}
