import axios from "axios";
import { Message } from "element-ui";

const DASHSCOPE_API_KEY = process.env.VUE_APP_DASHSCOPE_API_KEY || "";
const DASHSCOPE_API_URL =
  process.env.VUE_APP_DASHSCOPE_API_URL ||
  "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions";
const DASHSCOPE_MODEL = process.env.VUE_APP_DASHSCOPE_MODEL || "qwen-turbo";

class RequestHelper {
  constructor() {
    this.baseURL = "";
  }
  // 请求
  request(options) {
    //console.log(options)
    let instance = axios.create();
    let opt = Object.assign(this.getDefaultConfig(), options);
    this.interceptors(instance);
    return instance(opt);
  }
  // 默认配置
  getDefaultConfig() {
    let config = {
      baseURL: this.baseURL,
      timeout: 30000,
      headers: {},
    };
    return config;
  }

  // 拦截器
  interceptors(instance) {
    instance.interceptors.request.use(
      (config) => {
              if (!DASHSCOPE_API_KEY) {
                Message.error("请先配置 VUE_APP_DASHSCOPE_API_KEY");
                return Promise.reject(new Error("Missing VUE_APP_DASHSCOPE_API_KEY"));
              }
              config.headers["Authorization"] = `Bearer ${DASHSCOPE_API_KEY}`;
              return config;
      },
      (error) => {
        console.log(error);
        return Promise.reject(error);
      }
    );

    instance.interceptors.response.use(
      (response) => {
        return response.data;
      },
      (error) => {
        if (error.response) {
          switch (error.response.status) {
            case 500:
              Message.error(`服务器错误${error.message}`);
              break;
            case 503:
              Message.error(`服务器错误${error.message}`);
              break;
          }
        } else {
          return Message.error(`请求无响应`);
        }
        return Promise.reject(error);
      }
    );
  }

  post({ data, options = {} }) {
              options.url = DASHSCOPE_API_URL;
        data.model = data.model || DASHSCOPE_MODEL;
          options.data = data;
    options.method = "post";
    return this.request(options);
  }
}
let requestHelper = new RequestHelper();

export default requestHelper;
