<template>
  <div class="page_header">
    <transition name="fade">
      <div v-show="visible" class="header_warp" :class="{ scrolled: scrolled }">
        <div class="container">
          <div class="my_header">
            <div class="header_top">
              <router-link to="/" class="brand_link">
                <div class="brand_mark">EM</div>
                <div class="brand_copy">
                  <div class="logo">会展管理系统</div>
                  <div class="logo_subtitle">Expo Management Portal</div>
                </div>
              </router-link>

              <div ref="searchBox" class="search_box">
                <input
                  v-model.trim="search_val"
                  class="search_input"
                  type="text"
                  placeholder="输入关键词搜索展会或资讯"
                  @keyup.enter="submit_search"
                >
                <button class="search_btn" type="button" @click="submit_search">
                  <svg viewBox="0 0 16 16" width="1em" height="1em" focusable="false" role="img" aria-label="search">
                    <path
                      fill="currentColor"
                      d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"
                    />
                  </svg>
                </button>
              </div>

              <div v-if="!user.user_id" class="user_actions">
                <router-link
                  v-for="(item, index) in not_login_dropdown"
                  :key="index"
                  class="login_link"
                  :to="item.url"
                >
                  {{ item.name }}
                </router-link>
              </div>

              <div v-else ref="userMenuShell" class="user_panel">
                <el-badge
                  v-if="messageInformListAll.length > 0"
                  :value="msgSum"
                  :hidden="msgSum === 0"
                  :max="99"
                  class="message_badge"
                >
                  <button class="icon_btn" type="button" @click="drawer = true">
                    <i class="el-icon-bell"></i>
                  </button>
                </el-badge>

                <button class="profile_btn" type="button" @click="toggleUserMenu">
                  <img class="user_img" :src="avatarUrl" alt="avatar">
                  <span class="own_text">{{ user_nickname || "用户中心" }}</span>
                  <span class="caret" :style="{ transform: 'rotate(' + (showUserMenu ? 180 : 0) + 'deg)' }" />
                </button>

                <div v-show="showUserMenu" class="dropdown user_dropdown">
                  <router-link v-for="(item, index) in my_nav" :key="index" class="dropdown_link" :to="item.url">
                    {{ item.name }}
                  </router-link>
                  <router-link class="dropdown_link" to="/user_center/index">个人中心</router-link>
                  <button class="dropdown_link dropdown_button" type="button" @click="sign_out">退出</button>
                </div>
              </div>
            </div>

            <div class="header_bottom">
              <div ref="navShell" class="nav_shell" :class="{ open: showMobileMenu }">
                <ul class="nav_ul" :style="navColumnStyle">
                  <li class="nav_li" :class="{ active: $route.path === '/' }">
                    <router-link to="/" class="nav_a">首页</router-link>
                  </li>
                  <li class="nav_li" v-if="$check_action('/notice/list', 'get')" :class="{ active: $route.path === '/notice/list' }">
                    <router-link to="/notice/list" class="nav_a">平台公告</router-link>
                  </li>
                  <li class="nav_li" v-if="$check_action('/article/list', 'get')" :class="{ active: $route.path === '/article/list' }">
                    <router-link to="/article/list" class="nav_a">会展资讯</router-link>
                  </li>
                  <li
                    v-for="(item, index) in visibleNavItems"
                    :key="item.path || index"
                    class="nav_li"
                    :class="{ active: $route.path === item.path }"
                  >
                    <router-link :to="item.path" class="nav_a">{{ item.page_title }}</router-link>
                  </li>
                  <li v-if="overflowNavItems.length" ref="more" class="nav_li more_shell">
                    <button class="more_btn" type="button" @click="toggleMoreMenu">
                      更多
                      <span class="caret" :style="{ transform: 'rotate(' + (showMoreMenu ? 180 : 0) + 'deg)' }" />
                    </button>
                    <div v-show="showMoreMenu" class="dropdown more_dropdown">
                      <router-link
                        v-for="(item, index) in overflowNavItems"
                        :key="item.path || 'more-' + index"
                        class="dropdown_link"
                        :to="item.path"
                      >
                        {{ item.page_title }}
                      </router-link>
                    </div>
                  </li>
                </ul>
              </div>

              <div ref="mobileShell" class="mini_nav">
                <button class="mini_btn" type="button" @click="toggleMobileMenu">
                  菜单
                  <span class="caret" :style="{ transform: 'rotate(' + (showMobileMenu ? 180 : 0) + 'deg)' }" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </transition>

    <el-drawer
      title="通知中心"
      :size="400"
      :visible.sync="drawer"
      :modal="false"
    >
      <div class="drawer_body">
        <div class="drawer_tabs">
          <el-badge
            v-for="(item, index) in messageTypeList"
            :key="index"
            :is-dot="isRead(item)"
            class="drawer_tab"
          >
            <el-button size="mini" @click="handleClick(item)">{{ item }}</el-button>
          </el-badge>
        </div>
        <div class="drawer_actions">
          <el-button type="text" @click="readAll">全部已读</el-button>
          <el-button type="text" @click="clearAll">清除</el-button>
        </div>
        <div class="drawer_list">
          <div
            v-for="item in messageInformList"
            :key="item.message_inform_id"
            class="drawer_item"
            @click="setState(item)"
          >
            <el-badge :is-dot="item.state == 1" class="item">
              <span class="drawer_title">{{ item.title }}</span>
            </el-badge>
            <span class="drawer_content">{{ item.content }}</span>
            <div class="drawer_time">{{ $toTime(item.create_time, "yyyy-MM-dd hh:mm:ss") }}</div>
          </div>
        </div>
      </div>
    </el-drawer>
  </div>
