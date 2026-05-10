<template>
  <div class="announcement_detail_page">
    <section class="announcement_hero" :style="heroStyle">
      <div class="announcement_hero_overlay">
        <span class="page_status_tag is-primary">{{ announcementType }}</span>
        <div class="announcement_hero_code">{{ announcementCode }}</div>
        <h1>{{ obj.announcement_title || "会展公告详情" }}</h1>
        <div class="announcement_hero_meta">
          <span>{{ formatDateTime(obj.release_time || obj.create_time) }}</span>
          <span>{{ hostUserText }}</span>
          <span>{{ obj.exhibitionconvention_number || "未关联会展编号" }}</span>
        </div>
        <p class="announcement_hero_desc">{{ announcementLead }}</p>
      </div>
    </section>

    <section class="announcement_document_shell">
      <div class="announcement_document_head">
        <div>
          <span class="page_kicker">Exhibition Notice</span>
          <h2>公告正文</h2>
        </div>
        <div v-if="$store.state.user.user_id" class="announcement_actions">
          <div v-if="$check_action('/exhibition_announcement/details', 'set')">
            <div
              v-if="state_praise"
              class="praise_btn praise_change"
              @click="change_praise()"
            >
              <b-icon icon="hand-thumbs-up-fill" class="icon icon_change"></b-icon>
              <span class="word_change">点赞</span>
            </div>
            <div v-else class="praise_btn" @click="change_praise()">
              <b-icon icon="hand-thumbs-up" class="icon"></b-icon>
              <span>点赞</span>
            </div>
          </div>
          <div v-if="$check_action('/exhibition_announcement/details', 'set')">
            <div
              v-if="state_collect"
              class="collect_btn collect_change"
              @click="change_collect()"
            >
              <b-icon icon="heart-fill" class="icon icon_change"></b-icon>
              <span class="word_change">收藏</span>
            </div>
            <div v-else class="collect_btn" @click="change_collect()">
              <b-icon icon="heart" class="icon"></b-icon>
              <span>收藏</span>
            </div>
          </div>
        </div>
      </div>

      <div class="announcement_document_meta">
        <div class="announcement_meta_item">
          <label>公告编号</label>
          <span>{{ announcementCode }}</span>
        </div>
        <div class="announcement_meta_item">
          <label>公告类型</label>
          <span>{{ announcementType }}</span>
        </div>
        <div class="announcement_meta_item">
          <label>所属会展</label>
          <span>{{ obj.exhibitionconvention_number || "-" }}</span>
        </div>
        <div class="announcement_meta_item">
          <label>发布人</label>
          <span>{{ hostUserText }}</span>
        </div>
      </div>

      <div class="announcement_metrics">
        <div class="announcement_metric_card">
          <label>发布时间</label>
          <strong>{{ formatDateTime(obj.release_time || obj.create_time) }}</strong>
        </div>
        <div class="announcement_metric_card">
          <label>点赞数</label>
          <strong>{{ praiseLen || 0 }}</strong>
        </div>
        <div class="announcement_metric_card">
          <label>浏览量</label>
          <strong>{{ hitsLen || 0 }}</strong>
        </div>
      </div>

      <article
        class="announcement_document_body"
        v-html="obj.announcement_content || '暂无公告内容'"
      ></article>

      <section v-if="obj.announcement_vuser_ideo" class="announcement_video_shell">
        <div class="announcement_video_head">
          <span class="page_kicker">Notice Video</span>
          <h3>公告视频</h3>
        </div>
        <video :src="$fullUrl(obj.announcement_vuser_ideo)" controls></video>
      </section>
    </section>
  </div>
</template>

<script>
import mixin from "@/mixins/component.js";
import mixinPage from "@/mixins/page.js";

