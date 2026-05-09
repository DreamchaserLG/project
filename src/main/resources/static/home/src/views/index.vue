<template>
  <div class="front_page home_page">
    <section class="home_banner page_intro_card" :style="bannerStyle">
      <div class="home_banner_layout">
        <div class="home_banner_main">
          <span class="page_kicker">Expo Service Platform</span>
          <h1>会展管理系统</h1>
          <p>
            提供会展信息浏览、展位查询、在线报名、行程确认、退款申请和公告通知等服务，
            保持普通用户、主办用户和管理员在同一系统内协同工作。
          </p>

          <div class="home_banner_search">
            <input
              v-model.trim="bannerKeyword"
              type="text"
              placeholder="请输入会展主题、会展类型或举办地点"
              @keyup.enter="submitBannerSearch"
            >
            <button class="page_primary_btn" type="button" @click="submitBannerSearch">搜索</button>
          </div>
        </div>

        <div class="home_banner_visual">
          <el-carousel class="home_banner_carousel" height="380px" indicator-position="outside">
            <el-carousel-item v-for="slide in bannerSlides" :key="slide.key">
              <router-link class="home_banner_slide" :to="slide.link">
                <img :src="slide.image" :alt="slide.title">
                <div class="home_banner_slide_mask">
                  <span class="page_status_tag is-primary">{{ slide.tag }}</span>
                  <h3>{{ slide.title }}</h3>
                  <p>{{ slide.desc }}</p>
                </div>
              </router-link>
            </el-carousel-item>
          </el-carousel>
        </div>
      </div>
    </section>

    <section class="page_content_block home_tabs_shell">
      <div class="page_section_head">
        <div>
          <span class="page_kicker">Home Navigation</span>
          <h2>首页功能导航</h2>
          <p>点击下方标签，仅切换当前页面内容区域，不跳转、不刷新。</p>
        </div>
      </div>

      <div class="home_tabs">
        <button
          v-for="item in homeTabs"
          :key="item.key"
          type="button"
          class="home_tab"
          :class="{ active: activeTab === item.key }"
          @click="activeTab = item.key"
        >
          <span class="home_tab_icon">{{ item.icon }}</span>
          <span class="home_tab_title">{{ item.title }}</span>
          <span class="home_tab_desc">{{ item.desc }}</span>
        </button>
      </div>

      <div class="tab_panel">
        <template v-if="activeTab === 'notice'">
          <div class="page_list_head">
            <div>
              <span class="page_kicker">Platform Notice</span>
              <h2>平台公告</h2>
              <p>展示系统平台通知、使用提示和重要公告。</p>
            </div>
            <router-link class="page_link_pill" to="/notice/list">查看全部</router-link>
          </div>

          <div class="page_inline_list" v-if="list_notice.length">
            <router-link
              v-for="item in list_notice"
              :key="item.notice_id"
              class="page_inline_item"
              :to="'/notice/details?notice_id=' + item.notice_id"
            >
              <div class="page_inline_item_main">
                <div class="page_inline_item_title">{{ item.title }}</div>
                <div class="page_inline_item_desc">{{ excerpt(item.content, 78) }}</div>
              </div>
              <div class="page_inline_item_side">
                <span class="page_status_tag is-primary">平台公告</span>
                <span>{{ formatDate(item.create_time) }}</span>
              </div>
            </router-link>
          </div>
          <div v-else class="page_empty_state">暂无平台公告</div>
        </template>

        <template v-else-if="activeTab === 'article'">
          <div class="page_list_head">
            <div>
              <span class="page_kicker">Expo Insight</span>
              <h2>会展资讯</h2>
              <p>展示会展相关资讯内容，支持查看详情。</p>
            </div>
            <router-link class="page_link_pill" to="/article/list">查看全部</router-link>
          </div>

          <div class="page_grid_3" v-if="list_article.length">
            <router-link
              v-for="item in list_article"
              :key="item.article_id"
              class="page_card"
              :to="'/article/details?article_id=' + item.article_id"
            >
              <div class="page_card_media">
                <img :src="getImageSrc(item.img)" v-default-img="defaultImage" alt="article">
                <span class="page_card_badge">{{ item.type || "会展资讯" }}</span>
              </div>
              <div class="page_card_body">
                <h3 class="page_card_title clamp_2">{{ item.title }}</h3>
                <p class="home_card_desc">{{ excerpt(item.description || item.content, 54) }}</p>
                <div class="page_card_meta">
                  <span>{{ formatDate(item.create_time) }}</span>
                  <span>浏览 {{ item.hits || 0 }}</span>
                </div>
              </div>
            </router-link>
          </div>
          <div v-else class="page_empty_state">暂无会展资讯</div>
        </template>

        <template v-else-if="activeTab === 'exhibition'">
          <div class="page_list_head">
            <div>
              <span class="page_kicker">Featured Exhibition</span>
              <h2>会展信息</h2>
              <p>支持浏览会展主题、类型、时间、地点和状态，并进入详情页面。</p>
            </div>
            <router-link class="page_link_pill" to="/exhibition_information/list">查看全部</router-link>
          </div>

          <div class="page_grid_3" v-if="list_exhibition_information.length">
            <router-link
              v-for="item in list_exhibition_information"
              :key="item.exhibition_information_id"
              class="page_card"
              :to="'/exhibition_information/details?exhibition_information_id=' + item.exhibition_information_id"
            >
              <div class="page_card_media">
                <img :src="getImageSrc(item.exhibition_poster)" v-default-img="defaultImage" alt="exhibition">
                <span class="page_card_badge">{{ item.exhibition_status || "进行中" }}</span>
              </div>
              <div class="page_card_body">
                <h3 class="page_card_title clamp_2">{{ item.exhibition_theme }}</h3>
                <div class="page_meta_group">
                  <span>会展类型：{{ item.exhibition_and_convention_types || "综合会展" }}</span>
                  <span>举办时间：{{ formatDate(item.event_time) }}</span>
                  <span>举办地点：{{ item.event_venue_name || "待更新" }}</span>
                </div>
              </div>
            </router-link>
          </div>
          <div v-else class="page_empty_state">暂无会展信息</div>
        </template>

        <template v-else-if="activeTab === 'booth'">
          <div class="page_list_head">
            <div>
              <span class="page_kicker">Booth Service</span>
              <h2>展位信息</h2>
              <p>查看展位编号、名称、位置、规格、价格和报名状态。</p>
            </div>
            <router-link class="page_link_pill" to="/booth_information/list">查看全部</router-link>
          </div>

          <div class="page_grid_3" v-if="list_booth_information.length">
            <router-link
              v-for="item in list_booth_information"
              :key="item.booth_information_id"
              class="page_card"
              :to="'/booth_information/details?booth_information_id=' + item.booth_information_id"
            >
              <div class="page_card_media">
                <img :src="getImageSrc(item.booth_images)" v-default-img="defaultImage" alt="booth">
                <span class="page_card_badge">{{ item.booth_type || "标准展位" }}</span>
              </div>
              <div class="page_card_body">
                <div class="home_card_topline">
                  <h3 class="page_card_title clamp_1">{{ item.booth_name }}</h3>
                  <span class="page_status_tag" :class="getBoothStatusClass(item)">{{ getBoothStatusText(item) }}</span>
                </div>
                <div class="page_meta_group">
                  <span>展位编号：{{ item.booth_number || "待分配" }}</span>
                  <span>展位位置：{{ item.booth_location || "待更新" }}</span>
                  <span>展位规格：{{ item.booth_specifications || "标准规格" }}</span>
                  <span>展位价格：¥{{ formatPrice(item.booth_prices) }}</span>
                </div>
              </div>
            </router-link>
          </div>
          <div v-else class="page_empty_state">暂无展位信息</div>
        </template>

        <template v-else-if="activeTab === 'announcement'">
          <div class="page_list_head">
            <div>
              <span class="page_kicker">Exhibition Notice</span>
              <h2>会展公告</h2>
              <p>查看主办方发布的活动变更、注意事项和相关公告。</p>
            </div>
            <router-link class="page_link_pill" to="/exhibition_announcement/list">查看全部</router-link>
          </div>

          <div class="page_grid_3" v-if="list_exhibition_announcement.length">
            <router-link
              v-for="item in list_exhibition_announcement"
              :key="item.exhibition_announcement_id"
              class="page_card"
              :to="'/exhibition_announcement/details?exhibition_announcement_id=' + item.exhibition_announcement_id"
            >
              <div class="page_card_media">
                <img :src="getImageSrc(item.announcement_image)" v-default-img="defaultImage" alt="announcement">
                <span class="page_card_badge">{{ item.announcement_type || "会展公告" }}</span>
              </div>
              <div class="page_card_body">
                <h3 class="page_card_title clamp_2">{{ item.announcement_title }}</h3>
                <p class="home_card_desc">{{ excerpt(item.announcement_content, 54) }}</p>
                <div class="page_card_meta">
                  <span>{{ formatDateTime(item.release_time) }}</span>
                  <span>主办用户 {{ item.host_user || "-" }}</span>
                </div>
              </div>
            </router-link>
          </div>
          <div v-else class="page_empty_state">暂无会展公告</div>
        </template>

        <template v-else>
          <div class="page_list_head">
            <div>
              <span class="page_kicker">Service Flow</span>
              <h2>服务流程</h2>
              <p>围绕普通用户的会展浏览、报名、行程确认和退款流程提供入口。</p>
            </div>
          </div>

          <div class="service_steps">
            <article v-for="item in serviceSteps" :key="item.step" class="service_step_card">
              <span class="service_step_index">{{ item.step }}</span>
              <h3>{{ item.title }}</h3>
              <p>{{ item.desc }}</p>
            </article>
          </div>

          <div class="service_links">
            <router-link to="/exhibition_information/list" class="service_link_card">
              <strong>浏览会展</strong>
              <span>查看活动详情与举办信息</span>
            </router-link>
            <router-link to="/booth_information/list" class="service_link_card">
              <strong>查询展位</strong>
              <span>查看展位资源并进入报名</span>
            </router-link>
            <router-link to="/user_center/index" class="service_link_card">
              <strong>进入个人中心</strong>
              <span>查看报名、行程确认和退款记录</span>
            </router-link>
          </div>
        </template>
      </div>
    </section>
  </div>
