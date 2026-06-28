package com.shop.enums;

public enum UserRole {
    ADMIN("admin", "管理员"),
    MERCHANT("merchant", "商家"),
    BUYER("buyer", "买家");

    private final String code;
    private final String desc;

    UserRole(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public String getCode() {
        return code;
    }

    public String getDesc() {
        return desc;
    }

    public static UserRole fromCode(String code) {
        for (UserRole role : values()) {
            if (role.code.equals(code)) {
                return role;
            }
        }
        return BUYER;
    }
}
