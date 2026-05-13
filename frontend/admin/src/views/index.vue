<template>
	<div class="page_dashboard">
		<div class="dashboard_welcome_card">
			<div class="welcome_content">
				<div class="welcome_text">
					<h1 class="welcome_title">欢迎回来，{{ user.nickname || user.username }}</h1>
					<p class="welcome_sub">
						<span class="welcome_badge">{{ user_group }}</span>
						<span class="welcome_time">{{ $toTime(user.login_time, "yyyy-MM-dd hh:mm:ss") }} 登录</span>
					</p>
				</div>
				<div class="welcome_actions">
					<el-button size="small" icon="el-icon-user" @click="$router.push('/user/info')">修改资料</el-button>
					<el-button size="small" icon="el-icon-key" @click="$router.push('/user/password')">修改密码</el-button>
					<el-button size="small" type="danger" icon="el-icon-switch-button" @click="sign_out_fun">退出</el-button>
				</div>
			</div>
		</div>

		<div class="dashboard_stats" v-if="dataScreen && dataScreen.length">
				<div
				v-for="(item, idx) in dataScreen"
				:key="idx"
				class="stat_card"
				@click="goStat(item)"
			>
				<div class="stat_icon" :class="'stat_icon_' + (idx % 4)">
					<i :class="statIcons[idx % statIcons.length]"></i>
				</div>
				<div class="stat_info">
					<div class="stat_number">{{ item.value }}</div>
					<div class="stat_label">{{ item.label }}</div>
				</div>
			</div>
		</div>

		<div class="dashboard_grid">
			<div class="grid_left">
				<div class="panel" v-if="user_group === '管理员'">
					<div class="panel_header">
						<span class="panel_title"><i class="el-icon-s-marketing"></i> 最近展会动态</span>
					</div>
					<div class="panel_body">
						<el-table :data="exhibitionStats" size="small" v-loading="dashboardLoading" style="width: 100%;">
							<el-table-column prop="exhibition_theme" label="展会名称" min-width="180" show-overflow-tooltip />
							<el-table-column prop="event_time" label="时间" min-width="170" show-overflow-tooltip />
							<el-table-column prop="registration_people" label="报名人数" width="90" align="right" />
							<el-table-column prop="attendee_people" label="实际参展" width="90" align="right" />
							<el-table-column label="成交额" width="110" align="right">
								<template slot-scope="{ row }">{{ formatMoney(row.revenue) }}</template>
							</el-table-column>
						</el-table>
					</div>
				</div>

				<div class="panel">
					<div class="panel_header">
						<span class="panel_title"><i class="el-icon-s-grid"></i> 快捷操作</span>
					</div>
					<div class="panel_body">
						<quickMenu />
					</div>
				</div>

				<div class="panel">
					<div class="panel_header">
						<span class="panel_title"><i class="el-icon-s-data"></i> 最近用户行为</span>
						<el-button type="text" size="small" @click="$router.push('/user_track_log/table')">查看全部 <i class="el-icon-arrow-right"></i></el-button>
					</div>
					<div class="panel_body">
						<el-table :data="recentTracks" size="small" v-loading="tracksLoading" style="width: 100%;">
							<el-table-column prop="username" label="用户" width="120">
								<template slot-scope="{ row }">
									<span class="track_user">{{ row.username }}</span>
								</template>
							</el-table-column>
							<el-table-column prop="event_name" label="事件" width="120">
								<template slot-scope="{ row }">
									<el-tag :type="eventTagType(row.event_name)" size="mini" effect="light">{{ row.event_name }}</el-tag>
								</template>
							</el-table-column>
							<el-table-column prop="page" label="页面" min-width="180" show-overflow-tooltip />
							<el-table-column prop="create_time" label="时间" width="160">
								<template slot-scope="{ row }">
									<span class="track_time">{{ row.create_time }}</span>
								</template>
							</el-table-column>
						</el-table>
					</div>
				</div>
			</div>

			<div class="grid_right">
				<div class="panel">
					<div class="panel_header">
						<span class="panel_title"><i class="el-icon-user"></i> 用户信息</span>
					</div>
					<div class="panel_body user_card">
						<div class="user_avatar">
							<img :src="$fullUrl(user.avatar)" alt="" />
						</div>
						<div class="user_info">
							<h3 class="user_name">{{ user.nickname || user.username }}</h3>
							<p class="user_role">{{ user_group }}</p>
						</div>
						<div class="user_meta">
							<div class="meta_item">
								<span class="meta_label">用户ID</span>
								<span class="meta_value">{{ user.user_id }}</span>
							</div>
							<div class="meta_item">
								<span class="meta_label">上次登录</span>
								<span class="meta_value">{{ $toTime(user.login_time, "yyyy-MM-dd") }}</span>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
