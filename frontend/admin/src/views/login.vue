<template>
	<div class="login_page">
		<div class="login_bg_shapes">
			<div class="shape shape_1"></div>
			<div class="shape shape_2"></div>
			<div class="shape shape_3"></div>
		</div>
		<div class="login_card" :class="{ show: visible }">
			<div class="login_brand">
				<div class="brand_icon">
					<i class="el-icon-s-platform"></i>
				</div>
				<h1 class="brand_title">会展管理系统</h1>
				<p class="brand_sub">管理后台 · Administrator</p>
			</div>
			<el-form ref="form" :model="form" class="login_form" @submit.native.prevent="submit()">
				<div class="form_group">
					<label class="form_label">账号</label>
					<el-input
						v-model="form.username"
						placeholder="请输入管理员账号"
						prefix-icon="el-icon-user"
						size="large"
						clearable
					/>
				</div>
				<div class="form_group">
					<label class="form_label">密码</label>
					<el-input
						v-model="form.password"
						placeholder="请输入密码"
						show-password
						prefix-icon="el-icon-lock"
						size="large"
					/>
				</div>
				<Verification @returnData="returnData" />
				<el-button
					type="primary"
					class="login_btn"
					size="large"
					:loading="loading"
					native-type="submit"
				>
					{{ loading ? '登录中...' : '登 录' }}
				</el-button>
			</el-form>
		</div>
	</div>
</template>

<script>
import Verification from '@/components/common/verification.vue';
import mixin from "@/mixins/page.js";
import { rsaEncrypt } from '@/store/encrypt.js';

export default {
	mixins: [mixin],
	components: { Verification },
	data() {
		return {
			visible: false,
			loading: false,
			form: {
				username: '',
				password: '',
				captcha: '',
				captcha_code: ''
			},
			allow_user: ['管理员', '主办用户']
		};
	},
	mounted() {
		setTimeout(() => { this.visible = true; }, 100);
	},
	methods: {
		returnData(e) {
			this.form.captcha = e.captcha;
			this.form.captcha_code = e.captcha_code;
		},
		submit() {
			if (!this.form.username) {
				return this.$message.warning('请输入账号');
			}
			if (!this.form.password) {
				return this.$message.warning('请输入密码');
			}
			this.loading = true;
			let params = JSON.parse(JSON.stringify(this.form));
			params.password = rsaEncrypt(params.password);

			this.$post('~/api/user/login?', params, (res) => {
				this.loading = false;
				if (res.result && res.result.obj) {
					let obj = res.result.obj;
					if (this.allow_user.includes(obj.user_group)) {
						localStorage.clear();
						sessionStorage.clear();
						$.db.set('token', obj.token);
						this.$store.commit('user_set', obj);
						sessionStorage.setItem('user_group', obj.user_group);
						this.$router.replace('/');
						this.$message.success('登录成功');
					} else {
						this.$message.error('非管理员或主办用户，无权登录');
					}
				} else if (res.error) {
					this.$message.error(res.error.message);
				}
			});
		}
	}
};
</script>

<style scoped>
.login_page {
	position: fixed;
	top: 0;
	left: 0;
	width: 100vw;
	height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	background: linear-gradient(135deg, #051e23 0%, #093943 30%, #0f5f6c 70%, #0a4852 100%);
	overflow: hidden;
}

.login_bg_shapes {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	pointer-events: none;
}

.shape {
	position: absolute;
	border-radius: 50%;
	opacity: 0.06;
	background: #4de8e0;
}

.shape_1 {
	width: 500px;
	height: 500px;
	top: -150px;
	right: -100px;
	animation: float 20s ease-in-out infinite;
}

.shape_2 {
	width: 350px;
	height: 350px;
	bottom: -100px;
	left: -80px;
	animation: float 25s ease-in-out infinite reverse;
}

.shape_3 {
	width: 200px;
	height: 200px;
	top: 50%;
	left: 60%;
	background: #c9872f;
	opacity: 0.04;
	animation: float 18s ease-in-out infinite;
}

@keyframes float {
	0%, 100% { transform: translateY(0) rotate(0deg); }
	50% { transform: translateY(-30px) rotate(5deg); }
}

.login_card {
	position: relative;
	width: 420px;
	background: rgba(255, 255, 255, 0.97);
	border-radius: 16px;
	padding: 48px 40px 40px;
	box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3), 0 0 0 1px rgba(255, 255, 255, 0.1);
	transform: translateY(30px);
	opacity: 0;
	transition: all 0.6s cubic-bezier(0.16, 1, 0.3, 1);
}

.login_card.show {
	transform: translateY(0);
	opacity: 1;
}

.login_brand {
	text-align: center;
	margin-bottom: 36px;
}

.brand_icon {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	width: 64px;
	height: 64px;
	border-radius: 16px;
	background: linear-gradient(135deg, #093943, #0f5f6c);
	color: #4de8e0;
	font-size: 28px;
	margin-bottom: 20px;
	box-shadow: 0 8px 24px rgba(9, 57, 67, 0.3);
}

.brand_title {
	font-size: 24px;
	font-weight: 700;
	color: #093943;
	margin: 0 0 6px;
	letter-spacing: 2px;
}

.brand_sub {
	font-size: 13px;
	color: #8c9ba5;
	margin: 0;
	letter-spacing: 4px;
	text-transform: uppercase;
}

.login_form {
	width: 100%;
}

.form_group {
	margin-bottom: 22px;
}

.form_label {
	display: block;
	font-size: 13px;
	font-weight: 600;
	color: #3a4a52;
	margin-bottom: 8px;
}

.login_form .el-input__inner {
	height: 46px;
	border-radius: 10px;
	border: 2px solid #e8edf0;
	font-size: 14px;
	padding-left: 40px;
	transition: all 0.3s ease;
}

.login_form .el-input__inner:focus {
	border-color: #0f5f6c;
	box-shadow: 0 0 0 3px rgba(15, 95, 108, 0.1);
}

.login_form .el-input__prefix {
	left: 12px;
	color: #8c9ba5;
}

.login_btn {
	width: 100%;
	height: 48px;
	border-radius: 10px;
	font-size: 16px;
	font-weight: 600;
	letter-spacing: 4px;
	margin-top: 8px;
	background: linear-gradient(135deg, #093943 0%, #0f5f6c 100%);
	border: none;
	transition: all 0.3s ease;
}

.login_btn:hover {
	transform: translateY(-1px);
	box-shadow: 0 8px 25px rgba(15, 95, 108, 0.35);
}

.login_btn:active {
	transform: translateY(0);
}

@media (max-width: 480px) {
	.login_card {
		width: calc(100% - 32px);
		padding: 36px 24px 32px;
		margin: 0 16px;
	}
}
</style>
