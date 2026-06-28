package com.shop.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class ProductSaveDTO {
    @NotBlank(message = "商品名称不能为空")
    private String name;

    private String description;

    private String image;

    private String images;

    @NotNull(message = "价格不能为空")
    @Positive(message = "价格必须为正数")
    private BigDecimal price;

    @NotNull(message = "库存不能为空")
    private Integer stock;

    private Long categoryId;
}
