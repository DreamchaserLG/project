<template>
  <div class="page_account auth_login_page" id="account_login">
    <div class="auth_login_shell">
      <section class="auth_login_visual">
        <span class="page_kicker">Secure Access</span>
        <h1>会展管理系统</h1>
        <p>登录后可继续进行会展浏览、展位报名、行程确认、退款申请和个人业务记录管理。</p>

        <div class="auth_visual_cards">
          <article class="auth_visual_card">
            <strong>统一登录入口</strong>
            <span>未登录访问前台业务页面时，将自动跳转到登录页，避免直接暴露业务数据。</span>
          </article>
          <article class="auth_visual_card">
            <strong>业务流程连续</strong>
            <span>登录成功后会自动回到原目标页面，不中断报名、公告查看和信息查询流程。</span>
          </article>
          <article class="auth_visual_card">
            <strong>多角色协同</strong>
            <span>支持普通用户与管理员在同一门户中按权限访问各自页面与功能。</span>
          </article>
        </div>
      </section>

      <section class="auth_login_panel">
        <div class="auth_login_header">
          <span class="page_kicker">Account Login</span>
          <h2>用户登录</h2>
          <p>请输入账号和密码，并完成验证码校验后继续。</p>
        </div>

        <b-form class="auth_login_form" @submit.prevent="submit">
          <b-form-group
            label="账号"
            label-for="login-username"
            :state="validation_username"
            invalid-feedback="账号长度应为 5 到 16 个字符"
          >
            <b-form-input
              id="login-username"
              v-model.trim="form.username"
              type="text"
              placeholder="请输入账号"
              autocomplete="username"
            />
          </b-form-group>

          <b-form-group
            label="密码"
            label-for="login-password"
            :state="validation_password"
            invalid-feedback="密码长度不能低于6位"
          >
            <div class="auth_password_field">
              <b-form-input
                id="login-password"
                v-model.trim="form.password"
                :type="showPassword ? 'text' : 'password'"
                placeholder="请输入密码"
                autocomplete="current-password"
              />
              <button type="button" class="password_toggle" @click="showPassword = !showPassword">
                <b-icon :icon="showPassword ? 'eye' : 'eye-slash'"></b-icon>
              </button>
            </div>
          </b-form-group>

          <div class="auth_verify_group">
            <label>验证码</label>
            <div class="auth_verify_box">
              <Verification ref="child"></Verification>
            </div>
          </div>
        </b-form>

        <div class="auth_login_actions">
          <button type="button" class="page_primary_btn auth_submit_btn" @click="submit">登录系统</button>
          <button type="button" class="page_secondary_btn auth_text_btn" @click="$router.push('/account/forgot')">找回密码</button>
        </div>

        <div class="auth_login_links">
          <span>还没有账号？</span>
          <button type="button" class="auth_inline_link" @click="$router.push('/account/register')">立即注册</button>
        </div>
      </section>
    </div>
  </div>
</template>

<script>
import Verification from "@/components/common/verification.vue";
import { rsaEncrypt } from "@/store/encrypt";
import mixin from "@/mixins/page.js";

export default {
  mixins: [mixin],
  components: {
    Verification,
  },
  data() {
    return {
      showPassword: false,
      allow_user: ["普通用户"],
      form: {
        username: "",
        password: "",
      },
    };
  },
  computed: {
    redirectPath() {
      return typeof this.$route.query.redirect === "string" && this.$route.query.redirect
        ? this.$route.query.redirect
        : "/";
    },
    validation_username() {
      const length = this.form.username.length;
      if (!length) {
        return null;
      }
      return length > 4 && length < 17;
    },
    validation_password() {
      const length = this.form.password.length;
      if (!length) {
        return null;
      }
      return length >= 6;
    },
  },
  methods: {
    submit() {
      const verified = this.$refs.child ? this.$refs.child.sublim() : true;
      if (!this.validation_username) {
        return this.$message.warning("请输入正确账号");
      }
      if (!this.validation_password) {
        return this.$message.warning("请输入正确密码");
      }
      if (!verified) {
        return;
      }

      const form = Object.assign({}, this.form);
      form.password = rsaEncrypt(form.password);
      this.$post("~/api/user/login?", form, (res) => {
        if (res.result && res.result.obj) {
          const obj = res.result.obj;
          const login_time = new Date().toLocaleString("zh-CN").replace(/\//g, "-").replace(/\s/, " ").split(".")[0];
          this.$post(`~/api/user/set?user_id=${obj.user_id}`, {
            login_time,
          });
          obj.login_time = login_time;

          if (this.allow_user.includes(obj.user_group)) {
            $.db.set("token", obj.token);
            this.$store.commit("user_set", obj);
            sessionStorage.setItem("user_id", obj.user_id);
            sessionStorage.setItem("nickname", obj.nickname || "");
            sessionStorage.setItem("avatar", obj.avatar || "");
            sessionStorage.setItem("user_group", obj.user_group || "");

            const targetPath = this.redirectPath && this.redirectPath.startsWith("/account/")
              ? "/"
              : this.redirectPath;
            this.$get_auth(obj.user_group, () => {
              this.$router.replace(targetPath).catch(() => {});
            });
            this.$message.success("登录成功");
          } else {
            this.$message.error("管理员和主办用户请使用管理端登录");
          }
        } else if (res.error) {
          this.$message.error(res.error.message);
        }
      });
    },
  },
};
</script>

<style scoped>
.auth_login_page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem 1.2rem;
}

