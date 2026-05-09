package com.project.demo.entity;

import com.alibaba.fastjson.annotation.JSONField;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

import java.io.Serializable;
import java.sql.Timestamp;


/**
 * 通知记录：(MessageInform)表实体类
 *
 */
@TableName("`message_inform`")
@Data
@EqualsAndHashCode(callSuper = false)
public class MessageInform implements Serializable {

    // MessageInform编号
    @TableId(value = "message_inform_id", type = IdType.AUTO)
    private Integer message_inform_id;

    // 通知人ID
    @TableField(value = "`user_id`")
    private Double user_id;
    // 标题
    @TableField(value = "`title`")
    private String title;
    // 状态
    @TableField(value = "`state`")
    private String state;
    // 分类
    @TableField(value = "`type`")
    private String type;
    // 内容
    @TableField(value = "`content`")
    private String content;























	// 更新时间
    @TableField(value = "update_time")
    private Timestamp update_time;

    // 创建时间
    @TableField(value = "create_time")
    private Timestamp create_time;

}
