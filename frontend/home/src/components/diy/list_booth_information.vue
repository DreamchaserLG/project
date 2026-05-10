<template>
  <div v-if="localList.length" class="booth_cards">
    <article
      v-for="(item, index) in localList"
      :key="item.booth_information_id"
      class="booth_card"
      @click="toDetails(item)"
    >
      <div class="booth_card_media">
        <img :src="getDisplayImage(item, index)" v-default-img="fallbackImage" alt="booth image">
        <span class="booth_card_code">{{ item.booth_number || "待分配" }}</span>
        <span class="booth_card_type">{{ item.booth_type || "标准展位" }}</span>
      </div>

      <div class="booth_card_body">
        <div class="booth_card_head">
          <span class="booth_card_theme">{{ item.exhibition_theme || "会展主题待补充" }}</span>
          <span class="page_status_tag" :class="getStatusClass(item)">{{ getStatusText(item) }}</span>
        </div>

        <h3>{{ item.booth_name || "展位信息" }}</h3>
        <p class="booth_card_desc">{{ excerpt(item.booth_specificss, 80) }}</p>

        <div class="booth_card_meta">
          <div class="booth_card_meta_item">
            <label>展位位置</label>
            <span>{{ item.booth_location || "待更新" }}</span>
          </div>
          <div class="booth_card_meta_item">
            <label>展位规格</label>
            <span>{{ item.booth_specifications || "标准规格" }}</span>
          </div>
          <div class="booth_card_meta_item">
            <label>参考价格</label>
            <strong>￥{{ formatPrice(item.booth_prices) }}</strong>
          </div>
          <div class="booth_card_meta_item">
            <label>名额情况</label>
            <span>{{ getSeatText(item) }}</span>
          </div>
        </div>

        <div class="booth_card_footer">
          <span class="booth_card_link">查看详情</span>
        </div>
      </div>
    </article>
  </div>
  <div v-else class="page_empty_state">暂无展位信息</div>
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
    choose_date: {
      type: String,
      default: "",
    },
  },
  data() {
    return {
      localList: [],
      fallbackImage: "/img/default.png",
      coverList: [
        "/img/theme/expo-floor.jpg",
        "/img/theme/future-showroom.jpg",
        "/img/theme/city-night.jpg",
      ],
      waitlistStateMap: {},
      requestToken: 0,
    };
  },
  watch: {
    list: {
      immediate: true,
      handler(value) {
        this.localList = Array.isArray(value) ? value.map((item) => ({ ...item })) : [];
        this.refreshWaitlistStates();
      },
    },
  },
  methods: {
    toDetails(item) {
      const query = {
        booth_information_id: item.booth_information_id,
      };
      if (this.choose_date) {
        query.choose_date = this.choose_date;
      }
      this.$router.push({
        path: "/booth_information/details",
        query,
      });
    },
    refreshWaitlistStates() {
      const boothIds = this.localList
        .map((item) => item.booth_information_id)
        .filter((id) => id !== null && id !== undefined && id !== "");

      this.requestToken += 1;
      const currentToken = this.requestToken;

      if (!boothIds.length) {
        this.waitlistStateMap = {};
        return;
      }

      const nextMap = {};
      let remaining = boothIds.length;
      const userId = this.$store && this.$store.state && this.$store.state.user
        ? this.$store.state.user.user_id
        : null;

      boothIds.forEach((boothId) => {
        const query = { boothId };
        if (userId) {
          query.userId = userId;
        }
        this.$get("~/api/registration/waitlist/status", query, (json) => {
          if (currentToken !== this.requestToken) {
            return;
          }
          if (json && json.result) {
            nextMap[boothId] = json.result;
          }
          remaining -= 1;
          if (remaining === 0 && currentToken === this.requestToken) {
            this.waitlistStateMap = nextMap;
          }
        });
      });
    },
    getWaitlistState(item) {
      return this.waitlistStateMap[item.booth_information_id] || null;
    },
    getDisplayImage(item, index) {
      if (item && item.booth_images) {
        return this.$fullUrl(item.booth_images);
      }
      return this.coverList[index % this.coverList.length];
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
        return plain || "支持查看展位位置、规格、价格和候补报名状态。";
      }
      return plain.slice(0, maxLength) + "...";
    },
    formatPrice(value) {
      if (value === null || value === undefined || value === "") {
        return "0.00";
      }
      const number = Number(value);
      return Number.isNaN(number) ? value : number.toFixed(2);
    },
    getStatusText(item) {
      const waitlistState = this.getWaitlistState(item);
      if (item.examine_state === "待审核") {
        return "待审核";
      }
      if (item.examine_state && item.examine_state !== "已通过") {
        return item.examine_state;
      }
      if (waitlistState && waitlistState.is_full) {
        return "可候补";
      }
      return "可报名";
    },
    getStatusClass(item) {
      const waitlistState = this.getWaitlistState(item);
      if (item.examine_state === "待审核") {
        return "is-warning";
      }
      if (item.examine_state && item.examine_state !== "已通过") {
        return "is-danger";
      }
      if (waitlistState && waitlistState.is_full) {
        return "is-warning";
      }
      return "is-success";
    },
    getSeatText(item) {
      const waitlistState = this.getWaitlistState(item);
      if (waitlistState) {
        if (waitlistState.capacity > 0) {
          return `已报 ${waitlistState.confirmed_count}/${waitlistState.capacity} · 候补 ${waitlistState.waitlist_count}`;
        }
        return `已报 ${waitlistState.confirmed_count} · 不限名额`;
      }

      const capacity = Number(item.registration_information_limit_times || 0);
      if (capacity > 0) {
        return `名额上限 ${capacity}`;
      }
      return "不限名额";
    },
  },
};
</script>

