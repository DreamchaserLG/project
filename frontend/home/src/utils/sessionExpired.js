import axios from "axios";
import { Message } from "element-ui";

let handlingSessionExpired = false;

const loginPath = "/account/login";
const authFreePaths = new Set([loginPath, "/account/register", "/account/forgot"]);

function currentPath(router) {
  return router && router.currentRoute ? router.currentRoute.path : "";
}

function errorMessage(data) {
  if (!data) {
    return "";
  }
  if (typeof data === "string") {
    return data;
  }
  if (data.error) {
    return String(data.error.message || data.error.msg || data.error || "");
  }
  return String(data.message || data.msg || "");
}

function isLoginExpiredPayload(response) {
  if (!response) {
    return false;
  }
  if (response.status === 401 || response.status === 403) {
    return true;
  }
  const data = response.data || {};
  const code = data.error ? data.error.code : data.code;
  const message = errorMessage(data);
  return (code === 401 || code === 403 || code === 10000 || code === 30000)
    && /未登录|请先登录|登录已过期|token|Token|TOKEN|session|Session/.test(message);
}

export function clearLoginState(store) {
  try {
    if (store && store.commit) {
      store.commit("sign_out");
    }
  } catch (e) {
    // ignore store reset errors, browser storage is the source of truth here.
  }
  try {
    localStorage.clear();
  } catch (e) {}
  try {
    sessionStorage.clear();
  } catch (e) {}
}

export function handleSessionExpired(router, store) {
  if (handlingSessionExpired) {
    return;
  }
  handlingSessionExpired = true;

  const path = currentPath(router);
  clearLoginState(store);

  if (!authFreePaths.has(path)) {
    Message.warning("登录已过期，请重新登录");
  }

  if (router && path !== loginPath) {
    router.replace({
      path: loginPath,
      query: path ? { redirect: router.currentRoute.fullPath } : {}
    }).catch(() => {});
  }

  setTimeout(() => {
    handlingSessionExpired = false;
  }, 1500);
}

export function setupSessionExpiredHandler(router, store) {
  axios.interceptors.response.use(
    (response) => {
      if (isLoginExpiredPayload(response)) {
        handleSessionExpired(router, store);
        return Promise.reject(response);
      }
      return response;
    },
    (error) => {
      if (error && isLoginExpiredPayload(error.response)) {
        handleSessionExpired(router, store);
      }
      return Promise.reject(error);
    }
  );
}

export function isAuthFreePath(path) {
  return authFreePaths.has(path);
}
