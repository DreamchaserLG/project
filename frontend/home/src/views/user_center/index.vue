<template>
  <div class="front_profile_page profile_page" id="user_center">
    <div class="profile-dashboard">
      <section v-if="isLoading" class="dashboard-card profile_loading">
        <strong>正在加载个人中心</strong>
        <span>系统正在同步账号信息和最近业务记录，请稍候。</span>
      </section>

      <template v-else>
        <header class="dashboard-header dashboard-card">
          <div class="profile_identity">
            <img class="profile_avatar" :src="avatarUrl" alt="avatar">
            <div class="profile_identity_text">
              <div class="profile_identity_head">
                <h2>{{ profile.nickname || profile.username || "未登录用户" }}</h2>
                <span class="page_status_tag" :class="profile.state === 1 ? 'is-success' : 'is-muted'">
                  {{ profile.state === 1 ? "正常" : "待确认" }}
                </span>
              </div>
              <p>{{ profile.user_group || "普通用户" }}</p>
              <span>统一管理个人资料、报名业务和后续参展流程。</span>
            </div>
          </div>

          <div class="dashboard-actions">
            <router-link class="page_primary_btn" to="/user/info">修改资料</router-link>
            <router-link class="page_secondary_btn" to="/user/password">修改密码</router-link>
          </div>
        </header>

        <div class="dashboard-content">
          <main class="dashboard-main">
            <section class="left-column dashboard-card profile_shortcuts">
              <div class="profile_section_head">
                <span class="page_kicker">Shortcut</span>
                <h2>快捷入口</h2>
                <p>快速进入报名、退款、公告和常用业务页面。</p>
              </div>
              <list_admin_menu_user />
            </section>

            <section class="right-column dashboard-card profile_info">
              <div class="profile_section_head">
                <span class="page_kicker">Profile</span>
                <h2>基础资料</h2>
                <p>展示账号信息、联系方式和当前角色状态。</p>
              </div>
              <div class="profile_info_rows">
                <div class="profile_info_row">
                  <label>用户名</label>
                  <span>{{ profile.username || "-" }}</span>
                </div>
                <div class="profile_info_row">
                  <label>昵称</label>
                  <span>{{ profile.nickname || "-" }}</span>
                </div>
                <div class="profile_info_row">
                  <label>手机号</label>
                  <span>{{ profile.phone || "-" }}</span>
                </div>
                <div class="profile_info_row">
                  <label>邮箱</label>
                  <span>{{ profile.email || "-" }}</span>
                </div>
                <div class="profile_info_row">
                  <label>用户角色</label>
                  <span>{{ profile.user_group || "-" }}</span>
                </div>
                <div class="profile_info_row">
                  <label>账号状态</label>
                  <span>{{ profile.state === 1 ? "正常" : "待确认" }}</span>
                </div>
              </div>
            </section>
          </main>

          <section class="dashboard-grid">
            <div class="dashboard-card profile_record_card">
              <div class="card-header profile_record_head">
                <div>
                  <span class="page_kicker">Registration</span>
                  <h2>最近报名</h2>
                </div>
                <router-link class="page_link_pill" to="/registration_information/table">查看全部</router-link>
              </div>

              <div class="card-body profile_record_body">
                <div v-if="registrationList.length" class="profile_record_list">
                  <div
                    v-for="item in registrationList"
                    :key="item.registration_information_id"
                    class="profile_record_item"
                  >
                    <router-link class="profile_record_main" to="/registration_information/table">
                      <strong>{{ item.booth_name || item.exhibition_theme || "报名信息" }}</strong>
                      <span>{{ item.exhibition_theme || "会展信息待更新" }}</span>
                    </router-link>
                    <div class="profile_record_side">
                      <span class="page_status_tag" :class="tagClassByText(item.registration_status || item.report_status)">
                        {{ item.registration_status || item.report_status || "已报名" }}
                      </span>
                      <small>{{ formatDate(item.registration_time || item.create_time) }}</small>
                      <el-button
                        v-if="(item.registration_status === '报名成功' || item.registration_status === '待支付') && !hasTravelForRegistration(item)"
                        type="primary"
                        size="mini"
                        @click="applyTravel(item)"
                      >行程确认</el-button>
                      <span v-else-if="hasTravelForRegistration(item)" class="page_status_tag is-success">行程已提交</span>
                      <el-button
                        v-if="(item.registration_status === '报名成功' || item.registration_status === '待支付') && !hasRefundForRegistration(item)"
                        type="warning"
                        size="mini"
                        @click="applyRefund(item)"
                      >申请退款</el-button>
                      <span v-else-if="hasRefundForRegistration(item)" class="page_status_tag is-warning">已申请退款</span>
                    </div>
                  </div>
                </div>
                <div v-else class="page_empty_state">暂无报名记录</div>
              </div>
            </div>

            <div class="dashboard-card profile_record_card">
              <div class="card-header profile_record_head">
                <div>
                  <span class="page_kicker">Travel</span>
                  <h2>行程确认</h2>
                </div>
                <router-link class="page_link_pill" to="/travel_confirmation/table">查看全部</router-link>
              </div>

              <div class="card-body profile_record_body">
                <div v-if="travelList.length" class="profile_record_list">
                  <router-link
                    v-for="item in travelList"
                    :key="item.travel_confirmation_id"
                    class="profile_record_item"
                    to="/travel_confirmation/table"
                  >
                    <div class="profile_record_main">
                      <strong>{{ item.exhibition_theme || item.booth_name || "行程确认" }}</strong>
                      <span>到场人数：{{ item.number_of_attendees || 0 }}</span>
                    </div>
                    <div class="profile_record_side">
                      <span class="page_status_tag is-success">{{ item.examine_state || "已提交" }}</span>
                      <small>{{ formatDate(item.confirm_time || item.create_time) }}</small>
                    </div>
                  </router-link>
                </div>
                <div v-else class="page_empty_state">暂无行程确认记录</div>
              </div>
            </div>

            <div class="dashboard-card profile_record_card">
              <div class="card-header profile_record_head">
                <div>
                  <span class="page_kicker">Refund</span>
                  <h2>退款申请</h2>
                </div>
                <router-link class="page_link_pill" to="/refund_request/table">查看全部</router-link>
              </div>

              <div class="card-body profile_record_body">
                <div v-if="refundList.length" class="profile_record_list">
                  <router-link
                    v-for="item in refundList"
                    :key="item.refund_request_id"
                    class="profile_record_item"
                    to="/refund_request/table"
                  >
                    <div class="profile_record_main">
                      <strong>{{ item.reason_for_application || "退款申请" }}</strong>
                      <span>退款金额：¥{{ formatPrice(item.booth_prices) }}</span>
                    </div>
                    <div class="profile_record_side">
                      <span class="page_status_tag" :class="tagClassByText(item.examine_state, 'is-warning')">
                        {{ item.examine_state || "处理中" }}
                      </span>
                      <small>{{ formatDate(item.application_time || item.create_time) }}</small>
                    </div>
                  </router-link>
                </div>
                <div v-else class="page_empty_state">暂无退款申请记录</div>
              </div>
            </div>
          </section>
        </div>
      </template>
    </div>
  </div>
