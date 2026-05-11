package com.project.demo.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.sql.Timestamp;

@TableName("`customer_chat_group`")
@Data
@EqualsAndHashCode(callSuper = false)
public class CustomerChatGroup implements Serializable {

    @TableId(value = "customer_chat_group_id", type = IdType.AUTO)
    private Integer customer_chat_group_id;

    @TableField(value = "`member`")
    private String member;

    @TableField(value = "`unread_count`")
    private Integer unread_count;

    @TableField(value = "`last_read_time`")
    private Timestamp last_read_time;

    @TableField(value = "create_time")
    private Timestamp create_time;

    @TableField(value = "update_time")
    private Timestamp update_time;
}
