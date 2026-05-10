<template>
	<div class="page_root" id="root_index">
		<div class="warp">
			<div class="container-fluid">
				<el-row>
<!--					<el-col :span="4">-->
<!--						<div_label bg_color="bg_red" icon="el-icon-message" :url="url_message_count" unit="条"-->
<!--								  title="留言信息"></div_label>-->
<!--					</el-col>-->
					<!--<el-col :span="4">
						<div_label bg_color="bg_purple" icon="el-icon-user-solid" :url="url_user_count" unit="人"
								  title="用户数量"></div_label>
					</el-col>-->
<!--					<el-col :span="4">-->
<!--						<div_label bg_color="bg_green" icon="el-icon-view" :url="url_article_hits" unit="次"-->
<!--								  title="文章浏览量"></div_label>-->
<!--					</el-col>-->
				</el-row>

				<el-row>
					<el-col :class="'home_user'" :span="8">
						<div class="card info">
							<div class="UserInfo">
								<el-row class="UserInfo-row" style="padding: 0 10px;">
								<el-col :span="8"
									><img :src="$fullUrl(user.avatar)" alt=""
								/></el-col>
								<el-col :span="12">
									<p>用户昵称：{{ user.nickname || user.username }}</p>
									<p>用户身份：{{ user_group }}</p>
								</el-col>
								</el-row>
								<div class="UserInfo-btn" style="padding: 0 10px;">
								<el-button @click="$router.push('/user/info')"
									>修改资料</el-button
								>
								<el-button @click="$router.push('/user/password')"
									>修改密码</el-button
								>
								<el-button @click="sign_out_fun">退出</el-button>
								</div>
								<p class="logotime">
								登录时间：{{
									$toTime(user.login_time, "yyyy-MM-dd hh:mm:ss")
								}}
								</p>
							</div>
						</div>
          			</el-col>
					<el-col :class="'home_overview'" v-if="user_group == '管理员'" :span="8">
						<div class="statistics card">
							<el-row>
								<el-col :span="4" v-for="(item, index) in dataScreen" :key="index">
									<div class="sumList">
										<p>{{ item.value }}</p>
										<p>{{ item.label }}</p>
										<p><i class="el-icon-position"></i></p>
									</div>
								</el-col>
							</el-row>
						</div>
					</el-col>
        		</el-row>
        		<el-row>
					<quickMenu />
        		</el-row>
        <el-row>
																																	<el-col :span="24">
						<div class="screen-container">
							<iframe ref="dynamicIframe" v-if="iframeSrc" :src="iframeSrc" frameborder="0" :style="{ width: '100%', border: 'none', height: 'auto' }" @load="adjustIframeHeight"></iframe>
						</div>
					</el-col>
                    				</el-row>

			</div>
		</div>
	</div>
