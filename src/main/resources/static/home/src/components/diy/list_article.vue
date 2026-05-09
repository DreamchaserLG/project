<template>
  <div v-if="list.length" class="article_rows">
    <router-link
      v-for="item in list"
      :key="item[vm.article_id]"
      class="article_row"
      :to="'/article/details?' + vm.article_id + '=' + item[vm.article_id]"
    >
      <div class="article_row_media">
        <img :src="getImageSrc(item[vm.img])" v-default-img="fallbackImage" alt="article cover">
        <span class="article_row_badge">{{ item[vm.tag] || "会展资讯" }}</span>
      </div>

      <div class="article_row_body">
        <div class="article_row_head">
          <h3 class="article_row_title">{{ item[vm.title] }}</h3>
          <span class="article_row_arrow">查看详情</span>
        </div>

        <p class="article_row_desc">{{ excerpt(item[vm.description] || item[vm.content], 140) }}</p>

        <div class="article_row_meta">
          <span>{{ formatDate(item[vm.create_time]) }}</span>
          <span>浏览 {{ item[vm.hits] || 0 }}</span>
          <span>点赞 {{ item[vm.praise_len] || 0 }}</span>
        </div>
      </div>
    </router-link>
  </div>
  <div v-else class="page_empty_state">暂无资讯内容</div>
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
          img: "img",
          article_id: "article_id",
          title: "title",
          description: "description",
          tag: "tag",
          create_time: "create_time",
          content: "content",
          praise_len: "praise_len",
          hits: "hits",
        };
      },
    },
  },
  data() {
    return {
      fallbackImage: "/img/default.png",
    };
  },
  methods: {
    getImageSrc(path) {
      return path ? this.$fullUrl(path) : this.fallbackImage;
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
};
</script>

<style scoped>
.article_rows {
  display: grid;
  gap: 1.25rem;
}

.article_row {
  display: grid;
  grid-template-columns: minmax(280px, 340px) minmax(0, 1fr);
  overflow: hidden;
  border-radius: 30px;
  background: #fff;
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: var(--shadow_card);
  transition: transform 0.22s ease, box-shadow 0.22s ease;
}

.article_row:hover {
  transform: translateY(-4px);
  box-shadow: 0 22px 40px rgba(16, 34, 51, 0.12);
}

.article_row_media {
  position: relative;
  min-height: 250px;
  background: #dfe7ed;
}

.article_row_media img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.article_row_badge {
  position: absolute;
  top: 1.1rem;
  left: 1.1rem;
  z-index: 1;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.42rem 0.9rem;
  border-radius: 999px;
  background: rgba(9, 57, 67, 0.74);
  color: #fff;
  font-size: 0.8rem;
  font-weight: 700;
  backdrop-filter: blur(10px);
}

.article_row_body {
  display: flex;
  flex-direction: column;
  gap: 0.95rem;
  padding: 1.55rem 1.7rem;
}

.article_row_head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 1rem;
}

.article_row_title {
  display: -webkit-box;
  overflow: hidden;
  margin: 0;
  color: var(--color_text);
  font-size: 1.5rem;
  line-height: 1.45;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.article_row_arrow {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 96px;
  min-height: 38px;
  padding: 0 0.9rem;
  border-radius: 999px;
  background: rgba(15, 95, 108, 0.08);
  color: var(--color_primary);
  font-size: 0.85rem;
  font-weight: 700;
  white-space: nowrap;
}

.article_row_desc {
  display: -webkit-box;
  overflow: hidden;
  margin: 0;
  color: var(--color_text_soft);
  line-height: 1.9;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
}

.article_row_meta {
  display: flex;
  flex-wrap: wrap;
  gap: 0.65rem 1rem;
  margin-top: auto;
  padding-top: 0.6rem;
  color: var(--color_text_soft);
  font-size: 0.9rem;
}

@media (max-width: 960px) {
  .article_row {
    grid-template-columns: 1fr;
  }

  .article_row_media {
    min-height: 220px;
  }

  .article_row_body {
    padding: 1.25rem;
  }

  .article_row_title {
    font-size: 1.28rem;
  }
}

@media (max-width: 640px) {
  .article_row_head {
    flex-direction: column;
  }

  .article_row_arrow {
    min-height: 34px;
  }
}
</style>
