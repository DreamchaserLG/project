package com.project.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

@Service
public class RegistrationWaitlistService {

    public static final String SOURCE_TABLE_BOOTH = "booth_information";
    public static final String SOURCE_TABLE_REGISTRATION = "registration_information";

    public static final String STATUS_CONFIRMED = "已报名";
    public static final String STATUS_WAITLIST = "候补中";
    public static final String STATUS_CANCELLED = "已取消";

    public static final String EXAMINE_PENDING = "未审核";
    public static final String EXAMINE_APPROVED = "已通过";
    public static final String EXAMINE_REJECTED = "未通过";

    public static final String PAY_UNPAID = "未支付";
    public static final String PAY_PAID = "已支付";
    public static final String PAY_REFUNDING = "退款中";
    public static final String PAY_REFUNDED = "已退款";

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public RegistrationWaitlistService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Transactional
    public Map<String, Object> createBoothRegistration(Map<String, Object> body) {
        Integer boothId = toInt(body.get("source_id"));
        Integer userId = toInt(body.get("enrolled_user"));

        if (boothId == null || boothId <= 0) {
            return fail("展位信息不存在");
        }

        if (userId == null || userId <= 0) {
            return fail("请先登录后再报名");
        }

        Double numberOfRegistrations = toDouble(body.get("number_of_registrations"));
        if (numberOfRegistrations == null || numberOfRegistrations < 1) {
            return fail("报名人数不能小于1人");
        }
        if (Math.floor(numberOfRegistrations) != numberOfRegistrations) {
            return fail("报名人数必须为正整数");
        }

        Map<String, Object> booth = getBoothForUpdate(boothId);

        if (booth == null) {
            return fail("展位信息不存在");
        }

        Integer capacity = boothCapacity(booth.get("registration_information_limit_times"));
        fillAvailableSeats(boothId, capacity);

        Map<String, Object> activeRegistration = getLatestActiveRegistration(boothId, userId);
        if (activeRegistration != null) {
            String currentStatus = normalizeStatus(activeRegistration.get("registration_status"));
            Integer registrationId = toInt(activeRegistration.get("registration_information_id"));
            Integer waitlistNo = toInt(activeRegistration.get("waitlist_no"));
            String message = STATUS_WAITLIST.equals(currentStatus)
                    ? "您已在当前展位候补队列中"
                    : "您已经报名该展位";
            return fail(message, registrationId, currentStatus, waitlistNo);
        }

        int confirmedCount = countConfirmed(boothId);
        boolean useWaitlist = capacity > 0 && confirmedCount >= capacity;
        String registrationStatus = useWaitlist ? STATUS_WAITLIST : STATUS_CONFIRMED;
        String orderNumber = buildOrderNumber(body.get("order_number"));
        String payState = PAY_UNPAID;
        String examineState = EXAMINE_PENDING;
        Integer waitlistNo = null;
        String boothNumber = safeString(booth.get("booth_number"));
        String exhibitionNumber = safeString(booth.get("exhibitionconvention_number"));
        String exhibitionTheme = safeString(booth.get("exhibition_theme"));
        Integer hostUser = toInt(booth.get("host_user"));
        String boothName = safeString(booth.get("booth_name"));
        String boothType = safeString(booth.get("booth_type"));
        Double boothPrice = toDouble(booth.get("booth_prices"));
        Integer createBy = toInt(body.get("create_by"));
        Integer sourceUserId = toInt(body.get("source_user_id"));

        if (createBy == null || createBy <= 0) {
            createBy = userId;
        }

        if (sourceUserId == null || sourceUserId <= 0) {
            sourceUserId = userId;
        }

        jdbcTemplate.update(
                "INSERT INTO registration_information (" +
                        "order_number, booth_number, exhibitionconvention_number, exhibition_theme, " +
                        "host_user, booth_name, booth_type, booth_prices, " +
                        "enrolled_user, user_name, users_mobile_phone, number_of_registrations, " +
                        "enterprise_qualifications, registration_notes, site_plan, exhibitor_documents, " +
                        "examine_state, examine_reply, pay_state, pay_type, " +
                        "travel_confirmation_limit_times, refund_request_limit_times, " +
                        "extra, source_table, source_id, source_user_id, create_by, " +
                        "registration_status, waitlist_no, waitlist_time, confirm_time, cancel_time, create_time, update_time"
                        +
                        ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())",
                orderNumber,
                boothNumber,
                exhibitionNumber,
                exhibitionTheme,
                hostUser,
                boothName,
                boothType,
                boothPrice,
                userId,
                safeString(body.get("user_name")),
                safeString(body.get("users_mobile_phone")),
                numberOfRegistrations,
                safeString(body.get("enterprise_qualifications")),
                safeString(body.get("registration_notes")),
                safeString(body.get("site_plan")),
                safeString(body.get("exhibitor_documents")),
                examineState,
                "",
                payState,
                safeString(body.get("pay_type")),
                defaultString(body.get("travel_confirmation_limit_times"), "1"),
                defaultString(body.get("refund_request_limit_times"), "1"),
                safeString(body.get("extra")),
                SOURCE_TABLE_BOOTH,
                boothId,
                sourceUserId,
                createBy,
                registrationStatus,
                waitlistNo,
                STATUS_WAITLIST.equals(registrationStatus) ? new java.sql.Timestamp(System.currentTimeMillis()) : null,
                STATUS_CONFIRMED.equals(registrationStatus) ? new java.sql.Timestamp(System.currentTimeMillis()) : null,
                null);

