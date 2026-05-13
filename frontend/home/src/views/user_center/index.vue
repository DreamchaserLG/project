<template>
  <div class="front_profile_page profile_page" id="user_center">
    <section class="page_intro_card profile_intro" :style="bannerStyle">
      <span class="page_kicker">User Center</span>
      <h1>个人中心</h1>
      <p>集中查看个人资料、报名记录、行程确认和退款申请，保持前台用户业务流程完整。</p>
    </section>

    <section v-if="isLoading" class="profile_loading_card">
      <strong>正在加载个人中心</strong>
      <span>正在同步账号信息和最近业务记录，请稍候。</span>
    </section>

    <template v-else>
      <section class="profile_dashboard_card">
        <div class="profile_dashboard_identity">
          <img class="profile_avatar" :src="avatarUrl" alt="avatar">
          <div class="profile_identity_copy">
            <div class="profile_identity_head">
              <h2>{{ profile.nickname || profile.username || "未登录用户" }}</h2>
              <span class="page_status_tag" :class="profile.state === 1 ? 'is-success' : 'is-muted'">
                {{ profile.state === 1 ? "正常" : "待确认" }}
              </span>
            </div>
            <p>{{ profile.user_group || "普通用户" }}</p>
            <span class="profile_identity_hint">统一管理个人资料、报名业务和后续参展流程。</span>
          </div>
        </div>

        <div class="profile_metric_strip">
          <article class="profile_metric_card">
            <strong>{{ registrationList.length }}</strong>
            <span>近期报名</span>
          </article>
          <article class="profile_metric_card">
            <strong>{{ refundList.length }}</strong>
            <span>退款申请</span>
          </article>
          <article class="profile_metric_card">
            <strong>{{ travelList.length }}</strong>
            <span>行程确认</span>
          </article>
        </div>

        <div class="profile_action_group">
          <router-link class="page_primary_btn" to="/user/info">修改资料</router-link>
          <router-link class="page_secondary_btn" to="/user/password">修改密码</router-link>
        </div>
      </section>

      <section class="profile_body_shell">
        <div class="profile_body_grid">
          <div class="profile_info_panel">
            <div class="page_list_head compact_head">
              <div>
                <span class="page_kicker">Profile</span>
                <h2>基础资料</h2>
                <p>统一展示账号信息、联系方式和当前角色状态。</p>
              </div>
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
          </div>

          <div class="profile_menu_panel">
            <div class="page_list_head compact_head">
              <div>
                <span class="page_kicker">Shortcut</span>
                <h2>快捷入口</h2>
                <p>快速跳转到报名、退款、公告和常用业务页面。</p>
              </div>
            </div>
            <list_admin_menu_user />
          </div>
        </div>
      </section>

      <section class="profile_record_grid">
        <div class="profile_record_card">
          <div class="page_list_head compact_head">
            <div>
              <span class="page_kicker">Registration</span>
              <h2>最近报名</h2>
            </div>
            <router-link class="page_link_pill" to="/registration_information/table">查看全部</router-link>
          </div>

          <div v-if="registrationList.length" class="profile_record_list">
            <div
              v-for="item in registrationList"
              :key="item.registration_information_id"
              class="profile_record_item"
            >
              <router-link
                class="profile_record_main"
                to="/registration_information/table"
              >
                <div class="profile_record_title">{{ item.booth_name || item.exhibition_theme || "报名信息" }}</div>
                <div class="profile_record_desc">{{ item.exhibition_theme }}</div>
              </router-link>
              <div class="profile_record_side">
                <span class="page_status_tag" :class="tagClassByText(item.registration_status || item.report_status)">
                  {{ item.registration_status || item.report_status || "已报名" }}
                </span>
                <span>{{ formatDate(item.registration_time || item.payment_date) }}</span>
                <el-button
                  v-if="item.examine_state === '已通过' && !hasTravelForRegistration(item)"
                  class="profile_refund_btn"
                  type="primary"
                  size="mini"
                  @click="applyTravel(item)"
                >行程确认</el-button>
                <span
                  v-else-if="hasTravelForRegistration(item)"
                  class="page_status_tag is-success"
                  style="margin-left: 8px;"
                >行程已提交</span>
                <el-button
                  v-if="item.examine_state === '已通过' && !hasRefundForRegistration(item)"
                  class="profile_refund_btn"
                  type="warning"
                  size="mini"
                  @click="applyRefund(item)"
                >申请退款</el-button>
                <span
                  v-else-if="hasRefundForRegistration(item)"
                  class="page_status_tag is-warning"
                  style="margin-left: 8px;"
                >已申请退款</span>
              </div>
            </div>
          </div>
          <div v-else class="page_empty_state">暂无报名记录</div>
        </div>

        <div class="profile_record_card">
          <div class="page_list_head compact_head">
            <div>
              <span class="page_kicker">Refund</span>
              <h2>退款申请</h2>
            </div>
            <router-link class="page_link_pill" to="/refund_request/table">查看全部</router-link>
          </div>

          <div v-if="refundList.length" class="profile_record_list">
            <router-link
              v-for="item in refundList"
              :key="item.refund_request_id"
              class="profile_record_item"
              to="/refund_request/table"
            >
              <div class="profile_record_main">
                <div class="profile_record_title">{{ item.reason_for_application || "退款申请" }}</div>
                <div class="profile_record_desc">退款金额：￥{{ formatPrice(item.booth_prices) }}</div>
              </div>
              <div class="profile_record_side">
                <span class="page_status_tag" :class="tagClassByText(item.refund_status || item.review_status, 'is-warning')">
                  {{ item.refund_status || item.review_status || "处理中" }}
                </span>
                <span>{{ formatDate(item.application_time || item.create_time) }}</span>
              </div>
            </router-link>
          </div>
          <div v-else class="page_empty_state">暂无退款申请记录</div>
        </div>

        <div class="profile_record_card">
          <div class="page_list_head compact_head">
            <div>
              <span class="page_kicker">Travel</span>
              <h2>行程确认</h2>
            </div>
            <router-link class="page_link_pill" to="/travel_confirmation/table">查看全部</router-link>
          </div>

          <div v-if="travelList.length" class="profile_record_list">
            <router-link
              v-for="item in travelList"
              :key="item.travel_confirmation_id"
              class="profile_record_item"
              to="/travel_confirmation/table"
            >
              <div class="profile_record_main">
                <div class="profile_record_title">{{ item.exhibition_theme || item.booth_name || "行程确认" }}</div>
                <div class="profile_record_desc">到场人数：{{ item.number_of_attendees || 0 }}</div>
              </div>
              <div class="profile_record_side">
                <span class="page_status_tag is-success">{{ item.confirmation_status || "已确认" }}</span>
                <span>{{ formatDate(item.confirm_time || item.create_time) }}</span>
              </div>
            </router-link>
          </div>
          <div v-else class="page_empty_state">暂无行程确认记录</div>
        </div>
      </section>
    </template>
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
    bannerStyle() {
      return {
        "--page-banner-image": "url(/img/theme/future-showroom.jpg)",
      };
    },
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
      if (/待|审核|候补|处理中|申请中/.test(text)) {
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
.profile_loading_card,
.profile_dashboard_card,
.profile_body_shell,
.profile_record_card {
  padding: 1.5rem 1.6rem;
  border-radius: 30px;
  background: rgba(255, 255, 255, 0.95);
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: var(--shadow_soft);
}

.profile_loading_card {
  display: flex;
  flex-direction: column;
  gap: 0.45rem;
  margin-top: 1.2rem;
  color: var(--color_text_soft);
}

.profile_loading_card strong {
  color: var(--color_text);
  font-size: 1.1rem;
}

.profile_dashboard_card {
  display: grid;
  grid-template-columns: minmax(0, 1.15fr) minmax(340px, 0.95fr) auto;
  gap: 1.1rem;
  align-items: center;
  margin-top: 1.2rem;
}

.profile_dashboard_identity {
  display: flex;
  align-items: center;
  gap: 1rem;
  min-width: 0;
}

.profile_avatar {
  width: 94px;
  height: 94px;
  border-radius: 50%;
  object-fit: cover;
  background: #dce6ed;
  box-shadow: 0 12px 22px rgba(16, 34, 51, 0.08);
  flex-shrink: 0;
}

.profile_identity_copy {
  min-width: 0;
}

.profile_identity_head {
  display: flex;
  align-items: center;
  gap: 0.8rem;
  flex-wrap: wrap;
}

.profile_identity_head h2 {
  margin: 0;
  color: var(--color_text);
  font-size: 1.72rem;
}

.profile_identity_copy p {
  margin: 0.45rem 0 0;
  color: var(--color_text_soft);
  font-size: 1rem;
}

.profile_identity_hint {
  display: block;
  margin-top: 0.55rem;
  color: var(--color_text_soft);
  line-height: 1.75;
}

.profile_metric_strip {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 0.85rem;
}

.profile_metric_card {
  padding: 1rem 0.9rem;
  border-radius: 20px;
  background: linear-gradient(180deg, #ffffff, #f4f8fb);
  border: 1px solid rgba(15, 54, 80, 0.08);
  text-align: center;
}

.profile_metric_card strong {
  display: block;
  color: var(--color_primary);
  font-family: var(--font_heading);
  font-size: 1.7rem;
}

.profile_metric_card span {
  display: block;
  margin-top: 0.35rem;
  color: var(--color_text_soft);
  font-size: 0.88rem;
}

.profile_action_group {
  display: grid;
  gap: 0.75rem;
}

.profile_action_group :deep(.page_primary_btn),
.profile_action_group :deep(.page_secondary_btn),
.profile_action_group .page_primary_btn,
.profile_action_group .page_secondary_btn {
  min-width: 150px;
  text-align: center;
}

.profile_body_shell,
.profile_body_grid,
.profile_record_grid {
  margin-top: 1.2rem;
}

.profile_body_grid {
  display: grid;
  gap: 1.2rem;
}

.profile_body_grid {
  grid-template-columns: minmax(0, 1.06fr) minmax(360px, 0.94fr);
  align-items: start;
}

.profile_info_panel {
  min-width: 0;
  padding-right: 1.2rem;
  border-right: 1px solid rgba(15, 54, 80, 0.08);
}

.profile_menu_panel {
  min-width: 0;
  padding-left: 0.1rem;
}

.compact_head {
  margin-bottom: 1rem;
}

.compact_head h2 {
  font-size: 1.5rem;
}

.profile_info_rows {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 0.75rem 1rem;
}

.profile_info_row {
  display: flex;
  align-items: center;
  min-height: 52px;
  padding: 0.6rem 1rem;
  border-radius: 16px;
  background: #fff;
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: 0 4px 12px rgba(16, 34, 51, 0.04);
}

.profile_info_row label {
  flex-shrink: 0;
  width: 80px;
  color: var(--color_text_sub);
  font-size: 0.88rem;
  text-align: right;
  padding-right: 0.8rem;
  border-right: 1px solid rgba(15, 54, 80, 0.08);
  margin-right: 0.8rem;
}

.profile_info_row span {
  flex: 1;
  min-width: 0;
  color: var(--color_text);
  font-size: 0.9rem;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

@media (max-width: 768px) {
  .profile_info_rows {
    grid-template-columns: 1fr;
  }
}

.profile_record_grid {
  display: flex;
  gap: 1.2rem;
  align-items: stretch;
  width: 100%;
}

.profile_record_card {
  display: flex;
  flex: 1 1 0;
  flex-direction: column;
  min-height: 100%;
  min-width: 0;
}

.profile_record_list {
  display: flex;
  flex-direction: column;
  gap: 0.85rem;
}

.profile_record_item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  padding: 0.85rem 1rem;
  border-radius: 16px;
  background: #fff;
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: 0 4px 12px rgba(16, 34, 51, 0.04);
  transition: transform 0.2s ease;
}

.profile_record_main {
  min-width: 0;
  flex: 1;
}

.profile_record_title {
  display: -webkit-box;
  overflow: hidden;
  color: var(--color_text);
  font-weight: 700;
  line-height: 1.65;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
}

.profile_record_desc {
  margin-top: 0.4rem;
  color: var(--color_text_soft);
  line-height: 1.75;
}

.profile_record_side {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 0.4rem;
  color: var(--color_text_soft);
  font-size: 0.88rem;
  flex-shrink: 0;
}

.profile_refund_btn {
  margin-top: 4px;
  font-size: 12px;
  padding: 4px 10px;
}

@media (max-width: 1280px) {
  .profile_dashboard_card {
    grid-template-columns: 1fr;
  }

  .profile_action_group {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 1100px) {
  .profile_body_grid,
  .profile_record_grid {
    display: grid;
    grid-template-columns: 1fr;
  }

  .profile_info_panel {
    padding-right: 0;
    border-right: none;
  }

  .profile_menu_panel {
    padding-left: 0;
    padding-top: 1.2rem;
    border-top: 1px solid rgba(15, 54, 80, 0.08);
  }
}

@media (max-width: 760px) {
  .profile_metric_strip,
  .profile_info_rows,
  .profile_action_group {
    grid-template-columns: 1fr;
  }

  .profile_dashboard_identity,
  .profile_record_item {
    flex-direction: column;
    align-items: flex-start;
  }

  .profile_info_row {
    grid-template-columns: 1fr;
    gap: 0.35rem;
    padding: 0.95rem 1rem;
  }

  .profile_record_side {
    align-items: flex-start;
  }
}
</style>
