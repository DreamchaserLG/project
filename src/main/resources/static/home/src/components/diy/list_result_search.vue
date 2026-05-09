<template>
  <div class="list_result_search">
    <div class="title_type">{{ title }}</div>
    <div class="list_result" v-if="list.length">
      <router-link
        :to="
          '/' +
          source_table +
          '/details?' +
          source_table +
          '_id=' +
          o[source_table + '_id']
        "
        class="item"
        v-for="(o, i) in list"
        :key="i"
      >
        <div class="title">{{ i + 1 }} , {{ o.display_title || o.title }}</div>
        <div v-if="o.matched_fields && o.matched_fields.length" class="matched-fields">
          <div v-for="(field, index) in o.matched_fields" :key="index" class="field-item">
            <span class="field-name">{{ field.field }}：</span>
            <span class="field-value" v-html="highlightKeyword(field.value, $route.query.word)"></span>
          </div>
        </div>
      </router-link>
    </div>
    <div v-else class="no_result">
      没有找到{{title}}相关内容
    </div>
  </div>
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
    title: {
      type: String,
      default() {
        return "";
      },
    },
    source_table: {
      type: String,
      default() {
        return "";
      },
    },
  },
  data() {
    return {};
  },
  methods: {
    highlightKeyword(text, keyword) {
      if (!text || !keyword) return text;
      const regex = new RegExp(`(${this.escapeRegExp(keyword)})`, 'gi');
      const result = text.toString().replace(regex, '<span class="highlight">$1</span>');
      return result;
    },

    escapeRegExp(string) {
      return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    }
  },
  components: {},
};
</script>

<style scoped>
.title_type {
  font-weight: 600;
}

.title {
  text-indent: 2em;
  border-bottom: 1px solid var(--color_border);
}

.list_result .item {
  display: block;
  margin: 10px 0;
  padding: 10px;
  border: 1px solid var(--color_border);
  border-radius: 4px;
}

.list_result .description {
  color: var(--color_grey);
  font-size: 0.875rem;
}

.no_result {
  margin: 10px 0;
  color: var(--color_grey);
  font-size: 0.875rem;
}

.matched-fields {
  margin-top: 8px;
  padding-left: 2em;
}

.field-item {
  margin-bottom: 4px;
  font-size: 0.875rem;
}

.field-name {
  color: #666;
  font-weight: 500;
}

.field-value {
  color: #333;
}
.field-value>>>.highlight {
  background-color: #fcf29b;
  color: #333;
  padding: 1px 2px;
  border-radius: 2px;
  font-weight: bold;
}
</style>