</template>

<script>
import mixin from "@/mixins/component.js";

const OFFSET_HEIGHT = 60;

export default {
  mixins: [mixin],
  data() {
    return {
      drawer: false,
      messageType: "通知",
      messageInformList: [],
      messageInformListAll: [],
      messageTypeList: [],
      msgList: [],
      msgSum: 0,
      top_max: 8,
      scrolled: false,
      showMoreMenu: false,
      showUserMenu: false,
      showMobileMenu: false,
      visible: true,
      search_val: "",
      user_nickname: "",
      user_avatar: "",
      my_nav: [
        {
          name: "我的账户",
          url: "/user/index",
        },
      ],
      not_login_dropdown: [
        {
          name: "登录",
          url: "/account/login",
        },
        {
          name: "注册",
          url: "/account/register",
        },
      ],
      nav_top: [],
    };
  },
  computed: {
    avatarUrl() {
      return this.$fullUrl(this.user_avatar || "/default_avatar.jpg");
    },
    navItemCount() {
      const staticCount =
        1 +
        (this.$check_action("/notice/list", "get") ? 1 : 0) +
        (this.$check_action("/article/list", "get") ? 1 : 0);
      return staticCount + this.visibleNavItems.length + (this.overflowNavItems.length ? 1 : 0);
    },
    visibleNavItems() {
      return this.nav_top.slice(0, this.top_max);
    },
    overflowNavItems() {
      return this.nav_top.slice(this.top_max);
    },
    navColumnStyle() {
      const count = Math.max(this.navItemCount, 1);
      return {
        "--nav-columns": count,
      };
    },
  },
  watch: {
    "user.user_id": {
      immediate: true,
      handler(value) {
        this.syncUserProfile();
        if (value) {
          this.getMessageInformList();
          return;
        }
        this.messageInformList = [];
        this.messageInformListAll = [];
        this.messageTypeList = [];
        this.msgList = [];
        this.msgSum = 0;
      },
    },
    "user.nickname"() {
      this.syncUserProfile();
    },
    "user.avatar"() {
      this.syncUserProfile();
    },
  },
  created() {
    this.get_nav_top();
    if (!this.user.user_id) {
      this.$get_auth("游客");
    }
    this.top_max = 6;
  },
  mounted() {
    this.syncUserProfile();
    window.addEventListener("scroll", this.handleScroll);
    window.addEventListener("resize", this.handleResize);
    document.addEventListener("mouseup", this.handleDocumentMouseup);
    this.handleResize();
  },
  destroyed() {
    window.removeEventListener("scroll", this.handleScroll);
    window.removeEventListener("resize", this.handleResize);
    document.removeEventListener("mouseup", this.handleDocumentMouseup);
  },
  methods: {
    syncUserProfile() {
      if (!this.$store.state.user) {
        this.user_nickname = "";
        this.user_avatar = "";
        return;
      }
      this.user_nickname = this.$store.state.user.nickname || "";
      this.user_avatar = this.$store.state.user.avatar || "";
    },
    async getMessageInformList() {
      if (!this.user || !this.user.user_id) {
        return;
      }
      try {
        this.msgList = [];
        if (this.user.user_group === "管理员") {
          const adminMessageRes = await this.$get("~/api/message_inform/get_list", { type: "消息" });
          this.msgList = adminMessageRes?.result?.list || [];
        }

        const listAll = await this.$get(`~/api/message_inform/get_list?user_id=${this.user.user_id}&like=0`);
        const baseList = listAll?.result?.list || [];
        this.messageInformListAll = [...baseList, ...this.msgList];
        this.msgSum = this.messageInformListAll.filter((item) => item.state === 1).length;
        this.messageTypeList = [...new Set(this.messageInformListAll.map((item) => item.type).filter(Boolean))];

        const currentType = this.messageTypeList.includes(this.messageType)
          ? this.messageType
          : this.messageTypeList[0];
        if (currentType) {
          await this.handleClick(currentType);
        } else {
          this.messageInformList = [];
        }
      } catch (error) {
        console.error("load message list failed:", error);
      }
    },
    async handleClick(type) {
      this.messageType = type;
      if (type === "消息") {
        this.messageInformList = this.msgList;
        return;
      }
      const res = await this.$get(`~/api/message_inform/get_list?user_id=${this.user.user_id}&like=0`, {
        type,
      });
      this.messageInformList = res?.result?.list || [];
    },
    isRead(type) {
      return this.messageInformListAll.some((item) => item.type === type && item.state === 1);
    },
    async readAll() {
      await Promise.all(
        this.messageInformList.map((item) =>
          this.$post(`~/api/message_inform/set?message_inform_id=${item.message_inform_id}`, { state: 0 })
        )
      );
      this.getMessageInformList();
    },
    async clearAll() {
      await Promise.all(
        this.messageInformList.map((item) =>
          this.$get(`~/api/message_inform/del?message_inform_id=${item.message_inform_id}`)
        )
      );
      this.getMessageInformList();
    },
    async setState(item) {
      await this.$post(`~/api/message_inform/set?message_inform_id=${item.message_inform_id}`, { state: 0 });
      this.getMessageInformList();
    },
    async get_nav_top() {
      const auth = this.$store?.state?.web?.auth || [];
      if (auth.length > 0) {
        this.nav_top = auth.filter((item) => item.position === "top");
        return;
      }
      const user_group = this.$store.state.user.user_group || $.db.get("user_group") || "游客";
      const res = await this.$get("~/api/auth/get_list?like=0", {
        user_group,
        get: 1,
        position: "top",
        page: "",
      });
      this.nav_top = res?.result?.list || [];
    },
    sign_out() {
      this.$store.commit("sign_out");
      this.$get("~/api/user/quit?", {}, () => {});
      sessionStorage.removeItem("nickname");
      sessionStorage.removeItem("avatar");
      sessionStorage.removeItem("user_id");
      location.reload();
    },
    submit_search() {
      if (!this.search_val.trim()) {
        return;
      }
      this.$router.push("/search?word=" + this.search_val);
      this.showMobileMenu = false;
    },
    toggleMoreMenu() {
      this.showMoreMenu = !this.showMoreMenu;
    },
    toggleUserMenu() {
      this.showUserMenu = !this.showUserMenu;
      if (this.showUserMenu) {
        this.showMoreMenu = false;
      }
    },
    toggleMobileMenu() {
      this.showMobileMenu = !this.showMobileMenu;
    },
    handleScroll() {
      const offsetTop = window.pageYOffset || document.documentElement.scrollTop;
      this.visible = true;
      this.scrolled = offsetTop > OFFSET_HEIGHT;
    },
    handleResize() {
      if (window.innerWidth > 960) {
        this.showMobileMenu = false;
      }
    },
    handleDocumentMouseup(event) {
      if (this.$refs.more && !this.$refs.more.contains(event.target)) {
        this.showMoreMenu = false;
      }
      if (this.$refs.userMenuShell && !this.$refs.userMenuShell.contains(event.target)) {
        this.showUserMenu = false;
      }
      if (this.$refs.mobileShell && !this.$refs.mobileShell.contains(event.target) && window.innerWidth <= 960) {
        this.showMobileMenu = false;
      }
    },
  },
};
</script>

