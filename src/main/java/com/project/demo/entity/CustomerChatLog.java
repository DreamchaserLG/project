package com.project.demo.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.sql.Timestamp;

@TableName("`customer_chat_log`")
@Data
@EqualsAndHashCode(callSuper = false)
public class CustomerChatLog implements Serializable {

    @TableId(value = "customer_chat_log_id", type = IdType.AUTO)
    private Integer customer_chat_log_id;

    @TableField(value = "`customer_chat_id`")
    private Integer customer_chat_id;

    @TableField(value = "`content`")
    private String content;

    @TableField(value = "create_time")
    private Timestamp create_time;

    @TableField(value = "update_time")
    private Timestamp update_time;
}
