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
 * 会展公告：(ExhibitionAnnouncement)表实体类
 *
 */
@TableName("`exhibition_announcement`")
@Data
@EqualsAndHashCode(callSuper = false)
public class ExhibitionAnnouncement implements Serializable {

    // ExhibitionAnnouncement编号
    @TableId(value = "exhibition_announcement_id", type = IdType.AUTO)
    private Integer exhibition_announcement_id;

    // 公告标题
    @TableField(value = "`announcement_title`")
    private String announcement_title;
    // 公告类型
    @TableField(value = "`announcement_type`")
    private String announcement_type;
    // 会展编号
    @TableField(value = "`exhibitionconvention_number`")
    private String exhibitionconvention_number;
    // 主办用户
    @TableField(value = "`host_user`")
    private Integer host_user;
    // 发布时间
    @TableField(value = "`release_time`")
    private Timestamp release_time;
    // 公告图片
    @TableField(value = "`announcement_image`")
    private String announcement_image;
    // 公告视频
    @TableField(value = "`announcement_vuser_ideo`")
    private String announcement_vuser_ideo;
    // 公告内容
    @TableField(value = "`announcement_content`")
    private String announcement_content;

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
