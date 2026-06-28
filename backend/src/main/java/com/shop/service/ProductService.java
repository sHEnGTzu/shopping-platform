package com.shop.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.shop.dto.ProductQueryDTO;
import com.shop.dto.ProductSaveDTO;
import com.shop.entity.Product;
import com.shop.vo.ProductVO;

public interface ProductService extends IService<Product> {
    IPage<ProductVO> getPage(ProductQueryDTO dto);
    ProductVO getDetail(Long id);
    Long createProduct(Long userId, String role, ProductSaveDTO dto);
    void updateProduct(Long userId, String role, Long productId, ProductSaveDTO dto);
    void deleteProduct(Long userId, String role, Long productId);
    IPage<ProductVO> getManagePage(Long userId, String role, Integer pageNum, Integer pageSize);
}
