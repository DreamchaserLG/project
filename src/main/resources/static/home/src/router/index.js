import Vue from 'vue';
import VueRouter from 'vue-router';
import index from '../views/index.vue'
import login from '../views/account/login.vue';
import store from '../store';
Vue.use(VueRouter)

const routes = [
	// 主页
	{
		path: '/',
		name: 'index',
		component: index
	},
	// 登录
	{
		path: '/account/login',
		name: 'login',
		component: login
	},
	// 忘记密码
	{
		path: '/account/forgot',
		name: 'forgot',
		component: () => import('../views/account/forgot.vue')
	},
	// 注册账号
	{
		path: '/account/register',
		name: 'register',
		component: () => import('../views/account/register.vue')
	},
	{
    path: "/filePreview",
    name: "filePreview",
    component: () => import("../views/filePreview/filePreview.vue"),
    meta: {
			title: "文件预览",
    },
  },
											// 二维码生成结束
		// 媒体图片
	{
		path: '/media/image',
		name: 'media_image',
		component: () => import('../views/media/image.vue')
	},

	// 音乐
	// {
	// 	path: '/media/music',
	// 	name: 'media_music',
	// 	component: () => import('../views/media/music.vue')
	// },
	// 媒体视频
	{
		path: '/media/video',
		name: 'media_video',
		component: () => import('../views/media/video.vue')
	},
	// 媒体视频
	{
		path: '/user_center/index',
		name: 'user_center_index',
		component: () => import('../views/user_center/index.vue')
	},
	// 文章路由
	{
		path: '/article/list',
		name: 'article_list',
		component: () => import('../views/article/list.vue')
	},
	{
		path: '/article/details',
		name: 'article_details',
		component: () => import('../views/article/details.vue')
	},
	// 浏览网站
	// 收藏路由
	{
		path: '/user/collect',
		name: 'collect_list',
		component: () => import('../views/user/collect.vue')
	},
	// 点赞路由
	{
		path: '/user/praise',
		name: 'praise_list',
		component: () => import('../views/user/praise.vue')
	},

	{
		path: '/comment/table',
		name: 'comment_table',
		component: () => import('../views/comment/table.vue')
	},
	{
		path: '/comment/view',
		name: 'comment_view',
		component: () => import('../views/comment/view.vue')
	},

	


	// 公告路由
	{
		path: '/notice/list',
		name: 'notice_list',
		component: () => import('../views/notice/list.vue')
	},
	{
		path: '/notice/details',
		name: 'notice_details',
		component: () => import('../views/notice/details.vue')
	},
	// 普通用户表格路由
	{
		path: '/regular_user/table',
		name: '/regular_user_table',
		component: () => import('../views/regular_user/table.vue')
	},
	// 普通用户详情路由
	{
		path: '/regular_user/view',
		name: '/regular_user_view',
		component: () => import('../views/regular_user/view.vue')
	},
	
	
	
	
	
	// 主办用户表格路由
	{
		path: '/host_user/table',
		name: '/host_user_table',
		component: () => import('../views/host_user/table.vue')
	},
	// 主办用户详情路由
	{
		path: '/host_user/view',
		name: '/host_user_view',
		component: () => import('../views/host_user/view.vue')
	},
	
	
	
	
	
	// 会展信息表格路由
	{
		path: '/exhibition_information/table',
		name: '/exhibition_information_table',
		component: () => import('../views/exhibition_information/table.vue')
	},
	// 会展信息详情路由
	{
		path: '/exhibition_information/view',
		name: '/exhibition_information_view',
		component: () => import('../views/exhibition_information/view.vue')
	},
	
		// 会展信息列表路由
	{
		path: '/exhibition_information/list',
		name: '/exhibition_information_list',
		component: () => import('../views/exhibition_information/list.vue')
	},
	
		// 会展信息详情路由
	{
		path: '/exhibition_information/details',
		name: '/exhibition_information_details',
		component: () => import('../views/exhibition_information/details.vue')
	},
	
	
	
	// 展位信息表格路由
	{
		path: '/booth_information/table',
		name: '/booth_information_table',
		component: () => import('../views/booth_information/table.vue')
	},
	// 展位信息详情路由
	{
		path: '/booth_information/view',
		name: '/booth_information_view',
		component: () => import('../views/booth_information/view.vue')
	},
	
		// 展位信息列表路由
	{
		path: '/booth_information/list',
		name: '/booth_information_list',
		component: () => import('../views/booth_information/list.vue')
	},
	
		// 展位信息详情路由
	{
		path: '/booth_information/details',
		name: '/booth_information_details',
		component: () => import('../views/booth_information/details.vue')
	},
	
	
	
	// 报名信息表格路由
	{
		path: '/registration_information/table',
		name: '/registration_information_table',
		component: () => import('../views/registration_information/table.vue')
	},
	// 报名信息详情路由
	{
		path: '/registration_information/view',
		name: '/registration_information_view',
		component: () => import('../views/registration_information/view.vue')
	},
		// 报名信息添加路由
	{
		path: '/registration_information/edit',
		name: '/registration_information_edit',
		component: () => import('../views/registration_information/edit.vue')
	},
	
	
	
	
	
	// 行程确认表格路由
	{
		path: '/travel_confirmation/table',
		name: '/travel_confirmation_table',
		component: () => import('../views/travel_confirmation/table.vue')
	},
	// 行程确认详情路由
	{
		path: '/travel_confirmation/view',
		name: '/travel_confirmation_view',
		component: () => import('../views/travel_confirmation/view.vue')
	},
	
	
	
	
	
	// 退款申请表格路由
	{
		path: '/refund_request/table',
		name: '/refund_request_table',
		component: () => import('../views/refund_request/table.vue')
	},
	// 退款申请详情路由
	{
		path: '/refund_request/view',
		name: '/refund_request_view',
		component: () => import('../views/refund_request/view.vue')
	},
	
	
	
	
	
	// 消息通知表格路由
	{
		path: '/message_notification/table',
		name: '/message_notification_table',
		component: () => import('../views/message_notification/table.vue')
	},
	// 消息通知详情路由
	{
		path: '/message_notification/view',
		name: '/message_notification_view',
		component: () => import('../views/message_notification/view.vue')
	},
	
	
	
	
	
	// 会展公告表格路由
	{
		path: '/exhibition_announcement/table',
		name: '/exhibition_announcement_table',
		component: () => import('../views/exhibition_announcement/table.vue')
	},
	// 会展公告详情路由
	{
		path: '/exhibition_announcement/view',
		name: '/exhibition_announcement_view',
		component: () => import('../views/exhibition_announcement/view.vue')
	},
	
		// 会展公告列表路由
	{
		path: '/exhibition_announcement/list',
		name: '/exhibition_announcement_list',
		component: () => import('../views/exhibition_announcement/list.vue')
	},
	
		// 会展公告详情路由
	{
		path: '/exhibition_announcement/details',
		name: '/exhibition_announcement_details',
		component: () => import('../views/exhibition_announcement/details.vue')
	},
	
	
	
	// 数据统计表格路由
	{
		path: '/data_statistics/table',
		name: '/data_statistics_table',
		component: () => import('../views/data_statistics/table.vue')
	},
	// 数据统计详情路由
	{
		path: '/data_statistics/view',
		name: '/data_statistics_view',
		component: () => import('../views/data_statistics/view.vue')
	},
	
	
	
	
	

	// 用户路由
	{
		path: '/user/index',
		name: 'user_index',
		component: () => import('../views/user/index.vue')
	},
	// 基本信息
	{
		path: '/user/info',
		name: 'user_info',
		component: () => import('../views/user/info.vue')
	},
	// 找回密码
	{
		path: '/user/password',
		name: 'user_password',
		component: () => import('../views/user/password.vue')
	},

	// 搜索
	{
		path: '/search',
		name: 'search',
		component: () => import('../views/search/index.vue')
	},
	// 局部搜索
	{
		path: '/search/details',
		name: 'search_details',
		component: () => import('../views/search/details.vue')
	}
]

const router = new VueRouter({
	mode: 'hash',
	base: process.env.BASE_URL,
	routes,
	scrollBehavior(to, from, savedPosition) {
		if (savedPosition) {
			return savedPosition;
		}
		return { x: 0, y: 0 };
	}
})

const authFreePaths = new Set([
	'/account/login',
	'/account/register',
	'/account/forgot',
]);

router.afterEach(() => {
	let title = "会展管理系统-home";
	document.title = title;
	document.logo = "会展管理系统"
})


router.beforeEach((to, from, next) => {
  window.scrollTo(0, 0);
  const storeToken = store?.state?.user?.token;
  const cacheToken = typeof $ !== "undefined" && $.db ? $.db.get("token") : "";
  const token = storeToken || cacheToken;
  const isAuthFree = authFreePaths.has(to.path);

  if (!token && !isAuthFree) {
    next({
      path: '/account/login',
      query: {
        redirect: to.fullPath,
      },
    });
    return;
  }

  if (token && isAuthFree) {
    const redirect = typeof to.query.redirect === "string" && to.query.redirect
      ? to.query.redirect
      : '/';
    next(redirect);
    return;
  }

  next();
});

export default router
