<template>
  <div class="page_search search_index">
	<div class="warp">
	  <div class="container">
		<div class="row">
		  <div class="col-12">
			<div class="card_result_search">
			  <div class="title">搜索结果</div>

				<!-- 文章搜索结果 -->
			  <list_result_search
				:list="result_article"
				title="会展资讯"
				source_table="article"
			  ></list_result_search>


						  <list_result_search
				v-if="$check_action('/regular_user/list', 'get')"
				:list="result_regular_user_user_name"
				title="普通用户用户姓名"
				source_table="regular_user"
			  ></list_result_search>
								  <list_result_search
				v-if="$check_action('/regular_user/list', 'get')"
				:list="result_regular_user_users_mobile_phone"
				title="普通用户用户手机"
				source_table="regular_user"
			  ></list_result_search>
									  <list_result_search
				v-if="$check_action('/host_user/list', 'get')"
				:list="result_host_user_company_name"
				title="主办用户企业名称"
				source_table="host_user"
			  ></list_result_search>
								  <list_result_search
				v-if="$check_action('/host_user/list', 'get')"
				:list="result_host_user_company_phone"
				title="主办用户企业电话"
				source_table="host_user"
			  ></list_result_search>
															  <list_result_search
				v-if="$check_action('/exhibition_information/list', 'get')"
				:list="result_exhibition_information_exhibition_theme"
				title="会展信息会展主题"
				source_table="exhibition_information"
			  ></list_result_search>
								  <list_result_search
				v-if="$check_action('/exhibition_information/list', 'get')"
				:list="result_exhibition_information_exhibition_and_convention_types"
				title="会展信息会展类型"
				source_table="exhibition_information"
			  ></list_result_search>
																																													  <list_result_search
				v-if="$check_action('/booth_information/list', 'get')"
				:list="result_booth_information_booth_name"
				title="展位信息展位名称"
				source_table="booth_information"
			  ></list_result_search>
								  <list_result_search
				v-if="$check_action('/booth_information/list', 'get')"
				:list="result_booth_information_booth_type"
				title="展位信息展位类型"
				source_table="booth_information"
			  ></list_result_search>
																								  <list_result_search
				v-if="$check_action('/registration_information/list', 'get')"
				:list="result_registration_information_order_number"
				title="报名信息订单编号"
				source_table="registration_information"
			  ></list_result_search>
																																  <list_result_search
				v-if="$check_action('/registration_information/list', 'get')"
				:list="result_registration_information_user_name"
				title="报名信息用户姓名"
				source_table="registration_information"
			  ></list_result_search>
																											  <list_result_search
				v-if="$check_action('/travel_confirmation/list', 'get')"
				:list="result_travel_confirmation_order_number"
				title="行程确认订单编号"
				source_table="travel_confirmation"
			  ></list_result_search>
																							  <list_result_search
				v-if="$check_action('/travel_confirmation/list', 'get')"
				:list="result_travel_confirmation_user_name"
				title="行程确认用户姓名"
				source_table="travel_confirmation"
			  ></list_result_search>
																		  <list_result_search
				v-if="$check_action('/refund_request/list', 'get')"
				:list="result_refund_request_order_number"
				title="退款申请订单编号"
				source_table="refund_request"
			  ></list_result_search>
																	  <list_result_search
				v-if="$check_action('/refund_request/list', 'get')"
				:list="result_refund_request_user_name"
				title="退款申请用户姓名"
				source_table="refund_request"
			  ></list_result_search>
																					  <list_result_search
				v-if="$check_action('/message_notification/list', 'get')"
				:list="result_message_notification_notice_title"
				title="消息通知通知标题"
				source_table="message_notification"
			  ></list_result_search>
																				  <list_result_search
				v-if="$check_action('/message_notification/list', 'get')"
				:list="result_message_notification_mark_status"
				title="消息通知标记状态"
				source_table="message_notification"
			  ></list_result_search>
									  <list_result_search
				v-if="$check_action('/exhibition_announcement/list', 'get')"
				:list="result_exhibition_announcement_announcement_title"
				title="会展公告公告标题"
				source_table="exhibition_announcement"
			  ></list_result_search>
								  <list_result_search
				v-if="$check_action('/exhibition_announcement/list', 'get')"
				:list="result_exhibition_announcement_announcement_type"
				title="会展公告公告类型"
				source_table="exhibition_announcement"
			  ></list_result_search>
																														  <list_result_search
				v-if="$check_action('/data_statistics/list', 'get')"
				:list="result_data_statistics_statistics_type"
				title="数据统计统计类型"
				source_table="data_statistics"
			  ></list_result_search>
								  <list_result_search
				v-if="$check_action('/data_statistics/list', 'get')"
				:list="result_data_statistics_statistical_indicators"
				title="数据统计统计指标"
				source_table="data_statistics"
			  ></list_result_search>
															</div>
		  </div>
		</div>
	  </div>
	</div>
  </div>
