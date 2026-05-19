<template>
  <div class="exhibition_detail_shell">
    <section class="exhibition_hero" :style="heroStyle">
      <div class="exhibition_hero_overlay">
        <span class="page_status_tag" :class="statusClass">{{ obj.exhibition_status || "会展信息" }}</span>
        <h1>{{ obj.exhibition_theme || "会展详情" }}</h1>
        <div class="exhibition_hero_meta">
          <span>{{ obj.exhibitionconvention_number || "编号待更新" }}</span>
          <span>{{ obj.exhibition_and_convention_types || "综合会展" }}</span>
          <span>{{ formatDateTime(obj.event_time) }}</span>
          <span>{{ obj.event_venue_name || "地点待更新" }}</span>
        </div>
        <p class="exhibition_hero_desc">{{ heroDesc }}</p>

        <div class="hero_action_row">
          <template v-if="$store.state.user.user_id">
            <button
              type="button"
              class="hero_action_btn"
              :class="{ active: state_praise }"
              @click="change_praise()"
            >
              <b-icon :icon="state_praise ? 'hand-thumbs-up-fill' : 'hand-thumbs-up'"></b-icon>
              <span>{{ state_praise ? "已点赞" : "点赞" }}</span>
            </button>
            <button
              type="button"
              class="hero_action_btn"
              :class="{ active: state_collect }"
              @click="change_collect()"
            >
              <b-icon :icon="state_collect ? 'heart-fill' : 'heart'"></b-icon>
              <span>{{ state_collect ? "已收藏" : "收藏" }}</span>
            </button>
          </template>

          <button
            v-if="obj.introduction_document"
            type="button"
            class="hero_action_btn secondary"
            @click="previewFile(obj.introduction_document)"
          >
            <b-icon icon="file-earmark-text"></b-icon>
            <span>预览文档</span>
          </button>
        </div>
      </div>
    </section>

    <div class="exhibition_overview">
      <div class="exhibition_poster_card">
        <img :src="posterSrc" alt="exhibition poster" v-default-img="defaultImage">
      </div>

      <div class="exhibition_info_grid">
        <div class="exhibition_info_item">
          <label>会展编号</label>
          <span>{{ obj.exhibitionconvention_number || "-" }}</span>
        </div>
        <div class="exhibition_info_item">
          <label>会展主题</label>
          <span>{{ obj.exhibition_theme || "-" }}</span>
        </div>
        <div class="exhibition_info_item">
          <label>会展类型</label>
          <span>{{ obj.exhibition_and_convention_types || "-" }}</span>
        </div>
        <div class="exhibition_info_item">
          <label>举办时间</label>
          <span>{{ formatDateTime(obj.event_time) }}</span>
        </div>
        <div class="exhibition_info_item">
          <label>举办地点</label>
          <span>{{ obj.event_venue_name || "-" }}</span>
        </div>
        <div class="exhibition_info_item">
          <label>会展状态</label>
          <span>{{ obj.exhibition_status || "-" }}</span>
        </div>
        <div class="exhibition_info_item">
          <label>主办用户</label>
          <span>{{ hostUserName || "-" }}</span>
        </div>
        <div class="exhibition_info_item">
          <label>介绍文档</label>
          <span v-if="obj.introduction_document" class="info_link_group">
            <a :href="$fullUrl(obj.introduction_document)" target="_blank" rel="noreferrer">下载</a>
            <a href="javascript:void(0)" @click.prevent="previewFile(obj.introduction_document)">预览</a>
          </span>
          <span v-else>-</span>
        </div>
        <div class="exhibition_info_item">
          <label>点赞数</label>
          <span>{{ praiseLen || 0 }}</span>
        </div>
        <div class="exhibition_info_item">
          <label>点击数</label>
          <span>{{ hitsLen || 0 }}</span>
        </div>
      </div>
    </div>

    <section v-if="obj.fee_standards" class="rich_text_panel">
      <div class="rich_text_head">
        <span class="page_kicker">Fee Standard</span>
        <h2>费用标准</h2>
      </div>
      <div class="rich_text_body" v-html="obj.fee_standards"></div>
    </section>

    <section v-if="obj.schedule_t" class="rich_text_panel">
      <div class="rich_text_head">
        <span class="page_kicker">Schedule</span>
        <h2>日程安排</h2>
      </div>
      <div class="rich_text_body" v-html="obj.schedule_t"></div>
    </section>
  </div>
