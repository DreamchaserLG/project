<template>
	<el-main class="bg edit_wrap">
		<el-form ref="form" :model="form" :rules="rules" status-icon label-width="120px" v-if="is_view()">
		<el-row class="row_ce">
												<el-col v-if="$check_field('get','order_number') || $check_field('add','order_number') || $check_field('set','order_number')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="订单编号" prop="order_number">
												<el-input id="order_number" v-model="form['order_number']" placeholder="请输入订单编号"
							v-if="(form['registration_information_id'] && $check_field('set','order_number')) || (!form['registration_information_id'] && $check_field('add','order_number'))" :disabled="true">
									</el-input>
					<div v-else-if="$check_field('get','order_number')">
						{{form['order_number']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','booth_number') || $check_field('add','booth_number') || $check_field('set','booth_number')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="展位编号" prop="booth_number">
												<el-input id="booth_number" v-model="form['booth_number']" placeholder="请输入展位编号"
							v-if="(form['registration_information_id'] && $check_field('set','booth_number')) || (!form['registration_information_id'] && $check_field('add','booth_number'))" :disabled="disabledObj['booth_number_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','booth_number')">
						{{form['booth_number']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','exhibitionconvention_number') || $check_field('add','exhibitionconvention_number') || $check_field('set','exhibitionconvention_number')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="会展编号" prop="exhibitionconvention_number">
												<el-input id="exhibitionconvention_number" v-model="form['exhibitionconvention_number']" placeholder="请输入会展编号"
							v-if="(form['registration_information_id'] && $check_field('set','exhibitionconvention_number')) || (!form['registration_information_id'] && $check_field('add','exhibitionconvention_number'))" :disabled="disabledObj['exhibitionconvention_number_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','exhibitionconvention_number')">
						{{form['exhibitionconvention_number']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','exhibition_theme') || $check_field('add','exhibition_theme') || $check_field('set','exhibition_theme')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="会展主题" prop="exhibition_theme">
												<el-input id="exhibition_theme" v-model="form['exhibition_theme']" placeholder="请输入会展主题"
							v-if="(form['registration_information_id'] && $check_field('set','exhibition_theme')) || (!form['registration_information_id'] && $check_field('add','exhibition_theme'))" :disabled="disabledObj['exhibition_theme_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','exhibition_theme')">
						{{form['exhibition_theme']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','host_user') || $check_field('add','host_user') || $check_field('set','host_user')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="主办用户" prop="host_user">
													<el-select v-if="(form['registration_information_id'] && $check_field('set','host_user')) || (!form['registration_information_id'] && $check_field('add','host_user'))" id="host_user" v-model="form['host_user']" :disabled="disabledObj['host_user_isDisabled']">
							<el-option v-for="o in list_user_host_user" :key="o['username']" :label="formatUserDisplay(o)"
									   :value="o['user_id']">
							</el-option>
						</el-select>
						<el-select v-else-if="$check_field('get','host_user')" id="host_user" v-model="form['host_user']" :disabled="true">
							<el-option v-for="o in list_user_host_user" :key="o['username']" :label="formatUserDisplay(o)"
									   :value="o['user_id']">
							</el-option>
						</el-select>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','booth_name') || $check_field('add','booth_name') || $check_field('set','booth_name')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="展位名称" prop="booth_name">
												<el-input id="booth_name" v-model="form['booth_name']" placeholder="请输入展位名称"
							v-if="(form['registration_information_id'] && $check_field('set','booth_name')) || (!form['registration_information_id'] && $check_field('add','booth_name'))" :disabled="disabledObj['booth_name_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','booth_name')">
						{{form['booth_name']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','booth_type') || $check_field('add','booth_type') || $check_field('set','booth_type')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="展位类型" prop="booth_type">
												<el-input id="booth_type" v-model="form['booth_type']" placeholder="请输入展位类型"
							v-if="(form['registration_information_id'] && $check_field('set','booth_type')) || (!form['registration_information_id'] && $check_field('add','booth_type'))" :disabled="disabledObj['booth_type_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','booth_type')">
						{{form['booth_type']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','booth_prices') || $check_field('add','booth_prices') || $check_field('set','booth_prices')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="展位价格" prop="booth_prices">
								<el-input-number id="booth_prices" v-model.number="form['booth_prices']"
						v-if="(form['registration_information_id'] && $check_field('set','booth_prices')) || (!form['registration_information_id'] && $check_field('add','booth_prices'))" :disabled="disabledObj['booth_prices_isDisabled']"></el-input-number>
					<span v-else-if="$check_field('get','booth_prices')">{{form['booth_prices']}}</span>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','enrolled_user') || $check_field('add','enrolled_user') || $check_field('set','enrolled_user')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="报名用户" prop="enrolled_user">
																		<div v-if="user_group !== '管理员'">
							{{ get_user_session_enrolled_user(form['enrolled_user']) }}
							<el-select v-if="(form['registration_information_id'] && $check_field('set','enrolled_user')) || (!form['registration_information_id'] && $check_field('add','enrolled_user'))" id="enrolled_user" v-model="form['enrolled_user']" :disabled="disabledObj['enrolled_user_isDisabled']">
								<el-option v-for="o in list_user_enrolled_user" :key="o['username']" :label="formatUserDisplay(o)"
										   :value="o['user_id']">
								</el-option>
							</el-select>
							<el-select v-else-if="$check_field('get','enrolled_user')" id="enrolled_user" v-model="form['enrolled_user']" :disabled="true">
								<el-option v-for="o in list_user_enrolled_user" :key="o['username']" :label="formatUserDisplay(o)"
										   :value="o['user_id']">
								</el-option>
							</el-select>
						</div>
						<el-select v-else id="enrolled_user" v-model="form['enrolled_user']" :disabled="disabledObj['enrolled_user_isDisabled']">
							<el-option v-for="o in list_user_enrolled_user" :key="o['username']" :label="formatUserDisplay(o)"
									   :value="o['user_id']">
							</el-option>
						</el-select>
																			</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','user_name') || $check_field('add','user_name') || $check_field('set','user_name')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="用户姓名" prop="user_name">
												<el-input id="user_name" v-model="form['user_name']" placeholder="请输入用户姓名"
							v-if="(form['registration_information_id'] && $check_field('set','user_name')) || (!form['registration_information_id'] && $check_field('add','user_name'))" :disabled="disabledObj['user_name_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','user_name')">
						{{form['user_name']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','users_mobile_phone') || $check_field('add','users_mobile_phone') || $check_field('set','users_mobile_phone')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="用户手机" prop="users_mobile_phone">
												<el-input id="users_mobile_phone" v-model="form['users_mobile_phone']" placeholder="请输入用户手机"
							v-if="(form['registration_information_id'] && $check_field('set','users_mobile_phone')) || (!form['registration_information_id'] && $check_field('add','users_mobile_phone'))" :disabled="disabledObj['users_mobile_phone_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','users_mobile_phone')">
						{{form['users_mobile_phone']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','number_of_registrations') || $check_field('add','number_of_registrations') || $check_field('set','number_of_registrations')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="报名人数" prop="number_of_registrations">
								<el-input-number id="number_of_registrations" v-model.number="form['number_of_registrations']" :min="1" :step="1" step-strictly
						v-if="(form['registration_information_id'] && $check_field('set','number_of_registrations')) || (!form['registration_information_id'] && $check_field('add','number_of_registrations'))" :disabled="disabledObj['number_of_registrations_isDisabled']"></el-input-number>
					<span v-else-if="$check_field('get','number_of_registrations')">{{form['number_of_registrations']}}</span>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','enterprise_qualifications') || $check_field('add','enterprise_qualifications') || $check_field('set','enterprise_qualifications')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="企业资质" prop="enterprise_qualifications">
												<div v-if="disabledObj['enterprise_qualifications_isDisabled']">
						<div v-if="$check_field('get','enterprise_qualifications')">
							<el-button type="primary" @click="$download($fullUrl(form['enterprise_qualifications']),form['enterprise_qualifications'])">下载<i
									class="el-icon-download el-icon--right"></i></el-button>
						</div>
					</div>
					<div v-else>
						<el-upload v-if="(form['registration_information_id'] && $check_field('set','enterprise_qualifications')) || (!form['registration_information_id'] && $check_field('add','enterprise_qualifications'))" class="upload-demo" :file-list="enterprise_qualifications_FileList" :on-preview="openPreview" :on-remove="enterprise_qualificationsRemove" drag
								   action="" style="max-width: 300px;width: 100%;" :http-request="upload_enterprise_qualifications" :limit="1" accept="">
							<i class="el-icon-upload"></i>
							<div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
						</el-upload>
						<div v-else-if="$check_field('get','enterprise_qualifications')">
							<el-button type="primary" @click="$download($fullUrl(form['enterprise_qualifications']),form['enterprise_qualifications'])">下载<i
									class="el-icon-download el-icon--right"></i></el-button>
						</div>
					</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','registration_notes') || $check_field('add','registration_notes') || $check_field('set','registration_notes')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="报名备注" prop="registration_notes">
								<el-input type="textarea" id="registration_notes" v-model="form['registration_notes']" placeholder="请输入报名备注"
						v-if="(form['registration_information_id'] && $check_field('set','registration_notes')) || (!form['registration_information_id'] && $check_field('add','registration_notes'))" :disabled="disabledObj['registration_notes_isDisabled']"></el-input>
					<div v-else-if="$check_field('get','registration_notes')">{{form['registration_notes']}}</div>
										</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','site_plan') || $check_field('add','site_plan') || $check_field('set','site_plan')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="场地平面图" prop="site_plan">
								<el-upload :disabled="disabledObj['site_plan_isDisabled']" class="avatar-uploader" drag
						accept="image/gif, image/jpeg, image/png, image/jpg" action="" :http-request="upload_site_plan"
						:show-file-list="false" v-if="(form['registration_information_id'] && $check_field('set','site_plan')) || (!form['registration_information_id'] && $check_field('add','site_plan'))">
						<img id="site_plan" v-if="form['site_plan']" :src="$fullUrl(form['site_plan'])" class="avatar">
						<i v-else class="el-icon-plus avatar-uploader-icon"></i>
					</el-upload>
					<el-image v-else-if="$check_field('get','site_plan')" style="width: 100px; height: 100px"
						:src="$fullUrl(form['site_plan'])" :preview-src-list="[$fullUrl(form['site_plan'])]">
						<div slot="error" class="image-slot">
							<img src="../../../public/img/error.png" style="width: 90px; height: 90px" />
						</div>
					</el-image>
										</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','exhibitor_documents') || $check_field('add','exhibitor_documents') || $check_field('set','exhibitor_documents')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="参展文件" prop="exhibitor_documents">
												<div v-if="disabledObj['exhibitor_documents_isDisabled']">
						<div v-if="$check_field('get','exhibitor_documents')">
							<el-button type="primary" @click="$download($fullUrl(form['exhibitor_documents']),form['exhibitor_documents'])">下载<i
									class="el-icon-download el-icon--right"></i></el-button>
						</div>
					</div>
					<div v-else>
						<el-upload v-if="(form['registration_information_id'] && $check_field('set','exhibitor_documents')) || (!form['registration_information_id'] && $check_field('add','exhibitor_documents'))" class="upload-demo" :file-list="exhibitor_documents_FileList" :on-preview="openPreview" :on-remove="exhibitor_documentsRemove" drag
								   action="" style="max-width: 300px;width: 100%;" :http-request="upload_exhibitor_documents" :limit="1" accept="">
							<i class="el-icon-upload"></i>
							<div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
						</el-upload>
						<div v-else-if="$check_field('get','exhibitor_documents')">
							<el-button type="primary" @click="$download($fullUrl(form['exhibitor_documents']),form['exhibitor_documents'])">下载<i
									class="el-icon-download el-icon--right"></i></el-button>
						</div>
					</div>
														</el-form-item>
			</el-col>
											<el-col :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="审核状态" prop="examine_state">
					<el-select id="examine_state" v-model="form['examine_state']"
						v-if="(form['examine_state'] && $check_examine()) || (!form['examine_state'] && $check_examine())" :disabled="true">
						<el-option key="未审核" label="未审核" value="未审核"></el-option>
						<el-option key="已通过" label="已通过" value="已通过"></el-option>
						<el-option key="未通过" label="未通过" value="未通过"></el-option>
					</el-select>
					<div v-else>{{form["examine_state"]}}</div>
				</el-form-item>
			</el-col>
					<el-col :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="审核回复" prop="examine_reply">
					<el-input id="examine_reply" v-model="form['examine_reply']" placeholder="请输入审核回复"
						v-if="(form['examine_reply'] && $check_examine()) || (!form['examine_reply'] && $check_examine())" :disabled="true"></el-input>
					<div v-else>{{form["examine_reply"]}}</div>
				</el-form-item>
			</el-col>
	
	
	
	
		
		
						<el-col :xs="24" :sm="12" :lg="8" class="el_form_item_warp" v-if="!form['source_user_id'] && 1 > 0 && $check_option('/registration_information/view','can_limits')">
			  <el-form-item label="行程确认限次">
				<el-input id="limit_times" v-model="form['travel_confirmation_limit_times']" placeholder="行程确认限制次数，0为不限"
						  v-if="$check_action('/registration_information/view','set')"
				></el-input>
				<div v-else-if="$check_action('/registration_information/view','get')" v-html="form['travel_confirmation_limit_times']"></div>
			  </el-form-item>
			</el-col>
					<el-col :xs="24" :sm="12" :lg="8" class="el_form_item_warp" v-if="!form['source_user_id'] && 1 > 0 && $check_option('/registration_information/view','can_limits')">
			  <el-form-item label="退款申请限次">
				<el-input id="limit_times" v-model="form['refund_request_limit_times']" placeholder="退款申请限制次数，0为不限"
						  v-if="$check_action('/registration_information/view','set')"
				></el-input>
				<div v-else-if="$check_action('/registration_information/view','get')" v-html="form['refund_request_limit_times']"></div>
			  </el-form-item>
			</el-col>
			
	
	
		
		</el-row>
					<el-col :xs="24" :sm="12" :lg="8" class="el_form_btn_warp">
				<el-form-item v-if="$check_action('/registration_information/view','set') || $check_action('/registration_information/view','add')">
					<el-button type="primary" @click="submit()">提交</el-button>
					<el-button @click="cancel()">取消</el-button>
				</el-form-item>
				<el-form-item v-else>
					<el-button @click="cancel()">返回</el-button>
				</el-form-item>
			</el-col>

		</el-form>
	</el-main>
</template>

<script>
	import mixin from "@/mixins/page.js";
																                                																
	export default {
		mixins: [mixin],
		components: {
																																																																																				},
		data() {
			return {
				field: "registration_information_id",
				url_add: "~/api/registration_information/add?",
				url_set: "~/api/registration_information/set?",
				url_get_obj: "~/api/registration_information/get_obj?",
				url_get_list: "~/api/registration_information/get_list?",
				url_upload: "~/api/registration_information/upload?",

				query: {
					"registration_information_id": 0,
					like: 0,
				},
				rules: {
																																																																																																																																																								},
				form: {
								"order_number": this.$get_stamp(), // 订单编号
										"booth_number":  '', // 展位编号
										"exhibitionconvention_number":  '', // 会展编号
										"exhibition_theme":  '', // 会展主题
										"host_user": 0, // 主办用户
										"booth_name":  '', // 展位名称
										"booth_type":  '', // 展位类型
										"booth_prices":  0, // 展位价格
										"enrolled_user": 0, // 报名用户
										"user_name":  '', // 用户姓名
										"users_mobile_phone":  '', // 用户手机
										"number_of_registrations":  1, // 报名人数
										"enterprise_qualifications":  '', // 企业资质
										"registration_notes":  '', // 报名备注
										"site_plan":  '', // 场地平面图
										"exhibitor_documents":  '', // 参展文件
										"examine_state": "未审核",
							"examine_reply": "",
							"registration_information_id": 0, // ID
													"travel_confirmation_limit_times": 1, // 行程确认限制次数
							"refund_request_limit_times": 1, // 退款申请限制次数
										"create_by": this.$store.state.user.user_id,
						},
				disabledObj:{
								"order_number_isDisabled": false,
										"booth_number_isDisabled": false,
										"exhibitionconvention_number_isDisabled": false,
										"exhibition_theme_isDisabled": false,
										"host_user_isDisabled": false,
										"booth_name_isDisabled": false,
										"booth_type_isDisabled": false,
					          			"booth_prices_isDisabled": false,
										"enrolled_user_isDisabled": false,
										"user_name_isDisabled": false,
										"users_mobile_phone_isDisabled": false,
					          			"number_of_registrations_isDisabled": false,
										"enterprise_qualifications_isDisabled": false,
										"registration_notes_isDisabled": false,
										"site_plan_isDisabled": false,
										"exhibitor_documents_isDisabled": false,
										},


																																			// 用户列表
				list_user_host_user: [],
																																			// 用户列表
				list_user_enrolled_user: [],
						// 用户组
				group_user_enrolled_user: "",
																																		enterprise_qualifications_FileList: [],
																										exhibitor_documents_FileList: [],
						
																			}
		},
		computed: {
			aiForm() {
				let form = {
																																																																																																																																																														};
				return form;
			},
																				},
		methods: {
																																	  openPreview(file) {
	    window.open(file.url)
	  },
		
	
					
	
					
	
					
	
					
	
				/**
			 * 获取主办用户用户列表
			 */
			async get_list_user_host_user() {
                var json = await this.$get("~/api/user/get_list?user_group=主办用户");
                if(json.result && json.result.list){
                    this.list_user_host_user = json.result.list;
                }
                else if(json.error){
                    console.error(json.error);
                }
			},
			formatUserDisplay(obj){
				if (!obj) {
					return "";
				}
				const nickname = String(obj.nickname || "").trim();
				const username = String(obj.username || "").trim();
				if (nickname && username && nickname !== username) {
					return nickname + "-" + username;
				}
				return nickname || username;
			},
					get_user_host_user(id){
				var obj = this.list_user_host_user.getObj({"user_id":id});
				var ret = "";
				if(obj){
					ret = this.formatUserDisplay(obj);
				}
				return ret;
			},
					
	
					
	
					
	
					
	
				/**
			 * 获取普通用户用户列表
			 */
			async get_list_user_enrolled_user() {
                var json = await this.$get("~/api/user/get_list?user_group=普通用户");
                if(json.result && json.result.list){
                    this.list_user_enrolled_user = json.result.list;
                }
                else if(json.error){
                    console.error(json.error);
                }
			},
					/**
			 * 获取普通用户用户组
			 */
			async get_group_user_enrolled_user() {
							this.form["enrolled_user"] = this.$store.state.user.user_id;
							var json = await this.$get("~/api/user_group/get_obj?name=普通用户");
				if(json.result && json.result.obj){
					this.group_user_enrolled_user = json.result.obj;
				}
				else if(json.error){
					console.error(json.error);
				}
			},
			get_user_session_enrolled_user(id){
				var _this = this;
				var user_id = {"user_id":id}
				var url = "~/api/"+_this.group_user_enrolled_user.source_table+"/get_obj?"
				this.$get(url, user_id, function(res) {
					if (res.result && res.result.obj) {
						var arr = []
						for (let key in res.result.obj) {
							arr.push(key)
						}
						var arrForm = []
									for (let key in _this.form) {
							arrForm.push(key)
						}
												_this.form["enrolled_user"] = id
									_this.disabledObj['enrolled_user' + '_isDisabled'] = true
						for (var i=0;i<arr.length;i++){
						  if (arr[i]!=='examine_state' && arr[i]!=='examine_reply') {
							for (var j = 0; j < arrForm.length; j++) {
							  if (arr[i] === arrForm[j]) {
								if (arr[i] !== "enrolled_user" && arr[i] !== "create_by") {
			                      _this.form[arrForm[j]] = res.result.obj[arr[i]]
			                      _this.disabledObj[arrForm[j] + '_isDisabled'] = true
								  break;
								} else {
								  _this.disabledObj[arrForm[j] + '_isDisabled'] = true
								}
							  }
							}
						  }
						}
					}
				});
			},
					get_user_enrolled_user(id){
				var obj = this.list_user_enrolled_user.getObj({"user_id":id});
				var ret = "";
				if(obj){
					ret = this.formatUserDisplay(obj);
				}
				return ret;
			},
					
	
					
	
					
	
							/**
			 * 上传企业资质
			 * @param {Object} param 文件参数
			 */
			upload_enterprise_qualifications(param){
									this.uploadFile(param.file, "enterprise_qualifications");
								},
					enterprise_qualificationsRemove() {
			  this.enterprise_qualifications_FileList = []
			  this.form.enterprise_qualifications = ""
			},
	
	
					
	
							/**
			 * 上传场地平面图
			 * @param {Object} param 图片参数
			 */
			upload_site_plan(param){
									this.uploadFile(param.file, "site_plan");
								},
		
	
							/**
			 * 上传参展文件
			 * @param {Object} param 文件参数
			 */
			upload_exhibitor_documents(param){
									this.uploadFile(param.file, "exhibitor_documents");
								},
					exhibitor_documentsRemove() {
			  this.exhibitor_documents_FileList = []
			  this.form.exhibitor_documents = ""
			},
	
	
					// 自动计算精度处理
		toFixed: function(num){
			if (!isNaN(num)) {
				return ((num + '').indexOf('.') == -1) ? num : num.toFixed(2);
			}
		},
			/**
			 * 获取对象之前
			 * @param {Object} param
			 */
			get_obj_before(param) {
				var form = "";
																						// 获取缓存数据附加
				form = $.db.get("form");
										if(form != null){
							if("examine_state" in form){
								delete form.examine_state
							}
												if("examine_reply" in form){
								delete form.examine_reply
							}
											}
													$.push(this.form ,form);
																			if(this.form && form){
					Object.keys(this.form).forEach(key => {
						Object.keys(form).forEach(dbKey => {
							// if(dbKey === "charging_standard"){
							// 	this.form['charging_rules'] = form[dbKey];
							// 	this.disabledObj['charging_rules_isDisabled'] = true;
							// };
							if(key === dbKey){
								this.disabledObj[key+'_isDisabled'] = true;
								this.form[key] = form[dbKey]
							}
							if(dbKey === "source_table"){
								this.form['source_table'] = form[dbKey];
							}
							if(dbKey === "source_id"){
								this.form['source_id'] = form[dbKey];
							}
							if(dbKey === "source_user_id"){
								this.form['source_user_id'] = form[dbKey];
							}
						})
					})
				}
																																				$.db.del("form");
				return param;
			},

			/**
			 * 获取对象之后
			 * @param {Object} json
			 * @param {Object} func
			 */
			async get_obj_after(json, func){
				if (json.result && json.result.obj) {
					const obj = json.result.obj;
				}

																																																																																																								this.enterprise_qualifications_FileList = []
				if (json.result.obj["enterprise_qualifications"]) {
				    this.enterprise_qualifications_FileList = [
				        {
				            url: this.$fullUrl(json.result.obj['enterprise_qualifications']),
				            name: json.result.obj['enterprise_qualifications'],
				        },
				    ];
				}
																													this.exhibitor_documents_FileList = []
				if (json.result.obj["exhibitor_documents"]) {
				    this.exhibitor_documents_FileList = [
				        {
				            url: this.$fullUrl(json.result.obj['exhibitor_documents']),
				            name: json.result.obj['exhibitor_documents'],
				        },
				    ];
				}
					


			},

																																																																																																																						async submit(param, func){
								if (!param) {
					param = this.form;
				}
				if(!this.form.registration_information_id){
					param.create_by = this.$store.state.user.user_id;
				}else{
					delete param.create_by;
				}
																var pm = this.events("submit_before", Object.assign({}, param)) || param;
				var msg = await this.events("submit_check", pm);
				var ret;

			
				if (msg) {
					this.$toast(msg, 'danger');
				} else {
																																																																																																																																let submitForm = JSON.parse(JSON.stringify(pm));
								ret = this.events("submit_main", submitForm, func);
				}
				return ret;
			},
					submit_after(json, func) {
						let path = this.$route.fullPath
						let skip_Path  = path.replace('/view','/table')
						if(!this.form.registration_information_id){
										  		  		  				  		  		  				  		  		  				  		  		  				  		  																			  		  				  		  		  				  		  		  				  		  		  				  		  		  				  		  		  											let message_inform = {
								title: '报名信息',
								type: '消息',
								content: this.$store.state.user.username + '-' + this.$store.state.user.nickname + '提交了一条报名信息数据',
								state: 1,
								user_id:'9999'
							}
							this.$post("~/api/message_inform/add",message_inform)
									setTimeout(() => {
								this.$router.push(skip_Path);
							}, 1000);
						}else{
							this.$router.push(skip_Path);
						}
					},
			/**
			 * 提交前验证事件
			 * @param {Object} 请求参数
			 * @return {String} 验证成功返回null, 失败返回错误提示
			 */
			async submit_check(param) {
																																																																																																																																																																																										var registration_notes_SensitiveWords = await this.filterSensitiveWords(param.registration_notes)
			if(registration_notes_SensitiveWords.length > 0){
				return '报名备注中包含敏感词: ' + registration_notes_SensitiveWords.join(',')
			}
																																		return null;
			},

			is_view(){
				// var bl = this.user_group == "管理员";
				var bl = false;

				if(!bl){
					bl = this.$check_action('/registration_information/table','add');
					console.log(bl ? "你有表格添加权限视作有添加权限" : "你没有表格添加权限");
				}
				if(!bl){
					bl = this.$check_action('/registration_information/table','set');
					console.log(bl ? "你有表格添加权限视作有修改权限" : "你没有表格修改权限");
				}
				if(!bl){
					bl = this.$check_action('/registration_information/view','add');
					console.log(bl ? "你有视图添加权限视作有添加权限" : "你没有视图添加权限");
				}
				if(!bl){
					bl = this.$check_action('/registration_information/view','set');
					console.log(bl ? "你有视图修改权限视作有修改权限" : "你没有视图修改权限");
				}
				if(!bl){
					bl = this.$check_action('/registration_information/view','get');
					console.log(bl ? "你有视图查询权限视作有查询权限" : "你没有视图查询权限");
				}

				console.log(bl ? "具有当前页面的查看权，请注意这不代表你有字段的查看权" : "无权查看当前页，请注意即便有字段查询权限没有页面查询权限也不行");

				return bl;
			},
			/**
			 * 上传文件
			 * @param {Object} param
			 */
			uploadimg(param) {
				this.uploadFile(param.file, "avatar");
			},
																																																																																			},
		created() {
																					this.get_list_user_host_user();
																						this.get_list_user_enrolled_user();
					this.get_group_user_enrolled_user();
																																			},
	}
</script>

<style>
	.avatar-uploader .el-upload {
		border: 1px dashed #d9d9d9;
		border-radius: 6px;
		cursor: pointer;
		position: relative;
		overflow: hidden;
	}

	.avatar-uploader .el-upload:hover {
		border-color: #409EFF;
	}

	.avatar-uploader-icon {
		font-size: 28px;
		color: #8c939d;
		width: 178px;
		height: 178px;
		line-height: 178px;
		text-align: center;
	}

	.avatar {
		width: 178px;
		height: 178px;
		display: block;
	}
	
	.img_multiple{
		overflow: hidden;
	}
	.img_multiple .img_block{
		float: left;
		margin-right: 5px;
		margin-bottom: 5px;
		position: relative;
	}
	.img_multiple .img_block img{
		height: 100px;
		width: auto;
	}
	.img_multiple .img_del{
		position: absolute;
		top: 5px;
		right: 5px;
		width: 20px;
		height: 20px;
		background: #0000008a;
		color: #fff;
		line-height: 20px;
		text-align: center;
		border-radius: 100%;
		cursor: pointer;
	}





	.check-item-list {
		width: 100%;
	}
	.check-item-list .check-item-li .check-item {
		width: 100%;
		height: 70px;
		display: flex;
		flex-direction: row;
		align-items: center;
		padding: 0 10px;
		box-sizing: border-box;
		background-color: #fff;
		line-height: 100%;
		position: relative;
		margin: 10px 0;
		border: 1px solid #000;
	}
	.check-item-list .check-item-li .check-item .image-container {
		display: block;
		width: 50px;
		height: 50px;
	}
	.check-item-list .check-item-li .check-item .check-item-title {
		width: 60%;
		margin-left: 10px;
	}
	.check-item-list .check-item-li .check-item .check-item-title > p:nth-child(1) {
		font-weight: bold;
		margin-bottom: 10px;
		text-align: left;
		font-size: 16px;
	}
	.check-item-list .check-item-li .check-item .check-item-title > p:nth-child(2) {
		width: 100%;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}
	.check-item-list .check-item-li .check-item .check-item-btn {
		margin-left: auto;
		display: flex;
		flex-direction: row;
		align-items: center;
	}
	.check-item-list .check-item-li .check-item-form {
		width: 100%;
		background-color: #fff;
		margin-top: 10px;
		padding: 10px 0;
		box-sizing: border-box;
	}
	.check-item-list .check-item-li .check-item-form form {
		margin: 0 auto !important;
	}
	.check-item-list .check-item-li .check-item-form form .el-form-item {
		margin-bottom: 15px;
	}
	.check-item-list .check-item-li .check-item-complete {
		border: 1px solid #409eff;
		overflow: hidden;
	}
	.check-item-list .check-item-li .check-item-complete:before {
		content: "";
		position: absolute;
		right: 0;
		top: 0;
		border: 15px solid #409eff;
		border-bottom-color: transparent;
		border-left-color: transparent;
	}
	.check-item-list .check-item-li .check-item-complete:after {
		content: "";
		width: 8px;
		height: 4px;
		position: absolute;
		right: 3px;
		top: 3px;
		border: 2px solid #fff;
		border-bottom-color: transparent;
		border-left-color: transparent;
		transform: rotate(135deg);
	}
	.ccc {
		color: #ccc;
	}
	.image-slot {
		width: 100%;
		height: 100%;
		display: flex;
		justify-content: center;
		align-items: center;
		color: #ccc;
		font-size: 24px;
	}
</style>
