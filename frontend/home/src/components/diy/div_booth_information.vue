<template>
  <div class="booth_detail_page">
    <section class="booth_hero" :style="heroStyle">
      <div class="booth_hero_panel">
        <div class="booth_hero_head">
          <div class="booth_hero_text">
            <span class="page_status_tag" :class="boothStatusClass">{{ boothStatusText }}</span>
            <div class="booth_hero_code">{{ boothCode }}</div>
            <h1>{{ obj.booth_name || "展位详情" }}</h1>
            <p>{{ boothSummary }}</p>
          </div>
          <div class="booth_hero_price">
            <label>参考价格</label>
            <strong>￥{{ boothPriceText }}</strong>
          </div>
        </div>

        <div class="booth_hero_highlights">
          <div class="booth_highlight_item">
            <label>会展主题</label>
            <strong>{{ obj.exhibition_theme || "-" }}</strong>
          </div>
          <div class="booth_highlight_item">
            <label>展位位置</label>
            <strong>{{ obj.booth_location || "待更新" }}</strong>
          </div>
          <div class="booth_highlight_item">
            <label>展位规格</label>
            <strong>{{ obj.booth_specifications || "标准规格" }}</strong>
          </div>
          <div class="booth_highlight_item">
            <label>展位类型</label>
            <strong>{{ obj.booth_type || "标准展位" }}</strong>
          </div>
        </div>
      </div>
    </section>

    <section class="booth_document_shell">
      <div class="booth_document_head">
        <div>
          <span class="page_kicker">Booth Profile</span>
          <h2>展位资料</h2>
        </div>
        <div v-if="$store.state.user.user_id" class="booth_actions">
          <div v-if="$check_action('/booth_information/details', 'set')">
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
          <div v-if="$check_action('/booth_information/details', 'set')">
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

      <div class="queue_summary premium_queue_summary" v-if="waitlistInfo.boothId">
        <div class="queue_summary_item">
          <span class="queue_summary_label">已报名</span>
          <span class="queue_summary_value">
            {{ waitlistInfo.confirmed_count }}
            <span v-if="waitlistInfo.capacity > 0"> / {{ waitlistInfo.capacity }}</span>
          </span>
        </div>
        <div class="queue_summary_item">
          <span class="queue_summary_label">候补人数</span>
          <span class="queue_summary_value">{{ waitlistInfo.waitlist_count }}</span>
        </div>
        <div class="queue_summary_notice">{{ queueNotice }}</div>
      </div>

      <div class="booth_cta_row">
        <button
          class="btn btn-primary booth_cta_btn"
          v-if="$check_action('/registration_information/edit', 'add') && !waitlistInfo.my_status"
          @click="to_form('/registration_information/edit')"
        >
          <span>{{ waitlistInfo.is_full ? "加入候补" : "立即报名" }}</span>
        </button>
        <button
          class="btn btn-outline-secondary booth_cta_btn"
          v-if="$check_action('/registration_information/edit', 'add') && canCancelCurrent()"
          @click="cancelCurrentRegistration()"
        >
          <span>{{ waitlistInfo.my_status === "候补中" ? "取消候补" : "取消报名" }}</span>
        </button>
      </div>

      <div class="booth_meta_grid">
        <div class="booth_meta_item">
          <label>展位编号</label>
          <span>{{ obj.booth_number || "-" }}</span>
        </div>
        <div class="booth_meta_item">
          <label>所属会展编号</label>
          <span>{{ obj.exhibitionconvention_number || "-" }}</span>
        </div>
        <div class="booth_meta_item">
          <label>主办方</label>
          <span>{{ hostUserText }}</span>
        </div>
        <div class="booth_meta_item">
          <label>当前状态</label>
          <span class="page_status_tag" :class="boothStatusClass">{{ boothStatusText }}</span>
        </div>
        <div class="booth_meta_item">
          <label>展位位置</label>
          <span>{{ obj.booth_location || "待更新" }}</span>
        </div>
        <div class="booth_meta_item">
          <label>展位规格</label>
          <span>{{ obj.booth_specifications || "标准规格" }}</span>
        </div>
        <div class="booth_meta_item">
          <label>点赞数</label>
          <span>{{ praiseLen || 0 }}</span>
        </div>
        <div class="booth_meta_item">
          <label>浏览量</label>
          <span>{{ hitsLen || 0 }}</span>
        </div>
      </div>

      <section class="booth_content_block">
        <div class="booth_content_head">
          <span class="page_kicker">Booth Description</span>
          <h3>展位说明</h3>
        </div>
        <div
          class="booth_content_body"
          v-html="obj.booth_specificss || '暂无展位说明'"
        ></div>
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
      registration_information_limit: false,
      waitlistInfo: {
        boothId: 0,
        capacity: 0,
        confirmed_count: 0,
        waitlist_count: 0,
        is_full: false,
        my_status: "",
        my_waitlist_no: null,
        my_registration_id: null,
        my_pay_state: "",
      },
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
        "--booth-cover": `url(${this.getCoverSrc(this.obj.booth_images)})`,
      };
    },
    boothCode() {
      const raw = this.obj.booth_number || this.obj.booth_information_id || 0;
      return `BTH-${String(raw).padStart(4, "0")}`;
    },
    boothPriceText() {
      return this.formatPrice(this.obj.booth_prices);
    },
    boothSummary() {
      return this.excerpt(
        this.obj.booth_specificss,
        140,
        "统一展示展位位置、规格、价格以及候补报名情况，支持直接查看详情并参与报名。"
      );
    },
    boothStatusText() {
      if (this.obj.examine_state === "待审核") {
        return "待审核";
      }
      if (this.obj.examine_state && this.obj.examine_state !== "已通过") {
        return this.obj.examine_state;
      }
      return this.waitlistInfo.is_full ? "可候补" : "可报名";
    },
    boothStatusClass() {
      if (this.obj.examine_state === "待审核") {
        return "is-warning";
      }
      if (this.obj.examine_state && this.obj.examine_state !== "已通过") {
        return "is-danger";
      }
      return this.waitlistInfo.is_full ? "is-warning" : "is-success";
    },
    hostUserText() {
      return this.get_user_info("host_user", this.obj.host_user) || this.obj.host_user || "主办方";
    },
    queueNotice() {
      if (!this.waitlistInfo || !this.waitlistInfo.boothId) {
        return "";
      }
      if (this.waitlistInfo.my_status === "候补中" || this.waitlistInfo.my_status === "候补审核中") {
        return `您已在候补队列中，当前为第 ${this.waitlistInfo.my_waitlist_no || "-"} 位。`;
      }
      if (this.waitlistInfo.my_status === "报名成功" || this.waitlistInfo.my_status === "已报名") {
        if (this.waitlistInfo.my_pay_state === "未支付") {
          return "您已转为正式报名，请尽快完成支付。";
        }
        return "您已获得当前展位名额。";
      }
      if (this.waitlistInfo.is_full) {
        return "当前正式名额已满，继续提交将进入候补队列。";
      }
      return "当前仍有正式名额，可直接报名。";
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
      const seed = this.obj.booth_information_id || 0;
      return this.fallbackCovers[seed % this.fallbackCovers.length];
    },
    stripHtml(content) {
      return String(content || "")
        .replace(/<[^>]+>/g, " ")
        .replace(/\s+/g, " ")
        .trim();
    },
    excerpt(content, maxLength, emptyText = "暂无说明") {
      const plain = this.stripHtml(content);
      if (plain.length <= maxLength) {
        return plain || emptyText;
      }
      return plain.slice(0, maxLength) + "...";
    },
    formatPrice(value) {
      if (value === null || value === undefined || value === "") {
        return "0.00";
      }
      const number = Number(value);
      return Number.isNaN(number) ? value : number.toFixed(2);
    },
    change_praise() {
      const user_id = this.user.user_id;
      const query = {
        source_table: "booth_information",
        source_field: "booth_information_id",
        source_id: this.obj.booth_information_id,
        user_id,
      };
      if (this.state_praise) {
        this.state_praise = false;
        this.$get("~/api/praise/del?", query, (res) => {
          if (res.result) {
            this.praiseLen = parseInt(this.praiseLen || 0, 10) - 1;
            const praise_len = this.praiseLen;
            this.$post(
              "~/api/booth_information/set?booth_information_id=" + this.obj.booth_information_id,
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
        query.title = this.obj.booth_name;
        query.img = this.obj.booth_images;
        this.$post("~/api/praise/add?", query, (res) => {
          if (res.result) {
            this.praiseLen = parseInt(this.praiseLen || 0, 10) + 1;
            const praise_len = this.praiseLen;
            this.$post(
              "~/api/booth_information/set?booth_information_id=" + this.obj.booth_information_id,
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
          source_table: "booth_information",
          source_field: "booth_information_id",
          source_id: this.obj.booth_information_id,
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
        source_table: "booth_information",
        source_field: "booth_information_id",
        source_id: this.obj.booth_information_id,
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
        query.title = this.obj.booth_name;
        query.img = this.obj.booth_images;
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
      const booth_information_id = this.obj.booth_information_id;
      this.$get(
        "~/api/collect/count?",
        {
          user_id,
          source_table: "booth_information",
          source_field: "booth_information_id",
          source_id: booth_information_id,
        },
        (res) => {
          this.state_collect = res.result;
        }
      );
    },
    to_form(url) {
      const cache_obj = { ...this.obj };
      delete cache_obj.booth_specificss;
      $.db.set("form", cache_obj);
      this.$router.push(url);
    },
    refreshWaitlistStatus() {
      if (!this.obj.booth_information_id) {
        return;
      }
      const query = {
        boothId: this.obj.booth_information_id,
      };
      if (this.$store.state.user.user_id) {
        query.userId = this.$store.state.user.user_id;
      }
      this.$get("~/api/registration/waitlist/status", query, (json) => {
        if (json && json.result) {
          this.waitlistInfo = Object.assign({}, this.waitlistInfo, json.result);
          this.registration_information_limit = Boolean(json.result.is_full);
        }
      });
    },
    canCancelCurrent() {
      if (!this.waitlistInfo || !this.waitlistInfo.my_status) {
        return false;
      }
      if (this.waitlistInfo.my_status === "候补中" || this.waitlistInfo.my_status === "候补审核中") {
        return true;
      }
      return (this.waitlistInfo.my_status === "报名成功" || this.waitlistInfo.my_status === "已报名")
        && this.waitlistInfo.my_pay_state !== "已支付"
        && this.waitlistInfo.my_pay_state !== "退款中";
    },
    cancelCurrentRegistration() {
      if (!this.waitlistInfo.my_registration_id) {
        return;
      }
      this.$confirm(
        (this.waitlistInfo.my_status === "候补中" || this.waitlistInfo.my_status === "候补审核中") ? "确认取消当前候补资格？" : "确认取消当前报名？",
        "提示",
        {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning",
        }
      )
        .then(() => {
          this.$post("~/api/registration_information/cancel/" + this.waitlistInfo.my_registration_id, {}, (json) => {
            if (json && json.result) {
              this.$message.success(json.result.message || "操作成功");
              this.refreshWaitlistStatus();
            } else if (json && json.error) {
              this.$toast(json.error.message, "danger");
            }
          });
        })
        .catch(() => {});
    },
    get_registration_information_limit() {
      const param = {
        source_table: "booth_information",
        source_id: this.obj.booth_information_id,
        source_user_id: this.user.user_id,
      };
      if (this.obj.registration_information_limit_times > 0) {
        this.$get("~/api/registration_information/count?", param, (result) => {
          if (result) {
            this.registration_information_limit =
              result.result >= this.obj.registration_information_limit_times;
          }
        });
      } else {
        this.registration_information_limit = false;
      }
      this.obj.source_table = param.source_table;
      this.obj.source_id = param.source_id;
      this.obj.source_user_id = param.source_user_id;
      this.refreshWaitlistStatus();
    },
  },
  created() {
    this.get_list_user_host_user();
    setTimeout(() => {
      this.get_praise();
      this.check_collect();
      this.get_registration_information_limit();
      this.refreshWaitlistStatus();
    }, 1000);
  },
  watch: {
    obj: {
      deep: true,
      handler() {
        this.praiseLen = this.obj.praise_len;
        this.hitsLen = this.obj.hits;
        this.refreshWaitlistStatus();
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
.booth_hero {
  position: relative;
  overflow: hidden;
  min-height: 380px;
  border-radius: 34px;
  background:
    linear-gradient(120deg, rgba(7, 24, 34, 0.22), rgba(7, 24, 34, 0.84)),
    var(--booth-cover) center/cover no-repeat;
  box-shadow: var(--shadow_deep);
}

.booth_hero::after {
  content: "";
  position: absolute;
  right: 1.5rem;
  bottom: 1.5rem;
  width: 84px;
  height: 84px;
  border-radius: 24px;
  background:
    rgba(255, 255, 255, 0.16)
    url(/img/marker.png) center/48% no-repeat;
  backdrop-filter: blur(10px);
}

.booth_hero_panel {
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  min-height: 380px;
  gap: 1.2rem;
  padding: 2.1rem;
  color: #fff;
}

.booth_hero_head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 1.25rem;
}

.booth_hero_code {
  margin-top: 0.85rem;
  color: rgba(255, 255, 255, 0.78);
  letter-spacing: 0.12em;
  font-size: 0.88rem;
  font-weight: 700;
}

.booth_hero_text h1 {
  max-width: 46rem;
  margin: 0.85rem 0 0;
  font-size: 2.45rem;
  line-height: 1.3;
}

.booth_hero_text p {
  max-width: 42rem;
  margin: 0.95rem 0 0;
  color: rgba(255, 255, 255, 0.86);
  line-height: 1.9;
}

.booth_hero_price {
  min-width: 220px;
  padding: 1.15rem 1.25rem;
  border-radius: 28px;
  background: rgba(255, 255, 255, 0.14);
  border: 1px solid rgba(255, 255, 255, 0.18);
  backdrop-filter: blur(12px);
  text-align: right;
}

.booth_hero_price label {
  display: block;
  color: rgba(255, 255, 255, 0.72);
  font-size: 0.84rem;
  font-weight: 700;
}

.booth_hero_price strong {
  display: block;
  margin-top: 0.45rem;
  font-size: 2rem;
  line-height: 1;
}

.booth_hero_highlights {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 1rem;
}

.booth_highlight_item {
  padding: 1rem 1.05rem;
  border-radius: 22px;
  background: rgba(255, 255, 255, 0.12);
  border: 1px solid rgba(255, 255, 255, 0.14);
  backdrop-filter: blur(8px);
}

.booth_highlight_item label {
  display: block;
  margin-bottom: 0.35rem;
  color: rgba(255, 255, 255, 0.74);
  font-size: 0.82rem;
  font-weight: 700;
}

.booth_highlight_item strong {
  color: #fff;
  line-height: 1.65;
}

.booth_document_shell {
  margin-top: 1.2rem;
  padding: 1.9rem 2rem;
  border-radius: 30px;
  background: rgba(255, 255, 255, 0.96);
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: var(--shadow_soft);
}

.booth_document_head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 1rem;
}

.booth_document_head h2 {
  margin: 0.85rem 0 0;
  color: var(--color_text);
  font-size: 1.9rem;
}

.booth_actions {
  display: flex;
  flex-wrap: wrap;
  gap: 0.8rem;
}

.booth_actions > div,
.booth_actions .praise_btn,
.booth_actions .collect_btn {
  margin: 0 !important;
}

.booth_actions .praise_btn,
.booth_actions .collect_btn {
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

.booth_actions .praise_change,
.booth_actions .collect_change {
  border-color: rgba(29, 122, 134, 0.25);
  background: rgba(29, 122, 134, 0.08);
  color: var(--color_primary);
}

.premium_queue_summary {
  margin-top: 1.35rem;
  border-radius: 24px;
}

.premium_queue_summary .queue_summary_notice {
  flex: 1 1 100%;
  margin-top: 0;
}

.booth_cta_row {
  display: flex;
  flex-wrap: wrap;
  gap: 0.85rem;
  margin-top: 1rem;
}

.booth_cta_btn {
  min-width: 138px;
  min-height: 44px;
  border-radius: 999px;
}

.booth_meta_grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 1rem;
  margin-top: 1.35rem;
}

.booth_meta_item {
  padding: 1rem 1.05rem;
  border-radius: 20px;
  background: #fff;
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: 0 8px 20px rgba(16, 34, 51, 0.05);
}

.booth_meta_item label {
  display: block;
  margin-bottom: 0.4rem;
  color: var(--color_text_soft);
  font-size: 0.82rem;
  font-weight: 700;
}

.booth_meta_item span {
  color: var(--color_text);
  line-height: 1.7;
  word-break: break-word;
}

.booth_content_block {
  margin-top: 1.45rem;
  padding: 1.45rem 1.5rem;
  border-radius: 26px;
  background: #fff;
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: var(--shadow_card);
}

.booth_content_head h3 {
  margin: 0.85rem 0 0;
  color: var(--color_text);
  font-size: 1.4rem;
}

.booth_content_body {
  margin-top: 1rem;
  color: var(--color_text);
  line-height: 1.95;
}

.booth_content_body :deep(p) {
  margin-bottom: 1rem;
}

.booth_content_body :deep(img) {
  display: block;
  max-width: 100%;
  margin: 1rem auto;
  border-radius: 20px;
}

@media (max-width: 1200px) {
  .booth_hero_highlights,
  .booth_meta_grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 900px) {
  .booth_hero_head {
    flex-direction: column;
    align-items: stretch;
  }

  .booth_hero_price {
    min-width: 0;
    text-align: left;
  }
}

@media (max-width: 768px) {
  .booth_hero,
  .booth_hero_panel {
    min-height: 320px;
  }

  .booth_hero_panel,
  .booth_document_shell {
    padding: 1.25rem;
  }

  .booth_hero_text h1 {
    font-size: 1.9rem;
  }

  .booth_hero_highlights,
  .booth_meta_grid {
    grid-template-columns: 1fr;
  }

  .booth_document_head {
    align-items: stretch;
    flex-direction: column;
  }
}
</style>