</template>

<script>
import mixin from "@/mixins/component.js";
import { formatEventTimeForDisplay } from "@/utils/eventTime";

export default {
  mixins: [mixin],
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
      defaultImage: "/img/default.png",
      praiseLen: this.obj.praise_len,
      hitsLen: this.obj.hits,
      list_user_host_user: [],
      state_praise: false,
      state_collect: false,
    };
  },
  computed: {
    posterSrc() {
      return this.obj.exhibition_poster ? this.$fullUrl(this.obj.exhibition_poster) : this.defaultImage;
    },
    heroStyle() {
      return {
        "--exhibition-cover": `url(${this.posterSrc})`,
      };
    },
    hostUserName() {
      return this.get_user_info("host_user", this.obj.host_user);
    },
    heroDesc() {
      return this.excerpt(this.obj.fee_standards || this.obj.schedule_t || this.obj.event_venue_name, 140);
    },
    statusClass() {
      const status = String(this.obj.exhibition_status || "");
      if (status.includes("结束") || status.includes("已下架")) {
        return "is-muted";
      }
      return "is-primary";
    },
  },
  methods: {
    previewFile(fileName) {
      const fileExtension = fileName.split(".").pop().toLowerCase();
      if (fileExtension === "docx" || fileExtension === "xlsx" || fileExtension === "pptx") {
        this.$router.push(`/filePreview?url=${fileName}&type=${fileExtension}`);
        return;
      }
      window.open(this.$fullUrl(fileName), "_blank");
    },
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
      let ret = "";
      if (obj) {
        ret = `${obj.nickname}-${obj.username}`;
      }
      return ret;
    },
    formatDateTime(value) {
      return formatEventTimeForDisplay(value, "minute");
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
        return plain || "暂无会展简介";
      }
      return plain.slice(0, maxLength) + "...";
    },
    change_praise() {
      const user_id = this.user.user_id;
      const query = {
        source_table: "exhibition_information",
        source_field: "exhibition_information_id",
        source_id: this.obj.exhibition_information_id,
        user_id,
      };

      if (this.state_praise) {
        this.state_praise = false;
        this.$get("~/api/praise/del?", query, (res) => {
          if (res.result) {
            this.praiseLen = parseInt(this.praiseLen || 0, 10) - 1;
            const praise_len = this.praiseLen;
            this.$post(`~/api/exhibition_information/set?exhibition_information_id=${this.obj.exhibition_information_id}`, {
              praise_len,
            }, () => {});
            this.$message.success("取消点赞成功");
          } else if (res.error) {
            this.$toast(res.error.message);
            console.error(res.error);
          }
        });
      } else {
        this.state_praise = true;
        query.title = this.obj.exhibition_theme;
        query.img = this.obj.exhibition_poster;
        this.$post("~/api/praise/add?", query, (res) => {
          if (res.result) {
            this.praiseLen = parseInt(this.praiseLen || 0, 10) + 1;
            const praise_len = this.praiseLen;
            this.$post(`~/api/exhibition_information/set?exhibition_information_id=${this.obj.exhibition_information_id}`, {
              praise_len,
            }, () => {});
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
      this.$get("~/api/praise/count?", {
        source_table: "exhibition_information",
        source_field: "exhibition_information_id",
        source_id: this.obj.exhibition_information_id,
        user_id,
      }, (res) => {
        if (res.result || res.result === 0) {
          this.state_praise = !!res.result;
        } else if (res.error) {
          this.$toast(res.error.message);
          console.error(res.error);
        }
      });
    },
    change_collect() {
      const user_id = this.user.user_id;
      const query = {
        source_table: "exhibition_information",
        source_field: "exhibition_information_id",
        source_id: this.obj.exhibition_information_id,
        user_id,
      };

      if (this.state_collect) {
        this.state_collect = false;
        this.$get("~/api/collect/del?", query, (res) => {
          if (res.result) {
            this.$message.success("取消收藏成功");
          } else if (res.error) {
            this.$toast(res.error.message);
            console.error(res.error);
          }
        });
      } else {
        this.state_collect = true;
        query.title = this.obj.exhibition_theme;
        query.img = this.obj.exhibition_poster;
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
      const exhibition_information_id = this.obj.exhibition_information_id;
      this.$get("~/api/collect/count?", {
        user_id,
        source_table: "exhibition_information",
        source_field: "exhibition_information_id",
        source_id: exhibition_information_id,
      }, (res) => {
        this.state_collect = res.result;
      });
    },
  },
  created() {
    this.get_list_user_host_user();
    setTimeout(() => {
      if (this.$store.state.user.user_id) {
        this.get_praise();
        this.check_collect();
      }
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

<style scoped>
.exhibition_detail_shell {
  display: grid;
  gap: 1.45rem;
}

.exhibition_hero {
  position: relative;
  overflow: hidden;
  min-height: 420px;
  border-radius: 34px;
  background:
    linear-gradient(180deg, rgba(7, 24, 34, 0.14), rgba(7, 24, 34, 0.82)),
    var(--exhibition-cover) center/cover no-repeat;
  box-shadow: var(--shadow_deep);
}

.exhibition_hero_overlay {
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  min-height: 420px;
  gap: 0.95rem;
  padding: 2.15rem 2.2rem;
  color: #fff;
}

.exhibition_hero_overlay h1 {
  max-width: 56rem;
  margin: 0;
  font-size: 2.55rem;
  line-height: 1.28;
}

.exhibition_hero_meta {
  display: flex;
  flex-wrap: wrap;
  gap: 0.7rem 1rem;
  color: rgba(255, 255, 255, 0.82);
}

.exhibition_hero_desc {
  max-width: 48rem;
  margin: 0;
  color: rgba(255, 255, 255, 0.86);
  line-height: 1.92;
}

.hero_action_row {
  display: flex;
  flex-wrap: wrap;
  gap: 0.8rem;
  margin-top: 0.25rem;
}

.hero_action_btn {
  display: inline-flex;
  align-items: center;
  gap: 0.45rem;
  min-height: 42px;
  padding: 0 1rem;
  border: 1px solid rgba(255, 255, 255, 0.18);
  border-radius: 14px;
  background: rgba(255, 255, 255, 0.12);
  color: #fff;
  cursor: pointer;
  backdrop-filter: blur(10px);
}

.hero_action_btn.active {
  background: rgba(255, 255, 255, 0.2);
}

.hero_action_btn.secondary {
  border-color: rgba(255, 255, 255, 0.26);
}

.exhibition_overview {
  display: grid;
  grid-template-columns: minmax(320px, 420px) minmax(0, 1fr);
  gap: 1.2rem;
  align-items: start;
}

.exhibition_poster_card {
  overflow: hidden;
  border-radius: 30px;
  background: #dce6ed;
  box-shadow: var(--shadow_card);
}

.exhibition_poster_card img {
  width: 100%;
  height: 100%;
  min-height: 360px;
  object-fit: cover;
}

.exhibition_info_grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 0.95rem;
}

.exhibition_info_item {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
  min-height: 88px;
  padding: 1rem 1.05rem;
  border-radius: 22px;
  background: #fff;
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: 0 8px 20px rgba(16, 34, 51, 0.05);
}

.exhibition_info_item label {
  color: var(--color_text_soft);
  font-size: 0.82rem;
  font-weight: 700;
}

.exhibition_info_item span {
  color: var(--color_text);
  line-height: 1.75;
  word-break: break-word;
}

.info_link_group {
  display: flex;
  gap: 0.8rem;
}

.info_link_group a {
  color: var(--color_primary) !important;
  font-weight: 700;
}

.rich_text_panel {
  padding: 1.55rem 1.65rem;
  border-radius: 28px;
  background: rgba(255, 255, 255, 0.96);
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: var(--shadow_soft);
}

.rich_text_head h2 {
  margin: 0.85rem 0 0;
  color: var(--color_text);
  font-size: 1.85rem;
}

.rich_text_body {
  margin-top: 1.25rem;
  color: var(--color_text);
  line-height: 1.95;
}

.rich_text_body :deep(img) {
  display: block;
  max-width: 100%;
  margin: 1.2rem auto;
  border-radius: 22px;
}

@media (max-width: 1100px) {
  .exhibition_overview {
    grid-template-columns: 1fr;
  }

  .exhibition_info_grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .exhibition_hero,
  .exhibition_hero_overlay {
    min-height: 340px;
  }

  .exhibition_hero_overlay {
    padding: 1.3rem;
  }

  .exhibition_hero_overlay h1 {
    font-size: 1.8rem;
  }

  .exhibition_poster_card img {
    min-height: 260px;
  }

  .rich_text_panel {
    padding: 1.2rem;
  }
}
</style>
