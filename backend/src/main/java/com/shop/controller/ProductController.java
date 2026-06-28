package com.shop.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.shop.common.result.PageResult;
import com.shop.common.result.Result;
import com.shop.dto.ProductQueryDTO;
import com.shop.dto.ProductSaveDTO;
import com.shop.service.ProductService;
import com.shop.vo.ProductVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/products")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;

    @GetMapping("/page")
    public Result<PageResult<ProductVO>> getPage(ProductQueryDTO dto) {
        IPage<ProductVO> page = productService.getPage(dto);
        return Result.success(PageResult.of(page));
    }

    @GetMapping("/detail/{id}")
    public Result<ProductVO> getDetail(@PathVariable Long id) {
        return Result.success(productService.getDetail(id));
    }

    @GetMapping("/manage/page")
    public Result<PageResult<ProductVO>> getManagePage(HttpServletRequest request,
                                                       @RequestParam(defaultValue = "1") Integer pageNum,
                                                       @RequestParam(defaultValue = "10") Integer pageSize) {
        Long userId = (Long) request.getAttribute("userId");
        String role = (String) request.getAttribute("role");
        IPage<ProductVO> page = productService.getManagePage(userId, role, pageNum, pageSize);
        return Result.success(PageResult.of(page));
    }

    @PostMapping("/manage")
    public Result<Long> create(HttpServletRequest request, @Valid @RequestBody ProductSaveDTO dto) {
        Long userId = (Long) request.getAttribute("userId");
        String role = (String) request.getAttribute("role");
        Long id = productService.createProduct(userId, role, dto);
        return Result.success(id);
    }

    @PutMapping("/manage/{id}")
    public Result<Void> update(HttpServletRequest request, @PathVariable Long id,
                               @Valid @RequestBody ProductSaveDTO dto) {
        Long userId = (Long) request.getAttribute("userId");
        String role = (String) request.getAttribute("role");
        productService.updateProduct(userId, role, id, dto);
        return Result.success();
    }

    @DeleteMapping("/manage/{id}")
    public Result<Void> delete(HttpServletRequest request, @PathVariable Long id) {
        Long userId = (Long) request.getAttribute("userId");
        String role = (String) request.getAttribute("role");
        productService.deleteProduct(userId, role, id);
        return Result.success();
    }
}
