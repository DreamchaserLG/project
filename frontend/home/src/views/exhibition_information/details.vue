<template>
  <div class="detail_view_page page_exhibition_information" id="exhibition_information_details">
    <section class="page_list_shell">
      <div_exhibition_information :obj="obj" />
    </section>

    <section class="detail_comment_shell" v-if="$check_action('/comment/list', 'get')">
      <div class="page_list_head">
        <div>
          <span class="page_kicker">Comment</span>
          <h2>评论区</h2>
        </div>
      </div>

      <div class="comment_box" v-if="list_comment.length">
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
      <div v-else class="page_empty_state">暂无评论内容</div>

      <div class="form_edit_box">
        <div class="details_form_editor_title">发表评论</div>
        <div class="answer_title" v-show="form_comment.reply_to_id">
          正在回复 <i>{{ respondent }}</i>
        </div>
        <div class="answer_reset" v-show="form_comment.reply_to_id">
          <b-button variant="outline-primary" size="sm" @click="form_comment.reply_to_id = 0">重置回复对象</b-button>
        </div>
        <form_editor class="fn" :form="form_comment" @update_comment="update_comment" />
      </div>
    </section>
  </div>
</template>

<script>
import div_exhibition_information from "@/components/diy/div_exhibition_information.vue";
import list_comment from "@/components/diy/list_comment.vue";
import form_editor from "@/components/diy/form_editor.vue";
import mixin from "@/mixins/page.js";

export default {
  mixins: [mixin],
  components: {
    list_comment,
    form_editor,
    div_exhibition_information,
  },
  data() {
    return {
      url_get_obj: "~/api/exhibition_information/get_obj?",
      field: "exhibition_information_id",
      obj: {
        praise_len: 0,
      },
      query: {
        exhibition_information_id: 0,
        like: 0,
      },
      list_comment: [],
      form_comment: {
        source_table: "exhibition_information",
        source_field: "exhibition_information_id",
        source_id: 0,
        reply_to_id: 0,
      },
      count_pages: 1,
    };
  },
  methods: {
    add_hits(obj) {
      obj.hits = parseInt(obj.hits || 0, 10) + 1;
      const hits = obj.hits;
      this.$post(`~/api/exhibition_information/set?exhibition_information_id=${obj.exhibition_information_id}`, {
        hits,
      }, (res) => {
        if (res.result) {
          const body = {
            source_table: "exhibition_information",
            source_field: "exhibition_information_id",
            source_id: this.obj.exhibition_information_id,
            user_id: this.$store.state.user.user_id,
          };
          this.$post("~/api/hits/add?", body, () => {});
        } else if (res.error) {
          console.error(res.error);
        }
      });
    },
    async get_obj_after(json) {
      if (json && json.result && json.result.obj) {
        const obj = json.result.obj;
        this.obj = obj;
        this.add_hits(obj);
        this.get_comment(obj);
        this.form_comment.source_id = this.obj.exhibition_information_id;
      }
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
    update_comment() {
      this.get_comment(this.obj);
    },
    get_comment(obj, page = 1, size = 5) {
      this.$get(
        "~/api/comment/get_list?",
        {
          source_table: "exhibition_information",
          source_field: "exhibition_information_id",
          source_id: obj.exhibition_information_id,
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
              source_table: "exhibition_information",
              source_field: "exhibition_information_id",
              source_id: this.obj.exhibition_information_id,
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
    isSelf() {
      return (this.obj.create_by === this.user.user_id) || this.user.user_group === "管理员";
    },
  },
};
</script>

<style scoped>
.page_exhibition_information {
  padding-top: 1rem;
}

.detail_comment_shell {
  margin-top: 1.2rem;
}

.form_edit_box {
  margin-top: 1.2rem;
  padding: 1.35rem;
  border-radius: 24px;
  background: #fff;
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: var(--shadow_card);
}

.details_form_editor_title {
  margin-bottom: 0.9rem;
  color: var(--color_text);
  font-size: 1.1rem;
  font-weight: 700;
}

.answer_title,
.answer_reset {
  margin-bottom: 0.8rem;
}
</style>
