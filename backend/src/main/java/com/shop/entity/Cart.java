package com.shop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("carts")
public class Cart {
    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private Long productId;

    private Integer quantity;

    @TableLogic
    @TableField("is_deleted")
    private Integer isDeleted;

    @TableField(value = "created_at", fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    @TableField(value = "updated_at", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
