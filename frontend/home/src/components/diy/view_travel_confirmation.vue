<template>
	<el-main class="bg edit_wrap">
		<el-form ref="form" :model="form" :rules="rules" status-icon label-width="120px" v-if="is_view()">
		<el-row class="row_ce">
												<el-col v-if="$check_field('get','order_number') || $check_field('add','order_number') || $check_field('set','order_number')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="订单编号" prop="order_number">
												<el-input id="order_number" v-model="form['order_number']" placeholder="请输入订单编号"
							v-if="(form['travel_confirmation_id'] && $check_field('set','order_number')) || (!form['travel_confirmation_id'] && $check_field('add','order_number'))" :disabled="disabledObj['order_number_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','order_number')">
						{{form['order_number']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','booth_number') || $check_field('add','booth_number') || $check_field('set','booth_number')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="展位编号" prop="booth_number">
												<el-input id="booth_number" v-model="form['booth_number']" placeholder="请输入展位编号"
							v-if="(form['travel_confirmation_id'] && $check_field('set','booth_number')) || (!form['travel_confirmation_id'] && $check_field('add','booth_number'))" :disabled="disabledObj['booth_number_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','booth_number')">
						{{form['booth_number']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','exhibitionconvention_number') || $check_field('add','exhibitionconvention_number') || $check_field('set','exhibitionconvention_number')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="会展编号" prop="exhibitionconvention_number">
												<el-input id="exhibitionconvention_number" v-model="form['exhibitionconvention_number']" placeholder="请输入会展编号"
							v-if="(form['travel_confirmation_id'] && $check_field('set','exhibitionconvention_number')) || (!form['travel_confirmation_id'] && $check_field('add','exhibitionconvention_number'))" :disabled="disabledObj['exhibitionconvention_number_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','exhibitionconvention_number')">
						{{form['exhibitionconvention_number']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','exhibition_theme') || $check_field('add','exhibition_theme') || $check_field('set','exhibition_theme')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="会展主题" prop="exhibition_theme">
												<el-input id="exhibition_theme" v-model="form['exhibition_theme']" placeholder="请输入会展主题"
							v-if="(form['travel_confirmation_id'] && $check_field('set','exhibition_theme')) || (!form['travel_confirmation_id'] && $check_field('add','exhibition_theme'))" :disabled="disabledObj['exhibition_theme_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','exhibition_theme')">
						{{form['exhibition_theme']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','host_user') || $check_field('add','host_user') || $check_field('set','host_user')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="主办用户" prop="host_user">
													<el-select v-if="(form['travel_confirmation_id'] && $check_field('set','host_user')) || (!form['travel_confirmation_id'] && $check_field('add','host_user'))" id="host_user" v-model="form['host_user']" :disabled="disabledObj['host_user_isDisabled']">
							<el-option v-for="o in list_user_host_user" :key="o['username']" :label="o['nickname'] + '-' + o['username']"
									   :value="o['user_id']">
							</el-option>
						</el-select>
						<el-select v-else-if="$check_field('get','host_user')" id="host_user" v-model="form['host_user']" :disabled="true">
							<el-option v-for="o in list_user_host_user" :key="o['username']" :label="o['nickname'] + '-' + o['username']"
									   :value="o['user_id']">
							</el-option>
						</el-select>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','enrolled_user') || $check_field('add','enrolled_user') || $check_field('set','enrolled_user')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="报名用户" prop="enrolled_user">
													<el-select v-if="(form['travel_confirmation_id'] && $check_field('set','enrolled_user')) || (!form['travel_confirmation_id'] && $check_field('add','enrolled_user'))" id="enrolled_user" v-model="form['enrolled_user']" :disabled="disabledObj['enrolled_user_isDisabled']">
							<el-option v-for="o in list_user_enrolled_user" :key="o['username']" :label="o['nickname'] + '-' + o['username']"
									   :value="o['user_id']">
							</el-option>
						</el-select>
						<el-select v-else-if="$check_field('get','enrolled_user')" id="enrolled_user" v-model="form['enrolled_user']" :disabled="true">
							<el-option v-for="o in list_user_enrolled_user" :key="o['username']" :label="o['nickname'] + '-' + o['username']"
									   :value="o['user_id']">
							</el-option>
						</el-select>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','user_name') || $check_field('add','user_name') || $check_field('set','user_name')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="用户姓名" prop="user_name">
												<el-input id="user_name" v-model="form['user_name']" placeholder="请输入用户姓名"
							v-if="(form['travel_confirmation_id'] && $check_field('set','user_name')) || (!form['travel_confirmation_id'] && $check_field('add','user_name'))" :disabled="disabledObj['user_name_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','user_name')">
						{{form['user_name']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','users_mobile_phone') || $check_field('add','users_mobile_phone') || $check_field('set','users_mobile_phone')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="用户手机" prop="users_mobile_phone">
												<el-input id="users_mobile_phone" v-model="form['users_mobile_phone']" placeholder="请输入用户手机"
							v-if="(form['travel_confirmation_id'] && $check_field('set','users_mobile_phone')) || (!form['travel_confirmation_id'] && $check_field('add','users_mobile_phone'))" :disabled="disabledObj['users_mobile_phone_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','users_mobile_phone')">
						{{form['users_mobile_phone']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','confirm_time') || $check_field('add','confirm_time') || $check_field('set','confirm_time')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="确认时间" prop="confirm_time">
								<el-date-picker :disabled="disabledObj['confirm_time_isDisabled']" v-if="(form['travel_confirmation_id'] && $check_field('set','confirm_time')) || (!form['travel_confirmation_id'] && $check_field('add','confirm_time'))" id="confirm_time"
						v-model="form['confirm_time']" type="datetime" placeholder="选择日期时间">
					</el-date-picker>
					<div v-else-if="$check_field('get','confirm_time')">{{form['confirm_time']}}</div>
										</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','number_of_attendees') || $check_field('add','number_of_attendees') || $check_field('set','number_of_attendees')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="到场人数" prop="number_of_attendees">
								<el-input-number id="number_of_attendees" v-model.number="form['number_of_attendees']" :min="1" :max="maxAttendees || 999999" :step="1" step-strictly
						v-if="(form['travel_confirmation_id'] && $check_field('set','number_of_attendees')) || (!form['travel_confirmation_id'] && $check_field('add','number_of_attendees'))" :disabled="disabledObj['number_of_attendees_isDisabled']"></el-input-number>
					<span v-else-if="$check_field('get','number_of_attendees')">{{form['number_of_attendees']}}</span>
														</el-form-item>
			</el-col>
									
	
	
	
		
		
	
	
	
		
		</el-row>
					<el-col :xs="24" :sm="12" :lg="8" class="el_form_btn_warp">
				<el-form-item v-if="$check_action('/travel_confirmation/view','set') || $check_action('/travel_confirmation/view','add')">
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
				field: "travel_confirmation_id",
				url_add: "~/api/travel_confirmation/add?",
				url_set: "~/api/travel_confirmation/set?",
				url_get_obj: "~/api/travel_confirmation/get_obj?",
				url_get_list: "~/api/travel_confirmation/get_list?",
				url_upload: "~/api/travel_confirmation/upload?",

				query: {
					"travel_confirmation_id": 0,
					like: 0,
				},
				rules: {
																																																																																																		},
				form: {
								"order_number":  '', // 订单编号
										"booth_number":  '', // 展位编号
										"exhibitionconvention_number":  '', // 会展编号
										"exhibition_theme":  '', // 会展主题
										"host_user": 0, // 主办用户
										"enrolled_user": 0, // 报名用户
										"user_name":  '', // 用户姓名
										"users_mobile_phone":  '', // 用户手机
										"confirm_time":  '', // 确认时间
										"number_of_attendees":  1, // 到场人数
												"travel_confirmation_id": 0, // ID
													"create_by": this.$store.state.user.user_id,
						},
				disabledObj:{
								"order_number_isDisabled": false,
										"booth_number_isDisabled": false,
										"exhibitionconvention_number_isDisabled": false,
										"exhibition_theme_isDisabled": false,
										"host_user_isDisabled": false,
										"enrolled_user_isDisabled": false,
										"user_name_isDisabled": false,
										"users_mobile_phone_isDisabled": false,
										"confirm_time_isDisabled": false,
					          			"number_of_attendees_isDisabled": false,
										},


																																			// 用户列表
				list_user_host_user: [],
														// 用户列表
				list_user_enrolled_user: [],
				maxAttendees: null,
																																			
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
			async get_list_user_enrolled_user() {
                var json = await this.$get("~/api/user/get_list?user_group=普通用户");
                if(json.result && json.result.list){
                    this.list_user_enrolled_user = json.result.list;
                }
                else if(json.error){
                    console.error(json.error);
                }
			},
					get_user_enrolled_user(id){
				var obj = this.list_user_enrolled_user.getObj({"user_id":id});
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
																															// 获取缓存数据附加
				form = $.db.get("form");
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
							if(dbKey === "number_of_registrations"){
								this.maxAttendees = Number(form[dbKey]) || null;
								if(!this.form["number_of_attendees"] || this.form["number_of_attendees"] < 1){
									this.form["number_of_attendees"] = this.maxAttendees || 1;
								}
							}
						})
					})
				}
																	        if (this.form["confirm_time"] && JSON.stringify(this.form["confirm_time"]).indexOf("-")===-1){
            this.form["confirm_time"] = this.$toTime(parseInt(this.form["confirm_time"]),"yyyy-MM-dd hh:mm:ss")
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
				if (!json || !json.result || !json.result.obj) {
					return;
				}
				if (json.result && json.result.obj) {
					const obj = json.result.obj;
				}

																																																																					if(json.result.obj["confirm_time"]=="0000-00-00 00:00:00"){
				  json.result.obj["confirm_time"] = null;
				}
				if(parseInt(json.result.obj["confirm_time"]) > 9999){
					json.result.obj["confirm_time"] = this.$toTime(parseInt(json.result.obj["confirm_time"]),"yyyy-MM-dd hh:mm:ss")
				}
																


			},

																																																																												async submit(param, func){
								if (!param) {
					param = this.form;
				}
				if(!this.form.travel_confirmation_id){
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
						if(!this.form.travel_confirmation_id){
										  		  		  				  		  		  				  		  		  				  		  		  				  		  																																						  		  				  		  		  				  		  		  				  		  		  				  		  		  				  		  		  											let message_inform = {
								title: '行程确认',
								type: '消息',
								content: this.$store.state.user.username + '-' + this.$store.state.user.nickname + '提交了一条行程确认数据',
								state: 1,
								user_id:'9999'
					}
							this.$post("~/api/message_inform/add",message_inform)
							this.$toast('提交成功！', 'success');
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
				if (!param.confirm_time){
					return "确认时间不能为空";
				}
				if (!param.number_of_attendees || Number(param.number_of_attendees) < 1){
					return "行程确认人数不能小于1人";
				}
				if (this.maxAttendees && Number(param.number_of_attendees) > this.maxAttendees){
					return "行程确认人数不能超过报名人数";
				}
																															return null;
			},

			is_view(){
				// var bl = this.user_group == "管理员";
				var bl = false;

				if(!bl){
					bl = this.$check_action('/travel_confirmation/table','add');
					console.log(bl ? "你有表格添加权限视作有添加权限" : "你没有表格添加权限");
				}
				if(!bl){
					bl = this.$check_action('/travel_confirmation/table','set');
					console.log(bl ? "你有表格添加权限视作有修改权限" : "你没有表格修改权限");
				}
				if(!bl){
					bl = this.$check_action('/travel_confirmation/view','add');
					console.log(bl ? "你有视图添加权限视作有添加权限" : "你没有视图添加权限");
				}
				if(!bl){
					bl = this.$check_action('/travel_confirmation/view','set');
					console.log(bl ? "你有视图修改权限视作有修改权限" : "你没有视图修改权限");
				}
				if(!bl){
					bl = this.$check_action('/travel_confirmation/view','get');
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
