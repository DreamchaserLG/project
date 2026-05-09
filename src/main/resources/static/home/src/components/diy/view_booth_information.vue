<template>
	<el-main class="bg edit_wrap">
		<el-form ref="form" :model="form" :rules="rules" status-icon label-width="120px" v-if="is_view()">
		<el-row class="row_ce">
												<el-col v-if="$check_field('get','booth_number') || $check_field('add','booth_number') || $check_field('set','booth_number')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="展位编号" prop="booth_number">
												<el-input id="booth_number" v-model="form['booth_number']" placeholder="请输入展位编号"
							v-if="(form['booth_information_id'] && $check_field('set','booth_number')) || (!form['booth_information_id'] && $check_field('add','booth_number'))" :disabled="disabledObj['booth_number_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','booth_number')">
						{{form['booth_number']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','exhibitionconvention_number') || $check_field('add','exhibitionconvention_number') || $check_field('set','exhibitionconvention_number')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="会展编号" prop="exhibitionconvention_number">
								<el-cascader id="exhibitionconvention_number" v-model="form['exhibitionconvention_number']" :options="exhibitionconvention_number_tree" :props="exhibitionconvention_number_cascader" :show-all-levels="false" clearable 
      					placeholder="请选择会展编号" @change="select_exhibitionconvention_number_field"
      					v-if="(form['booth_information_id'] && $check_field('set', 'exhibitionconvention_number')) || (!form['booth_information_id'] && $check_field('add', 'exhibitionconvention_number'))">
   		 			</el-cascader>
					<div v-else-if="$check_field('get','exhibitionconvention_number')">{{form['exhibitionconvention_number']}}</div>
										</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','exhibition_theme') || $check_field('add','exhibition_theme') || $check_field('set','exhibition_theme')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="会展主题" prop="exhibition_theme">
								<el-input id="exhibition_theme" v-model="form['exhibition_theme']"
						v-if="(form['booth_information_id'] && $check_field('set','exhibition_theme')) || (!form['booth_information_id'] && $check_field('add','exhibition_theme'))" :disabled="true">
									</el-input>
					<div v-else-if="$check_field('get','exhibition_theme')">
						{{form['exhibition_theme']}}
									</div>
										</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','host_user') || $check_field('add','host_user') || $check_field('set','host_user')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="主办用户" prop="host_user">
																		<div v-if="user_group !== '管理员'">
							{{ get_user_session_host_user(form['host_user']) }}
							<el-select v-if="(form['booth_information_id'] && $check_field('set','host_user')) || (!form['booth_information_id'] && $check_field('add','host_user'))" id="host_user" v-model="form['host_user']" :disabled="disabledObj['host_user_isDisabled']">
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
																<el-col v-if="$check_field('get','booth_name') || $check_field('add','booth_name') || $check_field('set','booth_name')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="展位名称" prop="booth_name">
												<el-input id="booth_name" v-model="form['booth_name']" placeholder="请输入展位名称"
							v-if="(form['booth_information_id'] && $check_field('set','booth_name')) || (!form['booth_information_id'] && $check_field('add','booth_name'))" :disabled="disabledObj['booth_name_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','booth_name')">
						{{form['booth_name']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','booth_type') || $check_field('add','booth_type') || $check_field('set','booth_type')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="展位类型" prop="booth_type">
												<el-input id="booth_type" v-model="form['booth_type']" placeholder="请输入展位类型"
							v-if="(form['booth_information_id'] && $check_field('set','booth_type')) || (!form['booth_information_id'] && $check_field('add','booth_type'))" :disabled="disabledObj['booth_type_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','booth_type')">
						{{form['booth_type']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','booth_location') || $check_field('add','booth_location') || $check_field('set','booth_location')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="展位位置" prop="booth_location">
												<el-input id="booth_location" v-model="form['booth_location']" placeholder="请输入展位位置"
							v-if="(form['booth_information_id'] && $check_field('set','booth_location')) || (!form['booth_information_id'] && $check_field('add','booth_location'))" :disabled="disabledObj['booth_location_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','booth_location')">
						{{form['booth_location']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','booth_prices') || $check_field('add','booth_prices') || $check_field('set','booth_prices')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="展位价格" prop="booth_prices">
								<el-input-number id="booth_prices" v-model.number="form['booth_prices']"
						v-if="(form['booth_information_id'] && $check_field('set','booth_prices')) || (!form['booth_information_id'] && $check_field('add','booth_prices'))" :disabled="disabledObj['booth_prices_isDisabled']"></el-input-number>
					<span v-else-if="$check_field('get','booth_prices')">{{form['booth_prices']}}</span>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','booth_specifications') || $check_field('add','booth_specifications') || $check_field('set','booth_specifications')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="展位规格" prop="booth_specifications">
												<el-input id="booth_specifications" v-model="form['booth_specifications']" placeholder="请输入展位规格"
							v-if="(form['booth_information_id'] && $check_field('set','booth_specifications')) || (!form['booth_information_id'] && $check_field('add','booth_specifications'))" :disabled="disabledObj['booth_specifications_isDisabled']">
									</el-input>
					<div v-else-if="$check_field('get','booth_specifications')">
						{{form['booth_specifications']}}
									</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','booth_images') || $check_field('add','booth_images') || $check_field('set','booth_images')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
				<el-form-item label="展位图片" prop="booth_images">
								<el-upload :disabled="disabledObj['booth_images_isDisabled']" class="avatar-uploader" drag
						accept="image/gif, image/jpeg, image/png, image/jpg" action="" :http-request="upload_booth_images"
						:show-file-list="false" v-if="(form['booth_information_id'] && $check_field('set','booth_images')) || (!form['booth_information_id'] && $check_field('add','booth_images'))">
						<img id="booth_images" v-if="form['booth_images']" :src="$fullUrl(form['booth_images'])" class="avatar">
						<i v-else class="el-icon-plus avatar-uploader-icon"></i>
					</el-upload>
					<el-image v-else-if="$check_field('get','booth_images')" style="width: 100px; height: 100px"
						:src="$fullUrl(form['booth_images'])" :preview-src-list="[$fullUrl(form['booth_images'])]">
						<div slot="error" class="image-slot">
							<img src="../../../public/img/error.png" style="width: 90px; height: 90px" />
						</div>
					</el-image>
										</el-form-item>
			</el-col>
													<el-col v-if="$check_field('get','booth_specificss') || $check_field('add','booth_specificss') || $check_field('set','booth_specificss')" :xs="24" :sm="24" :lg="24" class="el_form_editor_warp">
				<el-form-item label="展位详情" prop="booth_specificss">
					<!-- <quill-editor v-model.number="form['booth_specificss']"
						v-if="(form['booth_information_id'] && $check_field('set','booth_specificss')) || (!form['booth_information_id'] && $check_field('add','booth_specificss')) ">
					</quill-editor> -->
					<ai_editor
						v-if="(form['booth_information_id'] && $check_field('set','booth_specificss')) || (!form['booth_information_id'] && $check_field('add','booth_specificss'))"
						class="editor el_form_editor_warp" 
						:key="form.booth_information_id" 
						:details="form.booth_specificss"
						:form="form"
						@blur_comment="blur_comment_booth_specificss"
						@update_comment="update_comment_booth_specificss"
						:publish_flag="false" />
					<div v-else-if="$check_field('get','booth_specificss')" v-html="form['booth_specificss']"></div>
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
		
	
	
	
		
		
						<el-col :xs="24" :sm="12" :lg="8" class="el_form_item_warp" v-if="!form['source_user_id'] && 0 > 0 && $check_option('/booth_information/view','can_limits')">
			  <el-form-item label="报名限次">
				<el-input id="limit_times" v-model="form['registration_information_limit_times']" placeholder="报名限制次数，0为不限"
						  v-if="$check_action('/booth_information/view','set')"
				></el-input>
				<div v-else-if="$check_action('/booth_information/view','get')" v-html="form['registration_information_limit_times']"></div>
			  </el-form-item>
			</el-col>
			
	
	
		
		</el-row>
					<el-col :xs="24" :sm="12" :lg="8" class="el_form_btn_warp">
				<el-form-item v-if="$check_action('/booth_information/view','set') || $check_action('/booth_information/view','add')">
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
				field: "booth_information_id",
				url_add: "~/api/booth_information/add?",
				url_set: "~/api/booth_information/set?",
				url_get_obj: "~/api/booth_information/get_obj?",
				url_get_list: "~/api/booth_information/get_list?",
				url_upload: "~/api/booth_information/upload?",

				query: {
					"booth_information_id": 0,
					like: 0,
				},
				rules: {
																																																																																																											},
				form: {
								"booth_number":  '', // 展位编号
										"exhibitionconvention_number":  '', // 会展编号
										"exhibition_theme":  '', // 会展主题
										"host_user": 0, // 主办用户
										"booth_name":  '', // 展位名称
										"booth_type":  '', // 展位类型
										"booth_location":  '', // 展位位置
										"booth_prices":  0, // 展位价格
										"booth_specifications":  '', // 展位规格
										"booth_images":  '', // 展位图片
										"booth_specificss":  '', // 展位详情
										"examine_state": "未审核",
								"booth_information_id": 0, // ID
													"registration_information_limit_times": 0, // 报名限制次数
										"create_by": this.$store.state.user.user_id,
						},
				disabledObj:{
								"booth_number_isDisabled": false,
										"exhibitionconvention_number_isDisabled": false,
										"exhibition_theme_isDisabled": false,
										"host_user_isDisabled": false,
										"booth_name_isDisabled": false,
										"booth_type_isDisabled": false,
										"booth_location_isDisabled": false,
					          			"booth_prices_isDisabled": false,
										"booth_specifications_isDisabled": false,
										"booth_images_isDisabled": false,
										"booth_specificss_isDisabled": false,
										},


																exhibitionconvention_number_cascader: {
					value: 'exhibitionconvention_number',
					label: 'exhibitionconvention_number',
					children: 'children',
					emitPath: false,
					expandTrigger: 'hover',
				},
				// 商品分类树形数据
				exhibitionconvention_number_tree: [],
						// 会展编号选项列表
				list_exhibitionconvention_number: [""],
																					// 用户列表
				list_user_host_user: [],
						// 用户组
				group_user_host_user: "",
																																																								
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
			 * 获取会展编号列表
			 */
			async get_list_exhibitionconvention_number() {
				let param = {}
																			var user_group = this.$store.state.user.user_group;
			  				let sqlwhere = "(";
				  									  									  									  									  									  									  									  										if(user_group=="主办用户"){
						sqlwhere+= "host_user = " + this.$store.state.user.user_id + " or ";
					}
									  									  									  									  					if (sqlwhere.length>1){
						sqlwhere = sqlwhere.substr(0,sqlwhere.length-4);
						sqlwhere += ")";
						param["sqlwhere"] = sqlwhere;
					}
			  																																												var json = await this.$get("~/api/exhibition_information/get_list?",param);
				if(json.result && json.result.list){
					if (json.result.list.length > 0 && 'type' in json.result.list[0]) {
						json.result.list = json.result.list.filter(item => item.type == 1);
					}
							const hasFatherId = json.result.list.some(item => 'father_id' in item);
					if (hasFatherId) {
						this.exhibitionconvention_number_tree = this.build_exhibitionconvention_number_tree(json.result.list, 0);
					} else {
						this.exhibitionconvention_number_tree = json.result.list;
					}
					if (!this.query.booth_information_id && this.exhibitionconvention_number_tree.length > 0) {
										this.form["exhibitionconvention_number"] = this.exhibitionconvention_number_tree[0]["exhibitionconvention_number"];
													this.select_exhibitionconvention_number_field(this.form['exhibitionconvention_number']);
															}
						}
				else if(json.error){
					console.error(json.error);
				}
			},
					build_exhibitionconvention_number_tree(list, fatherId) {
				const tree = [];
				for (let item of list) {
					if (item.father_id === fatherId) {
					const children = this.build_exhibitionconvention_number_tree(list, item.exhibition_information_id);
					if (children.length > 0) {
						item.children = children;
					}
					tree.push(item);
					}
				}
				return tree;
			},
							select_exhibitionconvention_number_field(v){
				this.$get('~/api/exhibition_information/get_obj?exhibitionconvention_number='+v,{},(res)=>{
					if(res.result && res.result.obj){
																																																								this.form.exhibition_theme = res.result.obj.exhibition_theme;
																																																																																																																																		}else{
						console.error(res.error);
					}
				})
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
			 * 上传展位图片
			 * @param {Object} param 图片参数
			 */
			upload_booth_images(param){
									this.uploadFile(param.file, "booth_images");
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
				}

																																																																																								


			},

																																																																																			async submit(param, func){
								if (!param) {
					param = this.form;
				}
				if(!this.form.booth_information_id){
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
						if(!this.form.booth_information_id){
										  		  		  				  		  		  				  		  		  				  		  		  				  		  																			  		  				  		  		  				  		  		  				  		  		  				  		  		  				  		  		  											let message_inform = {
								title: '展位信息',
								type: '消息',
								content: this.$store.state.user.username + '-' + this.$store.state.user.nickname + '提交了一条展位信息数据',
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
																																																																																																																																																			var booth_specificss_SensitiveWords = await this.filterSensitiveWords(param.booth_specificss)
			if(booth_specificss_SensitiveWords.length > 0){
				return '展位详情中包含敏感词: ' + booth_specificss_SensitiveWords.join(',')
			}
								return null;
			},

			is_view(){
				// var bl = this.user_group == "管理员";
				var bl = false;

				if(!bl){
					bl = this.$check_action('/booth_information/table','add');
					console.log(bl ? "你有表格添加权限视作有添加权限" : "你没有表格添加权限");
				}
				if(!bl){
					bl = this.$check_action('/booth_information/table','set');
					console.log(bl ? "你有表格添加权限视作有修改权限" : "你没有表格修改权限");
				}
				if(!bl){
					bl = this.$check_action('/booth_information/view','add');
					console.log(bl ? "你有视图添加权限视作有添加权限" : "你没有视图添加权限");
				}
				if(!bl){
					bl = this.$check_action('/booth_information/view','set');
					console.log(bl ? "你有视图修改权限视作有修改权限" : "你没有视图修改权限");
				}
				if(!bl){
					bl = this.$check_action('/booth_information/view','get');
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
																																																								blur_comment_booth_specificss(data) {
				this.form['booth_specificss'] = data;
			},
			update_comment_booth_specificss(data) {
				this.form['booth_specificss'] = data;
			},
							},
		created() {
								this.get_list_exhibitionconvention_number();
													this.get_list_user_host_user();
					this.get_group_user_host_user();
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