</template>
<script>
	import mixin from "@/mixins/page.js";
	import newLineChart2 from "@/components/charts/new_line_chart2";
	import quickMenu from "@/components/diy/quick_menu.vue";
	import doughnutChart from "@/components/charts/doughnut_chart";
	import div_label from "@/components/div_label.vue";
	export default {
		mixins: [mixin],
		name: "Home",
		components: {
			newLineChart2,
			quickMenu,
			doughnutChart,
			div_label
		},
		data() {
			return {
				activeName: "third",
				iframeSrc: '',
				url_user_count: "~/api/user/count?",
				url_article_hits: "~/api/article/sum?field=hits",
				dataScreen: null,
				sumList: [
									{
						label: "访问总数",
						value: "111",
						icon: "Position",
						field: "hits",
					},
					{
						label: "轮播图数",
						value: "111",
						icon: "Position",
						field: "slides",
					},
										{
						label: "收藏数",
						value: "111",
						icon: "Position",
						field: "collect",
					},
															{
						label: "评论数",
						value: "111",
						icon: "Position",
						field: "comment",
					},
															{
						label: "点赞数",
						value: "111",
						icon: "Position",
						field: "praise",
					},
															{
						label: "公告数",
						value: "111",
						icon: "Position",
						field: "notice",
					},
													],
																												month_list: [
					"一月",
					"二月",
					"三月",
					"四月",
					"五月",
					"六月",
					"七月",
					"八月",
					"九月",
					"十月",
					"十一月",
					"十二月",
				],
				now_month: new Date().getMonth() + 1,
				monthDateList: [],
		  				  				  				  				  				  				  				  				  				  							};
		},
		created() {
			this.getMonthDateList();
			this.get_list_count();
			this.initScreenIframe()
												},
		methods: {
			initScreenIframe() {
				let href = window.location.href;
				if (href.indexOf('/admin/dist/index.html') !== -1) {
					href = href.split('/admin/dist/index.html')[0]
					href = href + '/admin/dist/screen/main.html'
				} else {
					href = window.location.origin + '/screen/main.html'
				}
				this.iframeSrc = href + '?user_id=' + this.$store.state.user.user_id + "&user_group=" + this.$store.state.user.user_group
			},
			adjustIframeHeight() {
				const iframe = this.$refs.dynamicIframe;
				try {
					const contentHeight = iframe.contentDocument.body.scrollHeight;
					iframe.style.height = contentHeight + 'px';
					// 监听内部 DOM 变化（动态内容）
					const observer = new MutationObserver(() => {
						const newHeight = iframe.contentDocument.body.scrollHeight;
						iframe.style.height = newHeight + 'px';
					});

					observer.observe(iframe.contentDocument.body, {
						childList: true, // 监听子元素变化
						subtree: true, // 监听所有后代元素
						attributes: true, // 监听属性变化
					});

					// 在组件销毁时停止监听（避免内存泄漏）
					this.$once('hook:beforeDestroy', () => {
						observer.disconnect();
					});
				} catch (e) {
					console.error("无法访问DOM，可能是跨域限制", e);
				}
			},
			async get_nickname(list,flag){
				if (flag) {
					for (let i=0;i<list.length;i++){
						await this.$get(
								"~/api/user/get_obj?user_id="+list[i],
								null,
								(json) => {
									if (json.result) {
										list[i] = json.result.obj.nickname;
									}
								});
					}
				}else {
					for (let i=0;i<list.length;i++){
						await this.$get(
								"~/api/user/get_obj?user_id="+list[i].name,
								null,
								(json) => {
									if (json.result) {
										list[i].name = json.result.obj.nickname;
									}
								});
					}
				}
			},
			// 数据预览模块
			get_list_count() {
				this.dataScreen = [...this.sumList, ...this.auth()];
				for (let i = 0; i < this.dataScreen.length; i++) {
					let url;
					let obj = this.dataScreen[i];
					if (
						obj.field != "normal_user" &&
						obj.field !== "freeze_user" &&
						obj.field !== "admin_user"
					) {
						url = `~/api/${obj.field}/count`;
						this.$get(url).then((json) => {
							if (json.result !== null) {
								obj.value = json.result;
							}
						});
					} else {
						// 正常账户，冻结账户数据获取
						let data = {};
						url = `~/api/user/count`;
						if (obj.field === "normal_user") {
							data = {
								state: 1,
							};
						} else if (obj.field === "freeze_user") {
							data = {
								state: 2,
							};
						} else {
							data = {
								user_group: "管理员",
							};
						}
						this.$get(url, data).then((json) => {
							if (json.result !== null) {
								obj.value = json.result;
							}
						});
					}
				}
			},
			sign_out_fun() {
				this.$get("~/api/user/quit", {}, (res) => {
					this.$store.commit("quit");
					this.$router.push("/login");
				});
			},
			auth() {
				// 从localStorage获取并解析权限数据
				let tables = this.$store.state.web.auth;
				let lt = [];
				let site_list = [];
				let IconArr = [
					"Edit",
					"Document",
					"Menu",
					"Location",
					"Setting",
					"Search",
				];
																																																		site_list.push("registration_information")
																			site_list.push("travel_confirmation")
																			site_list.push("refund_request")
																																								
				// 初始化表格列表并添加额外项
				let list = [
											"article",
					"article_type",
					"comment",
														"notice",
																];
															list.push("regular_user");
																list.push("host_user");
																																																																			// 处理表格权限数据
				for (let i = 0; i < tables.length; i++) {
					let o = tables[i];
					if (o.path && o.path.indexOf("/table") !== -1) {
						// 添加path存在性检查
						if (list.indexOf(o.table_name) === -1) {
							o.has_add = site_list.indexOf(o.table_name) === -1;
							o.Icon = IconArr[parseInt(Math.random() * IconArr.length)];
							lt.push({
								label: o.mod_name,
								value: "111",
								icon: o.Icon,
								field: o.table_name,
							});
						}
					}
				}
				return lt; // 返回处理后的权限列表
			},
			// 获取当年1-6月最大，最小日期
			getMonthDateList() {
				// 将Vue3的month_list.value替换为Vue2的this.month_list
				let monthList =
					this.month_list.slice(this.now_month - 6, this.now_month).length >= 6
						? this.month_list.slice(this.now_month - 6, this.now_month)
						: this.month_list
								.slice(
									this.month_list.length -
										(6 - this.month_list.slice(0, this.now_month).length),
									this.month_list.length
								)
								.concat(this.month_list.slice(0, this.now_month));

				// 将Vue3的monthDateList.value替换为Vue2的this.monthDateList
				this.monthDateList = [];

				if (this.now_month >= 5) {
					let index = 0;
					const currentYear = new Date().getFullYear();
					for (let i = this.now_month - 5; i <= this.now_month; i++) {
						let maxDay = new Date(currentYear, i, 0).getDate();
						this.monthDateList.push({
							name: index,
							month: monthList[index],
							create_time_min:
								currentYear +
								"-" +
								i.toString().padStart(2, "0") +
								"-01 00:00:00",
							create_time_max:
								currentYear +
								"-" +
								i.toString().padStart(2, "0") +
								"-" +
								maxDay +
								" 23:59:59",
						});
						index++;
					}
				} else {
					const currentYear = new Date().getFullYear();
					const lastYear = currentYear - 1;
					let index = 0;
					// 循环去年
					for (let i = 12 - (6 - (this.now_month + 1)); i <= 12; i++) {
						let maxDay = new Date(lastYear, i, 0).getDate();
						this.monthDateList.push({
							name: index,
							month: monthList[index],
							create_time_min:
								lastYear + "-" + i.toString().padStart(2, "0") + "-01 00:00:00",
							create_time_max:
								lastYear +
								"-" +
								i.toString().padStart(2, "0") +
								"-" +
								maxDay +
								" 23:59:59",
						});
						index++;
					}
					// 循环今年
					for (let i = 1; i <= this.now_month; i++) {
						let maxDay = new Date(currentYear, i, 0).getDate();
						this.monthDateList.push({
							name: index,
							month: monthList[index],
							create_time_min:
								currentYear +
								"-" +
								i.toString().padStart(2, "0") +
								"-01 00:00:00",
							create_time_max:
								currentYear +
								"-" +
								i.toString().padStart(2, "0") +
								"-" +
								maxDay +
								" 23:59:59",
						});
						index++;
					}
				}
			},
															  		  		  		  		  		  		  		  		  		  				},
		computed:{
			recognitionHeight(){
				return "830px"
			},
			recognitionUrl(){
				return "https://www.faceplusplus.com.cn/${model.filter.recognitionType}/"
			}
		}
	};
