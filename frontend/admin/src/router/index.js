import Vue from 'vue';
import VueRouter from 'vue-router';
import index from '../views/index.vue';
import login from '../views/login.vue';
import forgot from '../views/forgot.vue';
import register from '../views/register.vue';
Vue.use(VueRouter)

const routes = [
    // 主页
    {
        path: '/',
        name: 'index',
        component: index,
        meta: {
            index: 0,
            title: '首页'
        }
    },

    // 登录
    {
        path: '/login',
        name: 'login',
        component: login,
        meta: {
            index: 0,
            title: '登录'
        }
    },
    {
        path: "/filePreview",
        name: "filePreview",
        component: () => import("../views/filePreview/filePreview.vue"),
        meta: {
            title: "文件预览",
        },
    },
                                        
            // 注册
        {
            path: '/register',
            name: 'register',
            component: register,
            meta: {
                index: 0,
                title: '注册'
            }
        },
    
	    
    // 忘记密码
    {
        path: '/forgot',
        name: "forgot",
        component: forgot,
        meta: {
            index: 0,
            title: '忘记密码'
        }
    },

    // 修改密码
    {
        path: '/user/password',
        name: "password",
        component: () => import("../views/user/password.vue"),
        meta: {
            index: 0,
            title: '修改密码'
        }
    },

            // 权限路由
        {
            path: '/auth/table',
            name: 'auth_table',
            component: () => import('../views/auth/table.vue'),
            meta: {
                index: 0,
                title: '权限列表'
            }
        },
        {
            path: '/auth/view',
            name: 'auth_view',
            component: () => import('../views/auth/view.vue'),
            meta: {
                index: 0,
                title: '权限详情'
            }
        },
    
    
                // 轮播图路由
        {
            path: '/slides/table',
            name: 'slides_table',
            component: () => import('../views/slides/table.vue'),
            meta: {
                index: 0,
                title: '轮播图列表'
            }
        },
        {
            path: '/slides/view',
            name: 'slides_view',
            component: () => import('../views/slides/view.vue'),
            meta: {
                index: 0,
                title: '轮播图详情'
            }
        },
                    // 文章路由
            {
                path: '/article/table',
                name: 'article_table',
                component: () => import('../views/article/table.vue'),
                meta: {
                    index: 0,
                    title: '会展资讯列表'
                }
            },
            {
                path: '/article/view',
                name: 'article_view',
                component: () => import('../views/article/view.vue'),
                meta: {
                    index: 0,
                    title: '会展资讯详情'
                }
            },

            // 文章分类路由
            {
                path: '/article_type/table',
                name: 'article_type_table',
                component: () => import('../views/article_type/table.vue'),
                meta: {
                    index: 0,
                    title: '会展资讯分类列表'
                }
            },
            {
                path: '/article_type/view',
                name: 'article_type_view',
                component: () => import('../views/article_type/view.vue'),
                meta: {
                    index: 0,
                    title: '会展资讯分类详情'
                }
            },
                            
    
    
            // 公告路由
        {
            path: '/notice/table',
            name: 'notice_table',
            component: () => import('../views/notice/table.vue'),
            meta: {
                index: 0,
                title: '平台公告列表'
            }
        },
        {
            path: '/notice/view',
            name: 'notice_view',
            component: () => import('../views/notice/view.vue'),
            meta: {
                index: 0,
                title: '平台公告详情'
            }
        },
            	        
            // 评论路由
        {
            path: '/comment/table',
            name: 'comment_table',
            component: () => import('../views/comment/table.vue'),
            meta: {
                index: 0,
                title: '评论列表'
            }
        },
        {
            path: '/comment/view',
            name: 'comment_view',
            component: () => import('../views/comment/view.vue'),
            meta: {
                index: 0,
                title: '评论详情'
            }
        },
        	            // 普通用户路由
        {
            path: '/regular_user/table',
            name: 'regular_user_table',
            component: () => import('../views/regular_user/table.vue'),
            meta: {
                index: 0,
                title: '普通用户列表'
            }
        },
        {
            path: '/regular_user/view',
            name: 'regular_user_view',
            component: () => import('../views/regular_user/view.vue'),
            meta: {
                index: 0,
                title: '普通用户详情'
            }
        },
		                				            // 主办用户路由
        {
            path: '/host_user/table',
            name: 'host_user_table',
            component: () => import('../views/host_user/table.vue'),
            meta: {
                index: 0,
                title: '主办用户列表'
            }
        },
        {
            path: '/host_user/view',
            name: 'host_user_view',
            component: () => import('../views/host_user/view.vue'),
            meta: {
                index: 0,
                title: '主办用户详情'
            }
        },
		                				            // 会展信息路由
        {
            path: '/exhibition_information/table',
            name: 'exhibition_information_table',
            component: () => import('../views/exhibition_information/table.vue'),
            meta: {
                index: 0,
                title: '会展信息列表'
            }
        },
        {
            path: '/exhibition_information/view',
            name: 'exhibition_information_view',
            component: () => import('../views/exhibition_information/view.vue'),
            meta: {
                index: 0,
                title: '会展信息详情'
            }
        },
		                				            // 展位信息路由
        {
            path: '/booth_information/table',
            name: 'booth_information_table',
            component: () => import('../views/booth_information/table.vue'),
            meta: {
                index: 0,
                title: '展位信息列表'
            }
        },
        {
            path: '/booth_information/view',
            name: 'booth_information_view',
            component: () => import('../views/booth_information/view.vue'),
            meta: {
                index: 0,
                title: '展位信息详情'
            }
        },
		                				            // 报名信息路由
        {
            path: '/registration_information/table',
            name: 'registration_information_table',
            component: () => import('../views/registration_information/table.vue'),
            meta: {
                index: 0,
                title: '报名信息列表'
            }
        },
        {
            path: '/registration_information/view',
            name: 'registration_information_view',
            component: () => import('../views/registration_information/view.vue'),
            meta: {
                index: 0,
                title: '报名信息详情'
            }
        },
		                				            // 行程确认路由
        {
            path: '/travel_confirmation/table',
            name: 'travel_confirmation_table',
            component: () => import('../views/travel_confirmation/table.vue'),
            meta: {
                index: 0,
                title: '行程确认列表'
            }
        },
        {
            path: '/travel_confirmation/view',
            name: 'travel_confirmation_view',
            component: () => import('../views/travel_confirmation/view.vue'),
            meta: {
                index: 0,
                title: '行程确认详情'
            }
        },
		                				            // 退款申请路由
        {
            path: '/refund_request/table',
            name: 'refund_request_table',
            component: () => import('../views/refund_request/table.vue'),
            meta: {
                index: 0,
                title: '退款申请列表'
            }
        },
        {
            path: '/refund_request/view',
            name: 'refund_request_view',
            component: () => import('../views/refund_request/view.vue'),
            meta: {
                index: 0,
                title: '退款申请详情'
            }
        },
		                				            // 消息通知路由
        {
            path: '/message_notification/table',
            name: 'message_notification_table',
            component: () => import('../views/message_notification/table.vue'),
            meta: {
                index: 0,
                title: '消息通知列表'
            }
        },
        {
            path: '/message_notification/view',
            name: 'message_notification_view',
            component: () => import('../views/message_notification/view.vue'),
            meta: {
                index: 0,
                title: '消息通知详情'
            }
        },
		                				            // 会展公告路由
        {
            path: '/exhibition_announcement/table',
            name: 'exhibition_announcement_table',
            component: () => import('../views/exhibition_announcement/table.vue'),
            meta: {
                index: 0,
                title: '会展公告列表'
            }
        },
        {
            path: '/exhibition_announcement/view',
            name: 'exhibition_announcement_view',
            component: () => import('../views/exhibition_announcement/view.vue'),
            meta: {
                index: 0,
                title: '会展公告详情'
            }
        },
		                				            // 数据统计路由
        {
            path: '/data_statistics/table',
            name: 'data_statistics_table',
            component: () => import('../views/data_statistics/table.vue'),
            meta: {
                index: 0,
                title: '数据统计列表'
            }
        },
        {
            path: '/data_statistics/view',
            name: 'data_statistics_view',
            component: () => import('../views/data_statistics/view.vue'),
            meta: {
                index: 0,
                title: '数据统计详情'
            }
        },
		                				    	        // 用户路由
    {
        path: '/user/table',
        name: 'user_table',
        component: () => import('../views/user/table.vue'),
        meta: {
            index: 0,
            title: '用户列表'
        }
    },
    {
        path: '/user/view',
        name: 'user_view',
        component: () => import('../views/user/view.vue'),
        meta: {
            index: 0,
            title: '用户详情'
        }
    },
    {
        path: '/user/info',
        name: 'user_info',
        component: () => import('../views/user/info.vue'),
        meta: {
            index: 0,
            title: '个人信息'
        }
    },
    // 用户组路由
    {
        path: '/user_group/table',
        name: 'user_group_table',
        component: () => import('../views/user_group/table.vue'),
        meta: {
            index: 0,
            title: '用户组列表'
        }
    },
    {
        path: '/user_group/view',
        name: 'user_group_view',
        component: () => import('../views/user_group/view.vue'),
        meta: {
            index: 0,
            title: '用户组详情'
        }
    }
]

const router = new VueRouter({
    mode: 'hash',
    base: process.env.BASE_URL,
    routes
})

router.beforeEach((to, from, next) => {
    let token = to.query.token;
    if (token) {
        $.db.set("token", token, 120);
    }
    next();
})

router.afterEach((to, from, next) => {
    let title = "会展管理系统-admin";
    document.title = title;
})

// 解决重载报错
const VueRouterPush = VueRouter.prototype.push;
VueRouter.prototype.push = function push(location) {
  return VueRouterPush.call(this, location).catch((err) => err);
};

export default router
