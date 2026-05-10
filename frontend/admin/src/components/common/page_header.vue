<template>
    <header class="page_header">
        <div class="header_inner">
            <div class="header_left">
                <i class="el-icon-s-unfold header_toggle" @click="handleSideToggle"></i>
                <span class="header_brand">
                    <i class="el-icon-s-platform"></i>
                    会展管理系统
                </span>
            </div>
            <div class="header_right">
                <span class="header_user_group">{{ user_group }}</span>
                <span class="header_user_name">{{ nickname || username }}</span>
                <el-avatar
                    :size="36"
                    :src="avatar || defaultAvatar"
                    class="header_avatar"
                ></el-avatar>
                <el-dropdown trigger="click" @command="handleCommand">
                    <span class="header_dropdown">
                        <i class="el-icon-arrow-down"></i>
                    </span>
                    <el-dropdown-menu slot="dropdown">
                        <el-dropdown-item command="user_center">
                            <i class="el-icon-user"></i> 个人中心
                        </el-dropdown-item>
                        <el-dropdown-item command="home" v-if="user_group === '管理员'">
                            <i class="el-icon-house"></i> 用户端首页
                        </el-dropdown-item>
                        <el-dropdown-item divided command="logout">
                            <i class="el-icon-switch-button"></i> 退出登录
                        </el-dropdown-item>
                    </el-dropdown-menu>
                </el-dropdown>
            </div>
        </div>
    </header>
</template>

<script>
    export default {
        name: 'page_header',
        data() {
            return {
                defaultAvatar: 'data:image/svg+xml,' + encodeURIComponent(
                    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="50" fill="%23eaf7f7"/><circle cx="50" cy="38" r="16" fill="%230f5f6c"/><ellipse cx="50" cy="72" rx="26" ry="18" fill="%230f5f6c"/></svg>'
                ),
            }
        },
        computed: {
            avatar() {
                return this.$store.state.user.avatar;
            },
            nickname() {
                return this.$store.state.user.nickname;
            },
            username() {
                return this.$store.state.user.username;
            },
            user_group() {
                return this.$store.state.user.user_group;
            },
        },
        methods: {
            handleSideToggle() {
                this.$emit('toggle-sidebar');
            },
            handleCommand(cmd) {
                if (cmd === 'logout') {
                    this.$store.commit('user_set', {});
                    sessionStorage.clear();
                    this.$router.push('/login');
                } else if (cmd === 'user_center') {
                    this.$router.push('/user_center');
                } else if (cmd === 'home') {
                    let base = window.location.origin + window.location.pathname;
                    let homeUrl = base.replace('/admin/dist/', '/home/dist/').replace('/admin/dist', '/home/dist');
                    window.location.href = homeUrl;
                }
            }
        }
    }
</script>

<style scoped>
    .page_header {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        z-index: 900;
        height: 60px;
        background: linear-gradient(135deg, #093943 0%, #0f5f6c 100%);
        border-bottom: 1px solid rgba(255,255,255,0.08);
        box-shadow: 0 2px 12px rgba(9,57,67,0.18);
    }

    .header_inner {
        display: flex;
        align-items: center;
        justify-content: space-between;
        height: 100%;
        padding: 0 24px;
        max-width: var(--page_max_width);
        margin: 0 auto;
    }

    .header_left {
        display: flex;
        align-items: center;
        gap: 16px;
    }

    .header_toggle {
        font-size: 22px;
        color: rgba(255,255,255,0.85);
        cursor: pointer;
        transition: color 0.2s;
    }

    .header_toggle:hover {
        color: #fff;
    }

    .header_brand {
        display: flex;
        align-items: center;
        gap: 8px;
        color: #fff;
        font-size: 16px;
        font-weight: 600;
        letter-spacing: 0.02em;
    }

    .header_brand i {
        font-size: 20px;
    }

    .header_right {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .header_user_group {
        display: inline-flex;
        align-items: center;
        padding: 2px 10px;
        border-radius: 999px;
        background: rgba(201,135,47,0.25);
        color: #f7ead4;
        font-size: 12px;
        font-weight: 600;
        letter-spacing: 0.04em;
    }

    .header_user_name {
        color: rgba(255,255,255,0.9);
        font-size: 14px;
        font-weight: 500;
    }

    .header_avatar {
        border: 2px solid rgba(255,255,255,0.2);
        cursor: pointer;
    }

    .header_dropdown {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 28px;
        height: 28px;
        border-radius: 8px;
        background: rgba(255,255,255,0.1);
        color: rgba(255,255,255,0.8);
        cursor: pointer;
        transition: background 0.2s;
    }

    .header_dropdown:hover {
        background: rgba(255,255,255,0.18);
    }
</style>
