<template>
    <div id="app" :class="{ auth_page_shell: isAuthPage }" :style="{ paddingTop: appPaddingTop }">
        <page_header v-if="showChrome"/>
        <transition name="fade-transform" mode="out-in">
            <router-view :key="$route.fullPath"/>
        </transition>
        <page_footer v-if="showChrome"/>
		<div class="back_top" v-if="showBackTop && showChrome" @click="scrollToTop"><i class="el-icon-upload2"></i></div>
    </div>
</template>

<style lang='less'>
    @import "../public/css/base.css";
    @import "../public/css/theme.css";
    html,
    body {
      height: 100%;
      width: 100%;
    }

    #app {
      width: 100%;
      height: 100%;
      overflow-x: hidden;
    }

    #app.auth_page_shell {
      min-height: 100vh;
      background:
        radial-gradient(circle at top left, rgba(15, 95, 108, 0.14), transparent 30%),
        radial-gradient(circle at bottom right, rgba(201, 135, 47, 0.12), transparent 24%),
        linear-gradient(180deg, #f3f8fb 0%, #eef4f8 100%);
    }

    .page-item.active .page-link {
        background-color: var(--color_primary) !important;
        border-color: var(--color_primary) !important;
    }

    .btn-outline-primary {
        color: var(--color_primary) !important;
        border-color: var(--color_primary) !important;
    }

    //放大镜
    .mouse-cover-canvas {
        position: absolute;
        left: calc(50% - 6rem) !important;
        top: 8rem !important;
    }

    body {
        background: transparent !important;
        font-family: var(--font_body) !important;
        color: var(--color_text);
    }

    [class="col-"] {
        padding: 0;
    }

    .page_header {
        position: fixed;
        top: 0;
        z-index: 1000;
        width: 100%;
    }

    a {
        color: inherit !important;
        text-decoration: none;
        -webkit-transition: all 0.3s ease 0s;
        -o-transition: all 0.3s ease 0s;
        transition: all 0.3s ease 0s;
    }

    a:hover {
        text-decoration: none !important;
        /*color: var(--color_primary) !important;*/
        color: #909399 !important;
    }

    .toast {
        opacity: 1 !important;
        min-width: 200px;
    }

    .b-toaster-top-right {
        position: absolute;
        top: 8rem;
        left: 50%;
        transform: translate(-50%);
    }

    figure,
    p,
    h1,
    h2,
    h3,
    h4,
    h5,
    h6,
    ul,
    li {
        margin: 0;
        padding: 0;
    }

    .fade-transform-leave-active,
    .fade-transform-enter-active {
        transition: all 0.5s;
    }

    .fade-transform-enter {
        opacity: 0;
        transform: translateX(-30px);
    }

    .fade-transform-leave-to {
        opacity: 0;
        transform: translateX(30px);
    }
	.back_top {
		display: flex;
		justify-content: center;
		align-items: center;
		width: 30px;
		height: 30px;
		font-size: 20px;
		font-weight: 700;
		position: fixed;
		bottom: 100px;
		right: 50px;
		border-radius: 30px;
		background-color: #fff;
		cursor: pointer;
		z-index: 1100;
		box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
	}
	
    @import "../public/css/diy.css";

    @media (max-width: 960px) {
        #app {
            padding-top: 112px !important;
        }

        #app.auth_page_shell {
            padding-top: 0 !important;
        }
    }
</style>
<script>
export default {
  data() {
      return {
        showBackTop: false
      }
  },
  computed: {
  	isQrcode() {
      return this.$route.path.includes('/qrcodeDetails')
    },
    isAuthPage() {
      return this.$route.path.startsWith('/account/');
    },
    showChrome() {
      return !this.isQrcode && !this.isAuthPage;
    },
    appPaddingTop() {
      return this.showChrome ? '132px' : '0px';
    },
  },
  mounted() {
      window.addEventListener('scroll', this.handleScroll)
  },
  methods: {
      handleScroll() {
        this.showBackTop = window.scrollY > 400
      },
      scrollToTop() {
        window.scrollTo({
          top: 0,
          behavior:'smooth'
        })
      }
  },
  beforeDestroy() {
      window.removeEventListener('scroll', this.handleScroll)
  }
}
</script>
