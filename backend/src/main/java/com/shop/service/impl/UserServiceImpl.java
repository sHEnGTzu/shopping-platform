package com.shop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shop.common.JwtUtil;
import com.shop.dto.LoginDTO;
import com.shop.dto.RegisterDTO;
import com.shop.dto.UserUpdateDTO;
import com.shop.entity.User;
import com.shop.exception.BusinessException;
import com.shop.mapper.UserMapper;
import com.shop.service.UserService;
import com.shop.vo.LoginVO;
import com.shop.vo.UserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    private final JwtUtil jwtUtil;

    @Override
    public LoginVO login(LoginDTO dto) {
        User user = getOne(new LambdaQueryWrapper<User>()
                .eq(User::getUsername, dto.getUsername()));
        if (user == null) {
            throw BusinessException.badRequest("用户名或密码错误");
        }
        if (!user.getPassword().equals(dto.getPassword())) {
            throw BusinessException.badRequest("用户名或密码错误");
        }
        String token = jwtUtil.generateToken(user.getId(), user.getUsername(), user.getRole());
        return new LoginVO(token, toUserVO(user));
    }

    @Override
    public UserVO register(RegisterDTO dto) {
        Long count = getCount(new LambdaQueryWrapper<User>()
                .eq(User::getUsername, dto.getUsername()));
        if (count > 0) {
            throw BusinessException.badRequest("用户名已存在");
        }
        User user = new User();
        user.setUsername(dto.getUsername());
        user.setPassword(dto.getPassword());
        user.setEmail(dto.getEmail());
        user.setPhone(dto.getPhone());
        String role = dto.getRole();
        if (role == null || (!role.equals("admin") && !role.equals("merchant") && !role.equals("buyer"))) {
            role = "buyer";
        }
        user.setRole(role);
        save(user);
        return toUserVO(user);
    }

    @Override
    public UserVO getUserInfo(Long userId) {
        User user = getById(userId);
        if (user == null) {
            throw BusinessException.notFound("用户不存在");
        }
        return toUserVO(user);
    }

    @Override
    public UserVO updateUser(Long userId, UserUpdateDTO dto) {
        User user = getById(userId);
        if (user == null) {
            throw BusinessException.notFound("用户不存在");
        }
        if (dto.getEmail() != null) user.setEmail(dto.getEmail());
        if (dto.getPhone() != null) user.setPhone(dto.getPhone());
        if (dto.getAvatar() != null) user.setAvatar(dto.getAvatar());
        updateById(user);
        return toUserVO(user);
    }

    private Long getCount(LambdaQueryWrapper<User> wrapper) {
        return count(wrapper);
    }

    private UserVO toUserVO(User user) {
        UserVO vo = new UserVO();
        vo.setId(user.getId());
        vo.setUsername(user.getUsername());
        vo.setEmail(user.getEmail());
        vo.setPhone(user.getPhone());
        vo.setAvatar(user.getAvatar());
        vo.setRole(user.getRole());
        vo.setCreatedAt(user.getCreatedAt());
        return vo;
    }
}