        Integer registrationId = findRegistrationIdByOrderNumber(orderNumber);

        if (useWaitlist) {
            renumberWaitlist(boothId);
            waitlistNo = queryWaitlistNo(registrationId);
        }

        notifyRegistrationCreated(userId, hostUser, boothName, registrationStatus, waitlistNo);

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("ok", true);
        result.put("registration_information_id", registrationId);
        result.put("order_number", orderNumber);
        result.put("registration_status", registrationStatus);
        result.put("waitlist_no", waitlistNo);
        result.put("need_pay", false);
        result.put("message", STATUS_WAITLIST.equals(registrationStatus)
                ? "当前展位名额已满，候补申请已提交，待管理员或主办方审核"
                : "报名已提交，待管理员或主办方审核");
        if (STATUS_WAITLIST.equals(registrationStatus) && waitlistNo == null) {
            result.put("message", "当前展位名额已满，候补申请已提交，待管理员或主办方审核");
        } else if (STATUS_WAITLIST.equals(registrationStatus)) {
            result.put("message", "当前展位名额已满，已加入候补队列");
        } else {
            result.put("message", "报名已提交，待管理员或主办方审核");
        }
        return result;
    }

    @Transactional
    public Map<String, Object> cancelRegistration(Integer registrationId, String reason, String remark) {
        if (registrationId == null || registrationId <= 0) {
            return fail("报名记录不存在");
        }

        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT registration_information_id, source_table, source_id, registration_status, pay_state, examine_state, "
                        +
                        "enrolled_user, host_user, booth_name " +
                        "FROM registration_information WHERE registration_information_id = ? FOR UPDATE",
                registrationId);

        if (rows.isEmpty()) {
            return fail("报名记录不存在");
        }

        Map<String, Object> registration = rows.get(0);
        String sourceTable = safeString(registration.get("source_table"));
        Integer boothId = toInt(registration.get("source_id"));
        String currentStatus = normalizeStatus(registration.get("registration_status"));
        String payState = safeString(registration.get("pay_state"));
        String examineState = safeString(registration.get("examine_state"));
        Integer enrolledUser = toInt(registration.get("enrolled_user"));
        Integer hostUser = toInt(registration.get("host_user"));
        String boothName = safeString(registration.get("booth_name"));

        if (STATUS_CANCELLED.equals(currentStatus)) {
            Map<String, Object> result = new HashMap<String, Object>();
            result.put("ok", true);
            result.put("registration_information_id", registrationId);
            result.put("registration_status", STATUS_CANCELLED);
            result.put("promoted_registration_id", null);
            result.put("message", "该报名记录已取消");
            return result;
        }

        if ("取消报名".equals(reason) && PAY_REFUNDING.equals(payState)) {
            return fail("当前报名正在退款审核中，请先处理退款申请");
        }

        if (!SOURCE_TABLE_BOOTH.equals(sourceTable) || boothId == null || boothId <= 0) {
            jdbcTemplate.update(
                    "UPDATE registration_information SET registration_status = ?, cancel_time = NOW(), update_time = NOW() "
                            +
                            "WHERE registration_information_id = ?",
                    STATUS_CANCELLED,
                    registrationId);

            notifyCancellation(enrolledUser, hostUser, boothName, reason, false, null);

            Map<String, Object> result = new HashMap<String, Object>();
            result.put("ok", true);
            result.put("registration_information_id", registrationId);
            result.put("registration_status", STATUS_CANCELLED);
            result.put("promoted_registration_id", null);
            result.put("message", "报名已取消");
            return result;
        }

        if (STATUS_WAITLIST.equals(currentStatus)) {
            jdbcTemplate.update(
                    "UPDATE registration_information " +
                            "SET registration_status = ?, waitlist_no = NULL, cancel_time = NOW(), update_time = NOW() "
                            +
                            "WHERE registration_information_id = ?",
                    STATUS_CANCELLED,
                    registrationId);

            renumberWaitlist(boothId);
            notifyCancellation(enrolledUser, hostUser, boothName, reason, true, null);

            Map<String, Object> result = new HashMap<String, Object>();
            result.put("ok", true);
            result.put("registration_information_id", registrationId);
            result.put("registration_status", STATUS_CANCELLED);
            result.put("promoted_registration_id", null);
            result.put("message", "候补记录已取消");
            return result;
        }

        String nextPayState = payState;
        String nextExamineState = examineState;

        if ("退款通过".equals(reason)) {
            nextPayState = PAY_REFUNDED;
        } else if ("审核未通过".equals(reason)) {
            nextExamineState = EXAMINE_REJECTED;
            if (PAY_PAID.equals(payState)) {
                nextPayState = PAY_REFUNDED;
            }
        } else if ("申请退款".equals(reason)) {
            nextPayState = PAY_REFUNDING;
        }

        jdbcTemplate.update(
                "UPDATE registration_information " +
                        "SET registration_status = ?, waitlist_no = NULL, examine_state = ?, examine_reply = ?, pay_state = ?, "
                        +
                        "cancel_time = NOW(), update_time = NOW() " +
                        "WHERE registration_information_id = ?",
                STATUS_CANCELLED,
                nextExamineState,
                safeString(remark),
                nextPayState,
                registrationId);

        Integer promotedId = promoteOneWaitlist(boothId);
        renumberWaitlist(boothId);
        notifyCancellation(enrolledUser, hostUser, boothName, reason, false, promotedId);
        if (promotedId != null) {
            notifyPromotion(promotedId);
        }

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("ok", true);
        result.put("registration_information_id", registrationId);
        result.put("registration_status", STATUS_CANCELLED);
        result.put("promoted_registration_id", promotedId);
        result.put("message", promotedId == null
                ? reason + "成功，当前没有候补用户"
                : reason + "成功，已自动递补下一位候补用户");
        return result;
    }

    @Transactional
    public Map<String, Object> auditRegistration(Integer registrationId, String examineState, String examineReply) {
        if (registrationId == null || registrationId <= 0) {
            return fail("报名记录不存在");
        }

        if (!EXAMINE_PENDING.equals(examineState)
                && !EXAMINE_APPROVED.equals(examineState)
                && !EXAMINE_REJECTED.equals(examineState)) {
            return fail("非法的审核状态");
        }

        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT registration_information_id, source_table, source_id, registration_status, waitlist_no, pay_state, "
                        +
                        "examine_state, enrolled_user, host_user, booth_name " +
                        "FROM registration_information WHERE registration_information_id = ? FOR UPDATE",
                registrationId);

        if (rows.isEmpty()) {
            return fail("报名记录不存在");
        }

        Map<String, Object> registration = rows.get(0);
        String sourceTable = safeString(registration.get("source_table"));
        Integer boothId = toInt(registration.get("source_id"));
        String currentStatus = normalizeStatus(registration.get("registration_status"));
        String currentPayState = safeString(registration.get("pay_state"));
        String reply = safeString(examineReply);

        if (!SOURCE_TABLE_BOOTH.equals(sourceTable) || boothId == null || boothId <= 0) {
            jdbcTemplate.update(
                    "UPDATE registration_information SET examine_state = ?, examine_reply = ?, update_time = NOW() " +
                            "WHERE registration_information_id = ?",
                    examineState,
                    reply,
                    registrationId);
            return auditResult(
                    registrationId,
                    currentStatus,
                    toInt(registration.get("waitlist_no")),
                    currentPayState,
                    examineState,
                    false,
                    EXAMINE_REJECTED.equals(examineState) ? "已审核不通过" : "审核成功");
        }

        if (EXAMINE_PENDING.equals(examineState)) {
            jdbcTemplate.update(
                    "UPDATE registration_information SET examine_state = ?, examine_reply = ?, update_time = NOW() " +
                            "WHERE registration_information_id = ?",
                    EXAMINE_PENDING,
                    reply,
                    registrationId);
            renumberWaitlist(boothId);
            return auditResult(
                    registrationId,
                    currentStatus,
                    queryWaitlistNo(registrationId),
                    currentPayState,
                    EXAMINE_PENDING,
                    false,
                    "审核状态已更新为未审核");
        }

        if (EXAMINE_REJECTED.equals(examineState)) {
            if (STATUS_WAITLIST.equals(currentStatus)) {
                jdbcTemplate.update(
                        "UPDATE registration_information SET examine_state = ?, examine_reply = ?, registration_status = ?, "
                                +
                                "waitlist_no = NULL, waitlist_time = NULL, cancel_time = NOW(), update_time = NOW() " +
                                "WHERE registration_information_id = ?",
                        EXAMINE_REJECTED,
                        reply,
                        STATUS_CANCELLED,
                        registrationId);
                renumberWaitlist(boothId);
                return auditResult(
                        registrationId,
                        STATUS_CANCELLED,
                        null,
                        currentPayState,
                        EXAMINE_REJECTED,
                        false,
                        "已审核不通过");
            }
            return cancelRegistration(registrationId, "审核未通过", reply);
        }

        Map<String, Object> booth = getBoothForUpdate(boothId);
        if (booth == null) {
            return fail("展位信息不存在");
        }

        Integer capacity = boothCapacity(booth.get("registration_information_limit_times"));
        fillAvailableSeats(boothId, capacity);

        int confirmedCount = countConfirmed(boothId);
        boolean canConfirm = STATUS_CONFIRMED.equals(currentStatus) || capacity <= 0 || confirmedCount < capacity;
        String nextPayState = keepOrResetPayState(currentPayState);

        if (canConfirm) {
            jdbcTemplate.update(
                    "UPDATE registration_information SET examine_state = ?, examine_reply = ?, registration_status = ?, "
                            +
                            "waitlist_no = NULL, waitlist_time = NULL, cancel_time = NULL, confirm_time = IFNULL(confirm_time, NOW()), "
                            +
                            "pay_state = ?, update_time = NOW() WHERE registration_information_id = ?",
                    EXAMINE_APPROVED,
                    reply,
                    STATUS_CONFIRMED,
                    nextPayState,
                    registrationId);
            renumberWaitlist(boothId);
            return auditResult(
                    registrationId,
                    STATUS_CONFIRMED,
                    null,
                    nextPayState,
                    EXAMINE_APPROVED,
                    PAY_UNPAID.equals(nextPayState),
                    PAY_UNPAID.equals(nextPayState)
                            ? "已审核通过，订单已转为正式报名，请用户尽快支付"
                            : "已审核通过，订单已转为正式报名");
        }

        Integer assignedWaitlistNo = nextWaitlistNo(boothId);
        jdbcTemplate.update(
                "UPDATE registration_information SET examine_state = ?, examine_reply = ?, registration_status = ?, " +
                        "waitlist_no = ?, waitlist_time = IFNULL(waitlist_time, NOW()), cancel_time = NULL, " +
                        "pay_state = ?, update_time = NOW() WHERE registration_information_id = ?",
                EXAMINE_APPROVED,
                reply,
                STATUS_WAITLIST,
                assignedWaitlistNo,
                PAY_UNPAID,
                registrationId);
        renumberWaitlist(boothId);

        Integer currentWaitlistNo = queryWaitlistNo(registrationId);
        return auditResult(
                registrationId,
                STATUS_WAITLIST,
                currentWaitlistNo,
                PAY_UNPAID,
                EXAMINE_APPROVED,
                false,
                "已审核通过，当前名额已满，订单进入候补队列" +
                        (currentWaitlistNo == null ? "" : "，当前候补第 " + currentWaitlistNo + " 位"));
    }

    @Transactional
    public Map<String, Object> boothStatus(Integer boothId, Integer userId) {
        Map<String, Object> booth = getBoothForUpdate(boothId);
        if (booth == null) {
            return fail("展位信息不存在");
        }

        Integer capacity = boothCapacity(booth.get("registration_information_limit_times"));
        fillAvailableSeats(boothId, capacity);

        int confirmedCount = countConfirmed(boothId);
        int waitlistCount = countWaitlist(boothId);
        Map<String, Object> myRegistration = userId == null ? null : getLatestActiveRegistration(boothId, userId);

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("boothId", boothId);
        result.put("booth_name", safeString(booth.get("booth_name")));
        result.put("capacity", capacity);
        result.put("confirmed_count", confirmedCount);
        result.put("waitlist_count", waitlistCount);
        result.put("is_full", capacity > 0 && confirmedCount >= capacity);
        result.put("my_registration_id",
                myRegistration == null ? null : toInt(myRegistration.get("registration_information_id")));
        result.put("my_status",
                myRegistration == null ? "" : normalizeStatus(myRegistration.get("registration_status")));
        result.put("my_waitlist_no", myRegistration == null ? null : toInt(myRegistration.get("waitlist_no")));
        result.put("my_pay_state", myRegistration == null ? "" : safeString(myRegistration.get("pay_state")));
        result.put("message", capacity <= 0
                ? "当前展位不限报名人数"
                : "当前已报名 " + confirmedCount + "/" + capacity + "，候补 " + waitlistCount + " 人");
        result.put("ok", true);
        return result;
    }

    @Transactional
    public List<Map<String, Object>> boothQueue(Integer boothId) {
        Map<String, Object> booth = getBoothForUpdate(boothId);
        if (booth == null) {
            return new ArrayList<Map<String, Object>>();
        }

        fillAvailableSeats(boothId, boothCapacity(booth.get("registration_information_limit_times")));

        return jdbcTemplate.queryForList(
                "SELECT registration_information_id, order_number, enrolled_user, user_name, users_mobile_phone, " +
                        "registration_status, waitlist_no, waitlist_time, confirm_time, cancel_time, create_time, pay_state, examine_state "
                        +
                        "FROM registration_information " +
                        "WHERE source_table = ? AND source_id = ? " +
                        "ORDER BY " +
                        "CASE " +
                        "WHEN registration_status = ? OR registration_status IS NULL OR registration_status = '' THEN 1 "
                        +
                        "WHEN registration_status = ? THEN 2 " +
                        "WHEN registration_status = ? THEN 3 " +
                        "ELSE 4 END, " +
                        "waitlist_no ASC, create_time ASC, registration_information_id ASC",
                SOURCE_TABLE_BOOTH,
                boothId,
                STATUS_CONFIRMED,
                STATUS_WAITLIST,
                STATUS_CANCELLED);
    }

    public String validatePaymentAllowed(Integer registrationId) {
        Map<String, Object> registration = getRegistration(registrationId);
        if (registration == null) {
            return "报名记录不存在";
        }

        String status = normalizeStatus(registration.get("registration_status"));
        if (!STATUS_CONFIRMED.equals(status)) {
            return "只有已报名记录才能支付";
        }

        if (EXAMINE_REJECTED.equals(safeString(registration.get("examine_state")))) {
            return "审核未通过的报名不能支付";
        }

        String payState = safeString(registration.get("pay_state"));
        if (PAY_PAID.equals(payState)) {
            return "当前报名记录已支付";
        }

        if (PAY_REFUNDING.equals(payState) || PAY_REFUNDED.equals(payState)) {
            return "退款中的报名不能再次支付";
        }

        return null;
    }

    public String validateTravelConfirmationAllowed(Integer registrationId) {
        Map<String, Object> registration = getRegistration(registrationId);
        if (registration == null) {
            return "报名记录不存在";
        }

        String status = normalizeStatus(registration.get("registration_status"));
        if (!STATUS_CONFIRMED.equals(status)) {
            return "只有已报名用户才能提交行程确认";
        }

        if (!EXAMINE_APPROVED.equals(safeString(registration.get("examine_state")))) {
            return "审核通过后才能提交行程确认";
        }

        Integer limit = toPositiveInt(registration.get("travel_confirmation_limit_times"), 1);
        Integer used = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM travel_confirmation WHERE source_table = ? AND source_id = ?",
                Integer.class,
                SOURCE_TABLE_REGISTRATION,
                registrationId);

        if (used != null && limit > 0 && used >= limit) {
            return "当前报名记录的行程确认次数已达上限";
        }

        if (PAY_REFUNDING.equals(safeString(registration.get("pay_state")))
                || PAY_REFUNDED.equals(safeString(registration.get("pay_state")))) {
            return "退款中的报名不能提交行程确认";
        }

        return null;
    }

    public String validateTravelAttendeesAllowed(Integer registrationId, Double attendees) {
        Map<String, Object> registration = getRegistration(registrationId);
        if (registration == null) {
            return "报名记录不存在";
        }

        if (attendees == null || attendees < 1) {
            return "行程确认人数不能小于1人";
        }
        if (Math.floor(attendees) != attendees) {
            return "行程确认人数必须为正整数";
        }

        Double registeredPeople = toDouble(registration.get("number_of_registrations"));
        if (registeredPeople == null || registeredPeople < 1) {
            return "报名人数异常，不能提交行程确认";
        }

        if (attendees > registeredPeople) {
            return "行程确认人数不能超过报名人数";
        }

        return null;
    }

    public String validateRefundRequestAllowed(Integer registrationId) {
        Map<String, Object> registration = getRegistration(registrationId);
        if (registration == null) {
            return "报名记录不存在";
        }

        String status = normalizeStatus(registration.get("registration_status"));
        if (!STATUS_CONFIRMED.equals(status)) {
            return "只有已报名用户才能发起退款";
        }

        if (!EXAMINE_APPROVED.equals(safeString(registration.get("examine_state")))) {
            return "审核通过后才能发起退款";
        }

        if (!PAY_PAID.equals(safeString(registration.get("pay_state")))) {
            return "支付完成后才能发起退款";
        }

        Integer pending = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM refund_request WHERE source_table = ? AND source_id = ? AND examine_state = ?",
                Integer.class,
                SOURCE_TABLE_REGISTRATION,
                registrationId,
                EXAMINE_PENDING);

        if (pending != null && pending > 0) {
            return "当前报名记录已有待审核退款申请";
        }

        Integer limit = toPositiveInt(registration.get("refund_request_limit_times"), 1);
        Integer used = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM refund_request WHERE source_table = ? AND source_id = ?",
                Integer.class,
                SOURCE_TABLE_REGISTRATION,
                registrationId);

        if (used != null && limit > 0 && used >= limit) {
            return "当前报名记录的退款申请次数已达上限";
        }

        return null;
    }

    public void markRefundRequestPending(Integer registrationId) {
        jdbcTemplate.update(
                "UPDATE registration_information SET pay_state = ?, update_time = NOW() WHERE registration_information_id = ?",
                PAY_REFUNDING,
                registrationId);
    }

    public void restorePaidStateAfterRefundReject(Integer registrationId) {
        jdbcTemplate.update(
                "UPDATE registration_information SET pay_state = ?, update_time = NOW() WHERE registration_information_id = ?",
                PAY_PAID,
                registrationId);
    }

    public Map<String, Object> getRegistration(Integer registrationId) {
        if (registrationId == null || registrationId <= 0) {
            return null;
        }

        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT registration_information_id, order_number, booth_number, exhibitionconvention_number, exhibition_theme, source_table, source_id, source_user_id, enrolled_user, "
                        +
                        "host_user, booth_name, booth_prices, user_name, users_mobile_phone, registration_status, waitlist_no, pay_state, examine_state, examine_reply, number_of_registrations, "
                        +
                        "travel_confirmation_limit_times, refund_request_limit_times " +
                        "FROM registration_information WHERE registration_information_id = ? LIMIT 1",
                registrationId);

        return rows.isEmpty() ? null : rows.get(0);
    }

    private Map<String, Object> getBoothForUpdate(Integer boothId) {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT booth_information_id, booth_number, exhibitionconvention_number, exhibition_theme, host_user, "
                        +
                        "booth_name, booth_type, booth_prices, registration_information_limit_times " +
                        "FROM booth_information WHERE booth_information_id = ? FOR UPDATE",
                boothId);

        return rows.isEmpty() ? null : rows.get(0);
    }

    private Map<String, Object> getLatestActiveRegistration(Integer boothId, Integer userId) {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT registration_information_id, registration_status, waitlist_no, pay_state " +
                        "FROM registration_information " +
                        "WHERE source_table = ? AND source_id = ? AND enrolled_user = ? " +
                        "AND (registration_status = ? OR registration_status = ? OR registration_status IS NULL OR registration_status = '') "
                        +
                        "ORDER BY registration_information_id DESC LIMIT 1",
                SOURCE_TABLE_BOOTH,
                boothId,
                userId,
                STATUS_CONFIRMED,
                STATUS_WAITLIST);

        return rows.isEmpty() ? null : rows.get(0);
    }

    private int countConfirmed(Integer boothId) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM registration_information " +
                        "WHERE source_table = ? AND source_id = ? " +
                        "AND (registration_status = ? OR registration_status IS NULL OR registration_status = '')",
                Integer.class,
                SOURCE_TABLE_BOOTH,
                boothId,
                STATUS_CONFIRMED);
        return count == null ? 0 : count;
    }

    private int countWaitlist(Integer boothId) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM registration_information " +
                        "WHERE source_table = ? AND source_id = ? AND registration_status = ? AND examine_state = ?",
                Integer.class,
                SOURCE_TABLE_BOOTH,
                boothId,
                STATUS_WAITLIST,
                EXAMINE_APPROVED);
        return count == null ? 0 : count;
    }

    private Integer nextWaitlistNo(Integer boothId) {
        Integer next = jdbcTemplate.queryForObject(
                "SELECT IFNULL(MAX(waitlist_no), 0) + 1 FROM registration_information " +
                        "WHERE source_table = ? AND source_id = ? AND registration_status = ? AND examine_state = ?",
                Integer.class,
                SOURCE_TABLE_BOOTH,
                boothId,
                STATUS_WAITLIST,
                EXAMINE_APPROVED);
        return next == null ? 1 : next;
    }

    private void fillAvailableSeats(Integer boothId, Integer capacity) {
        if (capacity == null || capacity <= 0) {
            while (promoteOneWaitlist(boothId) != null) {
                // promote all when no limit
            }
            renumberWaitlist(boothId);
            return;
        }

        while (countConfirmed(boothId) < capacity) {
            Integer promotedId = promoteOneWaitlist(boothId);
            if (promotedId == null) {
                break;
            }
        }

        renumberWaitlist(boothId);
    }

    private Integer promoteOneWaitlist(Integer boothId) {
        List<Map<String, Object>> waitRows = jdbcTemplate.queryForList(
                "SELECT registration_information_id FROM registration_information " +
                        "WHERE source_table = ? AND source_id = ? AND registration_status = ? AND examine_state = ? " +
                        "ORDER BY waitlist_time ASC, registration_information_id ASC " +
                        "LIMIT 1 FOR UPDATE",
                SOURCE_TABLE_BOOTH,
                boothId,
                STATUS_WAITLIST,
                EXAMINE_APPROVED);

        if (waitRows.isEmpty()) {
            return null;
        }

        Integer promotedId = toInt(waitRows.get(0).get("registration_information_id"));
        jdbcTemplate.update(
                "UPDATE registration_information " +
                        "SET registration_status = ?, waitlist_no = NULL, waitlist_time = NULL, cancel_time = NULL, " +
                        "confirm_time = NOW(), examine_state = ?, pay_state = ?, update_time = NOW() " +
                        "WHERE registration_information_id = ?",
                STATUS_CONFIRMED,
                EXAMINE_APPROVED,
                PAY_UNPAID,
                promotedId);
        return promotedId;
    }

    private void renumberWaitlist(Integer boothId) {
        jdbcTemplate.update(
                "UPDATE registration_information SET waitlist_no = NULL, update_time = NOW() " +
                        "WHERE source_table = ? AND source_id = ? AND registration_status = ? " +
                        "AND (examine_state IS NULL OR examine_state <> ?)",
                SOURCE_TABLE_BOOTH,
                boothId,
                STATUS_WAITLIST,
                EXAMINE_APPROVED);
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT registration_information_id FROM registration_information " +
                        "WHERE source_table = ? AND source_id = ? AND registration_status = ? AND examine_state = ? " +
                        "ORDER BY waitlist_time ASC, registration_information_id ASC FOR UPDATE",
                SOURCE_TABLE_BOOTH,
                boothId,
                STATUS_WAITLIST,
                EXAMINE_APPROVED);

        for (int i = 0; i < rows.size(); i++) {
            Integer registrationId = toInt(rows.get(i).get("registration_information_id"));
            jdbcTemplate.update(
                    "UPDATE registration_information SET waitlist_no = ?, update_time = NOW() WHERE registration_information_id = ?",
                    i + 1,
                    registrationId);
        }
    }

    private Integer queryWaitlistNo(Integer registrationId) {
        if (registrationId == null) {
            return null;
        }

        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT waitlist_no FROM registration_information WHERE registration_information_id = ? LIMIT 1",
                registrationId);

        return rows.isEmpty() ? null : toInt(rows.get(0).get("waitlist_no"));
    }

    private Map<String, Object> auditResult(Integer registrationId,
            String registrationStatus,
            Integer waitlistNo,
            String payState,
            String examineState,
            boolean needPay,
            String message) {
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("ok", true);
        result.put("registration_information_id", registrationId);
        result.put("registration_status", registrationStatus);
        result.put("waitlist_no", waitlistNo);
        result.put("pay_state", payState);
        result.put("examine_state", examineState);
        result.put("need_pay", needPay);
        result.put("message", message);
        return result;
    }

    private String keepOrResetPayState(String currentPayState) {
        if (PAY_PAID.equals(currentPayState) || PAY_REFUNDING.equals(currentPayState)
                || PAY_REFUNDED.equals(currentPayState)) {
            return currentPayState;
        }
        return PAY_UNPAID;
    }

    private Integer findRegistrationIdByOrderNumber(String orderNumber) {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT registration_information_id FROM registration_information WHERE order_number = ? " +
                        "ORDER BY registration_information_id DESC LIMIT 1",
                orderNumber);

        return rows.isEmpty() ? null : toInt(rows.get(0).get("registration_information_id"));
    }

    private String buildOrderNumber(Object rawValue) {
        String value = safeString(rawValue);
        if (!value.isEmpty() && !"null".equalsIgnoreCase(value) && !"undefined".equalsIgnoreCase(value)
                && !"nan".equalsIgnoreCase(value)) {
            return value;
        }
        return "BM" + System.currentTimeMillis() + ThreadLocalRandom.current().nextInt(1000, 9999);
    }

    private void notifyRegistrationCreated(Integer enrolledUser, Integer hostUser, String boothName,
            String registrationStatus, Integer waitlistNo) {
        String boothDisplay = boothDisplayName(boothName);
        if (STATUS_WAITLIST.equals(registrationStatus)) {
            String suffix = waitlistNo == null ? "，待管理员或主办方审核。" : "，当前排位第 " + waitlistNo + " 位。";
            notifyUser(enrolledUser, "候补报名提醒", boothDisplay + "名额已满，候补申请已提交" + suffix);
            notifyUser(hostUser, "新增候补报名", boothDisplay + "新增了一条待审核候补报名记录" + suffix);
            return;
        }

        notifyUser(enrolledUser, "展位报名已提交", boothDisplay + "报名已提交，待管理员或主办方审核。");
        notifyUser(hostUser, "新增正式报名", boothDisplay + "新增了一条待审核正式报名记录。");
    }

    private void notifyCancellation(Integer enrolledUser, Integer hostUser, String boothName,
            String reason, boolean waitlistCancelled, Integer promotedId) {
        String boothDisplay = boothDisplayName(boothName);
        if (waitlistCancelled) {
            notifyUser(enrolledUser, "候补状态变更", boothDisplay + "的候补资格已取消。");
            notifyUser(hostUser, "候补队列变更", boothDisplay + "有候补用户退出，系统已自动更新队列顺序。");
            return;
        }

        String userContent;
        if ("退款通过".equals(reason)) {
            userContent = boothDisplay + "的退款已通过，当前报名名额已释放。";
        } else if ("审核未通过".equals(reason)) {
            userContent = boothDisplay + "审核未通过，当前报名已取消。";
        } else {
            userContent = boothDisplay + "已取消报名。";
        }
        if (promotedId != null) {
            userContent += " 系统已自动递补下一位候补用户。";
        }

        String hostContent = boothDisplay + "有正式报名释放名额。";
        if (promotedId != null) {
            hostContent += " 系统已自动递补下一位候补用户。";
        }

        notifyUser(enrolledUser, "报名状态变更", userContent);
        notifyUser(hostUser, "展位名额变更", hostContent);
    }

    private void notifyPromotion(Integer registrationId) {
        Map<String, Object> registration = getRegistration(registrationId);
        if (registration == null) {
            return;
        }

        Integer enrolledUser = toInt(registration.get("enrolled_user"));
        String boothDisplay = boothDisplayName(safeString(registration.get("booth_name")));
        notifyUser(enrolledUser, "候补递补成功", boothDisplay + "的候补已自动转为正式报名，请尽快完成支付和审核流程。");
    }

    private void notifyUser(Integer userId, String title, String content) {
        if (userId == null || userId <= 0) {
            return;
        }
        if (safeString(title).isEmpty() || safeString(content).isEmpty()) {
            return;
        }

        jdbcTemplate.update(
                "INSERT INTO message_inform (user_id, title, state, type, content, create_time, update_time) " +
                        "VALUES (?, ?, ?, ?, ?, NOW(), NOW())",
                userId,
                title,
                "1",
                "通知",
                content);
    }

    private String boothDisplayName(String boothName) {
        String name = safeString(boothName);
        return name.isEmpty() ? "当前展位" : "展位【" + name + "】";
    }

    private Integer boothCapacity(Object rawValue) {
        Integer value = toInt(rawValue);
        return value == null || value < 0 ? 0 : value;
    }

    private Double defaultNumberOfRegistrations(Object rawValue) {
        Double value = toDouble(rawValue);
        return value == null || value <= 0 ? 1D : value;
    }

    private Integer toPositiveInt(Object rawValue, int defaultValue) {
        Integer value = toInt(rawValue);
        if (value == null || value <= 0) {
            return defaultValue;
        }
        return value;
    }

    private String normalizeStatus(Object rawValue) {
        String value = safeString(rawValue);
        return value.isEmpty() ? STATUS_CONFIRMED : value;
    }

    private String defaultString(Object rawValue, String defaultValue) {
        String value = safeString(rawValue);
        return value.isEmpty() ? defaultValue : value;
    }

    private String safeString(Object rawValue) {
        if (rawValue == null) {
            return "";
        }

        String value = String.valueOf(rawValue).trim();
        if ("null".equalsIgnoreCase(value) || "undefined".equalsIgnoreCase(value) || "nan".equalsIgnoreCase(value)) {
            return "";
        }
        return value;
    }

    private Integer toInt(Object rawValue) {
        if (rawValue == null) {
            return null;
        }

        try {
            String value = String.valueOf(rawValue).trim();
            if (value.isEmpty() || "null".equalsIgnoreCase(value) || "undefined".equalsIgnoreCase(value)
                    || "nan".equalsIgnoreCase(value)) {
                return null;
            }
            return Integer.valueOf(value);
        } catch (Exception e) {
            return null;
        }
    }

    private Double toDouble(Object rawValue) {
        if (rawValue == null) {
            return null;
        }

        try {
            String value = String.valueOf(rawValue).trim();
            if (value.isEmpty() || "null".equalsIgnoreCase(value) || "undefined".equalsIgnoreCase(value)
                    || "nan".equalsIgnoreCase(value)) {
                return null;
            }
            return Double.valueOf(value);
        } catch (Exception e) {
            return null;
        }
    }

    private Map<String, Object> fail(String message) {
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("ok", false);
        result.put("message", message);
        return result;
    }

    private Map<String, Object> fail(String message, Integer registrationId, String registrationStatus,
            Integer waitlistNo) {
        Map<String, Object> result = fail(message);
        result.put("registration_information_id", registrationId);
        result.put("registration_status", registrationStatus);
        result.put("waitlist_no", waitlistNo);
        return result;
    }

    public boolean isEscalatable(Map<String, Object> registration) {
        if (registration == null) {
            return false;
        }
        String status = normalizeStatus(registration.get("registration_status"));
        String examineState = safeString(registration.get("examine_state"));
        String escalateState = safeString(registration.get("escalate_state"));
        return !STATUS_CANCELLED.equals(status)
                && EXAMINE_REJECTED.equals(examineState)
                && !"已越级".equals(escalateState);
    }

    @Transactional
    public Map<String, Object> escalateToAdmin(Integer registrationId, String reason) {
        if (registrationId == null || registrationId <= 0) {
            return fail("报名记录不存在");
        }

        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT registration_information_id, examine_state, registration_status, escalate_state, enrolled_user "
                        +
                        "FROM registration_information WHERE registration_information_id = ? FOR UPDATE",
                registrationId);

        if (rows.isEmpty()) {
            return fail("报名记录不存在");
        }

        Map<String, Object> registration = rows.get(0);
        Integer enrolledUser = toInt(registration.get("enrolled_user"));
        String currentExamineState = safeString(registration.get("examine_state"));
        String currentEscalateState = safeString(registration.get("escalate_state"));
        String currentStatus = normalizeStatus(registration.get("registration_status"));

        if (STATUS_CANCELLED.equals(currentStatus)) {
            return fail("已取消的报名不能申请越级审核");
        }

        if (!EXAMINE_REJECTED.equals(currentExamineState)) {
            return fail("只有审核未通过的记录才能申请越级审核");
        }

        if ("已越级".equals(currentEscalateState)) {
            return fail("该记录已经申请过越级审核");
        }

        String escalateReason = safeString(reason);
        if (escalateReason.isEmpty()) {
            escalateReason = "主办用户审核未通过，申请管理员重新审核";
        }

        jdbcTemplate.update(
                "UPDATE registration_information " +
                        "SET examine_state = ?, examine_reply = ?, escalate_state = ?, escalate_reason = ?, " +
                        "registration_status = CASE WHEN registration_status = '已取消' THEN registration_status ELSE registration_status END, "
                        +
                        "update_time = NOW() " +
                        "WHERE registration_information_id = ?",
                EXAMINE_PENDING,
                "",
                "已越级",
                escalateReason,
                registrationId);

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("ok", true);
        result.put("registration_information_id", registrationId);
        result.put("examine_state", EXAMINE_PENDING);
        result.put("escalate_state", "已越级");
        result.put("message", "已提交越级审核申请，等待管理员审核");
        return result;
    }
}