<style scoped>
.page_header {
  position: relative;
  z-index: 1200;
}

.header_warp {
  position: fixed !important;
  inset: 0 0 auto 0 !important;
  background:
    linear-gradient(180deg, rgba(255, 255, 255, 0.97), rgba(250, 252, 253, 0.94)) !important;
  color: var(--color_text);
  backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: 0 16px 34px rgba(17, 36, 51, 0.08) !important;
  z-index: 24;
  transition: box-shadow 0.25s ease, background 0.25s ease, transform 0.25s ease;
}

.header_warp.scrolled {
  background: rgba(255, 255, 255, 0.95);
  box-shadow: 0 18px 42px rgba(9, 31, 46, 0.12);
}

.header_warp > .container {
  max-width: var(--page_max_width) !important;
}

.my_header {
  display: flex;
  flex-direction: column;
  gap: 0.65rem;
  padding: 0.8rem 0 0.85rem;
  background: transparent !important;
  transition: gap 0.25s ease, padding 0.25s ease;
}

.header_top,
.header_bottom {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
}

.header_top {
  position: relative;
  z-index: 8;
}

.header_bottom {
  position: relative;
  z-index: 4;
}

.brand_link {
  display: flex;
  align-items: center;
  gap: 0.9rem;
  min-width: max-content;
}

