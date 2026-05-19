package com.project.demo.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class RegistrationPaymentTimeoutScheduler {

    private final RegistrationWaitlistService registrationWaitlistService;

    public RegistrationPaymentTimeoutScheduler(RegistrationWaitlistService registrationWaitlistService) {
        this.registrationWaitlistService = registrationWaitlistService;
    }

    @Scheduled(fixedDelay = 300000L, initialDelay = 60000L)
    public void cancelExpiredPendingPayments() {
        int count = registrationWaitlistService.cancelExpiredPendingPayments();
        if (count > 0) {
            log.info("已自动取消 {} 条超时未支付报名", count);
        }
    }
}
