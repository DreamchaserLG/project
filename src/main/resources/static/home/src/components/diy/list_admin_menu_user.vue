<template>
  <div class="profile_menu_list">
    <router-link
      v-for="item in visibleItems"
      :key="item.path"
      :to="item.path"
      class="profile_menu_item"
      :class="{ selected: isActive(item.path) }"
    >
      <span class="profile_menu_icon">
        <b-icon :icon="item.icon"></b-icon>
      </span>
      <span class="profile_menu_meta">
        <strong>{{ item.label }}</strong>
        <small>{{ item.desc }}</small>
      </span>
    </router-link>
  </div>
</template>

<script>
import mixin from "@/mixins/page.js";

export default {
  mixins: [mixin],
  data() {
    return {
      menuItems: [
        { path: "/user_center/index", label: "个人首页", desc: "查看个人业务概览", icon: "person-circle", permission: null },
        { path: "/regular_user/table", label: "普通用户", desc: "维护普通用户资料", icon: "people-fill", permission: "/regular_user/table" },
        { path: "/host_user/table", label: "主办用户", desc: "查看主办方信息", icon: "briefcase-fill", permission: "/host_user/table" },
        { path: "/exhibition_information/table", label: "会展信息", desc: "浏览会展活动数据", icon: "calendar-event", permission: "/exhibition_information/table" },
        { path: "/booth_information/table", label: "展位信息", desc: "查看展位资源状态", icon: "grid-3x3-gap-fill", permission: "/booth_information/table" },
        { path: "/registration_information/table", label: "报名信息", desc: "跟踪报名审核进度", icon: "clipboard-check", permission: "/registration_information/table" },
        { path: "/travel_confirmation/table", label: "行程确认", desc: "确认参展行程安排", icon: "geo-alt-fill", permission: "/travel_confirmation/table" },
        { path: "/refund_request/table", label: "退款申请", desc: "处理退款进度查询", icon: "credit-card-2-front-fill", permission: "/refund_request/table" },
        { path: "/message_notification/table", label: "消息通知", desc: "接收系统提醒消息", icon: "bell-fill", permission: "/message_notification/table" },
        { path: "/exhibition_announcement/table", label: "会展公告", desc: "查看主办方公告", icon: "megaphone-fill", permission: "/exhibition_announcement/table" },
        { path: "/data_statistics/table", label: "数据统计", desc: "查看业务统计结果", icon: "bar-chart-fill", permission: "/data_statistics/table" },
        { path: "/user/collect", label: "收藏记录", desc: "快速回看收藏内容", icon: "heart-fill", permission: "/collect/list" },
        { path: "/user/praise", label: "点赞记录", desc: "查看互动反馈记录", icon: "hand-thumbs-up-fill", permission: "/praise/list" },
        { path: "/comment/table", label: "评论管理", desc: "管理评论与留言", icon: "chat-left-text-fill", permission: "/comment/table" },
      ],
    };
  },
  computed: {
    visibleItems() {
      return this.menuItems.filter((item) => !item.permission || this.$check_action(item.permission, "get"));
    },
  },
  methods: {
    isActive(path) {
      return this.$route.path === path;
    },
  },
};
</script>

<style scoped>
.profile_menu_list {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 0.9rem;
}

.profile_menu_item {
  display: flex;
  align-items: center;
  gap: 0.9rem;
  min-height: 84px;
  padding: 1rem 1.05rem;
  border-radius: 20px;
  background: linear-gradient(180deg, #ffffff, #f8fbfd);
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: 0 12px 24px rgba(16, 34, 51, 0.05);
  color: var(--color_text) !important;
  transition: transform 0.22s ease, box-shadow 0.22s ease, border-color 0.22s ease;
}

.profile_menu_item:hover {
  transform: translateY(-2px);
  box-shadow: 0 16px 28px rgba(16, 34, 51, 0.08);
}

.profile_menu_item.selected {
  border-color: rgba(29, 122, 134, 0.24);
  background: linear-gradient(180deg, #eef8fb, #e5f2f7);
  color: var(--color_primary) !important;
}

.profile_menu_icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 42px;
  height: 42px;
  border-radius: 14px;
  background: rgba(15, 95, 108, 0.09);
  color: var(--color_primary);
  font-size: 1rem;
  flex-shrink: 0;
}

.profile_menu_item.selected .profile_menu_icon {
  background: linear-gradient(135deg, #1d7a86, #0f5f6c);
  color: #fff;
}

.profile_menu_meta {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  min-width: 0;
}

.profile_menu_meta strong {
  color: inherit;
  font-size: 0.98rem;
  font-weight: 700;
}

.profile_menu_meta small {
  color: var(--color_text_soft);
  line-height: 1.55;
}

@media (max-width: 1100px) {
  .profile_menu_list {
    grid-template-columns: 1fr;
  }
}
</style>
