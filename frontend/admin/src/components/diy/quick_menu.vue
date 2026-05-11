<template>
  <div class="quick_menu" v-if="auth.length > 0">
    <div
      class="menu_item"
      v-for="i in auth"
      :key="i.auth_id"
      v-show="$check_action(i.path)"
      @click="moreBtn(i.path)"
    >
      <div class="menu_icon" :class="'menu_icon_' + (i.auth_id % 6)">
        <i :class="i.Icon"></i>
      </div>
      <span class="menu_text">{{ i.mod_name + "管理" }}</span>
    </div>
  </div>
</template>

<script>
export default {
  computed: {
    auth() {
      let tables = this.$store.state.web.auth;
      let lt = [];
      let site_list = [];
      let colorArr = ["success", "primary", "info", "warning", "danger"];
      let IconArr = [
        "el-icon-edit-outline",
        "el-icon-document-copy",
        "el-icon-menu",
        "el-icon-location-outline",
        "el-icon-setting",
        "el-icon-search"
      ];
      site_list.push("registration_information");
      site_list.push("travel_confirmation");
      site_list.push("refund_request");
      let list = ["exam", "article", "article_type", "comment", "notice"];
      list.push("regular_user");
      list.push("host_user");
      for (let i = 0; i < tables.length; i++) {
        let o = tables[i];
        if (o.path && o.path.indexOf("/table") !== -1) {
          if (list.indexOf(o.table_name) === -1) {
            o.has_add = site_list.indexOf(o.table_name) === -1;
            o.Bgcolor = colorArr[parseInt(Math.random() * colorArr.length)];
            o.Icon = IconArr[i % IconArr.length];
            lt.push(o);
          }
        }
      }
      return lt;
    }
  },
  methods: {
    moreBtn(path) {
      this.$router.push(path);
    }
  }
};
</script>

<style scoped>
.quick_menu {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
  gap: 16px;
}

.menu_item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  padding: 16px 8px;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
  text-align: center;
}

.menu_item:hover {
  background: #f4f7fb;
  transform: translateY(-2px);
}

.menu_icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 48px;
  height: 48px;
  border-radius: 14px;
  font-size: 22px;
}

.menu_icon_0 {
  background: linear-gradient(135deg, #eaf7f7, #d4f0f0);
  color: #0f5f6c;
}

.menu_icon_1 {
  background: linear-gradient(135deg, #f7ead4, #f0ddb8);
  color: #c9872f;
}

.menu_icon_2 {
  background: linear-gradient(135deg, #e8f4fd, #d0e8fa);
  color: #1d7a86;
}

.menu_icon_3 {
  background: linear-gradient(135deg, #f0e8fd, #e0d0fa);
  color: #7f39e8;
}

.menu_icon_4 {
  background: linear-gradient(135deg, #e8fdf0, #d0fae0);
  color: #197555;
}

.menu_icon_5 {
  background: linear-gradient(135deg, #fde8e8, #fad0d0);
  color: #c0392b;
}

.menu_text {
  font-size: 12px;
  font-weight: 500;
  color: #3a4a52;
  line-height: 1.3;
}
</style>
