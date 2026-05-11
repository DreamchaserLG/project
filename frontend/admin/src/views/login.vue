<template>
    <article class="auth_login_page">
        <div class="auth_login_shell">
            <section class="auth_login_visual">
                <span class="auth_kicker">Admin Portal</span>
                <h1>会展管理系统</h1>
                <p>管理端用于会展业务的后台管理，包括用户管理、会展信息维护、报名审核、退款处理和数据追踪。</p>

                <div class="auth_visual_cards">
                    <article class="auth_visual_card">
                        <strong>多角色管理</strong>
                        <span>支持管理员与主办用户登录，按权限分配功能模块，确保数据安全与职责分离。</span>
                    </article>
                    <article class="auth_visual_card">
                        <strong>业务全流程</strong>
                        <span>从会展创建到展位管理、报名审核、行程确认、退款处理的完整业务闭环。</span>
                    </article>
                    <article class="auth_visual_card">
                        <strong>数据追踪</strong>
                        <span>实时追踪用户行为日志，助力运营分析和系统优化决策。</span>
                    </article>
                </div>
            </section>

            <section class="auth_login_panel">
                <div class="auth_login_header">
                    <span class="auth_kicker">Admin Login</span>
                    <h2>管理端登录</h2>
                    <p>请使用管理员或主办用户账号登录。</p>
                </div>

                <el-form :model="form" :rules="rules" ref="form" class="auth_login_form" label-position="top">
                    <el-form-item label="账号" prop="account">
                        <el-input
                            type="text"
                            v-model="form.account"
                            placeholder="请输入账号"
                            prefix-icon="el-icon-user"
                            clearable
                        />
                    </el-form-item>

                    <el-form-item label="密码" prop="password">
                        <el-input
                            :type="passwordType"
                            v-model="form.password"
                            placeholder="请输入密码"
                            autocomplete="off"
                            prefix-icon="el-icon-lock"
                        >
                            <i slot="suffix" class="password_toggle" @click="showPwd">
                                <svg v-if="passwordType === 'password'" t="1620373409646" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="3656" width="16" height="16"><path d="M512 366.545455c80.290909 0 145.454545 65.163636 145.454545 145.454545s-65.163636 145.454545-145.454545 145.454545-145.454545-65.163636-145.454545-145.454545 65.163636-145.454545 145.454545-145.454545m0-72.727273c-120.436364 0-218.181818 97.745455-218.181818 218.181818s97.745455 218.181818 218.181818 218.181818 218.181818-97.745455 218.181818-218.181818-97.745455-218.181818-218.181818-218.181818z" p-id="3657" fill="#8a8a8a"></path><path d="M512 145.454545c186.181818 0 346.181818 101.818182 436.363636 256-90.181818 154.181818-250.181818 256-436.363636 256S165.818182 555.636364 75.636364 401.454545c90.181818-154.181818 250.181818-256 436.363636-256m0-72.727272C288 72.727273 98.909091 212.363636 0 401.454545c98.909091 189.090909 288 328.727273 512 328.727273s413.090909-139.636364 512-328.727273c-98.909091-189.090909-288-328.727273-512-328.727273z" p-id="3658" fill="#8a8a8a"></path><path d="M167.272727 129.454545l698.181818 698.181819-50.90909 50.90909L116.363636 180.363636z" p-id="3659" fill="#8a8a8a"></path></svg>
                                <svg v-else t="1620373409647" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="3660" width="16" height="16"><path d="M512 366.545455c80.290909 0 145.454545 65.163636 145.454545 145.454545s-65.163636 145.454545-145.454545 145.454545-145.454545-65.163636-145.454545-145.454545 65.163636-145.454545 145.454545-145.454545m0-72.727273c-120.436364 0-218.181818 97.745455-218.181818 218.181818s97.745455 218.181818 218.181818 218.181818 218.181818-97.745455 218.181818-218.181818-97.745455-218.181818-218.181818-218.181818z" p-id="3661" fill="#8a8a8a"></path><path d="M512 145.454545c186.181818 0 346.181818 101.818182 436.363636 256-90.181818 154.181818-250.181818 256-436.363636 256S165.818182 555.636364 75.636364 401.454545c90.181818-154.181818 250.181818-256 436.363636-256m0-72.727272C288 72.727273 98.909091 212.363636 0 401.454545c98.909091 189.090909 288 328.727273 512 328.727273s413.090909-139.636364 512-328.727273c-98.909091-189.090909-288-328.727273-512-328.727273z" p-id="3662" fill="#8a8a8a"></path></svg>
                            </i>
                        </el-input>
                    </el-form-item>

                    <div class="auth_verify_group">
                        <label class="auth_verify_label">验证码 <span class="auth_required">*</span></label>
                        <div class="auth_verify_box">
                            <Verification ref="child"></Verification>
                        </div>
                    </div>
                </el-form>

                <div class="auth_login_actions">
                    <el-button class="auth_submit_btn" type="primary" @click="sign_in()" :loading="loading">
                        登录管理端
                    </el-button>
                    <div class="auth_secondary_actions">
                        <el-button type="text" class="auth_text_btn" @click="$router.push('./register')">注册账号</el-button>
                        <el-button type="text" class="auth_text_btn" @click="$router.push('./forgot')">忘记密码</el-button>
                    </div>
                </div>

                <div class="auth_login_links">
                    <span>普通用户？</span>
                    <a class="auth_inline_link" href="javascript:void(0)" @click="goHome">前往用户端</a>
                </div>
            </section>
        </div>
    </article>
