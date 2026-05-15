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
 * 数据统计：(DataStatistics)表实体类
 *
 */
@TableName("`data_statistics`")
@Data
@EqualsAndHashCode(callSuper = false)
public class DataStatistics implements Serializable {

    // DataStatistics编号
    @TableId(value = "data_statistics_id", type = IdType.AUTO)
    private Integer data_statistics_id;

    // 统计编号
    @TableField(value = "`statistics_number`")
    private String statistics_number;
    // 统计类型
    @TableField(value = "`statistics_type`")
    private String statistics_type;
    // 统计指标
    @TableField(value = "`statistical_indicators`")
    private String statistical_indicators;
    // 统计日期
    @TableField(value = "`statistics_date`")
    private Timestamp statistics_date;
    // 统计结果
    @TableField(value = "`statistical_results`")
    private Double statistical_results;
    // 主办用户
    @TableField(value = "`host_user`")
    private Integer host_user;
			


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
