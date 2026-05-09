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
 * 展位信息：(BoothInformation)表实体类
 *
 */
@TableName("`booth_information`")
@Data
@EqualsAndHashCode(callSuper = false)
public class BoothInformation implements Serializable {

    // BoothInformation编号
    @TableId(value = "booth_information_id", type = IdType.AUTO)
    private Integer booth_information_id;

    // 展位编号
    @TableField(value = "`booth_number`")
    private String booth_number;
    // 会展编号
    @TableField(value = "`exhibitionconvention_number`")
    private String exhibitionconvention_number;
    // 会展主题
    @TableField(value = "`exhibition_theme`")
    private String exhibition_theme;
    // 主办用户
    @TableField(value = "`host_user`")
    private Integer host_user;
    // 展位名称
    @TableField(value = "`booth_name`")
    private String booth_name;
    // 展位类型
    @TableField(value = "`booth_type`")
    private String booth_type;
    // 展位位置
    @TableField(value = "`booth_location`")
    private String booth_location;
    // 展位价格
    @TableField(value = "`booth_prices`")
    private Double booth_prices;
    // 展位规格
    @TableField(value = "`booth_specifications`")
    private String booth_specifications;
    // 展位图片
    @TableField(value = "`booth_images`")
    private String booth_images;
    // 展位详情
    @TableField(value = "`booth_specificss`")
    private String booth_specificss;

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














		// 报名限制次数
	@TableField(value = "registration_information_limit_times")
	private String registration_information_limit_times;
	
			


                                        





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
