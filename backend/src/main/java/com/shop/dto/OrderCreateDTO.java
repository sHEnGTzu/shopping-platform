package com.shop.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class OrderCreateDTO {
    @NotEmpty(message = "请选择购物车商品")
    private List<Long> cartItemIds;

    @NotBlank(message = "收货地址不能为空")
    private String address;

    private String remark;
}
