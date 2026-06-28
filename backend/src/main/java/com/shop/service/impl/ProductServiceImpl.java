package com.shop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shop.dto.ProductQueryDTO;
import com.shop.dto.ProductSaveDTO;
import com.shop.entity.Category;
import com.shop.entity.Product;
import com.shop.exception.BusinessException;
import com.shop.entity.User;
import com.shop.mapper.CategoryMapper;
import com.shop.mapper.ProductMapper;
import com.shop.mapper.UserMapper;
import com.shop.service.ProductService;
import com.shop.vo.ProductVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProductServiceImpl extends ServiceImpl<ProductMapper, Product> implements ProductService {

    private final CategoryMapper categoryMapper;
    private final UserMapper userMapper;

    @Override
    public IPage<ProductVO> getPage(ProductQueryDTO dto) {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<Product>()
                .eq(dto.getCategoryId() != null, Product::getCategoryId, dto.getCategoryId())
                .like(StringUtils.hasText(dto.getKeyword()), Product::getName, dto.getKeyword());

        if ("price".equals(dto.getSortBy())) {
            wrapper.orderBy(true, true, Product::getPrice);
        } else if ("sales".equals(dto.getSortBy())) {
            wrapper.orderBy(true, false, Product::getSales);
        } else {
            wrapper.orderBy(true, false, Product::getCreatedAt);
        }

        IPage<Product> page = page(new Page<>(dto.getPageNum(), dto.getPageSize()), wrapper);

        return page.convert(this::toProductVO);
    }

    @Override
    public ProductVO getDetail(Long id) {
        Product product = getById(id);
        if (product == null) {
            throw BusinessException.notFound("商品不存在");
        }
        return toProductVO(product);
    }

    @Override
    public Long createProduct(Long userId, String role, ProductSaveDTO dto) {
        if (!"admin".equals(role) && !"merchant".equals(role)) {
            throw BusinessException.forbidden("无权限创建商品");
        }
        Product product = new Product();
        product.setName(dto.getName());
        product.setDescription(dto.getDescription());
        product.setImage(dto.getImage());
        product.setImages(dto.getImages());
        product.setPrice(dto.getPrice());
        product.setStock(dto.getStock());
        product.setSales(0);
        product.setCategoryId(dto.getCategoryId());
        product.setUserId(userId);
        save(product);
        return product.getId();
    }

    @Override
    public void updateProduct(Long userId, String role, Long productId, ProductSaveDTO dto) {
        Product product = getById(productId);
        if (product == null) {
            throw BusinessException.notFound("商品不存在");
        }
        if (!"admin".equals(role) && !product.getUserId().equals(userId)) {
            throw BusinessException.forbidden("无权修改此商品");
        }
        product.setName(dto.getName());
        product.setDescription(dto.getDescription());
        product.setImage(dto.getImage());
        product.setImages(dto.getImages());
        product.setPrice(dto.getPrice());
        product.setStock(dto.getStock());
        product.setCategoryId(dto.getCategoryId());
        updateById(product);
    }

    @Override
    public void deleteProduct(Long userId, String role, Long productId) {
        Product product = getById(productId);
        if (product == null) {
            throw BusinessException.notFound("商品不存在");
        }
        if (!"admin".equals(role) && !product.getUserId().equals(userId)) {
            throw BusinessException.forbidden("无权删除此商品");
        }
        removeById(productId);
    }

    @Override
    public IPage<ProductVO> getManagePage(Long userId, String role, Integer pageNum, Integer pageSize) {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<Product>()
                .orderBy(true, false, Product::getCreatedAt);

        if ("merchant".equals(role)) {
            wrapper.eq(Product::getUserId, userId);
        }

        IPage<Product> page = page(new Page<>(pageNum, pageSize), wrapper);
        return page.convert(this::toProductVO);
    }

    private ProductVO toProductVO(Product product) {
        ProductVO vo = new ProductVO();
        vo.setId(product.getId());
        vo.setName(product.getName());
        vo.setDescription(product.getDescription());
        vo.setImage(product.getImage());
        if (StringUtils.hasText(product.getImages())) {
            vo.setImages(Arrays.asList(product.getImages().split(",")));
        } else {
            vo.setImages(Collections.emptyList());
        }
        vo.setPrice(product.getPrice());
        vo.setStock(product.getStock());
        vo.setSales(product.getSales());
        vo.setCategoryId(product.getCategoryId());
        vo.setUserId(product.getUserId());

        if (product.getUserId() != null) {
            User user = userMapper.selectById(product.getUserId());
            if (user != null) {
                vo.setUserName(user.getUsername());
            }
        }

        if (product.getCategoryId() != null) {
            Category category = categoryMapper.selectById(product.getCategoryId());
            if (category != null) {
                vo.setCategoryName(category.getName());
            }
        }

        vo.setCreatedAt(product.getCreatedAt());
        return vo;
    }
}
