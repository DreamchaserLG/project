<template>
  <div class="front_page notice_page" id="exhibition_announcement_list">
    <section class="page_intro_card notice_intro" :style="bannerStyle">
      <span class="page_kicker">Exhibition Notice</span>
      <h1>会展公告</h1>
      <p>展示主办方发布的会展公告、参展提醒和重要说明，整体版式与平台公告页面保持一致。</p>
    </section>

    <section class="page_query_card">
      <div class="page_query_grid">
        <div class="page_query_item wide notice_query_main">
          <label>公告标题</label>
          <b-form-input v-model.trim="query.announcement_title" placeholder="请输入公告标题"></b-form-input>
        </div>
        <div class="page_query_actions">
          <button type="button" class="page_primary_btn" @click="search()">查询</button>
          <button type="button" class="page_secondary_btn" @click="resetAnnouncement">重置</button>
        </div>
      </div>
    </section>

    <section class="page_list_shell">
      <div class="page_list_head">
        <div>
          <span class="page_kicker">Notice List</span>
          <h2>公告列表</h2>
          <p>采用公告条目形式展开展示，左侧图片、右侧内容，点击后进入正式公告详情页。</p>
        </div>
      </div>

      <div v-if="list.length" class="notice_rows">
        <router-link
          v-for="(item, index) in list"
          :key="item.exhibition_announcement_id"
          class="notice_row"
          :to="'/exhibition_announcement/details?exhibition_announcement_id=' + item.exhibition_announcement_id"
        >
          <div class="notice_row_media">
            <img :src="getAnnouncementCover(item, index)" v-default-img="fallbackImage" alt="announcement cover">
            <span class="notice_row_badge">会展公告</span>
          </div>

          <div class="notice_row_body">
            <div class="notice_row_top">
              <div class="notice_row_code">{{ getAnnouncementCode(item) }}</div>
              <div class="notice_row_time">{{ formatDateTime(item.release_time || item.create_time) }}</div>
            </div>

            <h3 class="notice_row_title">{{ item.announcement_title || "会展公告" }}</h3>
            <p class="notice_row_desc">{{ excerpt(item.announcement_content, 150) }}</p>

            <div class="notice_row_footer">
              <span class="notice_row_type">{{ getAnnouncementType(item) }}</span>
              <span class="notice_row_link">查看公告</span>
            </div>
          </div>
        </router-link>
      </div>
      <div v-else class="page_empty_state">暂无会展公告</div>

      <div class="page_pager">
        <b-pagination
          v-model="query.page"
          :total-rows="count"
          :per-page="query.size"
          @change="goToPage"
        />
      </div>
    </section>
  </div>
</template>

<script>
import mixin from "@/mixins/page.js";

export default {
  mixins: [mixin],
  data() {
    return {
      url_get_list: "~/api/exhibition_announcement/get_list",
      list: [],
      query: {
        announcement_title: "",
        page: 1,
        size: 10,
      },
      count_pages: 1,
      fallbackImage: "/img/default.png",
      coverList: [
        "/img/theme/expo-floor.jpg",
        "/img/theme/future-showroom.jpg",
        "/img/theme/city-night.jpg",
      ],
    };
  },
  computed: {
    bannerStyle() {
      return {
        "--page-banner-image": "url(/img/theme/future-showroom.jpg)",
      };
    },
  },
  methods: {
    get_list_after(json) {
      this.count_pages = Math.ceil(json.result.count / this.query.size);
    },
    resetAnnouncement() {
      this.query.announcement_title = "";
      this.query.page = 1;
      this.search();
    },
    goToPage(v) {
      this.query.page = v;
      this.goToNew(v);
    },
    getAnnouncementCover(item, index) {
      if (item && item.announcement_image) {
        return this.$fullUrl(item.announcement_image);
      }
      return this.coverList[index % this.coverList.length];
    },
    getAnnouncementCode(item) {
      const value = String(item.exhibition_announcement_id || 0).padStart(4, "0");
      return `HZGG-${value}`;
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
.notice_rows {
  display: grid;
  gap: 1.15rem;
}

.notice_query_main {
  grid-column: 1 / 11;
}

.notice_row {
  display: grid;
  grid-template-columns: 260px minmax(0, 1fr);
  overflow: hidden;
  border-radius: 28px;
  background: #fff;
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: var(--shadow_card);
  transition: transform 0.22s ease, box-shadow 0.22s ease;
}

.notice_row:hover {
  transform: translateY(-3px);
  box-shadow: 0 20px 36px rgba(16, 34, 51, 0.12);
}

.notice_row_media {
  position: relative;
  min-height: 220px;
}

.notice_row_media::after {
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

.notice_row_media img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.notice_row_badge {
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

.notice_row_body {
  display: flex;
  flex-direction: column;
  gap: 0.85rem;
  padding: 1.45rem 1.55rem;
}

.notice_row_top,
.notice_row_footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  flex-wrap: wrap;
}

.notice_row_code {
  color: var(--color_primary);
  font-size: 0.86rem;
  font-weight: 700;
  letter-spacing: 0.08em;
}

.notice_row_time {
  color: var(--color_text_soft);
  font-size: 0.9rem;
}

.notice_row_title {
  margin: 0;
  color: var(--color_text);
  font-size: 1.4rem;
  line-height: 1.45;
}

.notice_row_desc {
  margin: 0;
  color: var(--color_text_soft);
  line-height: 1.9;
}

.notice_row_type {
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

.notice_row_link {
  color: var(--color_primary);
  font-weight: 700;
}

@media (max-width: 900px) {
  .notice_row {
    grid-template-columns: 1fr;
  }

  .notice_row_media {
    min-height: 200px;
  }

  .notice_row_body {
    padding: 1.2rem;
  }
}
</style>