.brand_mark {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 2.8rem;
  height: 2.8rem;
  border-radius: 1rem;
  background: linear-gradient(135deg, var(--color_primary), var(--color_primary_deep));
  color: #fff;
  font-family: var(--font_heading);
  font-size: 1.3rem;
  letter-spacing: 0.08em;
  box-shadow: 0 16px 30px rgba(9, 57, 67, 0.24);
  transition: width 0.25s ease, height 0.25s ease, font-size 0.25s ease, border-radius 0.25s ease;
}

.brand_copy {
  display: flex;
  flex-direction: column;
}

.logo {
  display: flex;
  align-items: center;
  min-height: 1.7rem;
  font-family: var(--font_heading);
  font-size: 1.7rem;
  letter-spacing: 0.08em;
  color: var(--color_primary);
  transition: min-height 0.25s ease, font-size 0.25s ease;
}

.logo_subtitle {
  margin-top: 0.1rem;
  font-size: 0.78rem;
  letter-spacing: 0.16em;
  text-transform: uppercase;
  color: var(--color_text_soft);
  transition: opacity 0.25s ease, transform 0.25s ease, font-size 0.25s ease;
}

.search_box {
  flex: 1;
  max-width: 32rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.38rem 0.45rem 0.38rem 0.95rem;
  border-radius: 999px;
  border: 1px solid rgba(15, 54, 80, 0.1);
  background: rgba(15, 95, 108, 0.04);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.6);
  transition: max-width 0.25s ease, padding 0.25s ease, box-shadow 0.25s ease;
}

.search_input {
  flex: 1;
  border: none;
  outline: none;
  background: transparent;
  color: var(--color_text);
}

.search_input::placeholder {
  color: #8190a0;
}

.search_btn,
.icon_btn,
.profile_btn,
.more_btn,
.mini_btn,
.dropdown_button {
  border: none;
  outline: none;
  cursor: pointer;
  background: transparent;
}

.search_btn {
  width: 2.3rem;
  height: 2.3rem;
  border-radius: 999px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, var(--color_primary), var(--color_primary_deep));
  color: #fff;
  transition: width 0.25s ease, height 0.25s ease, transform 0.2s ease;
}

