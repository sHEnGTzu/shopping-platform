package com.shop.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class OrderVO {
    private Long id;
    private String orderNo;
    private BigDecimal totalAmount;
    private Integer status;
    private String statusDesc;
    private String address;
    private String remark;
    private List<OrderItemVO> items;
    private LocalDateTime createdAt;
}
