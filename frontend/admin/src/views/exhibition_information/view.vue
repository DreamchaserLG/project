<template>
	<el-main class="bg edit_wrap comtable_e">
		<el-form ref="form" :model="form" status-icon label-width="120px" v-if="is_view()">
		<el-row class="row_ce"> 
												<el-col v-if="$check_field('get','exhibitionconvention_number') || $check_field('add','exhibitionconvention_number') || $check_field('set','exhibitionconvention_number')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="会展编号" prop="exhibitionconvention_number">
															<el-input id="exhibitionconvention_number" v-model="form['exhibitionconvention_number']" placeholder="请输入会展编号"
							  v-if="(form['exhibition_information_id'] && $check_field('set','exhibitionconvention_number')) || (!form['exhibition_information_id'] && $check_field('add','exhibitionconvention_number'))" :disabled="true">
				  					</el-input>
					<div v-else-if="$check_field('get','exhibitionconvention_number')">
						{{form['exhibitionconvention_number']}}
				  					</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','exhibition_theme') || $check_field('add','exhibition_theme') || $check_field('set','exhibition_theme')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="会展主题" prop="exhibition_theme">
															<el-input id="exhibition_theme" v-model="form['exhibition_theme']" placeholder="请输入会展主题"
							  v-if="(form['exhibition_information_id'] && $check_field('set','exhibition_theme')) || (!form['exhibition_information_id'] && $check_field('add','exhibition_theme'))" :disabled="disabledObj['exhibition_theme_isDisabled']">
				  					</el-input>
					<div v-else-if="$check_field('get','exhibition_theme')">
						{{form['exhibition_theme']}}
				  					</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','exhibition_and_convention_types') || $check_field('add','exhibition_and_convention_types') || $check_field('set','exhibition_and_convention_types')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="会展类型" prop="exhibition_and_convention_types">
															<el-input id="exhibition_and_convention_types" v-model="form['exhibition_and_convention_types']" placeholder="请输入会展类型"
							  v-if="(form['exhibition_information_id'] && $check_field('set','exhibition_and_convention_types')) || (!form['exhibition_information_id'] && $check_field('add','exhibition_and_convention_types'))" :disabled="disabledObj['exhibition_and_convention_types_isDisabled']">
				  					</el-input>
					<div v-else-if="$check_field('get','exhibition_and_convention_types')">
						{{form['exhibition_and_convention_types']}}
				  					</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','event_time') || $check_field('add','event_time') || $check_field('set','event_time')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="举办时间" prop="event_time">
															<el-date-picker id="event_time" v-model="event_time_range" type="datetimerange" range-separator="至" start-placeholder="开始时间" end-placeholder="结束时间" value-format="yyyy-MM-dd HH:mm:ss" @change="normalizeEventTimeRange"
							  v-if="(form['exhibition_information_id'] && $check_field('set','event_time')) || (!form['exhibition_information_id'] && $check_field('add','event_time'))" :disabled="disabledObj['event_time_isDisabled']">
									</el-date-picker>
					<div v-else-if="$check_field('get','event_time')">
						{{form['event_time']}}
				  					</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','event_venue_name') || $check_field('add','event_venue_name') || $check_field('set','event_venue_name')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="举办地点" prop="event_venue_name">
															<el-input id="event_venue_name" v-model="form['event_venue_name']" placeholder="请输入举办地点"
							  v-if="(form['exhibition_information_id'] && $check_field('set','event_venue_name')) || (!form['exhibition_information_id'] && $check_field('add','event_venue_name'))" :disabled="disabledObj['event_venue_name_isDisabled']">
				  					</el-input>
					<div v-else-if="$check_field('get','event_venue_name')">
						{{form['event_venue_name']}}
				  					</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','exhibition_status') || $check_field('add','exhibition_status') || $check_field('set','exhibition_status')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="会展状态" prop="exhibition_status">
											<el-select id="exhibition_status" v-model="form['exhibition_status']"
						v-if="(form['exhibition_information_id'] && $check_field('set','exhibition_status')) || (!form['exhibition_information_id'] && $check_field('add','exhibition_status'))">
						<el-option v-for="o in list_exhibition_status" :key="o" :label="o" :value="o">
						</el-option>
					</el-select>
					<div v-else-if="$check_field('get','exhibition_status')">{{form['exhibition_status']}}</div>
										</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','exhibition_poster') || $check_field('add','exhibition_poster') || $check_field('set','exhibition_poster')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="会展海报" prop="exhibition_poster">
											<el-upload :disabled="disabledObj['exhibition_poster_isDisabled']" class="avatar-uploader" drag
						accept="image/gif, image/jpeg, image/png, image/jpg" action="" :http-request="upload_exhibition_poster"
						:show-file-list="false" v-if="(form['exhibition_information_id'] && $check_field('set','exhibition_poster')) || (!form['exhibition_information_id'] && $check_field('add','exhibition_poster'))">
						<img id="exhibition_poster" v-if="form['exhibition_poster']" :src="$fullUrl(form['exhibition_poster'])" class="avatar">
						<i v-else class="el-icon-plus avatar-uploader-icon"></i>
					</el-upload>
					<el-image v-else-if="$check_field('get','exhibition_poster')" style="width: 100px; height: 100px"
						:src="$fullUrl(form['exhibition_poster'])" :preview-src-list="[$fullUrl(form['exhibition_poster'])]">
						<div slot="error" class="image-slot">
							<img src="../../../public/img/error.png" style="width: 90px; height: 90px" />
						</div>
					</el-image>
										</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','host_user') || $check_field('add','host_user') || $check_field('set','host_user')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="主办用户" prop="host_user">
																					<div v-if="user_group !== '管理员'">
							{{ get_user_session_host_user(form['host_user']) }}
							<el-select v-if="(form['exhibition_information_id'] && $check_field('set','host_user')) || (!form['exhibition_information_id'] && $check_field('add','host_user'))" id="host_user" v-model="form['host_user']" :disabled="disabledObj['host_user_isDisabled']">
								<el-option v-for="o in list_user_host_user" :key="o['username']" :label="o['nickname'] + '-' + o['username']"
										   :value="o['user_id']">
								</el-option>
							</el-select>
							<el-select v-else-if="$check_field('get','host_user')" id="host_user" v-model="form['host_user']" :disabled="true">
								<el-option v-for="o in list_user_host_user" :key="o['username']" :label="o['nickname'] + '-' + o['username']"
										   :value="o['user_id']">
								</el-option>
							</el-select>
						</div>
						<el-select v-else id="host_user" v-model="form['host_user']" :disabled="disabledObj['host_user_isDisabled']">
							<el-option v-for="o in list_user_host_user" :key="o['username']" :label="o['nickname'] + '-' + o['username']"
									   :value="o['user_id']">
							</el-option>
						</el-select>
																			</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','introduction_document') || $check_field('add','introduction_document') || $check_field('set','introduction_document')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="介绍文档" prop="introduction_document">
															<div v-if="disabledObj['introduction_document_isDisabled']">
						<div v-if="$check_field('get','introduction_document')">
							<el-button type="primary" @click="$download($fullUrl(form['introduction_document']),form['introduction_document'])">下载<i
									class="el-icon-download el-icon--right"></i></el-button>
						</div>
					</div>
					<div v-else>
						<el-upload v-if="(form['exhibition_information_id'] && $check_field('set','introduction_document')) || (!form['exhibition_information_id'] && $check_field('add','introduction_document'))":file-list="introduction_document_FileList" :on-preview="openPreview" :on-remove="introduction_documentRemove" class="upload-demo" drag
								   action="" style="max-width: 300px;width: 100%;" :http-request="upload_introduction_document" :limit="1" accept="">
							<i class="el-icon-upload"></i>
							<div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
						</el-upload>
						<div v-else-if="$check_field('get','introduction_document')">
							<el-button type="primary" @click="$download($fullUrl(form['introduction_document']),form['introduction_document'])">下载<i
									class="el-icon-download el-icon--right"></i></el-button>
						</div>
					</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','fee_standards') || $check_field('add','fee_standards') || $check_field('set','fee_standards')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="费用标准" prop="fee_standards">
											<el-input type="textarea" id="fee_standards" v-model="form['fee_standards']" placeholder="请输入费用标准"
						v-if="(form['exhibition_information_id'] && $check_field('set','fee_standards')) || (!form['exhibition_information_id'] && $check_field('add','fee_standards'))" :disabled="disabledObj['fee_standards_isDisabled']"></el-input>
					<div v-else-if="$check_field('get','fee_standards')">{{form['fee_standards']}}</div>
										</el-form-item>
			</el-col>
													<el-col v-if="$check_field('get','schedule_t') || $check_field('add','schedule_t') || $check_field('set','schedule_t')" :xs="24" :sm="24" :lg="24" class="el_form_editor_warp">
							<el-form-item label="日程安排" prop="schedule_t">
								<!-- <quill-editor v-model.number="form['schedule_t']"
						v-if="(form['exhibition_information_id'] && $check_field('set','schedule_t')) || (!form['exhibition_information_id'] && $check_field('add','schedule_t')) ">
					</quill-editor> -->
					<ai_editor
						v-if="(form['exhibition_information_id'] && $check_field('set','schedule_t')) || (!form['exhibition_information_id'] && $check_field('add','schedule_t'))"
						class="editor el_form_editor_warp"
						:details="form.schedule_t"
						:form="form"
						@blur_comment="blur_comment_schedule_t"
						@update_comment="update_comment_schedule_t"
						:publish_flag="false" />
					<div v-else-if="$check_field('get','schedule_t')" v-html="form['schedule_t']"></div>
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
		
	
	
	
		
		
	
	
	
		
		
		
		</el-row>
					<el-col :xs="24" :sm="12" :lg="8" class="el_form_btn_warp">
				<el-form-item v-if="$check_action('/exhibition_information/view','set') || $check_action('/exhibition_information/view','add')">
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
				field: "exhibition_information_id",
				event_time_range: [],
				url_add: "~/api/exhibition_information/add?",
				url_set: "~/api/exhibition_information/set?",
				url_get_obj: "~/api/exhibition_information/get_obj?",
				url_get_list: "~/api/exhibition_information/get_list?",
				url_upload: "~/api/exhibition_information/upload?",

				query: {
					"exhibition_information_id": 0,
					like: 0,
				},

				form: {
								"exhibitionconvention_number": this.$get_stamp(), // 会展编号
										"exhibition_theme":  '', // 会展主题
										"exhibition_and_convention_types":  '', // 会展类型
										"event_time":  '', // 举办时间
										"event_venue_name":  '', // 举办地点
										"exhibition_status":  '', // 会展状态
										"exhibition_poster":  '', // 会展海报
										"host_user": 0, // 主办用户
										"introduction_document":  '', // 介绍文档
										"fee_standards":  '', // 费用标准
										"schedule_t":  '', // 日程安排
										"examine_state": "未审核",
								"exhibition_information_id": 0, // ID
																		"create_by": this.$store.state.user.user_id,
				},
				disabledObj:{
								"exhibitionconvention_number_isDisabled": false,
										"exhibition_theme_isDisabled": false,
										"exhibition_and_convention_types_isDisabled": false,
										"event_time_isDisabled": false,
										"event_venue_name_isDisabled": false,
										"exhibition_status_isDisabled": false,
										"exhibition_poster_isDisabled": false,
										"host_user_isDisabled": false,
										"introduction_document_isDisabled": false,
										"fee_standards_isDisabled": false,
										"schedule_t_isDisabled": false,
										},

																																												// 会展状态选项列表
				list_exhibition_status: ['报名中','进行中','已下架'],
																					// 用户列表
				list_user_host_user: [],
						// 用户组
				group_user_host_user: "",
													introduction_document_FileList: [],
																				

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
			 * 上传会展海报
			 * @param {Object} param 图片参数
			 */
			upload_exhibition_poster(param){
									this.uploadFile(param.file, "exhibition_poster");
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
					/**
			 * 获取主办用户用户组
			 */
			async get_group_user_host_user() {
							this.form["host_user"] = this.user.user_id;
							var json = await this.$get("~/api/user_group/get_obj?name=主办用户");
				if(json.result && json.result.obj){
					this.group_user_host_user = json.result.obj;
				}
				else if(json.error){
					console.error(json.error);
				}
			},
			get_user_session_host_user(id){
				var _this = this;
				var user_id = {"user_id":id}
				var url = "~/api/"+_this.group_user_host_user.source_table+"/get_obj?"
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
												_this.form["host_user"] = id
									_this.disabledObj['host_user' + '_isDisabled'] = true
						for (var i=0;i<arr.length;i++){
						  if (arr[i]!=='examine_state' && arr[i]!=='examine_reply') {
							for (var j = 0; j < arrForm.length; j++) {
							  if (arr[i] === arrForm[j]) {
								if (arr[i] !== "host_user" && arr[i] !== "create_by") {
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
					get_user_host_user(id){
				var obj = this.list_user_host_user.getObj({"user_id":id});
				var ret = "";
				if(obj){
					if(obj.nickname){
						ret = obj.nickname;}
					else{
						ret = obj.username;
					}
				}
				return ret;
			},
							/**
			 * 上传介绍文档
			 * @param {Object} param 文件参数
			 */
			upload_introduction_document(param){
									this.uploadFile(param.file, "introduction_document");
								},
					introduction_documentRemove() {
			  this.introduction_document_FileList = []
							  this.form.introduction_document = ""
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
					this.event_time_range = this.parseEventTimeRange(obj.event_time);
				}
																																																																								if (this.form["introduction_document"]) {
					this.introduction_document_FileList = []
					this.introduction_document_FileList = [
					  {
						url: this.$fullUrl(this.form['introduction_document']),
						name: this.form['introduction_document'],
					  },
					];
				}
																					
			},

			submit_before(param){
				param.event_time = this.formatEventTimeRange();
				return param;
			},

																																																																																									async submit(param, func){
								if (!param) {
					param = this.form;
				}
				if(!this.form.exhibition_information_id){
					param.create_by = this.$store.state.user.user_id;
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
					async submit_after(json, func) {
						let path = this.$route.fullPath
						let skip_Path  = path.replace('/view','/table')
								if(!this.form.exhibition_information_id){
						  		  							  		  							  		  							  		  							  		  																											  		  							  		  							  		  							  		  							  		  														let message_inform = {
								title: '会展信息',
								type: '消息',
								content: this.$store.state.user.username + '-' + this.$store.state.user.nickname + '提交了一条会展信息数据',
								state: 1,
								user_id:'9999'
							}
							this.$post("~/api/message_inform/add",message_inform)
									this.$message.success("提交成功!");
							setTimeout(() => {
								this.$router.push(skip_Path);
							}, 1000);
						}else{
							this.$message.success("提交成功!");
							this.$router.push(skip_Path);
						}
					},
			
			/**
			 * 提交前验证事件
			 * @param {Object} 请求参数
			 * @return {String} 验证成功返回null, 失败返回错误提示
			 */
						async submit_check(param) {
				if (!this.event_time_range || this.event_time_range.length !== 2) {
					return "请选择会展开始时间和结束时间";
				}
				const start = new Date(this.event_time_range[0]).getTime();
				const end = new Date(this.event_time_range[1]).getTime();
				if (!start || !end || end - start < 3 * 60 * 60 * 1000) {
					return "结束时间必须至少晚于开始时间3小时";
				}
					
																																																																																																																																																															return null;
			},

			formatEventTimeRange() {
				if (!this.event_time_range || this.event_time_range.length !== 2) {
					return "";
				}
				return this.event_time_range[0] + " 至 " + this.event_time_range[1];
			},
			parseEventTimeRange(value) {
				if (!value) {
					return [];
				}
				const matches = String(value).match(/\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}(?::\d{2})?/g);
				if (!matches || matches.length < 2) {
					return [];
				}
				return matches.slice(0, 2).map((item) => item.length === 16 ? item + ":00" : item.replace("T", " "));
			},
			normalizeEventTimeRange(value) {
				if (!value || value.length !== 2) {
					return;
				}
				const start = new Date(value[0]).getTime();
				const end = new Date(value[1]).getTime();
				if (start && end && end - start < 3 * 60 * 60 * 1000) {
					this.$set(this.event_time_range, 1, this.formatDateTime(new Date(start + 3 * 60 * 60 * 1000)));
					this.$message.warning("结束时间已自动调整为开始时间3小时后");
				}
			},
			formatDateTime(date) {
				const pad = (n) => String(n).padStart(2, "0");
				return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`;
			},

			is_view(){
				// var bl = this.user_group == "管理员";
				var bl = false;

				if(!bl){
					bl = this.$check_action('/exhibition_information/table','add');
					console.log(bl ? "你有表格添加权限视作有添加权限" : "你没有表格添加权限");
				}
				if(!bl){
					bl = this.$check_action('/exhibition_information/table','set');
					console.log(bl ? "你有表格添加权限视作有修改权限" : "你没有表格修改权限");
				}
				if(!bl){
					bl = this.$check_action('/exhibition_information/view','add');
					console.log(bl ? "你有视图添加权限视作有添加权限" : "你没有视图添加权限");
				}
				if(!bl){
					bl = this.$check_action('/exhibition_information/view','set');
					console.log(bl ? "你有视图修改权限视作有修改权限" : "你没有视图修改权限");
				}
				if(!bl){
					bl = this.$check_action('/exhibition_information/view','get');
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
			handlePictureCardPreview(file) {
				this.previewImageUrl = file.url;
				this.previewVisible = true;
			},
			uploadExceed() {
				this.$message({
					message: "最多可设置5张主图",
					type: "warning",
				});
			},
																																																								blur_comment_schedule_t(data) {
				this.form['schedule_t'] = data;
			},
			update_comment_schedule_t(data) {
				this.form['schedule_t'] = data;
			},
							},
		created() {
																								if(!this.query.exhibition_information_id){
			this.form["exhibition_status"] = this.list_exhibition_status[0];
		}
											this.get_list_user_host_user();
					this.get_group_user_host_user();
																			},
	}
</script>

<style scoped>
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
	.mul-upload-container{
		display: flex;
	}
	.mul-upload-container .el-form-item__content{
		margin-left: 0 !important;
	}
	.upload-container.hide-upload .el-upload--picture-card {
		display: none;
	}
	.el-upload--picture-card{
		width: 180px;
    	height: 180px;
		line-height: 180px;
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