export default {
  mixins: [mixin, mixinPage],
  props: {
    obj: {
      type: Object,
      default() {
        return {};
      },
    },
  },
  data() {
    return {
      praiseLen: this.obj.praise_len,
      hitsLen: this.obj.hits,
      list_user_host_user: [],
      state_praise: false,
      state_collect: false,
      fallbackCovers: [
        "/img/theme/expo-floor.jpg",
        "/img/theme/future-showroom.jpg",
        "/img/theme/city-night.jpg",
      ],
    };
  },
  computed: {
    heroStyle() {
      return {
        "--announcement-cover": `url(${this.getCoverSrc(this.obj.announcement_image)})`,
      };
    },
    announcementCode() {
      return `HZGG-${String(this.obj.exhibition_announcement_id || 0).padStart(4, "0")}`;
    },
    announcementType() {
      return this.obj.announcement_type || "会展公告";
    },
    announcementLead() {
      return this.excerpt(this.obj.announcement_content, 120);
    },
    hostUserText() {
      return this.get_user_info("host_user", this.obj.host_user) || this.obj.host_user || "主办方";
    },
  },
  methods: {
    async get_list_user_host_user() {
      const json = await this.$get("~/api/user/get_list?user_group=主办用户");
      if (json.result && json.result.list) {
        this.list_user_host_user = json.result.list;
      } else if (json.error) {
        console.error(json.error);
      }
    },
    get_user_info(name, id) {
      let obj = null;
      if (name === "host_user") {
        obj = this.list_user_host_user.getObj({ user_id: id });
      }
      if (!obj) {
        return "";
      }
      return `${obj.nickname}-${obj.username}`;
    },
    getCoverSrc(path) {
      if (path) {
        return this.$fullUrl(path);
      }
      const seed = this.obj.exhibition_announcement_id || 0;
      return this.fallbackCovers[seed % this.fallbackCovers.length];
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
    change_praise() {
      const user_id = this.user.user_id;
      const query = {
        source_table: "exhibition_announcement",
        source_field: "exhibition_announcement_id",
        source_id: this.obj.exhibition_announcement_id,
        user_id,
      };
      if (this.state_praise) {
        this.state_praise = false;
        this.$get("~/api/praise/del?", query, (res) => {
          if (res.result) {
            this.praiseLen = parseInt(this.praiseLen || 0, 10) - 1;
            const praise_len = this.praiseLen;
            this.$post(
              "~/api/exhibition_announcement/set?exhibition_announcement_id=" + this.obj.exhibition_announcement_id,
              { praise_len },
              () => {}
            );
            this.$message.success("取消点赞");
          } else if (res.error) {
            this.$toast(res.error.message);
            console.error(res.error);
          }
        });
      } else {
        this.state_praise = true;
        query.title = this.obj.announcement_title;
        query.img = this.obj.announcement_image;
        this.$post("~/api/praise/add?", query, (res) => {
          if (res.result) {
            this.praiseLen = parseInt(this.praiseLen || 0, 10) + 1;
            const praise_len = this.praiseLen;
            this.$post(
              "~/api/exhibition_announcement/set?exhibition_announcement_id=" + this.obj.exhibition_announcement_id,
              { praise_len },
              () => {}
            );
            this.$message.success("点赞成功");
          } else if (res.error) {
            this.$toast(res.error.message);
            console.error(res.error);
          }
        });
      }
    },
    get_praise() {
      const user_id = this.$store.state.user.user_id;
      this.$get(
        "~/api/praise/count?",
        {
          source_table: "exhibition_announcement",
          source_field: "exhibition_announcement_id",
          source_id: this.obj.exhibition_announcement_id,
          user_id,
        },
        (res) => {
          if (res.result || res.result === 0) {
            this.state_praise = !!res.result;
          } else if (res.error) {
            this.$toast(res.error.message);
            console.error(res.error);
          }
        }
      );
    },
    change_collect() {
      const user_id = this.user.user_id;
      const query = {
        source_table: "exhibition_announcement",
        source_field: "exhibition_announcement_id",
        source_id: this.obj.exhibition_announcement_id,
        user_id,
      };
      if (this.state_collect) {
        this.state_collect = false;
        this.$get("~/api/collect/del?", query, (res) => {
          if (res.result) {
            this.$message.success("取消收藏");
          } else if (res.error) {
            this.$toast(res.error.message);
            console.error(res.error);
          }
        });
      } else {
        this.state_collect = true;
        query.title = this.obj.announcement_title;
        query.img = this.obj.announcement_image;
        this.$post("~/api/collect/add?", query, (res) => {
          if (res.result) {
            this.$message.success("收藏成功");
          } else if (res.error) {
            this.$toast(res.error.message);
            console.error(res.error);
          }
        });
      }
    },
    check_collect() {
      const user_id = this.$store.state.user.user_id;
      const exhibition_announcement_id = this.obj.exhibition_announcement_id;
      this.$get(
        "~/api/collect/count?",
        {
          user_id,
          source_table: "exhibition_announcement",
          source_field: "exhibition_announcement_id",
          source_id: exhibition_announcement_id,
        },
        (res) => {
          this.state_collect = res.result;
        }
      );
    },
  },
  created() {
    this.get_list_user_host_user();
    setTimeout(() => {
      this.get_praise();
      this.check_collect();
    }, 1000);
  },
  watch: {
    obj: {
      deep: true,
      handler() {
        this.praiseLen = this.obj.praise_len;
        this.hitsLen = this.obj.hits;
      },
    },
  },
};
</script>

<style>
.collect_btn,
.praise_btn {
  margin-right: 0.5rem;
  display: flex;
  white-space: nowrap;
  padding: 0.125rem 0.5rem;
  border-radius: 0.25rem;
  color: var(--color_base);
  border: 1px solid var(--color_default);
  cursor: pointer;
}

.icon_change {
  color: var(--color_base);
}

.collect_btn:hover {
  border: 1px solid var(--color_base);
}

.praise_btn:hover {
  border: 1px solid var(--color_base);
}

.icon {
  font-size: 15px;
  margin: 3px;
}

.word_change {
  color: var(--color_base);
  font-weight: bold;
}
</style>

<style scoped>
.announcement_hero {
  position: relative;
  overflow: hidden;
  min-height: 360px;
  border-radius: 34px;
  background:
    linear-gradient(180deg, rgba(7, 24, 34, 0.18), rgba(7, 24, 34, 0.84)),
    var(--announcement-cover) center/cover no-repeat;
  box-shadow: var(--shadow_deep);
}

.announcement_hero::after {
  content: "";
  position: absolute;
  right: 1.5rem;
  bottom: 1.5rem;
  width: 84px;
  height: 84px;
  border-radius: 24px;
  background:
    rgba(255, 255, 255, 0.16)
    url(/img/gonggaolan-bg.png) center/58% no-repeat;
  backdrop-filter: blur(10px);
}

.announcement_hero_overlay {
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  min-height: 360px;
  gap: 0.8rem;
  padding: 2rem 2.1rem;
  color: #fff;
}

.announcement_hero_code {
  color: rgba(255, 255, 255, 0.78);
  letter-spacing: 0.12em;
  font-size: 0.88rem;
  font-weight: 700;
}

.announcement_hero_overlay h1 {
  max-width: 52rem;
  margin: 0;
  font-size: 2.45rem;
  line-height: 1.32;
}

.announcement_hero_meta {
  display: flex;
  flex-wrap: wrap;
  gap: 0.65rem 1rem;
  color: rgba(255, 255, 255, 0.82);
}

.announcement_hero_desc {
  max-width: 46rem;
  margin: 0;
  color: rgba(255, 255, 255, 0.88);
  line-height: 1.9;
}

.announcement_document_shell {
  margin-top: 1.2rem;
  padding: 1.9rem 2rem;
  border-radius: 30px;
  background: rgba(255, 255, 255, 0.96);
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: var(--shadow_soft);
}

.announcement_document_head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 1rem;
}