.user_actions,
.user_panel {
  display: flex;
  align-items: center;
  gap: 0.85rem;
  position: relative;
}

.user_panel {
  z-index: 18;
}

.login_link {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 5.9rem;
  height: 2.9rem;
  padding: 0 1rem;
  border-radius: 999px;
  background: rgba(15, 95, 108, 0.06);
  color: var(--color_primary) !important;
  font-weight: 700;
  transition: min-height 0.25s ease, transform 0.2s ease, box-shadow 0.2s ease;
}

.message_badge {
  display: inline-flex;
}

.icon_btn,
.profile_btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 2.6rem;
  border-radius: 999px;
  border: 1px solid rgba(15, 54, 80, 0.08);
  background: rgba(255, 255, 255, 0.9);
  box-shadow: var(--shadow_card);
  transition: min-height 0.25s ease, transform 0.2s ease, box-shadow 0.2s ease;
}

.icon_btn {
  width: 2.6rem;
  color: var(--color_primary);
  font-size: 1.05rem;
}

.profile_btn {
  gap: 0.7rem;
  padding: 0.2rem 0.85rem 0.2rem 0.3rem;
}

.user_img {
  width: 1.95rem;
  height: 1.95rem;
  border-radius: 999px;
  object-fit: cover;
  background: #e8edf3;
}

.own_text {
  color: var(--color_text);
  font-weight: 700;
}

.caret {
  display: inline-block;
  width: 0;
  height: 0;
  margin-left: 0.45rem;
  vertical-align: middle;
  border-top: 4px dashed currentColor;
  border-right: 4px solid transparent;
  border-left: 4px solid transparent;
  transition: transform 0.2s ease;
}

.nav_shell {
  flex: 1;
  min-width: 0;
}

.nav_ul {
  display: flex;
  flex-wrap: nowrap;
  align-items: stretch;
  gap: 0.65rem;
  width: 100%;
  margin: 0;
  padding: 0;
}

.nav_li {
  list-style: none;
  position: relative;
  flex: 1 1 0;
  min-width: 0;
}

.nav_a,
.more_btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  min-width: 4.2rem;
  min-height: 2.65rem;
  padding: 0.1rem 0.9rem;
  border-radius: 16px;
  color: #5d6d7f !important;
  font-weight: 700;
  background: linear-gradient(180deg, rgba(241, 246, 248, 0.95), rgba(233, 240, 245, 0.92));
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.7);
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
  transition:
    min-height 0.25s ease,
    border-radius 0.25s ease,
    background 0.2s ease,
    box-shadow 0.2s ease,
    transform 0.2s ease;
}

.nav_li.active .nav_a,
.nav_a:hover,
.more_btn:hover,
.mini_btn:hover,
.login_link:hover,
.profile_btn:hover,
.icon_btn:hover {
  color: var(--color_primary) !important;
}

.nav_li.active .nav_a {
  background: linear-gradient(135deg, var(--color_primary), var(--color_primary_deep));
  color: #fff !important;
  box-shadow: 0 12px 24px rgba(9, 57, 67, 0.2);
}

.nav_a:hover,
.more_btn:hover,
.mini_btn:hover,
.login_link:hover,
.profile_btn:hover,
.icon_btn:hover {
  background: rgba(15, 95, 108, 0.08);
}

.dropdown {
  position: absolute;
  top: calc(100% + 0.75rem);
  right: 0;
  min-width: 11rem;
  padding: 0.45rem;
  border-radius: 1rem;
  background: #fff;
  border: 1px solid rgba(15, 76, 129, 0.08);
  box-shadow: var(--shadow_card);
  display: flex;
  flex-direction: column;
  gap: 0.2rem;
  z-index: 40;
}

.more_dropdown {
  left: 0;
  right: auto;
}

.dropdown_link {
  display: flex;
  align-items: center;
  width: 100%;
  min-height: 2.9rem;
  padding: 0 0.9rem;
  border-radius: 0.8rem;
  color: var(--color_text) !important;
  text-align: left;
}

