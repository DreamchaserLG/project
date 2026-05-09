<template>
  <el-menu ref="menu" class="side el-menu-vertical-demo" default-active="$route.path" @open="handleOpen" @close="handleClose"
           background-color="#545c64" text-color="#fff" active-text-color="#38f" :collapse="isCollapse" :router="true">

    <span class="hide-avatar" style="display: none;">
      <img :src="$fullUrl($store.state.user.avatar)" alt="avatar">
    </span>
    <span class="hide-username" style="display:none;">
       {{ $store.state.user.nickname || $store.state.user.username }}
    </span>

    <el-menu-item index="/" @click="handleButtonClick('后台首页')">
      <i class="el-icon-s-home"></i>
      <span slot="title">后台首页</span>
    </el-menu-item>

     <el-submenu index="user"
                v-show="user_group == '管理员' || $check_group(['/user/table','/user_group/table'
                                                                        ,'/regular_user/table'
                                                                                                ,'/host_user/table'
                                                                                                                                                                                                                                                                                                                                                                                                                                ])">
      <template slot="title"><i class="el-icon-s-custom"></i><span ref="customTemplate8">系统用户</span></template>
      <el-menu-item index="/user/table" v-show="user_group == '管理员'" @click="handleButtonClick(8)"><span>管理员</span></el-menu-item>
                                  <el-menu-item index="/regular_user/table" v-show="$check_action('/regular_user/table')" @click="handleButtonClick(8)">
                <span>普通用户</span></el-menu-item>
                                              <el-menu-item index="/host_user/table" v-show="$check_action('/host_user/table')" @click="handleButtonClick(8)">
                <span>主办用户</span></el-menu-item>
                                                                                                                                                                                          <!-- <el-menu-item index="/user_group/table"><span>用户组</span></el-menu-item> -->
    </el-submenu>

	<el-submenu class="Cust" :index="i.id" v-for="i in auth" :key="i.id" v-show="$check_action(i.path)">
	  <template slot="title">
	    <i class="el-icon-news"></i>
	    <span v-if="!i.children.length">{{ i.mod_name + "管理" }}</span>
	    <span v-else>{{ i.mod_name }}</span>
	  </template>
	  <div v-if="!i.children.length">
	    <el-menu-item menu-trigger :index="i.path" :class="{ active: $route.path === i.path }" @click="handleButtonClick(`${i.mod_name}管理`)">
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
	        <el-menu-item menu-trigger :index="item.path" :class="{ active: $route.path === item.path }" @click="handleButtonClick(`${item.mod_name}管理`)">
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

      

    
              <el-submenu index="notic"
                    v-show="$check_group(['/notice/table'])">
          <template slot="title"><i class="el-icon-warning-outline"></i><span ref="customTemplate2">平台公告管理</span>
          </template>
          <el-menu-item v-show="$check_action('/notice/table')" index="/notice/table" @click="handleButtonClick(2)">
            <span>平台公告</span>
          </el-menu-item>
        </el-submenu>
      

                            <el-submenu index="news"
                        v-show="$check_group(['/article/table','/article_type/table','/exam/table','/evaluation/table'])">
              <template slot="title"><i class="el-icon-s-opportunity"></i><span ref="customTemplate3">资源管理</span></template>

                                  <el-menu-item v-show="$check_action('/article/table')" index="/article/table" @click="handleButtonClick(3)">
                    <!-- <span>文章</span> -->
                    <span>{{$page_title("/article/table") || "文章"}}</span>
                  </el-menu-item>
                  <el-menu-item v-show="$check_action('/article_type/table')"
                                index="/article_type/table" @click="handleButtonClick(3)">
                    <!-- <span>文章类型</span> -->
                    <span>{{$page_title("/article_type/table") || "文章分类"}}</span>
                  </el-menu-item>
                                				            </el-submenu>
                            

      


              <el-submenu index="auth"
                    v-show="user_group == '管理员'">
          <template slot="title"><i class="el-icon-s-custom"></i><span ref="customTemplate9">权限管理</span></template>
          <el-menu-item index="/auth/table" v-show="user_group == '管理员'" @click="handleButtonClick(9)"><span>权限列表</span></el-menu-item>
        </el-submenu>
      
	  
    

  </el-menu>
</template>

<script>
  export default {
    props: {
      isCollapse: {
        trye: Boolean,
        default: false
      }
    },
    data: function () {
      return {
        user_group: this.$store.state.user.user_group
      }
    },
    methods: {
      handleOpen(key, keyPath) {
        // console.log(key, keyPath);
      },

      handleClose(key, keyPath) {
        // console.log(key, keyPath);
      },
       handleButtonClick(buttonId) {
      let lis_title;
      const templateRefs = [
        null, // 索引 0 不使用
        this.$refs.customTemplate1,
        this.$refs.customTemplate2,
        this.$refs.customTemplate3,
        this.$refs.customTemplate4,
        this.$refs.customTemplate5,
        this.$refs.customTemplate6,
        this.$refs.customTemplate7,
        this.$refs.customTemplate8,
        this.$refs.customTemplate9,
        this.$refs.customTemplate10,
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
        console.log(this.text);
        sessionStorage.setItem('title-text', this.text);
      }
      // sessionStorage.setItem('title-text', buttonId)
    }

    },
    computed: {
      auth() {
        var tables = this.$store.state.web.auth;
        var lt = [];
        let site_list = []
		    let map_list = []
        let forecast_list = []
        let seat_list = []
                                                                                                                                                                                                                              site_list.push("registration_information")
                                                                      site_list.push("travel_confirmation")
                                                                      site_list.push("refund_request")
                                                                                                                                                                                                        let list = ["exam", 'evaluation', "article", "article_type", "comment", "notice"];
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
          const id = `${o.parent}-${o.mod_name}-${o.auth_id}-${i}`
          if (!o.parent) {
            lt2.push({ ...o, id, children: [] });
          } else {
            const parentIndex = lt2.findIndex((el) => el.mod_name === o.parent);
            if (parentIndex !== -1) {
              lt2[parentIndex].children.push({...o, id});
            } else {
              lt2.push({
                ...o,
                // path: '/' + o.parent + o.mod_name + o.auth_id,
                mod_name: o.parent,
                children: [{...o, id}],
                id
              });
            }
          }
        }
        console.log('lt======', lt2);

        return lt2.sort((a, b) => a.parent_sort - b.parent_sort);
      }
    },
	watch: {
	    $route: {
	      handler(to) {
	        // 路由变化时更新当前激活菜单
	        this.$nextTick(() => {
	          if(this.$refs.menu) {
	            this.$refs.menu.activeIndex = to.path;
	          }
	        });
	      },
	      immediate: true
	    }
	}
  }
</script>


<style scoped="scoped">
  .el-menu-vertical-demo:not(.el-menu--collapse) {
    width: 16rem;
  }

  .side {
    float: left;
    background: #545c64;
    color: #fff;
    overflow-y: scroll;
    height: 100vh;
  }
.active {
  color: #409EFF !important;
}

.sactive {
  color: #fdfcfb !important;
}
  .side::-webkit-scrollbar {
    display: none;
  }
</style>