import mixin from "@/mixins/page.js";
import quickMenu from "@/components/diy/quick_menu.vue";
export default {
	mixins: [mixin],
	name: "Home",
	components: { quickMenu },
	data() {
		return {
			dataScreen: [],
			exhibitionStats: [],
			dashboardLoading: false,
			recentTracks: [],
			tracksLoading: false,
			statIcons: [
				'el-icon-user',
				'el-icon-document',
				'el-icon-picture-outline',
				'el-icon-bell'
			],
		};
	},
	created() {
		if (this.user_group === "管理员") {
			this.loadAdminDashboard();
		} else {
			this.get_list_count();
		}
		this.loadRecentTracks();
	},
	methods: {
		async loadAdminDashboard() {
			this.dashboardLoading = true;
			try {
				const summary = await this.$get("~/api/admin_dashboard/summary");
				if (summary && summary.result) {
					const s = summary.result;
					this.dataScreen = [
						{ label: "总展会数", value: s.total_exhibitions || 0, field: "exhibition_information" },
						{ label: "总报名人数", value: s.total_registration_people || 0, field: "registration_information" },
						{ label: "总成交额", value: this.formatMoney(s.total_revenue), field: "" },
						{ label: "待审核报名", value: s.pending_registration || 0, field: "registration_information", query: { examine_state: "未审核" } },
						{ label: "待审核退款", value: s.pending_refund || 0, field: "refund_request", query: { examine_state: "未审核" } },
						{ label: "待审核行程确认", value: s.pending_travel || 0, field: "travel_confirmation", query: { examine_state: "未审核" } },
					];
				}
				const stats = await this.$get("~/api/admin_dashboard/exhibition_stats");
				this.exhibitionStats = stats && stats.result && Array.isArray(stats.result.list) ? stats.result.list : [];
			} catch (e) {
				this.exhibitionStats = [];
			}
			this.dashboardLoading = false;
		},
		goStat(item) {
			if (!item || !item.field) {
				return;
			}
			this.$router.push({ path: "/" + item.field + "/table", query: item.query || {} });
		},
		formatMoney(value) {
			const num = Number(value || 0);
			return "￥" + num.toFixed(2);
		},
		async loadRecentTracks() {
			this.tracksLoading = true;
			try {
				const res = await this.$axios.get("/api/track/list");
				const rows = res && res.result && Array.isArray(res.result.list) ? res.result.list : res;
				this.recentTracks = Array.isArray(rows) ? rows.slice(0, 8) : [];
			} catch (e) {
				this.recentTracks = [];
			}
			this.tracksLoading = false;
		},
		eventTagType(event) {
			const map = {
				"页面访问": "",
				"点击": "success",
				"提交表单": "warning",
				"登录": "danger",
				"搜索": "info",
			};
			return map[event] || "";
		},
		get_list_count() {
			let list = [
				{ label: "用户数量", value: "0", field: "user" },
				{ label: "文章数量", value: "0", field: "article" },
				{ label: "轮播图数", value: "0", field: "slides" },
				{ label: "公告数量", value: "0", field: "notice" },
				{ label: "评论数量", value: "0", field: "comment" },
				{ label: "收藏数量", value: "0", field: "collect" },
			];
			let tables = this.$store.state.web.auth || [];
			let site_list = ["registration_information", "travel_confirmation", "refund_request"];
			let added = [];
			for (let i = 0; i < tables.length; i++) {
				let o = tables[i];
				if (o.path && o.path.indexOf("/table") !== -1 && site_list.indexOf(o.table_name) !== -1) {
					if (added.indexOf(o.table_name) === -1) {
						added.push(o.table_name);
						list.push({ label: o.mod_name + "数量", value: "0", field: o.table_name });
					}
				}
			}
			this.dataScreen = list;
			for (let i = 0; i < list.length; i++) {
				let item = list[i];
				this.$get("~/api/" + item.field + "/count").then((json) => {
					if (json.result !== null) {
						this.$set(this.dataScreen[i], "value", json.result);
					}
				}).catch(() => {});
			}
		},
		sign_out_fun() {
			this.$get("~/api/user/quit", {}, () => {
				this.$store.commit("quit");
				this.$router.push("/login");
			});
		},
	},
};
</script>

<style scoped>
.page_dashboard {
	padding: 24px;
	max-width: 1200px;
	margin: 0 auto;
}