</template>

<script>
import list_admin_menu_user from "@/components/diy/list_admin_menu_user.vue";

export default {
  components: {
    list_admin_menu_user,
  },
  data() {
    return {
      isLoading: true,
      profile: {
        user_id: 0,
        username: "",
        nickname: "",
        avatar: "",
        email: "",
        user_group: "",
        phone: "",
        state: 0,
      },
      registrationList: [],
      travelList: [],
      refundList: [],
    };
  },
  computed: {
    avatarUrl() {
      return this.profile.avatar ? this.$fullUrl(this.profile.avatar) : "/default_avatar.jpg";
    },
  },
  async mounted() {
    await this.initializePage();
  },
  methods: {
    getToken() {
      const storeToken = this.$store?.state?.user?.token;
      const cacheToken = typeof $ !== "undefined" && $.db ? $.db.get("token") : "";
      return storeToken || cacheToken || "";
    },
    resolveUserId() {
      return this.$store?.state?.user?.user_id || sessionStorage.getItem("user_id") || 0;
    },
    redirectToLogin() {
      this.$router.replace({
        path: "/account/login",
        query: {
          redirect: this.$route.fullPath,
        },
      });
    },
    async fetchCurrentUser() {
      return new Promise((resolve) => {
        this.$get_user((user) => {
          resolve(user || null);
        });
      });
    },
    async ensureUserContext() {
      const token = this.getToken();
      if (!token) {
        this.redirectToLogin();
        return 0;
      }

      let userId = this.resolveUserId();
      if (userId) {
        return userId;
      }

      const currentUser = await this.fetchCurrentUser();
      userId = currentUser?.user_id || this.resolveUserId();
      if (!userId) {
        this.$store.commit("sign_out");
        this.redirectToLogin();
        return 0;
      }

      sessionStorage.setItem("user_id", userId);
      sessionStorage.setItem("nickname", currentUser?.nickname || "");
      sessionStorage.setItem("avatar", currentUser?.avatar || "");
      sessionStorage.setItem("user_group", currentUser?.user_group || "");
      return userId;
    },
    async initializePage() {
      this.isLoading = true;
      const userId = await this.ensureUserContext();
      if (!userId) {
        return;
      }

      try {
        await Promise.all([this.loadProfile(userId), this.loadLatestRecords(userId)]);
      } finally {
        this.isLoading = false;
      }
    },
    async loadProfile(userId) {
      try {
        const userRes = await this.$get("~/api/user/get_obj", { user_id: userId });
        const userObj = userRes?.result?.obj || {};
        const nextProfile = {
          user_id: userId,
          username: userObj.username || "",
          nickname: userObj.nickname || sessionStorage.getItem("nickname") || "",
          avatar: userObj.avatar || sessionStorage.getItem("avatar") || "",
          email: userObj.email || "",
          user_group: userObj.user_group || sessionStorage.getItem("user_group") || "",
          phone: "",
          state: Number(userObj.state || 0),
        };

        if (nextProfile.user_group) {
          const groupRes = await this.$get("~/api/user_group/get_obj", { name: nextProfile.user_group });
          const sourceTable = groupRes?.result?.obj?.source_table;
          if (sourceTable) {
            const sourceRes = await this.$get(`~/api/${sourceTable}/get_obj`, { user_id: userId });
            const sourceObj = sourceRes?.result?.obj || {};
            nextProfile.phone =
              sourceObj.users_mobile_phone ||
              sourceObj.company_phone ||
              sourceObj.phone ||
              "";
            nextProfile.email = nextProfile.email || sourceObj.email || sourceObj.users_email || "";
          }
        }

        this.profile = nextProfile;
      } catch (error) {
        console.error("load profile failed:", error);
      }
    },
    async loadLatestRecords(userId) {
      try {
        const [registrationRes, travelRes, refundRes] = await Promise.all([
          this.$get("~/api/registration_information/get_list", {
            enrolled_user: userId,
            page: 1,
            size: 3,
            orderby: "create_time desc",
          }),
          this.$get("~/api/travel_confirmation/get_list", {
            enrolled_user: userId,
            page: 1,
            size: 3,
            orderby: "create_time desc",
          }),
          this.$get("~/api/refund_request/get_list", {
            enrolled_user: userId,
            page: 1,
            size: 3,
            orderby: "create_time desc",
          }),
        ]);

        this.registrationList = registrationRes?.result?.list || [];
        this.travelList = travelRes?.result?.list || [];
        this.refundList = refundRes?.result?.list || [];
      } catch (error) {
        console.error("load latest records failed:", error);
      }
    },
    formatDate(value) {
      if (!value) {
        return "时间待更新";
      }
      try {
        return this.$toTime(value, "yyyy-MM-dd");
      } catch (error) {
        return value;
      }
    },
    formatPrice(value) {
      if (value === null || value === undefined || value === "") {
        return "0.00";
      }
      const number = Number(value);
      return Number.isNaN(number) ? value : number.toFixed(2);
    },
    hasRefundForRegistration(reg) {
      return this.refundList.some(
        (r) =>
          (r.source_table === "registration_information" &&
            String(r.source_id) === String(reg.registration_information_id)) ||
          (r.order_number && reg.order_number &&
            String(r.order_number) === String(reg.order_number))
      );
    },
    hasTravelForRegistration(reg) {
      return this.travelList.some(
        (r) =>
          (r.source_table === "registration_information" &&
            String(r.source_id) === String(reg.registration_information_id)) ||
          (r.order_number && reg.order_number &&
            String(r.order_number) === String(reg.order_number))
      );
    },
    applyTravel(reg) {
      const formData = {};
      [
        "order_number",
        "booth_number",
        "exhibitionconvention_number",
        "exhibition_theme",
        "host_user",
        "booth_name",
        "user_name",
        "users_mobile_phone",
        "number_of_registrations",
      ].forEach((key) => {
        if (reg[key] !== undefined && reg[key] !== null && reg[key] !== "") {
          formData[key] = reg[key];
        }
      });
      formData.source_table = "registration_information";
      formData.source_id = reg.registration_information_id;
      formData.source_user_id = this.profile.user_id || this.$store.state.user.user_id;
      formData.enrolled_user = reg.enrolled_user || formData.source_user_id;
      $.db.set("form", formData);
      this.$router.push({
        path: "/travel_confirmation/view",
      });
    },
    applyRefund(reg) {
      const formData = {};
      if (reg.order_number) {
        formData.order_number = reg.order_number;
      }
      if (reg.booth_prices || reg.booth_price) {
        formData.booth_prices = reg.booth_prices || reg.booth_price;
      }
      if (reg.host_user) {
        formData.host_user = reg.host_user;
      }
      if (reg.booth_name) {
        formData.booth_name = reg.booth_name;
      }
      if (this.profile.phone || this.profile.username) {
        formData.users_mobile_phone = this.profile.phone || "";
      }
      if (this.profile.nickname || this.profile.username) {
        formData.user_name = this.profile.nickname || this.profile.username;
      }
      formData.source_table = "registration_information";
      formData.source_id = reg.registration_information_id;
      formData.source_user_id = this.profile.user_id || this.$store.state.user.user_id;
      formData.enrolled_user = reg.enrolled_user || formData.source_user_id;
      $.db.set("form", formData);
      this.$router.push({
        path: "/refund_request/view",
      });
    },
    tagClassByText(value, fallback = "is-primary") {
      const text = String(value || "");
      if (!text) {
        return fallback;
      }
      if (/成功|通过|正常|已确认|已报名|已完成|转正/.test(text)) {
        return "is-success";
      }
      if (/待|审核|候补|处理中|申请中|未审核/.test(text)) {
        return "is-warning";
      }
      if (/取消|失败|驳回|结束|关闭|退款/.test(text)) {
        return "is-muted";
      }
      return fallback;
    },
  },
};
</script>

