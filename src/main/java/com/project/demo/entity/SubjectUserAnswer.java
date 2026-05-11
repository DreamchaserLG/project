package com.project.demo.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.sql.Timestamp;

@TableName("`subject_user_answer`")
@Data
@EqualsAndHashCode(callSuper = false)
public class SubjectUserAnswer implements Serializable {

    @TableId(value = "subject_user_answer_id", type = IdType.AUTO)
    private Integer subject_user_answer_id;

    @TableField(value = "`exam_id`")
    private Integer exam_id;

    @TableField(value = "`user_id`")
    private Integer user_id;

    @TableField(value = "`nickname`")
    private String nickname;

    @TableField(value = "`score`")
    private Double score;

    @TableField(value = "create_time")
    private Timestamp create_time;

    @TableField(value = "update_time")
    private Timestamp update_time;
}
