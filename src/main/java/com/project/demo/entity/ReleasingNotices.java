package com.project.demo.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.sql.Timestamp;

@TableName("`releasing_notices`")
@Data
@EqualsAndHashCode(callSuper = false)
public class ReleasingNotices implements Serializable {

    @TableId(value = "notices_id", type = IdType.AUTO)
    private Integer notices_id;

    @TableField(value = "`title`")
    private String title;

    @TableField(value = "`type`")
    private String type;

    @TableField(value = "`content`")
    private String content;

    @TableField(value = "create_time")
    private Timestamp create_time;

    @TableField(value = "update_time")
    private Timestamp update_time;
}