.dashboard_welcome_card {
	background: linear-gradient(135deg, #093943 0%, #0f5f6c 60%, #1d7a86 100%);
	border-radius: 16px;
	padding: 28px 32px;
	margin-bottom: 24px;
	box-shadow: 0 8px 32px rgba(9, 57, 67, 0.2);
}

.welcome_content {
	display: flex;
	align-items: center;
	justify-content: space-between;
}

.welcome_title {
	font-size: 22px;
	font-weight: 700;
	color: #fff;
	margin: 0 0 8px;
	letter-spacing: 0.5px;
}

.welcome_sub {
	display: flex;
	align-items: center;
	gap: 12px;
	margin: 0;
}

.welcome_badge {
	display: inline-flex;
	align-items: center;
	padding: 3px 12px;
	border-radius: 999px;
	background: rgba(77, 232, 224, 0.2);
	color: #4de8e0;
	font-size: 12px;
	font-weight: 600;
}

.welcome_time {
	color: rgba(255, 255, 255, 0.7);
	font-size: 13px;
}

.welcome_actions .el-button {
	border-color: rgba(255, 255, 255, 0.3);
	color: #fff;
	background: rgba(255, 255, 255, 0.1);
	border-radius: 8px;
}

.welcome_actions .el-button:hover {
	background: rgba(255, 255, 255, 0.2);
	border-color: rgba(255, 255, 255, 0.5);
}

.welcome_actions .el-button--danger {
	background: rgba(239, 68, 68, 0.3);
	border-color: rgba(239, 68, 68, 0.4);
}

.welcome_actions .el-button--danger:hover {
	background: rgba(239, 68, 68, 0.5);
}

.dashboard_stats {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
	gap: 16px;
	margin-bottom: 24px;
}

.stat_card {
	background: #fff;
	border-radius: 14px;
	padding: 20px;
	display: flex;
	align-items: center;
	gap: 16px;
	cursor: pointer;
	transition: all 0.3s ease;
	border: 1px solid #eef2f7;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.stat_card:hover {
	transform: translateY(-4px);
	box-shadow: 0 12px 24px rgba(9, 57, 67, 0.12);
	border-color: transparent;
}

.stat_icon {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 52px;
	height: 52px;
	border-radius: 14px;
	font-size: 24px;
	flex-shrink: 0;
}

.stat_icon_0 {
	background: linear-gradient(135deg, #eaf7f7, #d4f0f0);
	color: #0f5f6c;
}

.stat_icon_1 {
	background: linear-gradient(135deg, #f7ead4, #f0ddb8);
	color: #c9872f;
}

.stat_icon_2 {
	background: linear-gradient(135deg, #e8f4fd, #d0e8fa);
	color: #1d7a86;
}

.stat_icon_3 {
	background: linear-gradient(135deg, #fde8e8, #fad0d0);
	color: #c0392b;
}

.stat_number {
	font-size: 24px;
	font-weight: 700;
	color: #093943;
	line-height: 1.2;
}

.stat_label {
	font-size: 13px;
	color: #8c9ba5;
	margin-top: 2px;
}

.dashboard_grid {
	display: grid;
	grid-template-columns: 1fr 340px;
	gap: 24px;
}

.panel {
	background: #fff;
	border-radius: 14px;
	border: 1px solid #eef2f7;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
	margin-bottom: 20px;
	overflow: hidden;
}

.panel_header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 16px 20px;
	border-bottom: 1px solid #f0f3f7;
}

.panel_title {
	font-size: 15px;
	font-weight: 600;
	color: #093943;
	display: flex;
	align-items: center;
	gap: 8px;
}

.panel_title i {
	color: #0f5f6c;
	font-size: 18px;
}

.panel_body {
	padding: 20px;
}

.grid_left .panel_body {
	padding: 16px 20px;
}

.user_card {
	text-align: center;
	padding: 24px 20px;
}

.user_avatar {
	margin-bottom: 16px;
}

.user_avatar img {
	width: 72px;
	height: 72px;
	border-radius: 50%;
	object-fit: cover;
	border: 4px solid #eaf7f7;
	box-shadow: 0 4px 12px rgba(15, 95, 108, 0.15);
}

.user_info {
	margin-bottom: 20px;
}

.user_name {
	font-size: 18px;
	font-weight: 600;
	color: #093943;
	margin: 0 0 4px;
}

.user_role {
	font-size: 13px;
	color: #8c9ba5;
	margin: 0;
}

.user_meta {
	border-top: 1px solid #f0f3f7;
	padding-top: 16px;
}

.meta_item {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 8px 0;
}

.meta_label {
	font-size: 13px;
	color: #8c9ba5;
}

.meta_value {
	font-size: 13px;
	font-weight: 500;
	color: #093943;
}

.track_user {
	font-weight: 500;
	color: #093943;
}

.track_time {
	font-size: 12px;
	color: #8c9ba5;
}

@media (max-width: 992px) {
	.dashboard_grid {
		grid-template-columns: 1fr;
	}

	.welcome_content {
		flex-direction: column;
		align-items: flex-start;
		gap: 16px;
	}

	.dashboard_stats {
		grid-template-columns: repeat(2, 1fr);
	}
}

@media (max-width: 576px) {
	.page_dashboard {
		padding: 16px;
	}

	.dashboard_stats {
		grid-template-columns: 1fr;
	}
}
</style>
