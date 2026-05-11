package com.project.demo.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.sql.Timestamp;

@TableName("`sensitive_vocabulary`")
@Data
@EqualsAndHashCode(callSuper = false)
public class SensitiveVocabulary implements Serializable {

    @TableId(value = "sensitive_vocabulary_id", type = IdType.AUTO)
    private Integer sensitive_vocabulary_id;

    @TableField(value = "`sensitive_vocabulary`")
    private String sensitive_vocabulary;

    @TableField(value = "create_time")
    private Timestamp create_time;

    @TableField(value = "update_time")
    private Timestamp update_time;
}
