<template>
  <footer class="page_footer">
    <div class="wrap">
      <div class="container footer_shell">
        <div class="footer_brand">
          <div class="footer_logo">会展管理系统</div>
          <p class="footer_desc">
            面向主办方、参展商与访客的综合会展门户，统一承载展会展示、资讯发布、平台公告与业务协同入口。
          </p>
        </div>

        <div class="footer_links">
          <div class="footer_title">快捷入口</div>
          <router-link to="/">首页</router-link>
          <router-link to="/article/list">会展资讯</router-link>
          <router-link to="/notice/list">平台公告</router-link>
          <router-link to="/exhibition_information/list">精选展会</router-link>
        </div>

        <div class="footer_meta">
          <div class="footer_title">平台定位</div>
          <p>以企业级视觉风格呈现会展管理、内容展示与信息门户能力。</p>
          <p>适合毕设演示、业务流程展示，以及后续功能扩展和二次开发。</p>
          <div class="footer_copy">Copyright {{ year }} Expo Management Portal</div>
        </div>
      </div>
    </div>
  </footer>
</template>

<script>
export default {
  data() {
    return {
      year: new Date().getFullYear(),
    };
  },
};
</script>

<style scoped>
.page_footer .wrap {
  margin-top: 4rem;
  padding: 3.4rem 0 3.2rem;
  background:
    radial-gradient(circle at top right, rgba(201, 135, 47, 0.18), transparent 20%),
    linear-gradient(135deg, #0a1d29 0%, #0f3440 45%, #0f5f6c 100%);
  color: rgba(255, 255, 255, 0.9);
}

.footer_shell {
  display: grid;
  grid-template-columns: 2fr 1fr 1.2fr;
  gap: 2.25rem;
  align-items: start;
  padding: 0 0.25rem;
}

.footer_logo {
  font-family: var(--font_heading);
  font-size: 2.15rem;
  letter-spacing: 0.08em;
  margin-bottom: 1rem;
  color: #fff;
}

.footer_desc,
.footer_meta p {
  margin: 0;
  line-height: 1.8;
  color: rgba(255, 255, 255, 0.72);
}

.footer_title {
  margin-bottom: 1rem;
  font-size: 0.95rem;
  font-weight: 700;
  color: #fff;
}

.footer_links {
  display: flex;
  flex-direction: column;
  gap: 0.85rem;
}

.footer_links a {
  width: fit-content;
  color: rgba(255, 255, 255, 0.78) !important;
  padding-bottom: 0.1rem;
  border-bottom: 1px solid transparent;
}

.footer_links a:hover {
  color: #fff !important;
  border-bottom-color: rgba(255, 255, 255, 0.4);
}

.footer_copy {
  margin-top: 1.4rem;
  color: rgba(255, 255, 255, 0.56);
  font-size: 0.88rem;
}

@media (max-width: 992px) {
  .footer_shell {
    grid-template-columns: 1fr;
  }
}
</style>
