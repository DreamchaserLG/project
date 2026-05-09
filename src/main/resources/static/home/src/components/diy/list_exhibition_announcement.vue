<template>
  <div v-if="localList.length" class="announcement_rows">
    <article
      v-for="(item, index) in localList"
      :key="item.exhibition_announcement_id"
      class="announcement_row"
      @click="toDetails(item)"
    >
      <div class="announcement_row_media">
        <img
          :src="getAnnouncementCover(item, index)"
          v-default-img="fallbackImage"
          alt="announcement cover"
        >
        <span class="announcement_row_badge">会展公告</span>
      </div>

      <div class="announcement_row_body">
        <div class="announcement_row_top">
          <div class="announcement_row_code">{{ getAnnouncementCode(item) }}</div>
          <div class="announcement_row_time">{{ formatDateTime(item.release_time || item.create_time) }}</div>
        </div>

        <h3 class="announcement_row_title">{{ item.announcement_title || "会展公告" }}</h3>
        <p class="announcement_row_desc">{{ excerpt(item.announcement_content, 150) }}</p>

        <div class="announcement_row_footer">
          <span class="announcement_row_type">{{ getAnnouncementType(item) }}</span>
          <span class="announcement_row_link">查看公告</span>
        </div>
      </div>
    </article>
  </div>
  <div v-else class="page_empty_state">暂无会展公告</div>
</template>

<script>
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
      coverList: [
        "/img/theme/expo-floor.jpg",
        "/img/theme/future-showroom.jpg",
        "/img/theme/city-night.jpg",
      ],
    };
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
    toDetails(item) {
      const query = {
        exhibition_announcement_id: item.exhibition_announcement_id,
      };
      if (this.choose_date) {
        query.choose_date = this.choose_date;
      }
      this.$router.push({
        path: "/exhibition_announcement/details",
        query,
      });
    },
    getAnnouncementCover(item, index) {
      if (item && item.announcement_image) {
        return this.$fullUrl(item.announcement_image);
      }
      return this.coverList[index % this.coverList.length];
    },
    getAnnouncementCode(item) {
      return `HZGG-${String(item.exhibition_announcement_id || 0).padStart(4, "0")}`;
    },
    getAnnouncementType(item) {
      const type = String(item.announcement_type || "").trim();
      if (type) {
        return type;
      }
      const title = String(item.announcement_title || "");
      if (title.includes("调整") || title.includes("变更")) {
        return "活动变更";
      }
      if (title.includes("提醒") || title.includes("须知")) {
        return "注意事项";
      }
      return "会展公告";
    },
    formatDateTime(value) {
      if (!value) {
        return "发布时间待更新";
      }
      try {
        return this.$toTime(value, "yyyy-MM-dd hh:mm:ss");
      } catch (error) {
        return value;
      }
    },
    stripHtml(content) {
      return String(content || "")
        .replace(/<[^>]+>/g, " ")
        .replace(/\s+/g, " ")
        .trim();
    },
    excerpt(content, maxLength) {
      const plain = this.stripHtml(content);
      if (plain.length <= maxLength) {
        return plain || "暂无公告摘要";
      }
      return plain.slice(0, maxLength) + "...";
    },
  },
};
</script>

<style scoped>
.announcement_rows {
  display: grid;
  gap: 1.15rem;
}

.announcement_row {
  display: grid;
  grid-template-columns: 260px minmax(0, 1fr);
  overflow: hidden;
  border-radius: 28px;
  background: #fff;
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: var(--shadow_card);
  cursor: pointer;
  transition: transform 0.22s ease, box-shadow 0.22s ease;
}

.announcement_row:hover {
  transform: translateY(-3px);
  box-shadow: 0 20px 36px rgba(16, 34, 51, 0.12);
}

.announcement_row_media {
  position: relative;
  min-height: 220px;
}

.announcement_row_media::after {
  content: "";
  position: absolute;
  right: 1rem;
  bottom: 1rem;
  width: 72px;
  height: 72px;
  border-radius: 22px;
  background:
    rgba(255, 255, 255, 0.18)
    url(/img/gonggaolan-bg.png) center/58% no-repeat;
  backdrop-filter: blur(6px);
  box-shadow: 0 10px 24px rgba(7, 24, 34, 0.18);
}

.announcement_row_media img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.announcement_row_badge {
  position: absolute;
  top: 1rem;
  left: 1rem;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.38rem 0.82rem;
  border-radius: 999px;
  background: rgba(7, 24, 34, 0.72);
  color: #fff;
  font-size: 0.78rem;
  font-weight: 700;
}

.announcement_row_body {
  display: flex;
  flex-direction: column;
  gap: 0.85rem;
  padding: 1.45rem 1.55rem;
}

.announcement_row_top,
.announcement_row_footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  flex-wrap: wrap;
}

.announcement_row_code {
  color: var(--color_primary);
  font-size: 0.86rem;
  font-weight: 700;
  letter-spacing: 0.08em;
}

.announcement_row_time {
  color: var(--color_text_soft);
  font-size: 0.9rem;
}

.announcement_row_title {
  margin: 0;
  color: var(--color_text);
  font-size: 1.4rem;
  line-height: 1.45;
}

.announcement_row_desc {
  margin: 0;
  color: var(--color_text_soft);
  line-height: 1.9;
}

.announcement_row_type {
  display: inline-flex;
  align-items: center;
  min-height: 34px;
  padding: 0 0.85rem;
  border-radius: 999px;
  background: rgba(15, 95, 108, 0.08);
  color: var(--color_primary);
  font-size: 0.82rem;
  font-weight: 700;
}

.announcement_row_link {
  color: var(--color_primary);
  font-weight: 700;
}

@media (max-width: 900px) {
  .announcement_row {
    grid-template-columns: 1fr;
  }

  .announcement_row_media {
    min-height: 200px;
  }

  .announcement_row_body {
    padding: 1.2rem;
  }
}
</style>
