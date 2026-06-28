package com.shop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("order_items")
public class OrderItem {
    @TableId(type = IdType.AUTO)
    private Long id;

    private Long orderId;

    private Long productId;

    private String productName;

    private String productImage;

    private BigDecimal price;

    private Integer quantity;

    @TableLogic
    @TableField("is_deleted")
    private Integer isDeleted;

    @TableField(value = "created_at", fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
