package com.shop.dto;

import lombok.Data;

@Data
public class ProductQueryDTO {
    private Integer pageNum = 1;
    private Integer pageSize = 10;
    private Long categoryId;
    private String keyword;
    private String sortBy;
}