</template>

<script>
    import Verification from '@/components/common/verification.vue'
    import {rsaEncrypt} from "@/store/encrypt";

    export default {
        components: {
            Verification,
        },
        data: function() {
            return {
                passwordType: 'password',
                oauth: {
                    signIn: false
                },
                allow_user: [
                    '管理员',
                    '主办用户'
                ],
                web: this.$store.state.web,
                loading: false,
                form: {
                    account: "",
                    password: "",
                },
                remember_me: 1,
                rules: {
                    account: [
                        { required: true, message: '请输入账号', trigger: 'blur' },
                        { min: 5, max: 16, message: '长度在 5 到 16 个字符', trigger: 'blur' }
                    ],
                    password: [
                        { required: true, message: '请输入密码', trigger: 'blur' },
                        { min: 6, max: 16, message: '长度在 6 到 16 个字符', trigger: 'blur' }
                    ]
                },
            }
        },
        methods: {
            showPwd() {
                this.passwordType = this.passwordType === 'password' ? 'text' : 'password';
            },
            goHome() {
                let base = window.location.origin + window.location.pathname;
                let homeUrl = base.replace('/admin/dist/', '/home/dist/').replace('/admin/dist', '/home/dist');
                window.location.href = homeUrl;
            },
            sign_in() {
                var _this = this;
                this.$refs.form.validate((valid) => {
                    if (!valid) return;

                    const bool = this.$refs.child ? this.$refs.child.sublim() : true;
                    if (!bool) return;

                    _this.loading = true;

                    var f = _this.form;
                    var form = {
                        password: rsaEncrypt(f.password),
                        username: f.account + ''
                    };

                    _this.$post('~/api/user/login?', form, (res) => {
                        _this.loading = false;
                        if (res.result && res.result.obj) {
                            var obj = res.result.obj;
                            const login_time = new Date().toLocaleString('zh-CN').replace(/\//g, '-').replace(/\s/, ' ').split('.')[0];
                            _this.$post("~/api/user/set?user_id=" + obj.user_id, {
                                login_time: login_time,
                            });
                            obj.login_time = login_time;

                            if (_this.allow_user.includes(obj.user_group)) {
                                _this.$store.commit('user_set', obj);

                                if (_this.remember_me) {
                                    $.db.set('account', f.account);
                                }

                                sessionStorage.setItem("user_id", obj.user_id);
                                sessionStorage.setItem("nickname", obj.nickname || "");
                                sessionStorage.setItem("avatar", obj.avatar || "");
                                sessionStorage.setItem("user_group", obj.user_group || "");

                                _this.$get_auth(obj.user_group, () => {
                                    var url = _this.$redirect();
                                    _this.$router.push(url || '/');
                                });

                                $.db.set('user_group', JSON.stringify(res.result.obj));
                                _this.$message.success('登录成功');
                            } else {
                                _this.$message.error('普通用户请使用用户端登录');
                            }
                        } else if (res.error) {
                            _this.$message.error(res.error.message);
                        }
                    });
                });
            },
        },
    }
</script>

<style scoped>
.auth_login_page {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 2rem 1.2rem;
    background:
        radial-gradient(circle at 0% 0%, rgba(15, 95, 108, 0.1), transparent 28%),
        radial-gradient(circle at 100% 0%, rgba(201, 135, 47, 0.08), transparent 22%),
        linear-gradient(180deg, #f9fbfd 0%, #f3f7fb 100%);
}

.auth_login_shell {
    display: grid;
    grid-template-columns: minmax(360px, 1.05fr) minmax(380px, 520px);
    width: min(100%, 1340px);
    overflow: hidden;
    border-radius: 34px;
    background: rgba(255, 255, 255, 0.94);
    border: 1px solid rgba(15, 54, 80, 0.08);
    box-shadow: 0 34px 70px rgba(12, 38, 56, 0.14);
}

.auth_login_visual {
    position: relative;
    overflow: hidden;
    padding: 2.6rem 2.6rem 2.4rem;
    background:
        linear-gradient(145deg, rgba(9, 57, 67, 0.95), rgba(15, 95, 108, 0.76)),
        url("/img/bg.jpg") center/cover no-repeat;
    color: #fff;
}

.auth_login_visual h1 {
    margin: 1rem 0 0.9rem;
    font-size: 3rem;
    line-height: 1.14;
}

.auth_login_visual p {
    max-width: 34rem;
    line-height: 1.9;
    color: rgba(255, 255, 255, 0.84);
}

.auth_kicker {
    display: inline-flex;
    align-items: center;
    gap: 0.55rem;
    padding: 0.45rem 0.95rem;
    border-radius: 999px;
    background: rgba(255, 255, 255, 0.14);
    border: 1px solid rgba(255, 255, 255, 0.18);
    color: #fff;
    font-size: 0.82rem;
    font-weight: 700;
    letter-spacing: 0.08em;
    text-transform: uppercase;
}

.auth_kicker::before {
    content: "";
    width: 0.45rem;
    height: 0.45rem;
    border-radius: 999px;
    background: #c9872f;
}

.auth_visual_cards {
    display: grid;
    gap: 1rem;
    margin-top: 2.1rem;
}

.auth_visual_card {
    padding: 1.15rem 1.2rem;
    border-radius: 24px;
    background: rgba(255, 255, 255, 0.12);
    border: 1px solid rgba(255, 255, 255, 0.14);
    backdrop-filter: blur(10px);
}

.auth_visual_card strong {
    display: block;
    font-size: 1rem;
}

.auth_visual_card span {
    display: block;
    margin-top: 0.45rem;
    color: rgba(255, 255, 255, 0.8);
    line-height: 1.78;
}

.auth_login_panel {
    padding: 2.5rem 2.45rem;
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.auth_login_header h2 {
    margin: 0.9rem 0 0.45rem;
    color: #132433;
    font-size: 2rem;
}

.auth_login_header p {
    margin: 0;
    color: #617385;
    line-height: 1.8;
}

.auth_login_form {
    margin-top: 1.45rem;
}

.auth_login_form >>> .el-form-item__label {
    color: #617385;
    font-size: 0.88rem;
    font-weight: 700;
    padding-bottom: 4px;
}

.auth_login_form >>> .el-input__inner {
    min-height: 48px;
    border-radius: 16px;
    border: 1px solid rgba(15, 54, 80, 0.12);
    box-shadow: none;
    font-size: 14px;
}

.auth_login_form >>> .el-input__inner:focus {
    border-color: rgba(15, 95, 108, 0.4);
    box-shadow: 0 0 0 3px rgba(15, 95, 108, 0.12);
}

.auth_login_form >>> .el-input__prefix {
    display: flex;
    align-items: center;
    color: #617385;
}

.auth_verify_group {
    margin-top: 0.2rem;
    margin-bottom: 0.5rem;
}

.auth_verify_label {
    display: block;
    margin-bottom: 0.45rem;
    color: #617385;
    font-size: 0.88rem;
    font-weight: 700;
}

.auth_required {
    color: #f56c6c;
    margin-left: 2px;
}

.auth_verify_box {
    display: flex;
    align-items: center;
    min-height: 64px;
    padding: 0.7rem 0.85rem;
    border-radius: 18px;
    background: #f7fafc;
    border: 1px solid rgba(15, 54, 80, 0.08);
}

.auth_verify_box >>> .el-input__inner {
    border: none;
    background: transparent;
    box-shadow: none;
}

.auth_login_actions {
    margin-top: 1.4rem;
}

.auth_submit_btn {
    width: 100%;
    min-height: 48px;
    border-radius: 16px;
    font-size: 15px;
    font-weight: 600;
    background: linear-gradient(135deg, #0f5f6c, #1d7a86);
    border: none;
    letter-spacing: 0.04em;
}

.auth_submit_btn:hover {
    background: linear-gradient(135deg, #0d4f5a, #176a75);
}

.auth_secondary_actions {
    display: flex;
    justify-content: center;
    gap: 1rem;
    margin-top: 0.8rem;
}

.auth_text_btn {
    color: #617385;
    font-size: 13px;
}

.auth_text_btn:hover {
    color: #0f5f6c;
}

.auth_login_links {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.45rem;
    margin-top: 1.1rem;
    color: #617385;
    font-size: 14px;
}

.auth_inline_link {
    border: none;
    background: transparent;
    color: #0f5f6c;
    font-weight: 700;
    cursor: pointer;
    text-decoration: none;
}

.auth_inline_link:hover {
    text-decoration: underline;
}

.password_toggle {
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100%;
    padding-right: 4px;
}

.password_toggle svg {
    width: 16px;
    height: 16px;
}

@media (max-width: 980px) {
    .auth_login_shell {
        grid-template-columns: 1fr;
    }

    .auth_login_visual,
    .auth_login_panel {
        padding: 1.6rem;
    }

    .auth_login_visual h1 {
        font-size: 2.3rem;
    }
}

@media (max-width: 640px) {
    .auth_login_page {
        padding: 1rem 0.8rem;
    }

    .auth_login_shell {
        border-radius: 22px;
    }
}
</style>