</template>

<script>
export default {
  data() {
    return {
      activeTab: "notice",
      bannerKeyword: "",
      defaultImage: "/img/default.png",
      list_notice: [],
      list_article: [],
      list_exhibition_information: [],
      list_booth_information: [],
      list_exhibition_announcement: [],
      homeTabs: [
        { key: "notice", icon: "N", title: "平台公告", desc: "系统通知与平台提醒" },
        { key: "article", icon: "I", title: "会展资讯", desc: "行业资讯与内容推荐" },
        { key: "exhibition", icon: "E", title: "会展信息", desc: "会展主题与活动查询" },
        { key: "booth", icon: "B", title: "展位信息", desc: "展位资源与报名入口" },
        { key: "announcement", icon: "A", title: "会展公告", desc: "主办方公告与变更说明" },
        { key: "service", icon: "S", title: "服务流程", desc: "报名、确认、退款指引" },
      ],
      serviceSteps: [
        { step: "01", title: "浏览会展信息", desc: "按主题、类型和举办地点查看当前开放的会展项目。" },
        { step: "02", title: "查询展位资源", desc: "根据展位位置、规格和价格选择合适的展位资源。" },
        { step: "03", title: "提交报名申请", desc: "在线填写报名资料，名额不足时自动进入候补队列。" },
        { step: "04", title: "办理后续业务", desc: "在个人中心继续完成行程确认、退款申请和记录查询。" },
      ],
    };
  },
  computed: {
    bannerStyle() {
      return {
        "--page-banner-image": "url(/img/theme/city-night.jpg)",
      };
    },
    bannerSlides() {
      const slides = [];

      this.list_exhibition_information.slice(0, 2).forEach((item) => {
        slides.push({
          key: `exhibition-${item.exhibition_information_id}`,
          title: item.exhibition_theme || "精选会展",
          desc: this.excerpt(item.fee_standards || item.schedule_t || item.event_venue_name, 88),
          tag: item.exhibition_status || "会展信息",
          image: this.getImageSrc(item.exhibition_poster) || "/img/theme/expo-floor.jpg",
          link: `/exhibition_information/details?exhibition_information_id=${item.exhibition_information_id}`,
        });
      });

      this.list_article.slice(0, 2).forEach((item) => {
        slides.push({
          key: `article-${item.article_id}`,
          title: item.title || "会展资讯",
          desc: this.excerpt(item.description || item.content, 88),
          tag: item.type || "会展资讯",
          image: this.getImageSrc(item.img) || "/img/theme/future-showroom.jpg",
          link: `/article/details?article_id=${item.article_id}`,
        });
      });

      this.list_notice.slice(0, 1).forEach((item) => {
        slides.push({
          key: `notice-${item.notice_id}`,
          title: item.title || "平台公告",
          desc: this.excerpt(item.content, 88),
          tag: "平台公告",
          image: "/img/theme/city-night.jpg",
          link: `/notice/details?notice_id=${item.notice_id}`,
        });
      });

      if (slides.length) {
        return slides;
      }

      return [
        {
          key: "fallback-exhibition",
          title: "会展信息服务平台",
          desc: "提供会展浏览、展位查询、在线报名和公告通知等服务。",
          tag: "系统首页",
          image: "/img/theme/expo-floor.jpg",
          link: "/exhibition_information/list",
        },
        {
          key: "fallback-article",
          title: "关注最新会展资讯",
          desc: "从平台首页快速进入资讯、公告、展位和会展详情页面。",
          tag: "会展资讯",
          image: "/img/theme/future-showroom.jpg",
          link: "/article/list",
        },
      ];
    },
  },
  created() {
    this.get_token();
  },
  async mounted() {
    await this.loadHomeData();
  },
  methods: {
    getHashParams() {
      const key = "token";
      let query = window.location.search.substring(1);
      let hash = window.location.hash.substring(1);
      if (hash.indexOf("?") > -1) {
        query += "&" + hash.split("?")[1];
      }
      const keyValues = query.split("&");
      const params = {};
      keyValues.forEach((keyVal) => {
        const keyValArr = keyVal.split("=");
        params[keyValArr[0]] = keyValArr[1];
      });
      return typeof params[key] !== "undefined" ? params[key] : "";
    },
    get_token() {
      const token = this.getHashParams();
      if (token) {
        $.db.set("token", token, 120);
        const newHref = window.location.href.replaceAll("?token=" + encodeURIComponent(token), "");
        location.href = newHref;
      }
    },
    async loadHomeData() {
      try {
        const [noticeRes, articleRes, exhibitionRes, boothRes, announcementRes] = await Promise.all([
          this.$get("~/api/notice/get_list?", { page: 1, size: 6 }),
          this.$get("~/api/article/get_list?", { page: 1, size: 6 }),
          this.$get("~/api/exhibition_information/get_list?", { examine_state: "已通过", page: 1, size: 6 }),
          this.$get("~/api/booth_information/get_list?", { examine_state: "已通过", page: 1, size: 6 }),
          this.$get("~/api/exhibition_announcement/get_list?", { page: 1, size: 6 }),
        ]);

        this.list_notice = noticeRes?.result?.list || [];
        this.list_article = articleRes?.result?.list || [];
        this.list_exhibition_information = exhibitionRes?.result?.list || [];
        this.list_booth_information = boothRes?.result?.list || [];
        this.list_exhibition_announcement = announcementRes?.result?.list || [];
      } catch (error) {
        console.error("load home data failed:", error);
      }
    },
    submitBannerSearch() {
      if (!this.bannerKeyword) {
        this.$router.push("/exhibition_information/list");
        return;
      }
      this.$router.push("/search?word=" + encodeURIComponent(this.bannerKeyword));
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
    formatDateTime(value) {
      if (!value) {
        return "时间待更新";
      }
      try {
        return this.$toTime(value, "yyyy-MM-dd hh:mm");
      } catch (error) {
        return value;
      }
    },
    formatPrice(value) {
      if (value === null || value === undefined || value === "") {
        return "0.00";
      }
      const number = Number(value);
      return Number.isNaN(number) ? value : number.toFixed(2);
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
        return plain || "暂无内容摘要";
      }
      return plain.slice(0, maxLength) + "...";
    },
    getBoothStatusText(item) {
      if (item.examine_state && item.examine_state !== "已通过") {
        return item.examine_state;
      }
      return "可报名";
    },
    getBoothStatusClass(item) {
      if (item.examine_state === "待审核") {
        return "is-warning";
      }
      if (item.examine_state && item.examine_state !== "已通过") {
        return "is-danger";
      }
      return "is-success";
    },
  },
};
</script>

