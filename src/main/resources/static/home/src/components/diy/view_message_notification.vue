<template>
	<el-main class="bg edit_wrap">
		<el-form ref="form" :model="form" :rules="rules" status-icon label-width="120px" v-if="is_view()">
		<el-row class="row_ce">
												<el-col v-if="$check_field('get','notice_number') || $check_field('add','notice_number') || $check_field('set','notice_number')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="通知编号" prop="notice_number">
												<el-input id="notice_number" v-model="form['notice_number']" placeholder="请输入通知编号"
							v-if="(form['message_notification_id'] && $check_field('set','notice_number')) || (!form['message_notification_id'] && $check_field('add','notice_number'))" :disabled="true">
									</el-input>
					<div v-else-if="$check_field('get','notice_number')">
						{{form['notice_number']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','notice_title') || $check_field('add','notice_title') || $check_field('set','notice_title')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="通知标题" prop="notice_title">
												<el-input id="notice_title" v-model="form['notice_title']" placeholder="请输入通知标题"
							v-if="(form['message_notification_id'] && $check_field('set','notice_title')) || (!form['message_notification_id'] && $check_field('add','notice_title'))" :disabled="disabledObj['notice_title_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','notice_title')">
						{{form['notice_title']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','notification_time') || $check_field('add','notification_time') || $check_field('set','notification_time')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="通知时间" prop="notification_time">
								<el-date-picker :disabled="disabledObj['notification_time_isDisabled']" v-if="(form['message_notification_id'] && $check_field('set','notification_time')) || (!form['message_notification_id'] && $check_field('add','notification_time'))" id="notification_time"
						v-model="form['notification_time']" type="datetime" placeholder="选择日期时间">
					</el-date-picker>
					<div v-else-if="$check_field('get','notification_time')">{{form['notification_time']}}</div>
										</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','host_user') || $check_field('add','host_user') || $check_field('set','host_user')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="主办用户" prop="host_user">
																		<div v-if="user_group !== '管理员'">
							{{ get_user_session_host_user(form['host_user']) }}
							<el-select v-if="(form['message_notification_id'] && $check_field('set','host_user')) || (!form['message_notification_id'] && $check_field('add','host_user'))" id="host_user" v-model="form['host_user']" :disabled="disabledObj['host_user_isDisabled']">
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
																<el-col v-if="$check_field('get','regular_user') || $check_field('add','regular_user') || $check_field('set','regular_user')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="普通用户" prop="regular_user">
													<el-select v-if="(form['message_notification_id'] && $check_field('set','regular_user')) || (!form['message_notification_id'] && $check_field('add','regular_user'))" id="regular_user" v-model="form['regular_user']" :disabled="disabledObj['regular_user_isDisabled']">
							<el-option v-for="o in list_user_regular_user" :key="o['username']" :label="o['nickname'] + '-' + o['username']"
									   :value="o['user_id']">
							</el-option>
						</el-select>
						<el-select v-else-if="$check_field('get','regular_user')" id="regular_user" v-model="form['regular_user']" :disabled="true">
							<el-option v-for="o in list_user_regular_user" :key="o['username']" :label="o['nickname'] + '-' + o['username']"
									   :value="o['user_id']">
							</el-option>
						</el-select>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','notice_content') || $check_field('add','notice_content') || $check_field('set','notice_content')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="通知内容" prop="notice_content">
								<el-input type="textarea" id="notice_content" v-model="form['notice_content']" placeholder="请输入通知内容"
						v-if="(form['message_notification_id'] && $check_field('set','notice_content')) || (!form['message_notification_id'] && $check_field('add','notice_content'))" :disabled="disabledObj['notice_content_isDisabled']"></el-input>
					<div v-else-if="$check_field('get','notice_content')">{{form['notice_content']}}</div>
										</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','mark_status') || $check_field('add','mark_status') || $check_field('set','mark_status')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="标记状态" prop="mark_status">
								<el-select id="mark_status" v-model="form['mark_status']"
						v-if="(form['message_notification_id'] && $check_field('set','mark_status')) || (!form['message_notification_id'] && $check_field('add','mark_status'))">
						<el-option v-for="o in list_mark_status" :key="o" :label="o" :value="o">
						</el-option>
					</el-select>
					<div v-else-if="$check_field('get','mark_status')">{{form['mark_status']}}</div>
										</el-form-item>
			</el-col>
									
	
	
	
		
		
	
	
	
		
		</el-row>
					<el-col :xs="24" :sm="12" :lg="8" class="el_form_btn_warp">
				<el-form-item v-if="$check_action('/message_notification/view','set') || $check_action('/message_notification/view','add')">
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
				field: "message_notification_id",
				url_add: "~/api/message_notification/add?",
				url_set: "~/api/message_notification/set?",
				url_get_obj: "~/api/message_notification/get_obj?",
				url_get_list: "~/api/message_notification/get_list?",
				url_upload: "~/api/message_notification/upload?",

				query: {
					"message_notification_id": 0,
					like: 0,
				},
				rules: {
																																																																							},
				form: {
								"notice_number": this.$get_stamp(), // 通知编号
										"notice_title":  '', // 通知标题
										"notification_time":  '', // 通知时间
										"host_user": 0, // 主办用户
										"regular_user": 0, // 普通用户
										"notice_content":  '', // 通知内容
										"mark_status":  '', // 标记状态
												"message_notification_id": 0, // ID
													"create_by": this.$store.state.user.user_id,
						},
				disabledObj:{
								"notice_number_isDisabled": false,
										"notice_title_isDisabled": false,
										"notification_time_isDisabled": false,
										"host_user_isDisabled": false,
										"regular_user_isDisabled": false,
										"notice_content_isDisabled": false,
										"mark_status_isDisabled": false,
										},


																												// 用户列表
				list_user_host_user: [],
						// 用户组
				group_user_host_user: "",
														// 用户列表
				list_user_regular_user: [],
																							// 标记状态选项列表
				list_mark_status: ['未读','已读'],
							
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
					/**
			 * 获取主办用户用户组
			 */
			async get_group_user_host_user() {
							this.form["host_user"] = this.$store.state.user.user_id;
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
			 * 获取普通用户用户列表
			 */
			async get_list_user_regular_user() {
                var json = await this.$get("~/api/user/get_list?user_group=普通用户");
                if(json.result && json.result.list){
                    this.list_user_regular_user = json.result.list;
                }
                else if(json.error){
                    console.error(json.error);
                }
			},
					get_user_regular_user(id){
				var obj = this.list_user_regular_user.getObj({"user_id":id});
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
					        if (this.form["notification_time"] && JSON.stringify(this.form["notification_time"]).indexOf("-")===-1){
            this.form["notification_time"] = this.$toTime(parseInt(this.form["notification_time"]),"yyyy-MM-dd hh:mm:ss")
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

																					if(json.result.obj["notification_time"]=="0000-00-00 00:00:00"){
				  json.result.obj["notification_time"] = null;
				}
				if(parseInt(json.result.obj["notification_time"]) > 9999){
					json.result.obj["notification_time"] = this.$toTime(parseInt(json.result.obj["notification_time"]),"yyyy-MM-dd hh:mm:ss")
				}
																																								


			},

																																																							async submit(param, func){
								if (!param) {
					param = this.form;
				}
				if(!this.form.message_notification_id){
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
						if(!this.form.message_notification_id){
										  		  		  				  		  		  				  		  		  				  		  		  				  		  																			  		  				  		  		  				  		  		  				  		  		  				  		  		  				  		  		  											let message_inform = {
								title: '消息通知',
								type: '消息',
								content: this.$store.state.user.username + '-' + this.$store.state.user.nickname + '提交了一条消息通知数据',
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
																																		if (!param.notification_time){
					return "通知时间不能为空";
				}
																																																						var notice_content_SensitiveWords = await this.filterSensitiveWords(param.notice_content)
			if(notice_content_SensitiveWords.length > 0){
				return '通知内容中包含敏感词: ' + notice_content_SensitiveWords.join(',')
			}
																					return null;
			},

			is_view(){
				// var bl = this.user_group == "管理员";
				var bl = false;

				if(!bl){
					bl = this.$check_action('/message_notification/table','add');
					console.log(bl ? "你有表格添加权限视作有添加权限" : "你没有表格添加权限");
				}
				if(!bl){
					bl = this.$check_action('/message_notification/table','set');
					console.log(bl ? "你有表格添加权限视作有修改权限" : "你没有表格修改权限");
				}
				if(!bl){
					bl = this.$check_action('/message_notification/view','add');
					console.log(bl ? "你有视图添加权限视作有添加权限" : "你没有视图添加权限");
				}
				if(!bl){
					bl = this.$check_action('/message_notification/view','set');
					console.log(bl ? "你有视图修改权限视作有修改权限" : "你没有视图修改权限");
				}
				if(!bl){
					bl = this.$check_action('/message_notification/view','get');
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
					this.get_group_user_host_user();
										this.get_list_user_regular_user();
														if(!this.query.message_notification_id){
					this.form["mark_status"] = this.list_mark_status[0];
				}
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
