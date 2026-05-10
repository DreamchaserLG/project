<template>
	<div class="page_dashboard">
		<div class="dashboard_header">
			<div class="dashboard_welcome">
				<h1 class="dashboard_title">欢迎回来，{{ user.nickname || user.username }}</h1>
				<p class="dashboard_subtitle">
					当前身份：{{ user_group }} · {{ $toTime(user.login_time, "yyyy-MM-dd hh:mm:ss") }} 登录
				</p>
			</div>
			<div class="dashboard_actions">
				<el-button size="small" @click="$router.push('/user/info')">修改资料</el-button>
				<el-button size="small" @click="$router.push('/user/password')">修改密码</el-button>
				<el-button size="small" type="danger" @click="sign_out_fun">退出</el-button>
			</div>
		</div>

		<div class="dashboard_overview" v-if="dataScreen && dataScreen.length">
			<div
				v-for="(item, idx) in dataScreen"
				:key="idx"
				class="overview_card"
				@click="$router.push('/' + item.field + '/table')"
			>
				<div class="overview_card_number">{{ item.value }}</div>
				<div class="overview_card_label">{{ item.label }}</div>
			</div>
		</div>

		<div class="dashboard_body">
			<el-row :gutter="16">
				<el-col :xs="24" :sm="16" style="margin-bottom: 16px;">
					<div class="section_title">快捷操作</div>
					<quickMenu />
				</el-col>
				<el-col :xs="24" :sm="8" style="margin-bottom: 16px;">
					<div class="section_title">用户信息</div>
					<div class="user_card">
						<div class="user_card_avatar">
							<img :src="$fullUrl(user.avatar)" alt="" />
						</div>
						<div class="user_card_info">
							<p class="user_card_name">{{ user.nickname || user.username }}</p>
							<p class="user_card_role">{{ user_group }}</p>
						</div>
						<div class="user_card_meta">
							<p><label>用户ID</label><span>{{ user.user_id }}</span></p>
							<p><label>上次登录</label><span>{{ $toTime(user.login_time, "yyyy-MM-dd") }}</span></p>
						</div>
					</div>
				</el-col>
			</el-row>

			<el-row :gutter="16">
				<el-col :span="24">
					<div class="section_title">
						最近用户行为
						<el-button type="text" @click="$router.push('/user_track_log/table')" style="float: right; font-size: 13px;">查看全部</el-button>
					</div>
					<el-table :data="recentTracks" border size="small" v-loading="tracksLoading" style="width: 100%;">
						<el-table-column prop="username" label="用户" width="120" />
						<el-table-column prop="event_name" label="事件" width="140">
							<template slot-scope="{ row }">
								<el-tag :type="eventTagType(row.event_name)" size="mini">{{ row.event_name }}</el-tag>
							</template>
						</el-table-column>
						<el-table-column prop="page" label="页面" min-width="200" show-overflow-tooltip />
						<el-table-column prop="create_time" label="时间" width="170" />
					</el-table>
				</el-col>
			</el-row>
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
			recentTracks: [],
			tracksLoading: false,
		};
	},
	created() {
		this.get_list_count();
		this.loadRecentTracks();
	},
	methods: {
		async loadRecentTracks() {
			this.tracksLoading = true;
			try {
				const res = await this.$axios.get("/api/track/list");
				this.recentTracks = Array.isArray(res) ? res.slice(0, 8) : [];
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
	padding: 0;
	max-width: 1200px;
	margin: 0 auto;
}

.dashboard_header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
	padding: 20px 24px;
	border-radius: 20px;
	background: linear-gradient(135deg, #0f3650 0%, #43b8b8 50%, #0d7a5c 100%);
	color: #fff;
	box-shadow: 0 8px 24px rgba(16, 34, 51, 0.18);
}

.dashboard_title {
	font-size: 22px;
	font-weight: 700;
	margin-bottom: 4px;
}

.dashboard_subtitle {
	font-size: 14px;
	opacity: 0.85;
}

.dashboard_overview {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
	gap: 16px;
	margin-bottom: 20px;
}

.overview_card {
	background: #fff;
	border: 1px solid rgba(15, 54, 80, 0.08);
	border-radius: 16px;
	padding: 20px 16px;
	text-align: center;
	box-shadow: 0 4px 12px rgba(16, 34, 51, 0.04);
	cursor: pointer;
	transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.overview_card:hover {
	transform: translateY(-3px);
	box-shadow: 0 8px 20px rgba(16, 34, 51, 0.1);
}

.overview_card_number {
	font-size: 24px;
	font-weight: 700;
	color: #10344e;
	margin-bottom: 4px;
}

.overview_card_label {
	font-size: 13px;
	color: var(--color_text_sub);
}

.section_title {
	font-size: 16px;
	font-weight: 600;
	color: #10344e;
	margin-bottom: 12px;
	padding-bottom: 8px;
	border-bottom: 1px solid rgba(15, 54, 80, 0.08);
}

.user_card {
	background: #fff;
	border-radius: 16px;
	padding: 20px;
	border: 1px solid rgba(15, 54, 80, 0.08);
	box-shadow: 0 4px 12px rgba(16, 34, 51, 0.04);
}

.user_card_avatar {
	text-align: center;
	margin-bottom: 12px;
}

.user_card_avatar img {
	width: 60px;
	height: 60px;
	border-radius: 50%;
	object-fit: cover;
	border: 3px solid rgba(67, 184, 184, 0.3);
}

.user_card_info {
	text-align: center;
	margin-bottom: 12px;
}

.user_card_name {
	font-size: 16px;
	font-weight: 600;
	color: #10344e;
}

.user_card_role {
	font-size: 13px;
	color: var(--color_text_sub);
	margin-top: 4px;
}

.user_card_meta p {
	display: flex;
	justify-content: space-between;
	padding: 6px 0;
	font-size: 13px;
	border-bottom: 1px solid rgba(15, 54, 80, 0.04);
}

.user_card_meta label {
	color: var(--color_text_sub);
}

.user_card_meta span {
	color: #10344e;
}
</style>