<style scoped>
.home_page {
  gap: 1.4rem;
}

.home_banner {
  padding: 2rem 2.2rem;
}

.home_banner_layout {
  position: relative;
  z-index: 1;
  display: grid;
  grid-template-columns: minmax(0, 1.1fr) minmax(0, 1.25fr);
  gap: 1.6rem;
  align-items: center;
}

.home_banner h1 {
  font-size: 2.7rem;
}

.home_banner_main p {
  max-width: 36rem;
}

.home_banner_search {
  display: flex;
  gap: 0.8rem;
  margin-top: 1.35rem;
}

.home_banner_search input {
  flex: 1;
  min-height: 46px;
  padding: 0 1rem;
  border: 1px solid rgba(255, 255, 255, 0.24);
  border-radius: 14px;
  background: rgba(255, 255, 255, 0.14);
  color: #fff;
  outline: none;
}

.home_banner_search input::placeholder {
  color: rgba(255, 255, 255, 0.7);
}

.home_banner_visual {
  position: relative;
  min-width: 0;
}

.home_banner_carousel :deep(.el-carousel__container) {
  border-radius: 30px;
  box-shadow: 0 20px 40px rgba(6, 26, 40, 0.26);
}

.home_banner_slide {
  position: relative;
  display: block;
  width: 100%;
  height: 100%;
  overflow: hidden;
  border-radius: 30px;
}

