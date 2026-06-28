package com.shop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("orders")
public class Order {
    @TableId(type = IdType.AUTO)
    private Long id;

    private String orderNo;

    private Long userId;

    private BigDecimal totalAmount;

    private Integer status;

    private String address;

    private String remark;

    @TableLogic
    @TableField("is_deleted")
    private Integer isDeleted;

    @TableField(value = "created_at", fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    @TableField(value = "updated_at", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
