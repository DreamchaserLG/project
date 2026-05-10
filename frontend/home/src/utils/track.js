import axios from "axios";

const TRACK_URL = "/api/track";

export function trackEvent(eventName, page, data = {}) {
  try {
    const userId = sessionStorage.getItem("user_id") || "";
    const username = sessionStorage.getItem("nickname") || sessionStorage.getItem("username") || "";
    axios.post(TRACK_URL, {
      event: eventName,
      page: page,
      userId: userId,
      username: username,
      data: data,
    }).catch(() => {});
  } catch (e) {}
}

export function trackPageView(page) {
  trackEvent("页面访问", page);
}

export function trackClick(page, target) {
  trackEvent("点击", page, { target });
}

export function trackSubmit(page, formName) {
  trackEvent("提交表单", page, { form: formName });
}