<style scoped>
.booth_cards {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 1.25rem;
}

.booth_card {
  display: flex;
  flex-direction: column;
  overflow: hidden;
  min-height: 100%;
  border-radius: 28px;
  background: #fff;
  border: 1px solid rgba(15, 54, 80, 0.08);
  box-shadow: var(--shadow_card);
  cursor: pointer;
  transition: transform 0.22s ease, box-shadow 0.22s ease;
}

.booth_card:hover {
  transform: translateY(-4px);
  box-shadow: 0 20px 36px rgba(16, 34, 51, 0.12);
}

.booth_card_media {
  position: relative;
  height: 240px;
  overflow: hidden;
}

.booth_card_media img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.booth_card_code,
.booth_card_type {
  position: absolute;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 34px;
  padding: 0 0.85rem;
  border-radius: 999px;
  font-size: 0.78rem;
  font-weight: 700;
  color: #fff;
  backdrop-filter: blur(8px);
}

.booth_card_code {
  top: 1rem;
  left: 1rem;
  background: rgba(7, 24, 34, 0.76);
}

.booth_card_type {
  right: 1rem;
  bottom: 1rem;
  background: rgba(15, 95, 108, 0.84);
}

.booth_card_body {
  display: flex;
  flex: 1;
  flex-direction: column;
  padding: 1.35rem 1.35rem 1.4rem;
}

.booth_card_head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.75rem;
}

.booth_card_theme {
  display: inline-flex;
  align-items: center;
  min-height: 32px;
  padding: 0 0.8rem;
  border-radius: 999px;
  background: rgba(15, 95, 108, 0.08);
  color: var(--color_primary);
  font-size: 0.78rem;
  font-weight: 700;
}

.booth_card h3 {
  margin: 1rem 0 0.6rem;
  color: var(--color_text);
  font-size: 1.35rem;
  line-height: 1.4;
}

.booth_card_desc {
  min-height: 3.8rem;
  margin: 0;
  color: var(--color_text_soft);
  line-height: 1.8;
}

.booth_card_meta {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 0.85rem;
  margin-top: 1.1rem;
}

.booth_card_meta_item {
  padding: 0.95rem 1rem;
  border-radius: 18px;
  background: rgba(248, 250, 252, 0.95);
  border: 1px solid rgba(15, 54, 80, 0.08);
}

.booth_card_meta_item label {
  display: block;
  margin-bottom: 0.35rem;
  color: var(--color_text_soft);
  font-size: 0.78rem;
  font-weight: 700;
}

.booth_card_meta_item span,
.booth_card_meta_item strong {
  color: var(--color_text);
  line-height: 1.65;
  word-break: break-word;
}

.booth_card_meta_item strong {
  color: var(--color_primary_deep);
  font-size: 1.02rem;
}

.booth_card_footer {
  display: flex;
  justify-content: flex-end;
  margin-top: auto;
  padding-top: 1rem;
}

.booth_card_link {
  color: var(--color_primary);
  font-weight: 700;
}

@media (max-width: 1200px) {
  .booth_cards {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 768px) {
  .booth_cards {
    grid-template-columns: 1fr;
  }

  .booth_card_media {
    height: 220px;
  }

  .booth_card_body {
    padding: 1.15rem;
  }

  .booth_card_meta {
    grid-template-columns: 1fr;
  }
}
</style>