.dropdown_link:hover,
.dropdown_button:hover {
  background: rgba(15, 76, 129, 0.06);
}

.dropdown_button {
  font: inherit;
}

.mini_nav {
  display: none;
}

.mini_btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 5.2rem;
  height: 2.7rem;
  padding: 0 1rem;
  border-radius: 999px;
  background: rgba(15, 95, 108, 0.06);
  color: var(--color_primary);
  font-weight: 700;
}

.drawer_body {
  padding: 0 20px;
}

.drawer_tabs {
  display: flex;
  flex-wrap: wrap;
  gap: 0.6rem;
  padding-top: 0.35rem;
}

.drawer_actions {
  display: flex;
  justify-content: flex-end;
  margin-top: 0.75rem;
}

.drawer_list {
  height: 80vh;
  overflow: auto;
  padding: 0.8rem 0 0.5rem;
}

.drawer_item {
  margin-bottom: 0.85rem;
  padding: 0.9rem 1rem;
  border-radius: 1rem;
  background: rgba(15, 76, 129, 0.04);
  cursor: pointer;
}

.drawer_title {
  font-size: 0.92rem;
  font-weight: 700;
}

.drawer_content,
.drawer_time {
  display: block;
  font-size: 0.88rem;
  line-height: 1.7;
  color: #7c8a98;
  white-space: pre-line;
}

.drawer_time {
  margin-top: 0.35rem;
}

.fade-enter-active,
.fade-leave-active {
  transition: all 0.4s ease;
}

.fade-enter,
.fade-leave-to {
  transform: translateY(-60px);
  opacity: 0;
}

.header_warp.scrolled .my_header {
  gap: 0.45rem;
  padding: 0.55rem 0 0.65rem;
}

.header_warp.scrolled .brand_mark {
  width: 2.35rem;
  height: 2.35rem;
  border-radius: 0.9rem;
  font-size: 1.08rem;
}

.header_warp.scrolled .logo {
  min-height: 1.45rem;
  font-size: 1.48rem;
}

.header_warp.scrolled .logo_subtitle {
  font-size: 0.68rem;
  opacity: 0.74;
  transform: translateY(-1px);
}

.header_warp.scrolled .search_box {
  max-width: 28rem;
  padding: 0.28rem 0.35rem 0.28rem 0.8rem;
}

.header_warp.scrolled .search_btn {
  width: 2.05rem;
  height: 2.05rem;
}

.header_warp.scrolled .icon_btn,
.header_warp.scrolled .profile_btn,
.header_warp.scrolled .login_link {
  min-height: 2.45rem;
}

.header_warp.scrolled .nav_a,
.header_warp.scrolled .more_btn {
  min-height: 2.35rem;
  border-radius: 14px;
}

@media (max-width: 960px) {
  .my_header {
    gap: 0.55rem;
    padding: 0.72rem 0 0.8rem;
  }

  .header_top {
    flex-wrap: wrap;
    align-items: stretch;
  }

  .search_box {
    order: 3;
    width: 100%;
    max-width: none;
  }

  .mini_nav {
    display: flex;
  }

  .nav_shell {
    display: none;
    width: 100%;
  }

  .nav_shell.open {
    display: block;
  }

  .nav_ul {
    flex-direction: column;
    gap: 0.4rem;
    padding-top: 0.5rem;
    display: flex;
  }

  .nav_a,
  .more_btn {
    width: 100%;
    justify-content: space-between;
    background: rgba(15, 95, 108, 0.04);
  }

  .more_dropdown {
    position: static;
    margin-top: 0.45rem;
  }
}

@media (max-width: 640px) {
  .brand_mark {
    width: 2.7rem;
    height: 2.7rem;
    font-size: 1.25rem;
  }

  .logo {
    font-size: 1.5rem;
  }

  .logo_subtitle {
    font-size: 0.72rem;
    letter-spacing: 0.12em;
  }

  .user_actions,
  .user_panel {
    width: 100%;
    justify-content: flex-end;
  }

  .profile_btn {
    max-width: 100%;
  }

  .own_text {
    max-width: 8rem;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}
</style>
