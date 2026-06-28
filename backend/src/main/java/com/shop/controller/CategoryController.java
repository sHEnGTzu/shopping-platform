package com.shop.controller;

import com.shop.common.result.Result;
import com.shop.entity.Category;
import com.shop.service.CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/categories")
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryService categoryService;

    @GetMapping
    public Result<List<Category>> getAll() {
        return Result.success(categoryService.getAll());
    }
}