</script>

<style scoped="scoped">
	.chart {
		display: block;
		width: 100%;
		height: 400px;
		padding: 1rem;
		position: relative;
	}

	.el-col {
		padding: 0.5rem;
	}

	.card {
		overflow: hidden;
	}

	.iframe_box ,.iframe_box_change{
		width: 100%;
		height: 1180px;
		position: relative;
		margin-top: 25px;
	}
	.iframe_box_change{
		height: 580px;
		padding-top: 50px;
	}
	.iframe_box	.iframe_box_content, .iframe_box_change .iframe_box_content{
		width: 100%;
		height: 100%;
	}
	.iframe_box_top{
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100px;
		font-size: 25px;
		line-height: 100px;
		background: #fff;
		z-index: 999;
		padding-left: 50px;
	}
	#iframe_box_face div::before {
		content: '';
		width: 100px;
		position: absolute;
		top: 154px;
		right: 129px;
		z-index: 999;
		height: 20px;
		background-color: #FFFFFF;
	}

	#iframe_box_face>h1 {
		margin-top: 100px;
		margin-bottom: 20px;
	}
	.UserInfo p {
		line-height: 30px;
	}

	.UserInfo img {
		width: 100px;
		height: 100px;
	}

	.UserInfo .logotime {
		text-align: center;
		font-size: 14px;
		line-height: 30px;
		border-top: 1px #d9d9d9 solid;
		margin: 10px 0;
	}

	.statistics {
		width: 100%;
		height: 240px;
		overflow-y: auto;
		background-color: #fff;
	}

	.statistics .sumList {
		text-align: center;
		font-size: 12px;
		color: gray;
		border-radius: 8px;
		padding: 5px;
		border: 1px solid gainsboro;
	}
	.home_user .card {
		min-height: 240px;
	}
	.progress-item {
    width: 100%;
    display: flex;
    flex-direction: row;
    align-items: center;
    margin-bottom: 20px;
  }

  .progress-item .progress-item-content {
    width: 65%;
    display: flex;
    flex-direction: column;
    height: 80px;
    margin-left: 10px;
    font-size: 14px;
  }

  .progress-item .progress-item-content > p {
    margin-bottom: 5px;
  }

  .progress-item .progress-item-content .progress-item-content-progress {
    display: flex;
    flex-direction: row;
    align-items: center;
    margin-top: auto;
  }
</style>
