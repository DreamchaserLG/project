<template>
  <div class="detail_view_page notice_detail_page">
    <section class="notice_hero" :style="heroStyle">
      <div class="notice_hero_overlay">
        <span class="page_status_tag is-primary">平台公告</span>
        <div class="notice_hero_code">{{ noticeCode }}</div>
        <h1>{{ obj.title || "公告详情" }}</h1>
        <div class="notice_hero_meta">
          <span>{{ formatDateTime(obj.create_time) }}</span>
          <span>{{ noticeType }}</span>
          <span>会展管理系统平台</span>
        </div>
        <p class="notice_hero_desc">{{ noticeLead }}</p>
      </div>
    </section>

    <section class="notice_document_shell">
      <div class="notice_document_head">
        <div>
          <span class="page_kicker">Official Notice</span>
          <h2>公告正文</h2>
        </div>
        <router-link class="page_link_pill" to="/notice/list">返回列表</router-link>
      </div>

      <div class="notice_document_meta">
        <div class="notice_meta_item">
          <label>公告编号</label>
          <span>{{ noticeCode }}</span>
        </div>
        <div class="notice_meta_item">
          <label>公告类型</label>
          <span>{{ noticeType }}</span>
        </div>
        <div class="notice_meta_item">
          <label>发布时间</label>
          <span>{{ formatDateTime(obj.create_time) }}</span>
        </div>
        <div class="notice_meta_item">
          <label>发布单位</label>
          <span>会展管理系统平台</span>
        </div>
      </div>

      <article class="notice_document_body" v-html="obj.content || '暂无公告内容'"></article>
    </section>
  </div>
</template>

<script>
import mixin from "@/mixins/page.js";

export default {
  mixins: [mixin],
  data() {
    return {
      url_get_obj: "~/api/notice/get_obj?",
      field: "notice_id",
      query: {
        notice_id: 0,
      },
      obj: {},
    };
  },
  computed: {
    heroStyle() {
      return {
        "--notice-cover": "url(/img/theme/future-showroom.jpg)",
      };
    },
    noticeCode() {
      return `PTGG-${String(this.obj.notice_id || 0).padStart(4, "0")}`;
    },
    noticeType() {
      const title = String(this.obj.title || "");
      if (title.includes("维护") || title.includes("升级")) {
        return "系统维护";
      }
      if (title.includes("活动") || title.includes("报名")) {
        return "活动通知";
      }
      return "平台通知";
    },
    noticeLead() {
      return this.excerpt(this.obj.content, 120);
    },
  },
  methods: {
    get_obj_after() {},
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
.notice_hero {
  position: relative;
  overflow: hidden;
  min-height: 360px;
  border-radius: 34px;
  background:
    linear-gradient(180deg, rgba(7, 24, 34, 0.15), rgba(7, 24, 34, 0.82)),
    var(--notice-cover) center/cover no-repeat;
  box-shadow: var(--shadow_deep);
}

.notice_hero_overlay {
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  min-height: 360px;
  gap: 0.8rem;
  padding: 2rem 2.1rem;
  color: #fff;
}

.notice_hero_code {
  color: rgba(255, 255, 255, 0.78);
  letter-spacing: 0.12em;
  font-size: 0.88rem;
  font-weight: 700;
}

.notice_hero_overlay h1 {
  max-width: 52rem;
  margin: 0;
  font-size: 2.45rem;
  line-height: 1.32;
}

.notice_hero_meta {
  display: flex;
  flex-wrap: wrap;
  gap: 0.65rem 1rem;
  color: rgba(255, 255, 255, 0.8);
}

.notice_hero_desc {
  max-width: 44rem;
  margin: 0;
  color: rgba(255, 255, 255, 0.86);
  line-height: 1.9;
}

.notice_document_shell {
  margin-top: 1.2rem;
  padding: 1.9rem 2rem;
  border-radius: 30px;
  background: rgba(255, 255, 255, 0.96);
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: var(--shadow_soft);
}

.notice_document_head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 1rem;
}

.notice_document_head h2 {
  margin: 0.85rem 0 0;
  color: var(--color_text);
  font-size: 1.9rem;
}

.notice_document_meta {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 1rem;
  margin-top: 1.4rem;
}

.notice_meta_item {
  padding: 1rem 1.05rem;
  border-radius: 20px;
  background: #fff;
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: 0 8px 20px rgba(16, 34, 51, 0.05);
}

.notice_meta_item label {
  display: block;
  margin-bottom: 0.4rem;
  color: var(--color_text_soft);
  font-size: 0.82rem;
  font-weight: 700;
}

.notice_meta_item span {
  color: var(--color_text);
  line-height: 1.7;
}

.notice_document_body {
  margin-top: 1.5rem;
  padding-top: 1.4rem;
  border-top: 1px solid rgba(15, 54, 80, 0.08);
  color: var(--color_text);
  line-height: 1.95;
  font-size: 1rem;
}

.notice_document_body :deep(p) {
  margin-bottom: 1rem;
}

.notice_document_body :deep(img) {
  display: block;
  max-width: 100%;
  margin: 1.2rem auto;
  border-radius: 20px;
}

@media (max-width: 960px) {
  .notice_document_meta {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 768px) {
  .notice_hero,
  .notice_hero_overlay {
    min-height: 300px;
  }

  .notice_hero_overlay {
    padding: 1.3rem;
  }

  .notice_hero_overlay h1 {
    font-size: 1.8rem;
  }

  .notice_document_shell {
    padding: 1.25rem;
  }

  .notice_document_head {
    flex-direction: column;
    align-items: flex-start;
  }

  .notice_document_meta {
    grid-template-columns: 1fr;
  }
}
</style>
