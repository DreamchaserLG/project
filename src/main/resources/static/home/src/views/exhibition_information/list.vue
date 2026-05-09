<template>
  <div class="front_page exhibition_page" id="exhibition_information_list">
    <section class="page_intro_card" :style="bannerStyle">
      <span class="page_kicker">Exhibition Center</span>
      <h1>会展信息</h1>
      <p>用于浏览和查询会展活动，保留原有字段与详情跳转，只统一展示结构和查询区域样式。</p>
    </section>

    <section class="page_query_card">
      <div class="page_query_grid">
        <div class="page_query_item wide">
          <label>会展主题</label>
          <b-form-input v-model.trim="query.exhibition_theme" placeholder="请输入会展主题"></b-form-input>
        </div>
        <div class="page_query_item">
          <label>会展类型</label>
          <b-form-input v-model.trim="query.exhibition_and_convention_types" placeholder="请输入会展类型"></b-form-input>
        </div>
        <div class="page_query_item">
          <label>排序方式</label>
          <el-select v-model="selectedSortValue" placeholder="默认排序" clearable @change="set_sort">
            <el-option v-for="item in list_sort" :key="item.value" :label="item.name" :value="item.value" />
          </el-select>
        </div>
        <div class="page_query_actions">
          <button type="button" class="page_primary_btn" @click="search()">查询</button>
          <button type="button" class="page_secondary_btn" @click="reset">重置</button>
        </div>
      </div>
    </section>

    <section class="page_list_shell">
      <div class="page_list_head">
        <div>
          <span class="page_kicker">Exhibition List</span>
          <h2>会展列表</h2>
          <p>每个卡片统一展示会展图片、主题、类型、时间、地点和详情入口。</p>
        </div>
      </div>

      <list_exhibition_information ref="exhibition_information" :list="list" />

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
import list_exhibition_information from "@/components/diy/list_exhibition_information.vue";
import diy_pager from "@/components/diy/diy_pager";
import mixin from "@/mixins/page.js";

export default {
  mixins: [mixin],
  components: {
    diy_pager,
    list_exhibition_information,
  },
  data() {
    return {
      url_get_list: "~/api/exhibition_information/get_list",
      query: {
        keyword: "",
        page: 1,
        size: 12,
        exhibition_theme: "",
        exhibition_and_convention_types: "",
        examine_state: "已通过",
      },
      selectedSortValue: "",
      list_sort: [
        { name: "创建时间从新到旧", value: "create_time desc" },
        { name: "创建时间从旧到新", value: "create_time asc" },
        { name: "更新时间从新到旧", value: "update_time desc" },
        { name: "更新时间从旧到新", value: "update_time asc" },
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
    toDetails(o) {
      const query = { exhibition_information_id: o.exhibition_information_id };
      this.$router.push({
        path: "/exhibition_information/details",
        query,
      });
    },
    get_list_before() {},
    filter_set(o, key) {
      this.query[key] = o === "全部" ? "" : o;
      this.search();
    },
    set_sort(o) {
      this.query.orderby = o;
      this.search();
    },
    get_list_after() {},
    reset() {
      this.query.exhibition_theme = "";
      this.query.exhibition_and_convention_types = "";
      this.query.page = 1;
      this.selectedSortValue = "";
      this.query.orderby = "";
      this.search();
    },
    toSize(i) {
      this.query.size = i;
      this.first();
    },
    toPage(i) {
      this.query.page = i;
      this.first();
    },
    goToPage(v) {
      this.query.page = v;
      this.goToNew(v);
    },
  },
};
</script>
