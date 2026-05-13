<template>
  <el-menu
    ref="menu"
    class="side"
    default-active="$route.path"
    @open="handleOpen"
    @close="handleClose"
    :background-color="'transparent'"
    text-color="rgba(255,255,255,0.78)"
    active-text-color="#4de8e0"
    :collapse="isCollapse"
    :router="true"
  >
    <div class="side_logo" v-if="!isCollapse">
      <i class="el-icon-s-platform"></i>
      <span>会展管理系统</span>
    </div>
    <div class="side_logo side_logo_mini" v-else>
      <i class="el-icon-s-platform"></i>
    </div>

    <el-menu-item index="/" @click="handleButtonClick('后台首页')">
      <i class="el-icon-s-home"></i>
      <span slot="title">后台首页</span>
    </el-menu-item>

    <el-submenu index="user"
      v-show="user_group == '管理员' || $check_group(['/user/table','/user_group/table','/regular_user/table','/host_user/table'])">
      <template slot="title"><i class="el-icon-s-custom"></i><span ref="customTemplate8">系统用户</span></template>
      <el-menu-item index="/user/table" v-show="user_group == '管理员'" @click="handleButtonClick(8)"><span>管理员</span></el-menu-item>
      <el-menu-item index="/regular_user/table" v-show="$check_action('/regular_user/table')" @click="handleButtonClick(8)"><span>普通用户</span></el-menu-item>
      <el-menu-item index="/host_user/table" v-show="$check_action('/host_user/table')" @click="handleButtonClick(8)"><span>主办用户</span></el-menu-item>
    </el-submenu>

    <el-submenu class="Cust" :index="i.id" v-for="i in auth" :key="i.id" v-show="$check_action(i.path)">
      <template slot="title">
        <i class="el-icon-news"></i>
        <span v-if="!i.children.length">{{ i.mod_name + "管理" }}</span>
        <span v-else>{{ i.mod_name }}</span>
      </template>
      <div v-if="!i.children.length">
        <el-menu-item :index="i.path" :class="{ active: $route.path === i.path }" @click="handleButtonClick(`${i.mod_name}管理`)">
          <span>{{ i.page_title + "列表" }}</span>
        </el-menu-item>
        <el-menu-item v-if="i.has_add && $check_action(i.path.replace(/(.*)table/, '$1view'), 'add')" :index="i.path.replace(/(.*)table/, '$1view')" :class="{ sactive: $route.path === i.path }" @click="handleButtonClick(` ${i.mod_name}管理`)">
          <span>{{ i.page_title + "添加" }}</span>
        </el-menu-item>
      </div>
      <div v-else>
        <el-submenu class="Cust" :index="'child'+ item.id" v-for="(item) in i.children" :key="item.id" v-show="$check_action(item.path)">
          <template slot="title">
            <i class="el-icon-news"></i>
            <span>{{ item.mod_name + "管理" }}</span>
          </template>
          <div>
            <el-menu-item :index="item.path" :class="{ active: $route.path === item.path }" @click="handleButtonClick(`${item.mod_name}管理`)">
              <span>{{ item.page_title + "列表" }}</span>
            </el-menu-item>
            <el-menu-item v-if="item.has_add && $check_action(item.path.replace(/(.*)table/, '$1view'), 'add')" :index="item.path.replace(/(.*)table/, '$1view')" :class="{ sactive: $route.path === item.path }" @click="handleButtonClick(` ${item.mod_name}管理`)">
              <span>{{ item.page_title + "添加" }}</span>
            </el-menu-item>
          </div>
        </el-submenu>
      </div>
    </el-submenu>

    <el-submenu index="web"
      v-show="user_group == '管理员' || $check_group(['/nav/table','/link/table','/slides/table','/ad/table'])">
      <template slot="title"><i class="el-icon-picture-outline"></i><span ref="customTemplate1">系统管理</span></template>
      <el-menu-item v-show="user_group == '管理员' || $check_action('/slides/table')" index="/slides/table" @click="handleButtonClick(1)">
        <span>轮播图管理</span>
      </el-menu-item>
    </el-submenu>

    <el-submenu index="notic" v-show="$check_group(['/notice/table'])">
      <template slot="title"><i class="el-icon-warning-outline"></i><span ref="customTemplate2">平台公告管理</span></template>
      <el-menu-item v-show="$check_action('/notice/table')" index="/notice/table" @click="handleButtonClick(2)">
        <span>平台公告</span>
      </el-menu-item>
    </el-submenu>

    <el-submenu index="news"
      v-show="$check_group(['/article/table','/article_type/table','/exam/table','/evaluation/table'])">
      <template slot="title"><i class="el-icon-s-opportunity"></i><span ref="customTemplate3">资源管理</span></template>
      <el-menu-item v-show="$check_action('/article/table')" index="/article/table" @click="handleButtonClick(3)">
        <span>{{$page_title("/article/table") || "文章"}}</span>
      </el-menu-item>
      <el-menu-item v-show="$check_action('/article_type/table')" index="/article_type/table" @click="handleButtonClick(3)">
        <span>{{$page_title("/article_type/table") || "文章分类"}}</span>
      </el-menu-item>
    </el-submenu>

    <el-submenu index="auth" v-show="user_group == '管理员'">
      <template slot="title"><i class="el-icon-s-custom"></i><span ref="customTemplate9">权限管理</span></template>
      <el-menu-item index="/auth/table" v-show="user_group == '管理员'" @click="handleButtonClick(9)"><span>权限列表</span></el-menu-item>
    </el-submenu>
  </el-menu>
