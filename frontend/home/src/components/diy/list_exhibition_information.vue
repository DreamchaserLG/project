<template>
  <div v-if="localList.length" class="expo_cards">
    <article
      v-for="item in localList"
      :key="item.exhibition_information_id"
      class="expo_card"
      @click="toDetails(item)"
    >
      <div class="expo_media">
        <img :src="getImageSrc(item.exhibition_poster)" v-default-img="fallbackImage" alt="exhibition poster">
        <span class="expo_badge">{{ item.exhibition_status || "进行中" }}</span>
      </div>
      <div class="expo_body">
        <div class="expo_head">
          <h3>{{ item.exhibition_theme || "会展信息" }}</h3>
          <span class="expo_type">{{ item.exhibition_and_convention_types || "综合会展" }}</span>
        </div>
        <div class="expo_meta">
          <span>举办时间：{{ formatDate(item.event_time) }}</span>
          <span>举办地点：{{ item.event_venue_name || "待更新" }}</span>
          <span>主办用户：{{ getHostUserName(item.host_user) }}</span>
        </div>
        <div class="expo_footer">
          <span class="expo_link">查看详情</span>
        </div>
      </div>
    </article>
  </div>
  <div v-else class="page_empty_state">暂无会展信息</div>
</template>

<script>
import { formatEventTimeForDisplay } from "@/utils/eventTime";

export default {
  props: {
    list: {
      type: Array,
      default() {
        return [];
      },
    },
    choose_date: {
      type: String,
      default: "",
    },
  },
  data() {
    return {
      localList: [],
      fallbackImage: "/img/default.png",
      hostUserList: [],
    };
  },
  created() {
    this.loadHostUserList();
  },
  watch: {
    list: {
      immediate: true,
      handler(value) {
        this.localList = Array.isArray(value) ? value.map((item) => ({ ...item })) : [];
      },
    },
  },
  methods: {
    async loadHostUserList() {
      try {
        const json = await this.$get("~/api/user/get_list?user_group=主办用户");
        if (json.result && json.result.list) {
          this.hostUserList = json.result.list;
        }
      } catch (e) {}
    },
    getHostUserName(id) {
      if (!id) return "-";
      const user = this.hostUserList.find((u) => u.user_id === id);
      if (user) {
        return user.nickname ? user.nickname + "-" + user.username : user.username;
      }
      return String(id);
    },
    getImageSrc(path) {
      return path ? this.$fullUrl(path) : this.fallbackImage;
    },
    formatDate(value) {
      return formatEventTimeForDisplay(value, "date");
    },
    toDetails(item) {
      const query = { exhibition_information_id: item.exhibition_information_id };
      if (this.choose_date) {
        query.choose_date = this.choose_date;
      }
      this.$router.push({
        path: "/exhibition_information/details",
        query,
      });
    },
  },
};
</script>

<style scoped>
.expo_cards {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 1.25rem;
}

.expo_card {
  display: flex;
  flex-direction: column;
  overflow: hidden;
  border-radius: 28px;
  background: #fff;
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: var(--shadow_card);
  cursor: pointer;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.expo_card:hover {
  transform: translateY(-4px);
  box-shadow: 0 18px 34px rgba(16, 34, 51, 0.12);
}

.expo_media {
  position: relative;
  aspect-ratio: 16 / 10;
  overflow: hidden;
  background: #dce6ed;
}

.expo_media img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.expo_badge {
  position: absolute;
  top: 0.95rem;
  left: 0.95rem;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.35rem 0.8rem;
  border-radius: 999px;
  background: rgba(9, 57, 67, 0.8);
  color: #fff;
  font-size: 0.78rem;
  font-weight: 700;
}

.expo_body {
  display: flex;
  flex: 1;
  flex-direction: column;
  padding: 1.2rem 1.25rem 1.3rem;
}

.expo_head {
  display: flex;
  flex-direction: column;
  gap: 0.45rem;
}

.expo_head h3 {
  display: -webkit-box;
  overflow: hidden;
  min-height: 3.2rem;
  margin: 0;
  color: var(--color_text);
  font-size: 1.08rem;
  line-height: 1.6;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.expo_type {
  color: var(--color_primary);
  font-size: 0.92rem;
  font-weight: 700;
}

.expo_meta {
  display: grid;
  gap: 0.5rem;
  margin-top: 0.95rem;
  color: var(--color_text_soft);
  font-size: 0.92rem;
  line-height: 1.7;
}

.expo_footer {
  margin-top: auto;
  padding-top: 1rem;
}

.expo_link {
  color: var(--color_primary);
  font-weight: 700;
}

@media (max-width: 1200px) {
  .expo_cards {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 768px) {
  .expo_cards {
    grid-template-columns: 1fr;
  }
}
</style>
