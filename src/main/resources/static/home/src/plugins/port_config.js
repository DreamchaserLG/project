const envBaseUrl = process.env.VUE_APP_API_BASE_URL;

let hostConfig = envBaseUrl || "/";
if (!hostConfig.endsWith("/")) {
  hostConfig += "/";
}

export default hostConfig;
