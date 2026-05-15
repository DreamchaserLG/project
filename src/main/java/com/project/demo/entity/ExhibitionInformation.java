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
 * 会展信息：(ExhibitionInformation)表实体类
 *
 */
@TableName("`exhibition_information`")
@Data
@EqualsAndHashCode(callSuper = false)
public class ExhibitionInformation implements Serializable {

    // ExhibitionInformation编号
    @TableId(value = "exhibition_information_id", type = IdType.AUTO)
    private Integer exhibition_information_id;

    // 会展编号
    @TableField(value = "`exhibitionconvention_number`")
    private String exhibitionconvention_number;
    // 会展主题
    @TableField(value = "`exhibition_theme`")
    private String exhibition_theme;
    // 会展类型
    @TableField(value = "`exhibition_and_convention_types`")
    private String exhibition_and_convention_types;
    // 举办时间
    @TableField(value = "`event_time`")
    private String event_time;
    // 举办地点
    @TableField(value = "`event_venue_name`")
    private String event_venue_name;
    // 会展状态
    @TableField(value = "`exhibition_status`")
    private String exhibition_status;
    // 会展海报
    @TableField(value = "`exhibition_poster`")
    private String exhibition_poster;
    // 主办用户
    @TableField(value = "`host_user`")
    private Integer host_user;
    // 介绍文档
    @TableField(value = "`introduction_document`")
    private String introduction_document;
    // 费用标准
    @TableField(value = "`fee_standards`")
    private String fee_standards;
    // 日程安排
    @TableField(value = "`schedule_t`")
    private String schedule_t;

    // 点击数
    @TableField(value = "hits")
    private Integer hits;

    // 点赞数
    @TableField(value = "praise_len")
    private Integer praise_len;

    // 收藏数
    @TableField(value = "collect_len")
    private Integer collect_len;

    // 评论数
    @TableField(value = "comment_len")
    private Integer comment_len;

    // 审核状态
    @TableField(value = "examine_state")
    private String examine_state;
			


    // 逻辑删除
    @TableField(value = "is_deleted")
    private Integer is_deleted;

    // 逻辑删除时间
    @TableField(value = "deleted_time")
    private Timestamp deleted_time;

    // 逻辑删除原因
    @TableField(value = "deleted_reason")
    private String deleted_reason;

                                        











			


                                        





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
