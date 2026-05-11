package com.project.demo.controller;

import com.project.demo.controller.base.BaseController;
import com.project.demo.entity.SensitiveVocabulary;
import com.project.demo.service.SensitiveVocabularyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/sensitive_vocabulary")
public class SensitiveVocabularyController extends BaseController<SensitiveVocabulary, SensitiveVocabularyService> {

    @Autowired
    public SensitiveVocabularyController(SensitiveVocabularyService service) {
        setService(service);
    }
}
