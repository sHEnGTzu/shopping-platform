package com.shop.common;

import com.shop.exception.BusinessException;
import io.jsonwebtoken.Claims;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
@RequiredArgsConstructor
public class JwtInterceptor implements HandlerInterceptor {

    private final JwtUtil jwtUtil;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        if ("OPTIONS".equals(request.getMethod())) {
            return true;
        }

        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            throw BusinessException.unauthorized("未登录或token已过期");
        }

        String token = authHeader.substring(7);
        if (!jwtUtil.validateToken(token)) {
            throw BusinessException.unauthorized("token无效或已过期");
        }

        Claims claims = jwtUtil.parseToken(token);
        request.setAttribute("userId", Long.parseLong(claims.getSubject()));
        request.setAttribute("username", claims.get("username"));
        request.setAttribute("role", claims.get("role", String.class));
        return true;
    }
}
