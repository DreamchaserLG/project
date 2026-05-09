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
 * 消息通知：(MessageNotification)表实体类
 *
 */
@TableName("`message_notification`")
@Data
@EqualsAndHashCode(callSuper = false)
public class MessageNotification implements Serializable {

    // MessageNotification编号
    @TableId(value = "message_notification_id", type = IdType.AUTO)
    private Integer message_notification_id;

    // 通知编号
    @TableField(value = "`notice_number`")
    private String notice_number;
    // 通知标题
    @TableField(value = "`notice_title`")
    private String notice_title;
    // 通知时间
    @TableField(value = "`notification_time`")
    private Timestamp notification_time;
    // 主办用户
    @TableField(value = "`host_user`")
    private Integer host_user;
    // 普通用户
    @TableField(value = "`regular_user`")
    private Integer regular_user;
    // 通知内容
    @TableField(value = "`notice_content`")
    private String notice_content;
    // 标记状态
    @TableField(value = "`mark_status`")
    private String mark_status;




















			


                                        





    // 创建用户
    @TableField(value = "create_by")
    private Integer create_by;
    
	// 更新时间
    @TableField(value = "update_time")
    private Timestamp update_time;

    // 创建时间
    @TableField(value = "create_time")
    private Timestamp create_time;

}
