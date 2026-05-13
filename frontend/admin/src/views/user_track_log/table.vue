<template>
	<div class="page_user_track_log diy_table diy_table_down">
		<el-card>
			<div slot="header" class="clearfix">
				<span>用户行为追踪</span>
			</div>
			<div class="search_bar">
				<el-input
					v-model="keyword"
					placeholder="搜索用户、对象、备注"
					prefix-icon="el-icon-search"
					size="small"
					clearable
					style="width: 280px; margin-right: 10px;"
					@keyup.enter.native="loadList"
				/>
				<el-input v-model="user_id" placeholder="用户ID" clearable size="small" style="width: 120px; margin-right: 10px;" />
				<el-input v-model="username" placeholder="用户名" clearable size="small" style="width: 140px; margin-right: 10px;" />
				<el-select v-model="user_role" placeholder="角色" clearable size="small" style="width: 130px; margin-right: 10px;">
					<el-option label="管理员" value="管理员" />
					<el-option label="主办用户" value="主办用户" />
					<el-option label="普通用户" value="普通用户" />
				</el-select>
				<el-input v-model="action_type" placeholder="操作类型" clearable size="small" style="width: 150px; margin-right: 10px;" />
				<el-date-picker
					v-model="timeRange"
					type="datetimerange"
					value-format="yyyy-MM-dd HH:mm:ss"
					range-separator="至"
					start-placeholder="开始时间"
					end-placeholder="结束时间"
					size="small"
					style="width: 360px; margin-right: 10px;"
				/>
				<el-button type="primary" size="small" @click="loadList">查询</el-button>
				<el-button size="small" @click="resetSearch">重置</el-button>
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
				<el-table-column prop="user_role" label="角色" width="100" />
				<el-table-column prop="event_name" label="事件" width="140">
					<template slot-scope="{ row }">
						<el-tag :type="eventTagType(row.event_name)" size="small">{{ row.event_name }}</el-tag>
					</template>
				</el-table-column>
				<el-table-column prop="object_type" label="对象" width="140" show-overflow-tooltip />
				<el-table-column prop="result" label="结果" width="90" />
				<el-table-column prop="remark" label="备注" min-width="180" show-overflow-tooltip />
				<el-table-column prop="ip" label="IP" width="130" show-overflow-tooltip />
				<el-table-column label="详情" width="80" align="center">
					<template slot-scope="{ row }">
						<el-button type="text" size="small" @click="showDetail(row)">查看</el-button>
					</template>
				</el-table-column>
				<el-table-column prop="create_time" label="时间" width="170" />
			</el-table>
			<div class="pager">
				<el-pagination
					:current-page="page"
					:page-size="size"
					:page-sizes="[10, 20, 50, 100]"
					layout="total, sizes, prev, pager, next, jumper"
					:total="count"
					@size-change="handleSizeChange"
					@current-change="handleCurrentChange"
				/>
			</div>
		</el-card>

		<el-dialog title="追踪详情" :visible.sync="detailVisible" width="600px">
			<el-descriptions :column="1" border size="medium">
				<el-descriptions-item label="ID">{{ currentRow.id }}</el-descriptions-item>
				<el-descriptions-item label="用户名">{{ currentRow.username }}</el-descriptions-item>
				<el-descriptions-item label="用户ID">{{ currentRow.user_id }}</el-descriptions-item>
				<el-descriptions-item label="角色">{{ currentRow.user_role }}</el-descriptions-item>
				<el-descriptions-item label="事件">{{ currentRow.event_name }}</el-descriptions-item>
				<el-descriptions-item label="对象">{{ currentRow.object_type }} {{ currentRow.object_id }}</el-descriptions-item>
				<el-descriptions-item label="IP">{{ currentRow.ip }}</el-descriptions-item>
				<el-descriptions-item label="结果">{{ currentRow.result }}</el-descriptions-item>
				<el-descriptions-item label="备注">{{ currentRow.remark }}</el-descriptions-item>
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
			user_id: "",
			username: "",
			user_role: "",
			action_type: "",
			timeRange: [],
			page: 1,
			size: 20,
			count: 0,
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
				const params = new URLSearchParams();
				if (this.keyword.trim()) params.append("keyword", this.keyword.trim());
				if (this.user_id.trim()) params.append("user_id", this.user_id.trim());
				if (this.username.trim()) params.append("username", this.username.trim());
				if (this.user_role) params.append("user_role", this.user_role);
				if (this.action_type.trim()) params.append("action_type", this.action_type.trim());
				if (this.timeRange && this.timeRange.length === 2) {
					params.append("start_time", this.timeRange[0]);
					params.append("end_time", this.timeRange[1]);
				}
				params.append("page", this.page);
				params.append("size", this.size);
				let url = "/api/track/list?" + params.toString();
				const res = await this.$axios.get(url);
				if (res && res.result) {
					this.list = Array.isArray(res.result.list) ? res.result.list : [];
					this.count = Number(res.result.count || 0);
				} else {
					this.list = Array.isArray(res) ? res : [];
					this.count = this.list.length;
				}
			} catch (e) {
				console.error("加载追踪日志失败", e);
				this.list = [];
				this.count = 0;
			}
			this.loading = false;
		},
		resetSearch() {
			this.keyword = "";
			this.user_id = "";
			this.username = "";
			this.user_role = "";
			this.action_type = "";
			this.timeRange = [];
			this.page = 1;
			this.loadList();
		},
		handleSizeChange(size) {
			this.size = size;
			this.page = 1;
			this.loadList();
		},
		handleCurrentChange(page) {
			this.page = page;
			this.loadList();
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
	flex-wrap: wrap;
	gap: 8px 0;
}
.pager {
	margin-top: 16px;
	text-align: right;
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