<style scoped>
.profile_page {
  width: 100%;
  min-width: 0;
  padding-top: 0;
  display: flex;
  flex-direction: column;
}

.profile-dashboard,
.profile-dashboard * {
  box-sizing: border-box;
}

.profile-dashboard {
  width: 100%;
  max-width: 1200px;
  min-width: 0;
  flex: 1;
  margin: 0 auto;
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.dashboard-content {
  display: flex;
  flex: 1;
  flex-direction: column;
  width: 100%;
  max-width: 100%;
  min-width: 0;
  gap: 24px;
}

.dashboard-card {
  min-width: 0;
  background: #fff;
  border-radius: 16px;
  padding: 24px;
  box-sizing: border-box;
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: 0 12px 30px rgba(16, 34, 51, 0.08);
  overflow: hidden;
}

.profile_loading {
  display: grid;
  gap: 8px;
  color: var(--color_text_soft);
}

.profile_loading strong {
  color: var(--color_text);
  font-size: 1.1rem;
}

.dashboard-header {
  min-height: 148px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
}

.profile_identity {
  display: flex;
  align-items: center;
  flex: 1 1 auto;
  min-width: 0;
  gap: 18px;
}

.profile_avatar {
  width: 96px;
  height: 96px;
  border-radius: 50%;
  object-fit: cover;
  background: #dce6ed;
  box-shadow: 0 12px 22px rgba(16, 34, 51, 0.08);
  flex-shrink: 0;
}

.profile_identity_text {
  min-width: 0;
  max-width: 760px;
}

.profile_identity_head {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.profile_identity_head h2 {
  margin: 0;
  color: var(--color_text);
  font-size: 27px;
  line-height: 1.25;
}

.profile_identity_text p {
  margin: 8px 0 0;
  color: var(--color_text_soft);
}

.profile_identity_text > span {
  display: block;
  margin-top: 10px;
  color: var(--color_text_soft);
  line-height: 1.75;
}

.dashboard-actions {
  display: grid;
  grid-template-columns: repeat(2, minmax(150px, 1fr));
  align-items: center;
  flex: 0 0 330px;
  min-width: 330px;
  gap: 12px;
}

.dashboard-actions .page_primary_btn,
.dashboard-actions .page_secondary_btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  min-width: 0;
  min-height: 44px;
  text-align: center;
  white-space: nowrap;
}

.dashboard-main {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 24px;
  align-items: stretch;
}

.left-column,
.right-column {
  display: flex;
  flex-direction: column;
  min-height: 100%;
}

.profile_shortcuts ::v-deep .profile_menu_list {
  align-content: start;
}

.profile_section_head {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  min-height: 88px;
  margin-bottom: 18px;
}

.profile_section_head h2,
.profile_record_head h2 {
  margin: 8px 0 0;
  color: var(--color_text);
  font-size: 22px;
  line-height: 1.28;
}

.profile_section_head p {
  margin: 10px 0 0;
  color: var(--color_text_soft);
  line-height: 1.75;
}

.profile_info_rows {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
  flex: 1;
  align-content: start;
}

.profile_info_row {
  display: grid;
  grid-template-columns: 76px minmax(0, 1fr);
  align-items: center;
  min-height: 54px;
  padding: 10px 14px;
  border-radius: 12px;
  background: #fff;
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: 0 6px 16px rgba(16, 34, 51, 0.05);
}

.profile_info_row label {
  padding-right: 12px;
  margin-right: 12px;
  border-right: 1px solid rgba(15, 54, 80, 0.08);
  color: var(--color_text_soft);
  text-align: right;
  font-size: 14px;
}

.profile_info_row span {
  min-width: 0;
  overflow: hidden;
  color: var(--color_text);
  text-overflow: ellipsis;
  white-space: nowrap;
}

.dashboard-grid {
  display: flex;
  flex-wrap: nowrap;
  gap: 24px;
  width: 100%;
  align-items: stretch;
  justify-content: stretch;
}

.dashboard-grid > .dashboard-card {
  display: flex;
  flex: 1 1 0;
  flex-direction: column;
  min-width: 0;
  width: 0;
  height: auto;
  min-height: 372px;
}

.dashboard-grid > .dashboard-card:nth-child(1) {
  order: 1;
}

.dashboard-grid > .dashboard-card:nth-child(2) {
  order: 2;
}

.dashboard-grid > .dashboard-card:nth-child(3) {
  order: 3;
}

.dashboard-grid .card-header {
  display: flex;
  flex: 0 0 62px;
  align-items: flex-start;
  padding-bottom: 18px;
}

.dashboard-grid .card-body {
  display: flex;
  flex: 1 1 auto;
  flex-direction: column;
  min-width: 0;
  min-height: 0;
}

.profile_record_head {
  justify-content: space-between;
  gap: 14px;
}

.profile_record_head > div {
  min-width: 0;
  overflow: hidden;
}

.profile_record_list {
  display: grid;
  gap: 12px;
  align-content: flex-start;
  flex: 1;
  min-height: 0;
}

.profile_record_item {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 14px;
  min-width: 0;
  min-height: 82px;
  padding: 14px;
  border-radius: 12px;
  background: #fff;
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: 0 6px 16px rgba(16, 34, 51, 0.05);
}

.profile_record_main {
  min-width: 0;
  flex: 1;
  overflow: hidden;
}

.profile_record_main strong {
  display: block;
  overflow: hidden;
  color: var(--color_text);
  overflow-wrap: anywhere;
  word-break: break-word;
}

.profile_record_main span {
  display: block;
  min-width: 0;
  margin-top: 6px;
  overflow: hidden;
  color: var(--color_text_soft);
  line-height: 1.65;
  overflow-wrap: anywhere;
  word-break: break-word;
}

.profile_record_side {
  display: flex;
  flex: 0 1 96px;
  flex-direction: column;
  align-items: flex-end;
  gap: 7px;
  color: var(--color_text_soft);
  font-size: 14px;
  min-width: 0;
  overflow: hidden;
}

.profile_record_side .el-button {
  margin: 0;
  padding: 4px 10px;
  font-size: 12px;
}

.profile_record_side .page_status_tag,
.profile_record_side small {
  max-width: 100%;
  overflow: hidden;
  text-align: right;
  overflow-wrap: anywhere;
  word-break: break-word;
}

.profile_record_card .page_empty_state {
  display: flex;
  align-items: center;
  justify-content: center;
  flex: 1;
  min-height: 170px;
}

@media (max-width: 1180px) {
  .profile-dashboard {
    padding: 20px;
    gap: 20px;
  }

  .dashboard-header,
  .dashboard-main,
  .dashboard-grid {
    gap: 20px;
  }

  .dashboard-actions {
    flex-basis: 310px;
    min-width: 310px;
  }
}

@media (max-width: 980px) {
  .dashboard-main {
    grid-template-columns: 1fr;
  }

  .dashboard-grid {
    flex-direction: column;
  }

  .dashboard-grid > .dashboard-card {
    width: 100%;
  }

  .profile_record_card {
    min-height: auto;
  }
}

@media (max-width: 960px) {
  .dashboard-card {
    padding: 20px;
  }

  .profile_info_rows {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 760px) {
  .profile-dashboard {
    padding: 16px;
    gap: 16px;
  }

  .dashboard-header {
    display: grid;
    grid-template-columns: 1fr;
    min-height: auto;
  }

  .dashboard-actions {
    width: 100%;
    min-width: 0;
    flex-basis: auto;
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .profile_identity,
  .profile_record_item {
    flex-direction: column;
    align-items: flex-start;
  }

  .profile_record_side {
    align-items: flex-start;
  }
}

@media (max-width: 560px) {
  .dashboard-card {
    padding: 16px;
    border-radius: 14px;
  }

  .profile_identity {
    min-height: auto;
  }

  .profile_avatar {
    width: 78px;
    height: 78px;
  }

  .dashboard-actions {
    grid-template-columns: 1fr;
  }

  .profile_identity_head h2 {
    font-size: 22px;
  }

  .profile_section_head,
  .profile_record_head {
    min-height: auto;
  }

  .profile_info_row {
    grid-template-columns: 1fr;
    gap: 6px;
  }

  .profile_info_row label {
    padding-right: 0;
    margin-right: 0;
    border-right: 0;
    text-align: left;
  }
}
</style>
