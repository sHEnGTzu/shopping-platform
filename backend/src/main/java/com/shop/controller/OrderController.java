package com.shop.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.shop.common.result.PageResult;
import com.shop.common.result.Result;
import com.shop.dto.OrderCreateDTO;
import com.shop.service.OrderService;
import com.shop.vo.OrderVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/orders")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    @PostMapping
    public Result<OrderVO> create(HttpServletRequest request, @Valid @RequestBody OrderCreateDTO dto) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(orderService.createOrder(userId, dto));
    }

    @GetMapping
    public Result<PageResult<OrderVO>> page(HttpServletRequest request,
                                            @RequestParam(defaultValue = "1") Integer pageNum,
                                            @RequestParam(defaultValue = "10") Integer pageSize,
                                            @RequestParam(required = false) Integer status) {
        Long userId = (Long) request.getAttribute("userId");
        IPage<OrderVO> page = orderService.getOrderPage(userId, pageNum, pageSize, status);
        return Result.success(PageResult.of(page));
    }

    @GetMapping("/{id}")
    public Result<OrderVO> detail(HttpServletRequest request, @PathVariable Long id) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(orderService.getOrderDetail(userId, id));
    }

    @PutMapping("/{id}/cancel")
    public Result<Void> cancel(HttpServletRequest request, @PathVariable Long id) {
        Long userId = (Long) request.getAttribute("userId");
        orderService.cancelOrder(userId, id);
        return Result.success();
    }

    @PutMapping("/{id}/pay")
    public Result<Void> pay(HttpServletRequest request, @PathVariable Long id) {
        Long userId = (Long) request.getAttribute("userId");
        orderService.payOrder(userId, id);
        return Result.success();
    }

    @PutMapping("/{id}/confirm")
    public Result<Void> confirm(HttpServletRequest request, @PathVariable Long id) {
        Long userId = (Long) request.getAttribute("userId");
        orderService.confirmReceipt(userId, id);
        return Result.success();
    }

    @GetMapping("/admin/page")
    public Result<PageResult<OrderVO>> adminPage(HttpServletRequest request,
                                                  @RequestParam(defaultValue = "1") Integer pageNum,
                                                  @RequestParam(defaultValue = "10") Integer pageSize,
                                                  @RequestParam(required = false) Integer status) {
        String role = (String) request.getAttribute("role");
        Long userId = (Long) request.getAttribute("userId");
        IPage<OrderVO> page = orderService.getAdminPage(role, userId, pageNum, pageSize, status);
        return Result.success(PageResult.of(page));
    }

    @GetMapping("/merchant/page")
    public Result<PageResult<OrderVO>> merchantPage(HttpServletRequest request,
                                                     @RequestParam(defaultValue = "1") Integer pageNum,
                                                     @RequestParam(defaultValue = "10") Integer pageSize,
                                                     @RequestParam(required = false) Integer status) {
        Long userId = (Long) request.getAttribute("userId");
        IPage<OrderVO> page = orderService.getMerchantOrderPage(userId, pageNum, pageSize, status);
        return Result.success(PageResult.of(page));
    }

    @GetMapping("/merchant/{id}")
    public Result<OrderVO> merchantDetail(HttpServletRequest request, @PathVariable Long id) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(orderService.getMerchantOrderDetail(userId, id));
    }

    @PutMapping("/merchant/{id}/ship")
    public Result<Void> ship(HttpServletRequest request, @PathVariable Long id) {
        Long userId = (Long) request.getAttribute("userId");
        orderService.shipOrder(userId, id);
        return Result.success();
    }

    @GetMapping("/admin/{id}")
    public Result<OrderVO> adminDetail(HttpServletRequest request, @PathVariable Long id) {
        String role = (String) request.getAttribute("role");
        return Result.success(orderService.getAdminOrderDetail(role, id));
    }

    @PutMapping("/admin/{id}/status")
    public Result<Void> updateStatus(HttpServletRequest request, @PathVariable Long id,
                                     @RequestParam Integer status) {
        String role = (String) request.getAttribute("role");
        orderService.updateOrderStatus(role, id, status);
        return Result.success();
    }
}
