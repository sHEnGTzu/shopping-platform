package com.shop.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class ProductVO {
    private Long id;
    private String name;
    private String description;
    private String image;
    private List<String> images;
    private BigDecimal price;
    private Integer stock;
    private Integer sales;
    private Long categoryId;
    private String categoryName;
    private Long userId;
    private String userName;
    private LocalDateTime createdAt;
}