.auth_login_shell {
  display: grid;
  grid-template-columns: minmax(360px, 1.05fr) minmax(380px, 520px);
  width: min(100%, 1340px);
  overflow: hidden;
  border-radius: 34px;
  background: rgba(255, 255, 255, 0.94);
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: 0 34px 70px rgba(12, 38, 56, 0.14);
}

.auth_login_visual {
  position: relative;
  overflow: hidden;
  padding: 2.6rem 2.6rem 2.4rem;
  background:
    linear-gradient(145deg, rgba(9, 57, 67, 0.95), rgba(15, 95, 108, 0.76)),
    url("/img/theme/future-showroom.jpg") center/cover no-repeat;
  color: #fff;
}

.auth_login_visual h1 {
  margin: 1rem 0 0.9rem;
  font-size: 3rem;
  line-height: 1.14;
}

.auth_login_visual p {
  max-width: 34rem;
  line-height: 1.9;
  color: rgba(255, 255, 255, 0.84);
}

.auth_visual_cards {
  display: grid;
  gap: 1rem;
  margin-top: 2.1rem;
}

.auth_visual_card {
  padding: 1.15rem 1.2rem;
  border-radius: 24px;
  background: rgba(255, 255, 255, 0.12);
  border: 1px solid rgba(255, 255, 255, 0.14);
  backdrop-filter: blur(10px);
}

.auth_visual_card strong {
  display: block;
  font-size: 1rem;
}

.auth_visual_card span {
  display: block;
  margin-top: 0.45rem;
  color: rgba(255, 255, 255, 0.8);
  line-height: 1.78;
}

.auth_login_panel {
  padding: 2.5rem 2.45rem;
}

.auth_login_header h2 {
  margin: 0.9rem 0 0.45rem;
  color: var(--color_text);
  font-size: 2rem;
}

.auth_login_header p {
  margin: 0;
  color: var(--color_text_soft);
  line-height: 1.8;
}

.auth_login_form {
  margin-top: 1.45rem;
}

.auth_login_form :deep(.form-group) {
  margin-bottom: 1.15rem;
}

.auth_login_form :deep(label) {
  display: block;
  margin-bottom: 0.45rem;
  color: var(--color_text_soft);
  font-size: 0.88rem;
  font-weight: 700;
}

.auth_login_form :deep(.form-control) {
  min-height: 48px;
  border-radius: 16px;
  border: 1px solid rgba(15, 54, 80, 0.12);
  box-shadow: none;
}

.auth_login_form :deep(.form-control:focus) {
  border-color: rgba(15, 95, 108, 0.4);
  box-shadow: 0 0 0 3px rgba(15, 95, 108, 0.12);
}

.auth_password_field {
  position: relative;
}

.password_toggle {
  position: absolute;
  top: 50%;
  right: 0.9rem;
  transform: translateY(-50%);
  border: none;
  background: transparent;
  color: var(--color_text_soft);
  cursor: pointer;
}

.auth_verify_group {
  margin-top: 0.2rem;
}

.auth_verify_group label {
  display: block;
  margin-bottom: 0.45rem;
  color: var(--color_text_soft);
  font-size: 0.88rem;
  font-weight: 700;
}

.auth_verify_box {
  display: flex;
  align-items: center;
  min-height: 64px;
  padding: 0.7rem 0.85rem;
  border-radius: 18px;
  background: #f7fafc;
  border: 1px solid rgba(15, 54, 80, 0.08);
}

.auth_verify_box :deep(.el-input) {
  flex: 1;
}

.auth_login_actions {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0.8rem;
  margin-top: 1.4rem;
}

.auth_submit_btn,
.auth_text_btn {
  min-height: 46px;
}

.auth_login_links {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.45rem;
  margin-top: 1.1rem;
  color: var(--color_text_soft);
}

.auth_inline_link {
  border: none;
  background: transparent;
  color: var(--color_primary);
  font-weight: 700;
  cursor: pointer;
}

@media (max-width: 980px) {
  .auth_login_shell {
    grid-template-columns: 1fr;
  }

  .auth_login_visual,
  .auth_login_panel {
    padding: 1.6rem;
  }

  .auth_login_visual h1 {
    font-size: 2.3rem;
  }
}

@media (max-width: 640px) {
  .auth_login_page {
    padding: 1rem 0.8rem;
  }

  .auth_login_actions {
    grid-template-columns: 1fr;
  }
}
</style>
