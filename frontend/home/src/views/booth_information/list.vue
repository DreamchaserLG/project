<template>
  <div class="front_page booth_page" id="booth_information_list">
    <section class="page_intro_card" :style="bannerStyle">
      <span class="page_kicker">Booth Center</span>
      <h1>展位信息</h1>
      <p>用于查看会展对应展位资源，保留原有展位详情、报名和候补业务逻辑。</p>
    </section>

    <section class="page_query_card">
      <div class="page_query_grid">
        <div class="page_query_item wide">
          <label>展位名称</label>
          <b-form-input v-model.trim="query.booth_name" placeholder="请输入展位名称"></b-form-input>
        </div>
        <div class="page_query_item">
          <label>展位类型</label>
          <b-form-input v-model.trim="query.booth_type" placeholder="请输入展位类型"></b-form-input>
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
          <span class="page_kicker">Booth List</span>
          <h2>展位列表</h2>
          <p>统一展示展位编号、位置、规格、价格和状态标签，点击进入原有详情页。</p>
        </div>
      </div>

      <list_booth_information ref="booth_information" :list="list" />

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
import list_booth_information from "@/components/diy/list_booth_information.vue";
import diy_pager from "@/components/diy/diy_pager";
import mixin from "@/mixins/page.js";

export default {
  mixins: [mixin],
  components: {
    diy_pager,
    list_booth_information,
  },
  data() {
    return {
      url_get_list: "~/api/booth_information/get_list",
      query: {
        keyword: "",
        page: 1,
        size: 12,
        booth_name: "",
        booth_type: "",
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
        "--page-banner-image": "url(/img/theme/expo-floor.jpg)",
      };
    },
  },
  methods: {
    toDetails(o) {
      const query = { booth_information_id: o.booth_information_id };
      this.$router.push({
        path: "/booth_information/details",
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
      this.query.booth_name = "";
      this.query.booth_type = "";
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
