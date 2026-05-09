<template>
  <div class="article_detail_shell">
    <section class="article_detail_hero" :style="heroStyle">
      <div class="article_detail_overlay">
        <span class="page_status_tag is-primary">{{ obj[vm.tag] || "会展资讯" }}</span>
        <h1>{{ obj[vm.title] || "资讯详情" }}</h1>
        <div class="article_detail_meta">
          <span>{{ formatDateTime(obj[vm.create_time]) }}</span>
          <span v-if="obj[vm.source]">来源 {{ obj[vm.source] }}</span>
          <span>浏览 {{ obj[vm.hits] || 0 }}</span>
          <span>点赞 {{ obj[vm.praise_len] || 0 }}</span>
        </div>
        <p class="article_detail_desc">{{ obj[vm.description] || "暂无资讯摘要" }}</p>
      </div>
    </section>

    <div v-if="$store.state.user.user_id" class="article_action_row">
      <b-button v-if="check_praised" @click="add_praise()" class="detail_action_btn is-active">
        <b-icon icon="hand-thumbs-up-fill" />
        <span>已点赞</span>
      </b-button>
      <b-button v-else @click="add_praise()" class="detail_action_btn">
        <b-icon icon="hand-thumbs-up" />
        <span>点赞</span>
      </b-button>

      <b-button v-if="check_collected" @click="add_collect()" class="detail_action_btn is-active">
        <b-icon icon="heart-fill" />
        <span>已收藏</span>
      </b-button>
      <b-button v-else @click="add_collect()" class="detail_action_btn">
        <b-icon icon="heart" />
        <span>收藏</span>
      </b-button>
    </div>

    <div class="article_content_paper">
      <div class="article_content_head">
        <span class="page_kicker">Insight Content</span>
        <h2>正文内容</h2>
      </div>
      <div class="article_detail_content" v-html="obj[vm.content] || '暂无资讯内容'"></div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    obj: {
      type: Object,
      default() {
        return {};
      },
    },
    vm: {
      type: Object,
      default() {
        return {
          img: "img",
          tag: "tag",
          url: "url",
          title: "title",
          source: "source",
          description: "description",
          content: "content",
          create_time: "create_time",
          hits: "hits",
          praise_len: "praise_len",
        };
      },
    },
  },
  data() {
    return {
      check_praised: false,
      check_collected: false,
    };
  },
  computed: {
    heroStyle() {
      const cover = this.obj[this.vm.img] ? this.$fullUrl(this.obj[this.vm.img]) : "/img/theme/future-showroom.jpg";
      return {
        "--article-cover": `url(${cover})`,
      };
    },
  },
  methods: {
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
    get_praise() {
      const user_id = this.$store.state.user.user_id;
      this.$get(
        "~/api/praise/count?",
        {
          source_table: "article",
          source_field: "article_id",
          source_id: this.obj.article_id,
          user_id,
        },
        (res) => {
          if (res.result || res.result === 0) {
            this.check_praised = !!res.result;
          } else if (res.error) {
            this.$toast(res.error.message);
            console.error(res.error);
          }
        }
      );
    },
    add_praise() {
      const body = {
        source_table: "article",
        source_field: "article_id",
        source_id: this.obj.article_id,
        user_id: this.$store.state.user.user_id,
        title: this.obj.title,
        img: this.obj.img,
      };
      const _this = this;
      _this.obj.praise_len = parseInt(_this.obj.praise_len || 0, 10);
      if (!this.check_praised) {
        this.check_praised = true;
        this.$post("~/api/praise/add?", body, (res) => {
          if (res.result) {
            _this.obj.praise_len += 1;
            this.$post(
              "~/api/article/set?article_id=" + _this.obj.article_id,
              { praise_len: _this.obj.praise_len },
              () => {}
            );
            this.$toast("点赞成功", "success");
          } else if (res.error) {
            this.$toast(res.error.message);
            console.error(res.error);
          }
        });
      } else {
        this.check_praised = false;
        this.$get("~/api/praise/del", body, (res) => {
          if (res.result) {
            _this.obj.praise_len -= 1;
            this.$post(
              "~/api/article/set?article_id=" + _this.obj.article_id,
              { praise_len: _this.obj.praise_len },
              () => {}
            );
            this.$toast("已取消点赞");
          } else if (res.error) {
            this.$toast(res.error.message);
            console.error(res.error);
          }
        });
      }
    },
    add_collect() {
      const { title, img, article_id } = this.obj;
      const body = {
        title,
        img,
        source_table: "article",
        source_field: "article_id",
        source_id: article_id,
        user_id: this.$store.state.user.user_id,
      };
      if (!this.check_collected) {
        this.check_collected = true;
        this.$post("~/api/collect/add?", body, () => {
          this.$toast("收藏成功", "success");
        });
      } else {
        this.check_collected = false;
        this.$get(
          "~/api/collect/del",
          {
            user_id: this.$store.state.user.user_id,
            source_id: article_id,
          },
          () => {
            this.$toast("已取消收藏");
          }
        );
      }
    },
    check_collect() {
      const user_id = this.$store.state.user.user_id;
      const article_id = this.obj.article_id;
      this.$get(
        "~/api/collect/count?",
        {
          user_id,
          source_table: "article",
          source_field: "article_id",
          source_id: article_id,
        },
        (res) => {
          this.check_collected = res.result;
        }
      );
    },
  },
  mounted() {
    setTimeout(() => {
      this.check_collect();
      this.get_praise();
    }, 1000);
  },
};
</script>