.home_banner_slide img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.home_banner_slide_mask {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  gap: 0.85rem;
  padding: 1.6rem 1.7rem;
  background: linear-gradient(180deg, rgba(7, 24, 34, 0.08), rgba(7, 24, 34, 0.74));
  color: #fff;
}

.home_banner_slide_mask h3 {
  margin: 0;
  font-size: 1.7rem;
  line-height: 1.35;
}

.home_banner_slide_mask p {
  margin: 0;
  color: rgba(255, 255, 255, 0.82);
  line-height: 1.85;
}

.home_tabs_shell {
  margin-top: 0.35rem;
}

.home_tabs {
  display: grid;
  grid-template-columns: repeat(6, minmax(0, 1fr));
  gap: 1rem;
}

.home_tab {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  justify-content: flex-start;
  gap: 0.5rem;
  min-height: 146px;
  padding: 1.1rem 1rem;
  border-radius: 22px;
  border: 1px solid rgba(15, 54, 80, 0.08);
  background: linear-gradient(180deg, #ffffff, #f7fafc);
  box-shadow: 0 10px 24px rgba(16, 34, 51, 0.06);
  text-align: left;
  cursor: pointer;
  transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease, background 0.2s ease;
}

.home_tab:hover {
  transform: translateY(-3px);
  box-shadow: 0 16px 30px rgba(16, 34, 51, 0.1);
}

.home_tab.active {
  border-color: rgba(29, 122, 134, 0.28);
  background: linear-gradient(180deg, #eff8fb, #e4f2f7);
  box-shadow: 0 18px 30px rgba(29, 122, 134, 0.14);
}

.home_tab_icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 42px;
  height: 42px;
  border-radius: 14px;
  background: rgba(15, 95, 108, 0.09);
  color: var(--color_primary);
  font-size: 1rem;
  font-weight: 700;
}

.home_tab.active .home_tab_icon {
  background: linear-gradient(135deg, #1d7a86, #0f5f6c);
  color: #fff;
}

.home_tab_title {
  font-size: 1rem;
  font-weight: 700;
  color: var(--color_text);
}

.home_tab_desc {
  display: -webkit-box;
  overflow: hidden;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  color: var(--color_text_soft);
  font-size: 0.88rem;
  line-height: 1.7;
}

.tab_panel {
  margin-top: 1.35rem;
}

.home_card_topline {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 0.75rem;
}

.page_meta_group {
  display: grid;
  gap: 0.55rem;
  margin-top: 0.95rem;
  color: var(--color_text_soft);
  font-size: 0.92rem;
  line-height: 1.7;
}

.home_card_desc {
  display: -webkit-box;
  min-height: 3.15rem;
  margin-top: 0.75rem;
  overflow: hidden;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  color: var(--color_text_soft);
  line-height: 1.75;
}

.clamp_1,
.clamp_2 {
  display: -webkit-box;
  overflow: hidden;
  -webkit-box-orient: vertical;
}

.clamp_1 {
  -webkit-line-clamp: 1;
}

.clamp_2 {
  -webkit-line-clamp: 2;
}

.service_steps {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 1rem;
}

.service_step_card {
  padding: 1.3rem 1.2rem;
  border-radius: 24px;
  background: #fff;
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: var(--shadow_card);
}

.service_step_index {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  border-radius: 14px;
  background: rgba(15, 95, 108, 0.1);
  color: var(--color_primary);
  font-family: var(--font_heading);
  font-size: 1.15rem;
}

.service_step_card h3 {
  margin-top: 1rem;
  font-size: 1.08rem;
  color: var(--color_text);
}

.service_step_card p {
  margin-top: 0.6rem;
  color: var(--color_text_soft);
  line-height: 1.8;
}

.service_links {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 1rem;
  margin-top: 1.2rem;
}

.service_link_card {
  display: flex;
  flex-direction: column;
  gap: 0.45rem;
  padding: 1.15rem 1.2rem;
  border-radius: 22px;
  background: linear-gradient(180deg, #ffffff, #f4f8fb);
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: var(--shadow_card);
}

.service_link_card strong {
  color: var(--color_text);
  font-size: 1rem;
}

.service_link_card span {
  color: var(--color_text_soft);
  line-height: 1.7;
}

@media (max-width: 1200px) {
  .home_banner_layout {
    grid-template-columns: 1fr;
  }

  .home_tabs {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }

  .service_steps,
  .service_links {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 768px) {
  .home_banner {
    padding: 1.25rem;
  }

  .home_banner h1 {
    font-size: 2rem;
  }

  .home_banner_search {
    flex-direction: column;
  }

  .home_banner_carousel :deep(.el-carousel__container) {
    height: 300px !important;
  }

  .home_banner_slide_mask {
    padding: 1.2rem;
  }

  .home_banner_slide_mask h3 {
    font-size: 1.35rem;
  }

  .home_tabs,
  .service_steps,
  .service_links {
    grid-template-columns: 1fr;
  }

  .home_tab {
    min-height: auto;
  }
}
</style>
