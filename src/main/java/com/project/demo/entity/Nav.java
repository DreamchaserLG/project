package com.project.demo.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.sql.Timestamp;

@TableName("`nav`")
@Data
@EqualsAndHashCode(callSuper = false)
public class Nav implements Serializable {

    @TableId(value = "nav_id", type = IdType.AUTO)
    private Integer nav_id;

    @TableField(value = "`name`")
    private String name;

    @TableField(value = "`location`")
    private String location;

    @TableField(value = "`target`")
    private String target;

    @TableField(value = "`url`")
    private String url;

    @TableField(value = "`father_id`")
    private Integer father_id;

    @TableField(value = "create_time")
    private Timestamp create_time;

    @TableField(value = "update_time")
    private Timestamp update_time;
}
