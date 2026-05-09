<template>
  <div class="front_page article_page" id="article_list" v-if="$check_action('/article/list','get')">
    <section class="page_intro_card article_intro" :style="bannerStyle">
      <span class="page_kicker">Expo Insight</span>
      <h1>{{ $page_title("/article/list") || "会展资讯" }}</h1>
      <p>展示会展相关资讯内容，支持按标题搜索、按类型筛选和按时间热度排序。</p>
    </section>

    <section class="page_query_card">
      <div class="page_query_grid">
        <div class="page_query_item wide">
          <label>关键词搜索</label>
          <b-form-input
            v-model.trim="search_val"
            placeholder="请输入资讯标题关键词"
            @keyup.enter="submit_search"
          />
        </div>
        <div class="page_query_item">
          <label>资讯类型</label>
          <el-select v-model="query.type" placeholder="全部类型" clearable @change="search">
            <el-option label="全部" value=""></el-option>
            <el-option
              v-for="item in articleTypeOptions"
              :key="item"
              :label="item"
              :value="item"
            />
          </el-select>
        </div>
        <div class="page_query_item">
          <label>排序方式</label>
          <el-select v-model="query.orderby" placeholder="默认排序" clearable @change="search">
            <el-option
              v-for="item in sort_list"
              :key="item.value"
              :label="item.name"
              :value="item.value"
            />
          </el-select>
        </div>
        <div class="page_query_actions">
          <button type="button" class="page_primary_btn" @click="submit_search">搜索</button>
          <button type="button" class="page_secondary_btn" @click="resetFilters">重置</button>
        </div>
      </div>
    </section>

    <section v-if="featuredArticles.length" class="page_content_block article_showcase_shell">
      <div class="page_section_head">
        <div>
          <span class="page_kicker">Featured Insight</span>
          <h2>重点资讯轮播</h2>
          <p>保留原有资讯详情跳转，只优化前台展示结构，突出重点图文内容。</p>
        </div>
      </div>

      <el-carousel class="article_showcase" height="360px" indicator-position="outside">
        <el-carousel-item v-for="item in featuredArticles" :key="item.article_id">
          <router-link class="article_showcase_item" :to="'/article/details?article_id=' + item.article_id">
            <img :src="getImageSrc(item.img)" v-default-img="defaultImage" alt="featured article">
            <div class="article_showcase_mask">
              <span class="page_status_tag is-primary">{{ item.type || item.tag || "会展资讯" }}</span>
              <h3>{{ item.title }}</h3>
              <p>{{ excerpt(item.description || item.content, 110) }}</p>
              <div class="article_showcase_meta">
                <span>{{ formatDate(item.create_time) }}</span>
                <span>浏览 {{ item.hits || 0 }}</span>
              </div>
            </div>
          </router-link>
        </el-carousel-item>
      </el-carousel>
    </section>

    <section class="page_list_shell article_main">
      <div class="page_list_head">
        <div>
          <span class="page_kicker">Insight List</span>
          <h2>资讯列表</h2>
          <p>按标题、类型和热度筛选会展资讯，列表改为更清晰的图文行式布局。</p>
        </div>
      </div>

      <list_article :list="list" />

      <div class="page_pager">
        <b-pagination
          v-model="query.page"
          :total-rows="count"
          :per-page="query.size"
          @change="goToPage"
        />
      </div>
    </section>

    <section v-if="list_hot.length" class="page_list_shell article_hot_shell">
      <div class="page_list_head side_head">
        <div>
          <span class="page_kicker">Hot List</span>
          <h2>热门资讯</h2>
          <p>展示当前浏览量较高的资讯内容，便于继续查看。</p>
        </div>
      </div>
      <list_article_hot :list="list_hot" />
    </section>
  </div>
</template>

<script>
import list_article from "@/components/diy/list_article.vue";
import list_article_hot from "@/components/diy/list_article_hot.vue";
import mixin from "@/mixins/page.js";

