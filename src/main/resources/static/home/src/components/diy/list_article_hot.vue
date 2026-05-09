<template>
  <div v-if="list.length" class="hot_article_list">
    <router-link
      v-for="(item, index) in list"
      :key="item[vm.article_id] || index"
      class="hot_article_item"
      :to="'/article/details?article_id=' + item[vm.article_id]"
    >
      <span class="hot_article_rank">{{ String(index + 1).padStart(2, "0") }}</span>
      <div class="hot_article_body">
        <div class="hot_article_title">{{ item[vm.title] }}</div>
        <div class="hot_article_meta">浏览 {{ item[vm.hits] || 0 }}</div>
      </div>
    </router-link>
  </div>
  <div v-else class="page_empty_state">暂无推荐资讯</div>
</template>

<script>
export default {
  props: {
    list: {
      type: Array,
      default() {
        return [];
      },
    },
    vm: {
      type: Object,
      default() {
        return {
          article_id: "article_id",
          title: "title",
          hits: "hits",
        };
      },
    },
  },
};
</script>

<style scoped>
.hot_article_list {
  display: grid;
  gap: 0.9rem;
}

.hot_article_item {
  display: flex;
  align-items: center;
  gap: 0.95rem;
  padding: 1rem 1.05rem;
  border-radius: 20px;
  background: #fff;
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: 0 10px 22px rgba(16, 34, 51, 0.05);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.hot_article_item:hover {
  transform: translateY(-2px);
  box-shadow: 0 16px 26px rgba(16, 34, 51, 0.08);
}

.hot_article_rank {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 50px;
  height: 50px;
  border-radius: 16px;
  background: linear-gradient(135deg, rgba(15, 95, 108, 0.14), rgba(201, 135, 47, 0.18));
  color: var(--color_primary);
  font-family: var(--font_heading);
  font-size: 1.18rem;
  letter-spacing: 0.05em;
}

.hot_article_body {
  min-width: 0;
  flex: 1;
}

.hot_article_title {
  display: -webkit-box;
  overflow: hidden;
  color: var(--color_text);
  font-weight: 700;
  line-height: 1.65;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.hot_article_meta {
  margin-top: 0.45rem;
  color: var(--color_text_soft);
  font-size: 0.88rem;
}
</style>