</template>

<script>
import mixin from "../../mixins/page.js";
import list_result_search from "../../components/diy/list_result_search.vue";

export default {
  mixins: [mixin],
  data() {
	return {
	  "query": {
		word: "",
	  },
	  "result_article": [],
						"result_regular_user_user_name":[],
								"result_regular_user_users_mobile_phone":[],
									"result_host_user_company_name":[],
								"result_host_user_company_phone":[],
															"result_exhibition_information_exhibition_theme":[],
								"result_exhibition_information_exhibition_and_convention_types":[],
																																													"result_booth_information_booth_name":[],
								"result_booth_information_booth_type":[],
																								"result_registration_information_order_number":[],
																																"result_registration_information_user_name":[],
																											"result_travel_confirmation_order_number":[],
																							"result_travel_confirmation_user_name":[],
																		"result_refund_request_order_number":[],
																	"result_refund_request_user_name":[],
																					"result_message_notification_notice_title":[],
																				"result_message_notification_mark_status":[],
									"result_exhibition_announcement_announcement_title":[],
								"result_exhibition_announcement_announcement_type":[],
																														"result_data_statistics_statistics_type":[],
								"result_data_statistics_statistical_indicators":[],
													};
  },
  methods: {
	/**
	 * 获取文章
	 */
	get_article() {
	  this.$get("~/api/article/get_list", { page: 1, size: 10, title: this.query.word }, (json) => {
		if (json.result) {
		  this.result_article = json.result.list;
		}
	  });
	},

				/**
	 * 获取user_name
	 */
	get_regular_user_user_name(){
		let url = "~/api/regular_user/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"user_name": this.query.word,
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_regular_user_user_name = json.result.list;
			result_regular_user_user_name.map(o => o.title = o['user_name'])
	  			this.result_regular_user_user_name = result_regular_user_user_name
		 	}
		});
	},
						/**
	 * 获取users_mobile_phone
	 */
	get_regular_user_users_mobile_phone(){
		let url = "~/api/regular_user/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"users_mobile_phone": this.query.word,
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_regular_user_users_mobile_phone = json.result.list;
			result_regular_user_users_mobile_phone.map(o => o.title = o['users_mobile_phone'])
	  			this.result_regular_user_users_mobile_phone = result_regular_user_users_mobile_phone
		 	}
		});
	},
							/**
	 * 获取company_name
	 */
	get_host_user_company_name(){
		let url = "~/api/host_user/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"company_name": this.query.word,
						examine_state: "已通过",
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_host_user_company_name = json.result.list;
			result_host_user_company_name.map(o => o.title = o['company_name'])
	  			this.result_host_user_company_name = result_host_user_company_name
		 	}
		});
	},
						/**
	 * 获取company_phone
	 */
	get_host_user_company_phone(){
		let url = "~/api/host_user/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"company_phone": this.query.word,
						examine_state: "已通过",
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_host_user_company_phone = json.result.list;
			result_host_user_company_phone.map(o => o.title = o['company_phone'])
	  			this.result_host_user_company_phone = result_host_user_company_phone
		 	}
		});
	},
													/**
	 * 获取exhibition_theme
	 */
	get_exhibition_information_exhibition_theme(){
		let url = "~/api/exhibition_information/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"exhibition_theme": this.query.word,
						examine_state: "已通过",
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_exhibition_information_exhibition_theme = json.result.list;
			result_exhibition_information_exhibition_theme.map(o => o.title = o['exhibition_theme'])
	  			this.result_exhibition_information_exhibition_theme = result_exhibition_information_exhibition_theme
		 	}
		});
	},
						/**
	 * 获取exhibition_and_convention_types
	 */
	get_exhibition_information_exhibition_and_convention_types(){
		let url = "~/api/exhibition_information/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"exhibition_and_convention_types": this.query.word,
						examine_state: "已通过",
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_exhibition_information_exhibition_and_convention_types = json.result.list;
			result_exhibition_information_exhibition_and_convention_types.map(o => o.title = o['exhibition_and_convention_types'])
	  			this.result_exhibition_information_exhibition_and_convention_types = result_exhibition_information_exhibition_and_convention_types
		 	}
		});
	},
																																											/**
	 * 获取booth_name
	 */
	get_booth_information_booth_name(){
		let url = "~/api/booth_information/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"booth_name": this.query.word,
						examine_state: "已通过",
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_booth_information_booth_name = json.result.list;
			result_booth_information_booth_name.map(o => o.title = o['booth_name'])
	  			this.result_booth_information_booth_name = result_booth_information_booth_name
		 	}
		});
	},
						/**
	 * 获取booth_type
	 */
	get_booth_information_booth_type(){
		let url = "~/api/booth_information/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"booth_type": this.query.word,
						examine_state: "已通过",
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_booth_information_booth_type = json.result.list;
			result_booth_information_booth_type.map(o => o.title = o['booth_type'])
	  			this.result_booth_information_booth_type = result_booth_information_booth_type
		 	}
		});
	},
																						/**
	 * 获取order_number
	 */
	get_registration_information_order_number(){
		let url = "~/api/registration_information/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"order_number": this.query.word,
						examine_state: "已通过",
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_registration_information_order_number = json.result.list;
			result_registration_information_order_number.map(o => o.title = o['order_number'])
	  			this.result_registration_information_order_number = result_registration_information_order_number
		 	}
		});
	},
																														/**
	 * 获取user_name
	 */
	get_registration_information_user_name(){
		let url = "~/api/registration_information/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"user_name": this.query.word,
						examine_state: "已通过",
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_registration_information_user_name = json.result.list;
			result_registration_information_user_name.map(o => o.title = o['user_name'])
	  			this.result_registration_information_user_name = result_registration_information_user_name
		 	}
		});
	},
																									/**
	 * 获取order_number
	 */
	get_travel_confirmation_order_number(){
		let url = "~/api/travel_confirmation/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"order_number": this.query.word,
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_travel_confirmation_order_number = json.result.list;
			result_travel_confirmation_order_number.map(o => o.title = o['order_number'])
	  			this.result_travel_confirmation_order_number = result_travel_confirmation_order_number
		 	}
		});
	},
																					/**
	 * 获取user_name
	 */
	get_travel_confirmation_user_name(){
		let url = "~/api/travel_confirmation/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"user_name": this.query.word,
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_travel_confirmation_user_name = json.result.list;
			result_travel_confirmation_user_name.map(o => o.title = o['user_name'])
	  			this.result_travel_confirmation_user_name = result_travel_confirmation_user_name
		 	}
		});
	},
																/**
	 * 获取order_number
	 */
	get_refund_request_order_number(){
		let url = "~/api/refund_request/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"order_number": this.query.word,
						examine_state: "已通过",
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_refund_request_order_number = json.result.list;
			result_refund_request_order_number.map(o => o.title = o['order_number'])
	  			this.result_refund_request_order_number = result_refund_request_order_number
		 	}
		});
	},
															/**
	 * 获取user_name
	 */
	get_refund_request_user_name(){
		let url = "~/api/refund_request/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"user_name": this.query.word,
						examine_state: "已通过",
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_refund_request_user_name = json.result.list;
			result_refund_request_user_name.map(o => o.title = o['user_name'])
	  			this.result_refund_request_user_name = result_refund_request_user_name
		 	}
		});
	},
																			/**
	 * 获取notice_title
	 */
	get_message_notification_notice_title(){
		let url = "~/api/message_notification/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"notice_title": this.query.word,
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_message_notification_notice_title = json.result.list;
			result_message_notification_notice_title.map(o => o.title = o['notice_title'])
	  			this.result_message_notification_notice_title = result_message_notification_notice_title
		 	}
		});
	},
																		/**
	 * 获取mark_status
	 */
	get_message_notification_mark_status(){
		let url = "~/api/message_notification/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"mark_status": this.query.word,
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_message_notification_mark_status = json.result.list;
			result_message_notification_mark_status.map(o => o.title = o['mark_status'])
	  			this.result_message_notification_mark_status = result_message_notification_mark_status
		 	}
		});
	},
							/**
	 * 获取announcement_title
	 */
	get_exhibition_announcement_announcement_title(){
		let url = "~/api/exhibition_announcement/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"announcement_title": this.query.word,
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_exhibition_announcement_announcement_title = json.result.list;
			result_exhibition_announcement_announcement_title.map(o => o.title = o['announcement_title'])
	  			this.result_exhibition_announcement_announcement_title = result_exhibition_announcement_announcement_title
		 	}
		});
	},
						/**
	 * 获取announcement_type
	 */
	get_exhibition_announcement_announcement_type(){
		let url = "~/api/exhibition_announcement/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"announcement_type": this.query.word,
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_exhibition_announcement_announcement_type = json.result.list;
			result_exhibition_announcement_announcement_type.map(o => o.title = o['announcement_type'])
	  			this.result_exhibition_announcement_announcement_type = result_exhibition_announcement_announcement_type
		 	}
		});
	},
																												/**
	 * 获取statistics_type
	 */
	get_data_statistics_statistics_type(){
		let url = "~/api/data_statistics/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"statistics_type": this.query.word,
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_data_statistics_statistics_type = json.result.list;
			result_data_statistics_statistics_type.map(o => o.title = o['statistics_type'])
	  			this.result_data_statistics_statistics_type = result_data_statistics_statistics_type
		 	}
		});
	},
						/**
	 * 获取statistical_indicators
	 */
	get_data_statistics_statistical_indicators(){
		let url = "~/api/data_statistics/get_list";
		let params = { 
			page: 1,
		 	size: 10,
			"statistical_indicators": this.query.word,
					};
		this.$get(url, params, (json) => {
		  if (json.result) {
			var result_data_statistics_statistical_indicators = json.result.list;
			result_data_statistics_statistical_indicators.map(o => o.title = o['statistical_indicators'])
	  			this.result_data_statistics_statistical_indicators = result_data_statistics_statistical_indicators
		 	}
		});
	},
												
  },
  components: { list_result_search },
	created(){
    this.query.word = this.$route.query.word || "";
  },
  mounted() {
	this.get_article();
					this.get_regular_user_user_name();
							this.get_regular_user_users_mobile_phone();
								this.get_host_user_company_name();
							this.get_host_user_company_phone();
														this.get_exhibition_information_exhibition_theme();
							this.get_exhibition_information_exhibition_and_convention_types();
																																												this.get_booth_information_booth_name();
							this.get_booth_information_booth_type();
																							this.get_registration_information_order_number();
																															this.get_registration_information_user_name();
																										this.get_travel_confirmation_order_number();
																						this.get_travel_confirmation_user_name();
																	this.get_refund_request_order_number();
																this.get_refund_request_user_name();
																				this.get_message_notification_notice_title();
																			this.get_message_notification_mark_status();
								this.get_exhibition_announcement_announcement_title();
							this.get_exhibition_announcement_announcement_type();
																													this.get_data_statistics_statistics_type();
							this.get_data_statistics_statistical_indicators();
												  },
  watch: {
	$route() {
	  $.push(this.query, this.$route.query);
	  this.get_article();
				  this.get_regular_user_user_name();
						  this.get_regular_user_users_mobile_phone();
							  this.get_host_user_company_name();
						  this.get_host_user_company_phone();
													  this.get_exhibition_information_exhibition_theme();
						  this.get_exhibition_information_exhibition_and_convention_types();
																																											  this.get_booth_information_booth_name();
						  this.get_booth_information_booth_type();
																						  this.get_registration_information_order_number();
																														  this.get_registration_information_user_name();
																									  this.get_travel_confirmation_order_number();
																					  this.get_travel_confirmation_user_name();
																  this.get_refund_request_order_number();
															  this.get_refund_request_user_name();
																			  this.get_message_notification_notice_title();
																		  this.get_message_notification_mark_status();
							  this.get_exhibition_announcement_announcement_title();
						  this.get_exhibition_announcement_announcement_type();
																												  this.get_data_statistics_statistics_type();
						  this.get_data_statistics_statistical_indicators();
													},
  },
};
</script>

<style scoped>
.card_search {
  text-align: center;
}
.card_result_search>.title {
  text-align: center;
  padding: 10px 0;
}
</style>
