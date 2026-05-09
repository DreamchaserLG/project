<template>
	<el-main class="bg edit_wrap comtable_e">
		<el-form ref="form" :model="form" status-icon label-width="120px" v-if="is_view()">
		<el-row class="row_ce"> 
												<el-col v-if="$check_field('get','announcement_title') || $check_field('add','announcement_title') || $check_field('set','announcement_title')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="公告标题" prop="announcement_title">
															<el-input id="announcement_title" v-model="form['announcement_title']" placeholder="请输入公告标题"
							  v-if="(form['exhibition_announcement_id'] && $check_field('set','announcement_title')) || (!form['exhibition_announcement_id'] && $check_field('add','announcement_title'))" :disabled="disabledObj['announcement_title_isDisabled']">
				  					</el-input>
					<div v-else-if="$check_field('get','announcement_title')">
						{{form['announcement_title']}}
				  					</div>
														</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','announcement_type') || $check_field('add','announcement_type') || $check_field('set','announcement_type')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="公告类型" prop="announcement_type">
											<el-select id="announcement_type" v-model="form['announcement_type']"
						v-if="(form['exhibition_announcement_id'] && $check_field('set','announcement_type')) || (!form['exhibition_announcement_id'] && $check_field('add','announcement_type'))">
						<el-option v-for="o in list_announcement_type" :key="o" :label="o" :value="o">
						</el-option>
					</el-select>
					<div v-else-if="$check_field('get','announcement_type')">{{form['announcement_type']}}</div>
										</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','exhibitionconvention_number') || $check_field('add','exhibitionconvention_number') || $check_field('set','exhibitionconvention_number')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="会展编号" prop="exhibitionconvention_number">
											<el-cascader id="exhibitionconvention_number" v-model="form['exhibitionconvention_number']" :options="exhibitionconvention_number_tree" :props="exhibitionconvention_number_cascader" :show-all-levels="false" clearable 
      					placeholder="请选择会展编号" 
      					v-if="(form['exhibition_announcement_id'] && $check_field('set', 'exhibitionconvention_number')) || (!form['exhibition_announcement_id'] && $check_field('add', 'exhibitionconvention_number'))">
   		 			</el-cascader>
					<div v-else-if="$check_field('get','exhibitionconvention_number')">{{form['exhibitionconvention_number']}}</div>
										</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','host_user') || $check_field('add','host_user') || $check_field('set','host_user')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="主办用户" prop="host_user">
																					<div v-if="user_group !== '管理员'">
							{{ get_user_session_host_user(form['host_user']) }}
							<el-select v-if="(form['exhibition_announcement_id'] && $check_field('set','host_user')) || (!form['exhibition_announcement_id'] && $check_field('add','host_user'))" id="host_user" v-model="form['host_user']" :disabled="disabledObj['host_user_isDisabled']">
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
																<el-col v-if="$check_field('get','release_time') || $check_field('add','release_time') || $check_field('set','release_time')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="发布时间" prop="release_time">
											<el-date-picker :disabled="disabledObj['release_time_isDisabled']" v-if="(form['exhibition_announcement_id'] && $check_field('set','release_time')) || (!form['exhibition_announcement_id'] && $check_field('add','release_time'))" id="release_time"
						v-model="form['release_time']" type="datetime" placeholder="选择日期时间">
					</el-date-picker>
					<div v-else-if="$check_field('get','release_time')">{{form['release_time']}}</div>
										</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','announcement_image') || $check_field('add','announcement_image') || $check_field('set','announcement_image')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="公告图片" prop="announcement_image">
											<el-upload :disabled="disabledObj['announcement_image_isDisabled']" class="avatar-uploader" drag
						accept="image/gif, image/jpeg, image/png, image/jpg" action="" :http-request="upload_announcement_image"
						:show-file-list="false" v-if="(form['exhibition_announcement_id'] && $check_field('set','announcement_image')) || (!form['exhibition_announcement_id'] && $check_field('add','announcement_image'))">
						<img id="announcement_image" v-if="form['announcement_image']" :src="$fullUrl(form['announcement_image'])" class="avatar">
						<i v-else class="el-icon-plus avatar-uploader-icon"></i>
					</el-upload>
					<el-image v-else-if="$check_field('get','announcement_image')" style="width: 100px; height: 100px"
						:src="$fullUrl(form['announcement_image'])" :preview-src-list="[$fullUrl(form['announcement_image'])]">
						<div slot="error" class="image-slot">
							<img src="../../../public/img/error.png" style="width: 90px; height: 90px" />
						</div>
					</el-image>
										</el-form-item>
			</el-col>
																<el-col v-if="$check_field('get','announcement_vuser_ideo') || $check_field('add','announcement_vuser_ideo') || $check_field('set','announcement_vuser_ideo')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="公告视频" prop="announcement_vuser_ideo">
															<el-upload v-if="(form['exhibition_announcement_id'] && $check_field('set','announcement_vuser_ideo')) || (!form['exhibition_announcement_id'] && $check_field('add','announcement_vuser_ideo'))" class="upload-demo":file-list="announcement_vuser_ideo_FileList" :on-preview="openPreview" :on-remove="announcement_vuser_ideoRemove" drag
						action="" style="max-width: 300px;width: 100%;" :http-request="upload_announcement_vuser_ideo" :limit="1" accept="video/ogg,video/mp4,video/webm">
						<i class="el-icon-upload"></i>
						<div class="el-upload__text">将视频拖到此处，或<em>点击上传</em></div>
					</el-upload>
					<div v-else-if="$check_field('get','announcement_vuser_ideo')">
						<el-button type="primary" @click="$download($fullUrl(form['announcement_vuser_ideo']),form['announcement_vuser_ideo'])">下载<i
								class="el-icon-download el-icon--right"></i></el-button>
					</div>
														</el-form-item>
			</el-col>
													<el-col v-if="$check_field('get','announcement_content') || $check_field('add','announcement_content') || $check_field('set','announcement_content')" :xs="24" :sm="24" :lg="24" class="el_form_editor_warp">
							<el-form-item label="公告内容" prop="announcement_content">
								<!-- <quill-editor v-model.number="form['announcement_content']"
						v-if="(form['exhibition_announcement_id'] && $check_field('set','announcement_content')) || (!form['exhibition_announcement_id'] && $check_field('add','announcement_content')) ">
					</quill-editor> -->
					<ai_editor
						v-if="(form['exhibition_announcement_id'] && $check_field('set','announcement_content')) || (!form['exhibition_announcement_id'] && $check_field('add','announcement_content'))"
						class="editor el_form_editor_warp"
						:details="form.announcement_content"
						:form="form"
						@blur_comment="blur_comment_announcement_content"
						@update_comment="update_comment_announcement_content"
						:publish_flag="false" />
					<div v-else-if="$check_field('get','announcement_content')" v-html="form['announcement_content']"></div>
				</el-form-item>
			</el-col>
						
	
	
	
		
		
	
	
	
		
		
		
		</el-row>
					<el-col :xs="24" :sm="12" :lg="8" class="el_form_btn_warp">
				<el-form-item v-if="$check_action('/exhibition_announcement/view','set') || $check_action('/exhibition_announcement/view','add')">
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
				field: "exhibition_announcement_id",
				url_add: "~/api/exhibition_announcement/add?",
				url_set: "~/api/exhibition_announcement/set?",
				url_get_obj: "~/api/exhibition_announcement/get_obj?",
				url_get_list: "~/api/exhibition_announcement/get_list?",
				url_upload: "~/api/exhibition_announcement/upload?",

				query: {
					"exhibition_announcement_id": 0,
					like: 0,
				},

				form: {
								"announcement_title":  '', // 公告标题
										"announcement_type":  '', // 公告类型
										"exhibitionconvention_number":  '', // 会展编号
										"host_user": 0, // 主办用户
										"release_time":  '', // 发布时间
										"announcement_image":  '', // 公告图片
										"announcement_vuser_ideo":  '', // 公告视频
										"announcement_content":  '', // 公告内容
												"exhibition_announcement_id": 0, // ID
																		"create_by": this.$store.state.user.user_id,
				},
				disabledObj:{
								"announcement_title_isDisabled": false,
										"announcement_type_isDisabled": false,
										"exhibitionconvention_number_isDisabled": false,
										"host_user_isDisabled": false,
										"release_time_isDisabled": false,
										"announcement_image_isDisabled": false,
										"announcement_vuser_ideo_isDisabled": false,
										"announcement_content_isDisabled": false,
										},

																// 公告类型选项列表
				list_announcement_type: ['活动变更','注意事项','展后总结'],
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
																											announcement_vuser_ideo_FileList: [],
													

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
			  			  			  				  			  				  			  					var user_group = this.user.user_group;
								let sqlwhere = "(";
				  									  									  									  									  									  									  									  										if(user_group=="主办用户"){
						sqlwhere+= "host_user = " + this.user.user_id + " or ";
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
					if (!this.query.exhibition_announcement_id && this.exhibitionconvention_number_tree.length > 0) {
										this.form["exhibitionconvention_number"] = this.exhibitionconvention_number_tree[0]["exhibitionconvention_number"];
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
			 * 上传公告图片
			 * @param {Object} param 图片参数
			 */
			upload_announcement_image(param){
									this.uploadFile(param.file, "announcement_image");
								},
		
	
							/**
			 * 上传公告视频
			 * @param {Object} param 视频参数
			 */
			upload_announcement_vuser_ideo(param){
									this.uploadFile(param.file, "announcement_vuser_ideo");
								},
					announcement_vuser_ideoRemove() {
			  this.announcement_vuser_ideo_FileList = []
							  this.form.announcement_vuser_ideo = ""
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
					        if (this.form["release_time"] && JSON.stringify(this.form["release_time"]).indexOf("-")===-1){
            this.form["release_time"] = this.$toTime(parseInt(this.form["release_time"]),"yyyy-MM-dd hh:mm:ss")
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
																																					if(this.form["release_time"]=="0000-00-00 00:00:00"){
				  this.form["release_time"] = null;
				}
				if(parseInt(this.form["release_time"]) > 9999){
					this.form["release_time"] = this.$toTime(parseInt(this.form["release_time"]),"yyyy-MM-dd hh:mm:ss")
				}
																								if (this.form["announcement_vuser_ideo"]) {
					this.announcement_vuser_ideo_FileList = []
					this.announcement_vuser_ideo_FileList = [
					  {
						url: this.$fullUrl(this.form['announcement_vuser_ideo']),
						name: this.form['announcement_vuser_ideo'],
					  },
					];
				}
													
			},

																																																																				async submit(param, func){
								if (!param) {
					param = this.form;
				}
				if(!this.form.exhibition_announcement_id){
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
								if(!this.form.exhibition_announcement_id){
						  		  							  		  							  		  							  		  							  		  																											  		  							  		  							  		  							  		  							  		  														let message_inform = {
								title: '会展公告',
								type: '消息',
								content: this.$store.state.user.username + '-' + this.$store.state.user.nickname + '提交了一条会展公告数据',
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
					
																																																											if (!param.release_time){
					return "发布时间不能为空";
				}
																																																														return null;
			},

			is_view(){
				// var bl = this.user_group == "管理员";
				var bl = false;

				if(!bl){
					bl = this.$check_action('/exhibition_announcement/table','add');
					console.log(bl ? "你有表格添加权限视作有添加权限" : "你没有表格添加权限");
				}
				if(!bl){
					bl = this.$check_action('/exhibition_announcement/table','set');
					console.log(bl ? "你有表格添加权限视作有修改权限" : "你没有表格修改权限");
				}
				if(!bl){
					bl = this.$check_action('/exhibition_announcement/view','add');
					console.log(bl ? "你有视图添加权限视作有添加权限" : "你没有视图添加权限");
				}
				if(!bl){
					bl = this.$check_action('/exhibition_announcement/view','set');
					console.log(bl ? "你有视图修改权限视作有修改权限" : "你没有视图修改权限");
				}
				if(!bl){
					bl = this.$check_action('/exhibition_announcement/view','get');
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
																																									blur_comment_announcement_content(data) {
				this.form['announcement_content'] = data;
			},
			update_comment_announcement_content(data) {
				this.form['announcement_content'] = data;
			},
							},
		created() {
								if(!this.query.exhibition_announcement_id){
			this.form["announcement_type"] = this.list_announcement_type[0];
		}
						this.get_list_exhibitionconvention_number();
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
