<template>
  <div class="detail_view_page article_detail_page">
    <section class="page_list_shell article_detail_main" v-if="$check_action('/article/list', 'get')">
      <div_article :obj="obj" />
    </section>

    <section v-if="list_hot.length" class="page_list_shell article_related_shell">
      <div class="page_list_head side_head">
        <div>
          <span class="page_kicker">Related Insight</span>
          <h2>推荐阅读</h2>
          <p>继续查看热门资讯，保持与会展主题相关的延伸阅读。</p>
        </div>
      </div>
      <list_article_hot :list="list_hot" />
    </section>

    <section class="detail_comment_shell" v-if="$check_action('/comment/list', 'get')">
      <div class="page_list_head">
        <div>
          <span class="page_kicker">Comment</span>
          <h2>评论区</h2>
        </div>
      </div>

      <div class="comment_box">
        <list_comment
          class="w-100"
          :list="list_comment"
          :obj="form_comment"
          @reset="update_comment()"
          @update-comment="update_comment"
          :self="isSelf"
        />
        <b-pagination-nav
          :base-url="$route.path"
          :number-of-pages="count_pages"
          :link-gen="link_gen"
          @change="change_page"
          first-number
          last-number
        />
      </div>

      <div class="detail_editor">
        <div class="detail_editor_hint" v-show="Number(form_comment.reply_to_id)">
          正在回复 <i>{{ respondent }}</i>
        </div>
        <div class="detail_editor_reset" v-show="Number(form_comment.reply_to_id)">
          <b-button variant="outline-primary" size="sm" @click="form_comment.reply_to_id = 0">取消回复</b-button>
        </div>
        <form_editor class="fn" :form="form_comment" @update_comment="update_comment" />
      </div>
    </section>
  </div>
</template>

<script>
import mixin from "@/mixins/page.js";
import div_article from "@/components/diy/div_article.vue";
import list_article_hot from "@/components/diy/list_article_hot.vue";
import list_comment from "@/components/diy/list_comment.vue";
import form_editor from "@/components/diy/form_editor.vue";

export default {
  mixins: [mixin],
  components: {
    list_comment,
    div_article,
    list_article_hot,
    form_editor,
  },
  data() {
    return {
      url_get_obj: "~/api/article/get_obj?",
      field: "article_id",
      obj: {},
      query: {
        article_id: 0,
      },
      list_hot: [],
      list_comment: [],
      form_comment: {
        source_table: "article",
        source_field: "article_id",
        source_id: 0,
        reply_to_id: 0,
      },
      count_pages: 1,
      seted_count_pages: true,
    };
  },
  methods: {
    get_hot_article() {
      this.$get(
        "~/api/article/get_list",
        {
          page: 1,
          size: 8,
          orderby: "hits desc",
        },
        (res) => {
          if (res.result) {
            this.list_hot = res.result.list.filter((item) => item.article_id !== this.query.article_id);
          }
        }
      );
    },
    get_comment(obj, page = 1, size = 5) {
      this.$get(
        "~/api/comment/get_list?",
        {
          source_table: "article",
          source_field: "article_id",
          source_id: obj.article_id,
          page,
          size,
          reply_to_id: "0",
          orderby: "create_time desc",
        },
        (json) => {
          if (json.result) {
            const list_comment = json.result.list;
            list_comment.map((o) => {
              o.list_reply = [];
              return o;
            });
            this.add_reply(list_comment).then((list) => {
              this.list_comment = list;
            });
            this.count_pages = Math.ceil(json.result.count / size) || 1;
          }
        }
      );
    },
    add_reply(list) {
      return new Promise((resolve) => {
        for (let idx = 0; idx < list.length; idx += 1) {
          const obj = list[idx];
          this.$get(
            "~/api/comment/get_list?",
            {
              source_table: "article",
              source_field: "article_id",
              source_id: obj.article_id,
              orderby: "create_time desc",
              reply_to_id: obj.comment_id,
            },
            (res) => {
              if (res.result) {
                obj.list_reply = res.result.list;
              }
            }
          );
        }
        resolve(list);
      });
    },
    update_comment() {
      this.get_comment(this.obj);
    },
    link_gen() {
      return {
        query: this.query,
      };
    },
    change_page(page_num) {
      this.get_comment(this.obj, page_num);
      this.form_comment.reply_to_id = 0;
    },
    get_obj_after(json) {
      const obj = json.result.obj;
      this.add_hits(obj);
      this.get_comment(obj);
      this.form_comment.source_id = obj.article_id;
      this.get_hot_article();
    },
    add_hits(obj) {
      this.$post(
        "~/api/article/set?article_id=" + obj.article_id,
        {
          hits: parseInt(obj.hits || 0, 10) + 1,
        },
        () => {
          obj.hits = parseInt(obj.hits || 0, 10) + 1;
        }
      );
    },
  },
  computed: {
    respondent() {
      const reply_to_id = this.form_comment.reply_to_id;
      let respondent = "";
      this.list_comment.forEach((o) => {
        if (o.comment_id === reply_to_id) {
          respondent = o.nickname;
        }
      });
      return respondent;
    },
  },
  mounted() {
    this.get_hot_article();
  },
};
</script>

<style scoped>
.article_related_shell,
.detail_comment_shell {
  margin-top: 1.2rem;
}

.side_head {
  margin-bottom: 1rem;
}

.detail_editor {
  margin-top: 1.2rem;
}

.detail_editor_hint {
  margin-bottom: 0.65rem;
  color: var(--color_text_soft);
}

.detail_editor_reset {
  margin-bottom: 0.8rem;
}
</style>
