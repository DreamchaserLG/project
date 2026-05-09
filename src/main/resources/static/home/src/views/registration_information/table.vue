<template>
  <div class="profile_workspace_page" id="registration_information_table_page">
    <section class="page_intro_card" :style="bannerStyle">
      <span class="page_kicker">Registration Records</span>
      <h1>报名信息</h1>
      <p>统一查看当前用户的展位报名、候补顺位、审核状态和支付进度，保持原有操作入口不变。</p>
    </section>

    <div class="profile_workspace_grid">
      <aside class="profile_workspace_sidebar">
        <list_admin_menu_user></list_admin_menu_user>
      </aside>

      <section class="profile_workspace_content">
        <div class="profile_workspace_head">
          <div>
            <span class="page_kicker">Registration Table</span>
            <h2>报名记录列表</h2>
            <p>支持查询订单编号、报名用户、审核状态和支付状态，并保留原有取消报名、退款申请和行程确认操作。</p>
          </div>
        </div>

        <table_registration_information v-if="$check_action('/registration_information/table','get')"></table_registration_information>
      </section>
    </div>
  </div>
</template>

<script>
import list_admin_menu_user from "@/components/diy/list_admin_menu_user.vue";
import table_registration_information from "../../components/diy/table_registration_information.vue";

export default {
  components: {
    list_admin_menu_user,
    table_registration_information,
  },
  computed: {
    bannerStyle() {
      return {
        "--page-banner-image": "url(/img/theme/expo-floor.jpg)",
      };
    },
  },
};
</script>