export default {
  mixins: [mixin],
  components: {
    list_article,
    list_article_hot,
  },
  data() {
    return {
      url_get_list: "~/api/article/get_list?",
      defaultImage: "/img/default.png",
      list: [],
      query: {
        page: 1,
        size: 12,
        type: "",
        orderby: "",
      },
      list_hot: [],
      count_pages: 1,
      list_article_type: [],
      sort_list: [
        { name: "热度从高到低", value: "hits desc" },
        { name: "热度从低到高", value: "hits asc" },
        { name: "发布时间从新到旧", value: "create_time desc" },
        { name: "发布时间从旧到新", value: "create_time asc" },
      ],
      search_val: "",
    };
  },
  computed: {
    bannerStyle() {
      return {
        "--page-banner-image": "url(/img/theme/city-night.jpg)",
      };
    },
    articleTypeOptions() {
      return this.list_article_type.filter((item) => item && item !== "全部");
    },
    featuredArticles() {
      const source = this.list_hot.length ? this.list_hot : this.list;
      return source.slice(0, 4);
    },
  },
  methods: {
    get_list_after() {},
    get_all_list() {
      this.query = {
        page: 1,
        size: 12,
        type: "",
        orderby: "",
      };
      this.get_list();
    },
    submit_search() {
      if (!this.search_val.trim()) {
        this.search();
        return;
      }
      this.$router.push({
        path: "/search/details",
        query: {
          word: this.search_val,
          search_key: "title",
          search_type: "article",
          search_title: "文章",
        },
      });
    },
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
            this.list_hot = res.result.list;
          }
        }
      );
    },
    get_article_type() {
      this.$get(
        "~/api/article_type/get_list",
        {
          page: 1,
          size: 0,
        },
        (res) => {
          if (res.result) {
            this.list_article_type = ["全部", ...res.result.list.map((item) => item.name)];
          }
        }
      );
    },
    filter_article(o) {
      this.query.type = o === "全部" ? "" : o;
      this.search();
    },
    sort_goods(o) {
      this.query.orderby = o.value;
      this.search();
    },
    resetFilters() {
      this.search_val = "";
      this.query.type = "";
      this.query.orderby = "";
      this.query.page = 1;
      this.search();
    },
    goToPage(v) {
      this.query.page = v;
      this.goToNew(v);
    },
    getImageSrc(path) {
      return path ? this.$fullUrl(path) : this.defaultImage;
    },
    formatDate(value) {
      if (!value) {
        return "时间待更新";
      }
      try {
        return this.$toTime(value, "yyyy-MM-dd");
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
        return plain || "暂无资讯摘要";
      }
      return plain.slice(0, maxLength) + "...";
    },
  },
  mounted() {
    this.get_hot_article();
    this.get_article_type();
  },
};
</script>

<style scoped>
.article_showcase_shell,
.article_main,
.article_hot_shell {
  margin-top: 1.2rem;
}

.article_showcase :deep(.el-carousel__container) {
  border-radius: 30px;
}

.article_showcase :deep(.el-carousel__button) {
  background: rgba(15, 95, 108, 0.45);
}

.article_showcase_item {
  position: relative;
  display: block;
  width: 100%;
  height: 100%;
  overflow: hidden;
  border-radius: 30px;
}

.article_showcase_item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.article_showcase_mask {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  gap: 0.85rem;
  padding: 1.9rem 2rem;
  background: linear-gradient(180deg, rgba(7, 24, 34, 0.08), rgba(7, 24, 34, 0.78));
  color: #fff;
}

.article_showcase_mask h3 {
  max-width: 52rem;
  margin: 0;
  font-size: 2rem;
  line-height: 1.35;
}

.article_showcase_mask p {
  max-width: 46rem;
  margin: 0;
  color: rgba(255, 255, 255, 0.82);
  line-height: 1.85;
}

.article_showcase_meta {
  display: flex;
  flex-wrap: wrap;
  gap: 0.65rem 1rem;
  color: rgba(255, 255, 255, 0.78);
}

.side_head {
  margin-bottom: 1rem;
}

@media (max-width: 768px) {
  .article_showcase {
    margin-bottom: 0.4rem;
  }

  .article_showcase :deep(.el-carousel__container) {
    height: 300px !important;
  }

  .article_showcase_mask {
    padding: 1.25rem;
  }

  .article_showcase_mask h3 {
    font-size: 1.45rem;
  }
}
</style>