<style scoped>
.article_detail_shell {
  display: grid;
  gap: 1.45rem;
}

.article_detail_hero {
  position: relative;
  overflow: hidden;
  min-height: 420px;
  border-radius: 34px;
  background:
    linear-gradient(180deg, rgba(7, 24, 34, 0.14), rgba(7, 24, 34, 0.82)),
    var(--article-cover) center/cover no-repeat;
  box-shadow: var(--shadow_deep);
}

.article_detail_overlay {
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  min-height: 420px;
  gap: 0.95rem;
  padding: 2.1rem 2.2rem;
  color: #fff;
}

.article_detail_overlay h1 {
  max-width: 54rem;
  margin: 0;
  font-size: 2.55rem;
  line-height: 1.3;
}

.article_detail_meta {
  display: flex;
  flex-wrap: wrap;
  gap: 0.7rem 1rem;
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.94rem;
}

.article_detail_desc {
  max-width: 46rem;
  margin: 0;
  color: rgba(255, 255, 255, 0.86);
  line-height: 1.95;
}

.article_action_row {
  display: flex;
  flex-wrap: wrap;
  gap: 0.85rem;
}

.detail_action_btn {
  display: inline-flex;
  align-items: center;
  gap: 0.45rem;
  min-width: 104px;
  min-height: 44px;
  border-radius: 14px;
  border: 1px solid rgba(15, 54, 80, 0.1);
  background: #fff !important;
  color: var(--color_text) !important;
  box-shadow: none !important;
}

.detail_action_btn.is-active {
  border-color: rgba(29, 122, 134, 0.24);
  background: rgba(29, 122, 134, 0.08) !important;
  color: var(--color_primary) !important;
}

.article_content_paper {
  padding: 1.85rem 1.95rem;
  border-radius: 30px;
  background: rgba(255, 255, 255, 0.96);
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: var(--shadow_soft);
}

.article_content_head h2 {
  margin: 0.8rem 0 0;
  color: var(--color_text);
  font-size: 1.85rem;
}

.article_detail_content {
  margin-top: 1.4rem;
  color: var(--color_text);
  line-height: 1.95;
  font-size: 1rem;
}

.article_detail_content :deep(p) {
  margin-bottom: 1rem;
}

.article_detail_content :deep(img) {
  display: block;
  max-width: 100%;
  margin: 1.2rem auto;
  border-radius: 22px;
}

@media (max-width: 768px) {
  .article_detail_hero,
  .article_detail_overlay {
    min-height: 340px;
  }

  .article_detail_overlay {
    padding: 1.3rem;
  }

  .article_detail_overlay h1 {
    font-size: 1.8rem;
  }

  .article_content_paper {
    padding: 1.25rem;
  }
}
</style>
