<template>
	<div class="app" id="app">
		<div class="page" v-if="$store.state.user.user_id === 0 || url.indexOf($route.path) !== -1 || $route.path.includes('/qrcodeDetails')">
			<router-view />
		</div>
		<div class="page" v-else>
			<page_side :isCollapse="isCollapse"></page_side>
			<main :style="{ marginLeft: isCollapse ? '64px' : '240px', transition: 'margin-left 0.3s' }">
				<page_header @toggle-sidebar="isCollapse = !isCollapse" />
				<article>
					<router-view />
				</article>
			</main>
		</div>
	</div>
</template>

<style>
	@import "../public/css/base.css";
	@import "../public/css/theme.css";

	* {
		box-sizing: border-box;
	}

	.el-dialog {
		width: calc(100% - 1rem);
		max-width: 80rem;
		border-radius: 12px !important;
	}

	.el-dialog__header {
		border-bottom: 1px solid #f0f3f7;
		padding: 16px 20px !important;
	}

	.el-dialog__title {
		font-size: 16px;
		font-weight: 600;
		color: #093943;
	}

	.el-dialog__body {
		padding: 20px !important;
	}

	.field_action {
		text-align: center;
	}

	.field_action .el-transfer {
		display: inline-block;
		text-align: left;
	}

	input::-webkit-outer-spin-button,
	input::-webkit-inner-spin-button {
		-webkit-appearance: none;
	}

	input[type=number] {
		-moz-appearance: textfield;
	}

	table a {
		color: inherit;
		text-decoration: none;
	}

	.el-input {
		max-width: 100%;
	}

	body {
		padding: 0;
		margin: 0;
		background-color: #f4f7fb;
		font-family: "PingFang SC", "Microsoft YaHei", "Helvetica Neue", sans-serif;
		color: #132433;
		-webkit-font-smoothing: antialiased;
		-moz-osx-font-smoothing: grayscale;
	}

	main {
		margin: 0 auto;
		overflow-x: hidden;
		width: 100%;
		margin-top: 60px;
	}

	header i {
		font-size: 1.75rem;
	}

	article {
		box-sizing: border-box;
		min-height: calc(100vh - 60px);
		padding: 0;
		background: #f4f7fb;
	}

	button i::before {
		font-weight: bold;
	}

	.el-breadcrumb {
		padding: 0.5rem;
	}

	.page {
		display: flex;
		align-items: stretch;
		width: 100%;
		height: 100%;
	}

	.btn_full {
		width: 100%;
	}

	.el-table .cell {
		white-space: nowrap;
	}

	.el-table th {
		background: #f8fafb !important;
		color: #3a4a52;
		font-weight: 600;
		font-size: 13px;
	}

	.el-table td {
		font-size: 13px;
		color: #3a4a52;
	}

	.el-table--border {
		border-radius: 8px;
		overflow: hidden;
		border: 1px solid #eef2f7;
	}

	.el-table--border th,
	.el-table--border td {
		border-color: #eef2f7;
	}

	.el-table--striped .el-table__body tr.el-table__row--striped td {
		background: #fafcfd;
	}

	.el-table__body tr:hover > td {
		background: #f0f7f8 !important;
	}

	.el-button--primary {
		background: #0f5f6c;
		border-color: #0f5f6c;
		border-radius: 8px;
	}

	.el-button--primary:hover {
		background: #1d7a86;
		border-color: #1d7a86;
	}

	.el-button--default {
		border-radius: 8px;
	}

	.el-button--danger {
		border-radius: 8px;
	}

	.el-button--success {
		border-radius: 8px;
	}

	.el-button--warning {
		border-radius: 8px;
	}

	.el-button--info {
		border-radius: 8px;
	}

	.el-tag--mini {
		border-radius: 4px;
	}

	.el-pagination {
		padding: 12px 0 !important;
	}

	.el-pagination .el-pager li.active {
		background: #0f5f6c !important;
		border-radius: 6px;
	}

	.ql-editor {
		height: 300px;
	}

	.quill-editor {
		background: #FFFFFF;
	}

	.ql-editor {
		min-height: 25rem;
	}

	.editor {
		min-height: 500px;
	}

	.diy_panel .el-radio {
		padding: 9px 15px;
	}

	.diy_panel .el-checkbox {
		padding: 9px 15px;
	}

	.bg {
		background: white;
		border-radius: 12px;
	}

	.form.p_4 {
		padding: 1rem;
	}

	.form .el-input {
		width: initial;
	}

	.mt {
		margin-top: 1rem;
	}

	.float-right {
		float: right;
	}

	.mr-1 {
		margin-right: 1rem;
	}

	.el-table .table_class {
		background: rgba(150, 150, 150, 0.1);
		text-align: center;
	}

	.text_center {
		text-align: center;
	}

	.warp {
		width: 100%;
	}

	.el-col {
		overflow: visible;
	}

	.ql-picker {
		height: initial !important;
	}

	.el-form-item__label {
		color: #3a4a52;
		font-weight: 500;
	}

	.el-input__inner {
		border-radius: 8px;
		border-color: #dde3e9;
	}

	.el-input__inner:focus {
		border-color: #0f5f6c;
		box-shadow: 0 0 0 2px rgba(15, 95, 108, 0.1);
	}

	.el-select .el-input__inner:focus {
		border-color: #0f5f6c;
	}

	.el-card {
		border-radius: 12px;
		border: 1px solid #eef2f7;
		box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
	}

	.el-card__header {
		border-bottom: 1px solid #f0f3f7;
		font-weight: 600;
		color: #093943;
	}

	.search_btn_find {
		background: #0f5f6c;
		border-color: #0f5f6c;
		border-radius: 8px;
	}

	.search_btn_find:hover {
		background: #1d7a86;
		border-color: #1d7a86;
	}

	.search_btn_reset {
		border-radius: 8px;
	}

	.search_btn_del {
		border-radius: 8px;
	}

	.search_btn_add {
		background: #0f5f6c;
		border-color: #0f5f6c;
		border-radius: 8px;
		color: #fff;
	}

	.search_btn_add:hover {
		background: #1d7a86;
		border-color: #1d7a86;
	}

	@import "../public/css/diy.css";
</style>

<script>
	export default {
		data() {
			return {
				isCollapse: false,
				url: ['/login', '/forgot', '/register', '/screen/index', '/otherLogin']
			}
		},
		methods: {
			init() {
				var token = $.db.get('token');
				if (token) {
					this.$store.commit('user_set', { token });
				}
			}
		},
		watch: {
			$route(to, from) {
				let currentPath = window.location.hash.slice(1);
				if (this.$route.path !== currentPath) {
					this.$router.push(currentPath);
				}
			}
		},
		created() {
			this.init();
		}
	}
</script>
