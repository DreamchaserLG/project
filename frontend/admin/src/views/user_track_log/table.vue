<template>
	<div class="page_user_track_log diy_table diy_table_down">
		<el-card>
			<div slot="header" class="clearfix">
				<span>用户行为追踪</span>
			</div>
			<div class="search_bar">
				<el-input
					v-model="keyword"
					placeholder="搜索用户ID或用户名"
					prefix-icon="el-icon-search"
					size="small"
					clearable
					style="width: 280px; margin-right: 10px;"
					@keyup.enter.native="loadList"
				/>
				<el-button type="primary" size="small" @click="loadList">查询</el-button>
				<el-button size="small" @click="keyword = ''; loadList()">重置</el-button>
			</div>
			<el-table
				:data="list"
				border
				style="width: 100%"
				v-loading="loading"
				element-loading-text="加载中..."
			>
				<el-table-column prop="id" label="ID" width="70" align="center" />
				<el-table-column prop="username" label="用户名" width="120" />
				<el-table-column prop="user_id" label="用户ID" width="100" />
				<el-table-column prop="event_name" label="事件" width="140">
					<template slot-scope="{ row }">
						<el-tag :type="eventTagType(row.event_name)" size="small">{{ row.event_name }}</el-tag>
					</template>
				</el-table-column>
				<el-table-column prop="page" label="页面" min-width="200" show-overflow-tooltip />
				<el-table-column label="详情" width="80" align="center">
					<template slot-scope="{ row }">
						<el-button type="text" size="small" @click="showDetail(row)">查看</el-button>
					</template>
				</el-table-column>
				<el-table-column prop="create_time" label="时间" width="170" />
			</el-table>
		</el-card>

		<el-dialog title="追踪详情" :visible.sync="detailVisible" width="600px">
			<el-descriptions :column="1" border size="medium">
				<el-descriptions-item label="ID">{{ currentRow.id }}</el-descriptions-item>
				<el-descriptions-item label="用户名">{{ currentRow.username }}</el-descriptions-item>
				<el-descriptions-item label="用户ID">{{ currentRow.user_id }}</el-descriptions-item>
				<el-descriptions-item label="事件">{{ currentRow.event_name }}</el-descriptions-item>
				<el-descriptions-item label="页面">{{ currentRow.page }}</el-descriptions-item>
				<el-descriptions-item label="时间">{{ currentRow.create_time }}</el-descriptions-item>
			</el-descriptions>
			<div style="margin-top: 16px;">
				<div style="font-weight: 600; margin-bottom: 8px;">附带数据：</div>
				<pre class="track_data_json">{{ formatJson(currentRow.data_json) }}</pre>
			</div>
		</el-dialog>
	</div>
</template>

<script>
export default {
	data() {
		return {
			list: [],
			loading: false,
			keyword: "",
			detailVisible: false,
			currentRow: {},
		};
	},
	created() {
		this.loadList();
	},
	methods: {
		async loadList() {
			this.loading = true;
			try {
				let url = "/api/track/list";
				if (this.keyword.trim()) {
					url += "?keyword=" + encodeURIComponent(this.keyword.trim());
				}
				const res = await this.$axios.get(url);
				this.list = Array.isArray(res) ? res : [];
			} catch (e) {
				console.error("加载追踪日志失败", e);
				this.list = [];
			}
			this.loading = false;
		},
		showDetail(row) {
			this.currentRow = row;
			this.detailVisible = true;
		},
		formatJson(jsonStr) {
			try {
				if (!jsonStr || jsonStr === "null") return "无";
				const obj = JSON.parse(jsonStr);
				return JSON.stringify(obj, null, 2);
			} catch {
				return jsonStr || "无";
			}
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
	},
};
</script>

<style scoped>
.search_bar {
	margin-bottom: 16px;
	display: flex;
	align-items: center;
}
.track_data_json {
	background: #f5f7fa;
	border-radius: 8px;
	padding: 12px 16px;
	font-size: 13px;
	line-height: 1.6;
	max-height: 300px;
	overflow: auto;
	white-space: pre-wrap;
	word-break: break-all;
}
</style>