.announcement_document_head h2 {
  margin: 0.85rem 0 0;
  color: var(--color_text);
  font-size: 1.9rem;
}

.announcement_actions {
  display: flex;
  flex-wrap: wrap;
  gap: 0.8rem;
}

.announcement_actions > div,
.announcement_actions .praise_btn,
.announcement_actions .collect_btn {
  margin: 0 !important;
}

.announcement_actions .praise_btn,
.announcement_actions .collect_btn {
  display: inline-flex;
  align-items: center;
  gap: 0.45rem;
  min-width: 96px;
  min-height: 42px;
  padding: 0 1rem;
  border-radius: 14px;
  border: 1px solid rgba(15, 54, 80, 0.1);
  background: #fff;
  color: var(--color_text);
}

.announcement_actions .praise_change,
.announcement_actions .collect_change {
  border-color: rgba(29, 122, 134, 0.25);
  background: rgba(29, 122, 134, 0.08);
  color: var(--color_primary);
}

.announcement_document_meta,
.announcement_metrics {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 1rem;
  margin-top: 1.4rem;
}

.announcement_metrics {
  grid-template-columns: repeat(3, minmax(0, 1fr));
}

.announcement_meta_item,
.announcement_metric_card {
  padding: 1rem 1.05rem;
  border-radius: 20px;
  background: #fff;
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: 0 8px 20px rgba(16, 34, 51, 0.05);
}

.announcement_meta_item label,
.announcement_metric_card label {
  display: block;
  margin-bottom: 0.4rem;
  color: var(--color_text_soft);
  font-size: 0.82rem;
  font-weight: 700;
}

.announcement_meta_item span {
  color: var(--color_text);
  line-height: 1.7;
}

.announcement_metric_card strong {
  color: var(--color_text);
  font-size: 1rem;
  line-height: 1.6;
}

.announcement_document_body {
  margin-top: 1.5rem;
  padding-top: 1.4rem;
  border-top: 1px solid rgba(15, 54, 80, 0.08);
  color: var(--color_text);
  line-height: 1.95;
  font-size: 1rem;
}

.announcement_document_body :deep(p) {
  margin-bottom: 1rem;
}

.announcement_document_body :deep(img) {
  display: block;
  max-width: 100%;
  margin: 1.2rem auto;
  border-radius: 20px;
}

.announcement_video_shell {
  margin-top: 1.5rem;
  padding-top: 1.4rem;
  border-top: 1px solid rgba(15, 54, 80, 0.08);
}

.announcement_video_head h3 {
  margin: 0.85rem 0 0;
  font-size: 1.3rem;
  color: var(--color_text);
}

.announcement_video_shell video {
  display: block;
  width: 100%;
  margin-top: 1rem;
  border-radius: 22px;
  background: #0f2233;
}

@media (max-width: 1100px) {
  .announcement_document_meta {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 900px) {
  .announcement_metrics {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .announcement_hero,
  .announcement_hero_overlay {
    min-height: 300px;
  }

  .announcement_hero_overlay {
    padding: 1.3rem;
  }

  .announcement_hero_overlay h1 {
    font-size: 1.8rem;
  }

  .announcement_document_shell {
    padding: 1.25rem;
  }

  .announcement_document_head {
    align-items: stretch;
    flex-direction: column;
  }

  .announcement_document_meta {
    grid-template-columns: 1fr;
  }
}
</style>