</template>

<script>
export default {
  props: {
    isCollapse: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      user_group: this.$store.state.user.user_group
    }
  },
  methods: {
    handleOpen(key, keyPath) {},
    handleClose(key, keyPath) {},
    handleButtonClick(buttonId) {
      let lis_title;
      const templateRefs = [
        null,
        this.$refs.customTemplate1,
        this.$refs.customTemplate2,
        this.$refs.customTemplate3,
        this.$refs.customTemplate4,
        this.$refs.customTemplate5,
        this.$refs.customTemplate6,
        this.$refs.customTemplate7,
        this.$refs.customTemplate8,
        this.$refs.customTemplate9,
        null,
        this.$refs.customTemplate11,
        this.$refs.customTemplate12,
      ];
      if (buttonId >= 1 && buttonId <= templateRefs.length) {
        lis_title = templateRefs[buttonId];
        sessionStorage.setItem('title-text', buttonId.toString());
      } else {
        sessionStorage.setItem('title-text', buttonId);
      }
      if (lis_title) {
        this.text = lis_title.innerText;
        sessionStorage.setItem('title-text', this.text);
      }
    }
  },
  computed: {
    auth() {
      var tables = this.$store.state.web.auth;
      var lt = [];
      let site_list = [];
      site_list.push("registration_information");
      site_list.push("travel_confirmation");
      site_list.push("refund_request");
      let list = ["exam", 'evaluation', "article", "article_type", "comment", "notice"];
      list.push("user_track_log");
      list.push("regular_user");
      list.push("host_user");
      for (var i = 0; i < tables.length; i++) {
        var o = tables[i];
        if (o.path.indexOf("/table") !== -1) {
          if (list.indexOf(o.table_name) === -1) {
            o.has_add = site_list.indexOf(o.table_name) === -1;
            lt.push(o);
          }
        }
      }
      let lt2 = [];
      for (var i = 0; i < lt.length; i++) {
        const o = lt[i];
        const id = `${o.parent}-${o.mod_name}-${o.auth_id}-${i}`;
        if (!o.parent) {
          lt2.push({ ...o, id, children: [] });
        } else {
          const parentIndex = lt2.findIndex((el) => el.mod_name === o.parent);
          if (parentIndex !== -1) {
            lt2[parentIndex].children.push({ ...o, id });
          } else {
            lt2.push({
              ...o,
              mod_name: o.parent,
              children: [{ ...o, id }],
              id
            });
          }
        }
      }
      return lt2.sort((a, b) => a.parent_sort - b.parent_sort);
    }
  },
  watch: {
    $route: {
      handler(to) {
        this.$nextTick(() => {
          if (this.$refs.menu) {
            this.$refs.menu.activeIndex = to.path;
          }
        });
      },
      immediate: true
    }
  }
}
</script>

<style scoped>
.side {
  position: fixed;
  left: 0;
  top: 0;
  bottom: 0;
  width: 240px;
  background: linear-gradient(180deg, #071e24 0%, #093943 40%, #0a424e 100%) !important;
  color: rgba(255, 255, 255, 0.78);
  overflow-y: auto;
  z-index: 901;
  border-right: 1px solid rgba(255, 255, 255, 0.05);
  transition: width 0.3s;
}

.side.el-menu--collapse {
  width: 64px;
}

.side_logo {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 0 20px;
  height: 60px;
  background: rgba(0, 0, 0, 0.15);
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
  margin-bottom: 4px;
}

.side_logo i {
  font-size: 24px;
  color: #4de8e0;
}

.side_logo span {
  font-size: 16px;
  font-weight: 700;
  color: #fff;
  letter-spacing: 1px;
  white-space: nowrap;
}

.side_logo_mini {
  justify-content: center;
  padding: 0;
}

.side_logo_mini i {
  font-size: 22px;
}

.side >>> .el-menu-item {
  font-size: 14px;
  height: 46px;
  line-height: 46px;
  transition: all 0.25s ease;
  margin: 2px 8px;
  border-radius: 8px;
}

.side >>> .el-menu-item:hover {
  background: rgba(77, 232, 224, 0.08) !important;
}

.side >>> .el-menu-item.is-active {
  background: rgba(77, 232, 224, 0.12) !important;
  color: #4de8e0 !important;
  font-weight: 600;
  position: relative;
}

.side >>> .el-menu-item.is-active::before {
  content: "";
  position: absolute;
  left: -8px;
  top: 10px;
  bottom: 10px;
  width: 3px;
  border-radius: 0 3px 3px 0;
  background: linear-gradient(180deg, #4de8e0, #0f5f6c);
}

.side >>> .el-submenu__title {
  font-size: 14px;
  height: 46px;
  line-height: 46px;
  margin: 2px 8px;
  border-radius: 8px;
  transition: all 0.25s ease;
}

.side >>> .el-submenu__title:hover {
  background: rgba(77, 232, 224, 0.08) !important;
}

.side >>> .el-submenu__title i {
  color: rgba(255, 255, 255, 0.55);
}

.side >>> .el-submenu .el-menu-item {
  padding-left: 52px !important;
  margin: 1px 8px;
  height: 40px;
  line-height: 40px;
  font-size: 13px;
}

.active {
  color: #4de8e0 !important;
}

.sactive {
  color: #fdfcfb !important;
}

.side::-webkit-scrollbar {
  width: 4px;
}

.side::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.12);
  border-radius: 4px;
}

.side::-webkit-scrollbar-track {
  background: transparent;
}
</style>
