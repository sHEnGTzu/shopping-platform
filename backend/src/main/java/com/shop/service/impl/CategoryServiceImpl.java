package com.shop.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shop.entity.Category;
import com.shop.mapper.CategoryMapper;
import com.shop.service.CategoryService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryServiceImpl extends ServiceImpl<CategoryMapper, Category> implements CategoryService {

    @Override
    public List<Category> getAll() {
        return list();
    }
}
