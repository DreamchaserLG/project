<template>
	<el-main class="bg table_wrap comtabel_t">
		<el-form label-position="right" :model="query" class="form p_4" label-width="120">
			<el-row class="rows row1">



							<el-col :xs="24" :sm="24" :lg="8" class="el_form_search_wrap" v-if="$check_field('get','order_number')">
					<el-form-item label="订单编号">
									<el-input v-model="query.order_number"></el-input>
								</el-form-item>
				</el-col>
																		<el-col :xs="24" :sm="24" :lg="8" class="el_form_search_wrap" v-if="$check_field('get','user_name')">
					<el-form-item label="用户姓名">
									<el-input v-model="query.user_name"></el-input>
								</el-form-item>
				</el-col>
																<el-col :xs="24" :sm="24" :lg="8" class="el_form_search_wrap">
					<el-form-item label="审核状态">
						<el-select v-model="query.examine_state">
							<el-option value="">全部</el-option>
							<el-option value="未审核">未审核</el-option>
								<el-option value="已通过">已通过</el-option>
							<el-option value="未通过">未通过</el-option>
						</el-select>
					</el-form-item>
				</el-col>
	</el-row>
	<el-row class="rows row2">

		<el-col :xs="24" :sm="24" :lg="24" class="search_btn_wrap search_btns">

				<el-col :xs="24" :sm="10" :lg="8" class="search_btn_1 search_btn_wrap_1 btns">

										<el-button type="primary" @click="search()" class="search_btn_find">查询</el-button>
						<el-button @click="reset()" style="margin-right: 74px;" class="search_btn_reset">重置</el-button>
																						

										<el-button v-if="$check_option('/refund_request/table', 'examine')" @click="batchInfo()" class="examine_btn_state">批量审核</el-button>
														<el-button v-if="$check_action('/refund_request/table','del') || $check_action('/refund_request/view','del')" class="search_btn_del" type="danger" @click="delInfo()">删除</el-button>
								
				</el-col>
		</el-col>
	</el-row >
	<div class="statistics-info" v-if="statisticsData.total > 0">
                                                      </div>

		</el-form>
				<el-table :data="list" @selection-change="selectionChange" @sort-change="$sortChange" style="width: 100%" id="dataTable" row-key="refund_request_id" :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
			:default-expand-all="isExpandAll" ref="tableRef">
					<el-table-column fixed type="selection" tooltip-effect="dark" width="55">
			</el-table-column>
				<el-table-column prop="order_number" @sort-change="$sortChange" label="订单编号" 				v-if="$check_field('get','order_number')" min-width="300">
					<template slot-scope="scope">
							{{ scope.row["order_number"] }}
									</template>
					</el-table-column>
					<el-table-column prop="host_user" @sort-change="$sortChange" label="主办用户" 				v-if="$check_field('get','host_user')" min-width="300">
						<template slot-scope="scope">
					{{ get_user_host_user(scope.row['host_user']) }}
				</template>
					</el-table-column>
					<el-table-column prop="booth_prices" @sort-change="$sortChange" label="展位价格" 				v-if="$check_field('get','booth_prices')" min-width="300">
					<template slot-scope="scope">
							{{ scope.row["booth_prices"] }}
									</template>
					</el-table-column>
					<el-table-column prop="enrolled_user" @sort-change="$sortChange" label="报名用户" 				v-if="$check_field('get','enrolled_user')" min-width="300">
						<template slot-scope="scope">
					{{ get_user_enrolled_user(scope.row['enrolled_user']) }}
				</template>
					</el-table-column>
					<el-table-column prop="user_name" @sort-change="$sortChange" label="用户姓名" 				v-if="$check_field('get','user_name')" min-width="300">
					<template slot-scope="scope">
							{{ scope.row["user_name"] }}
									</template>
					</el-table-column>
					<el-table-column prop="users_mobile_phone" @sort-change="$sortChange" label="用户手机" 				v-if="$check_field('get','users_mobile_phone')" min-width="300">
					<template slot-scope="scope">
							{{ scope.row["users_mobile_phone"] }}
									</template>
					</el-table-column>
					<el-table-column prop="application_time" @sort-change="$sortChange" label="申请时间" 				v-if="$check_field('get','application_time')" min-width="300">
						<template slot-scope="scope">
									                	{{ $toTime(scope.row["application_time"],"yyyy-MM-dd hh:mm:ss") }}
																		</template>
					</el-table-column>
					<el-table-column prop="reason_for_application" @sort-change="$sortChange" label="申请理由" 				v-if="$check_field('get','reason_for_application')" min-width="300">
					<template slot-scope="scope">
							{{ scope.row["reason_for_application"] }}
									</template>
					</el-table-column>
				<el-table-column label="审核状态" prop="examine_state" min-width="100">
				<template slot-scope="scope">
					<span v-if="scope.row['examine_state'] == '未审核'" style="color: red;">未审核</span>
					<span v-else-if="scope.row['examine_state'] == '审核中'" style="color: orange;">审核中</span>
					<span v-else-if="scope.row['examine_state'] == '已通过'" style="color: green;">已通过</span>
					<span v-else-if="scope.row['examine_state'] == '未通过'" style="color: gray;">未通过</span>
				</template>
			</el-table-column>
			<el-table-column label="审核回复" prop="examine_reply" min-width="200">
			</el-table-column>
			<el-table-column label="申诉状态" prop="escalate_state" min-width="120">
				<template slot-scope="scope">
					<span v-if="scope.row['escalate_state'] === '已申诉'" style="color: #E6A23C;">已申诉</span>
					<span v-else-if="scope.row['escalate_state'] === '已处理'" style="color: #67C23A;">已处理</span>
					<span v-else>{{ scope.row['escalate_state'] }}</span>
				</template>
			</el-table-column>
			<el-table-column label="申诉原因" prop="escalate_reason" min-width="260">
			</el-table-column>

			<el-table-column prop="extra" @sort-change="$sortChange" label="信息" min-width="300" v-if="hasExtraData" >
				<template slot-scope="scope">
					<div v-for="(value, key) in JSON.parse(scope.row.extra || '{}')" :key="key">{{ key }}：{{ value }}</div>
				</template>
			</el-table-column>
            <el-table-column sortable prop="create_time" label="创建时间" min-width="200">
                <template slot-scope="scope">
                	{{ $toTime(scope.row["create_time"],"yyyy-MM-dd hh:mm:ss") }}
                </template>
            </el-table-column>

			<el-table-column sortable prop="update_time" label="更新时间" min-width="200">
                <template slot-scope="scope">
                	{{ $toTime(scope.row["update_time"],"yyyy-MM-dd hh:mm:ss") }}
                </template>
			</el-table-column>







			<el-table-column fixed="right" label="操作" min-width="200" v-if="$check_action('/refund_request/table','set') || $check_action('/refund_request/view','set') || $check_action('/refund_request/view','get')
						" >


				<template slot-scope="scope">
					<div class="view_a">
					<router-link class="e-button el-button--small is-plain el-button--success" style="margin: 5px !important;"
					v-if="$check_action('/refund_request/table','set') || $check_action('/refund_request/view','set') || $check_action('/refund_request/view','get')"
						:to="'./view?' + field + '=' + scope.row[field]"
						 size="small">
						<span>详情</span>
					</router-link>
					<el-button class="e-button el-button--small is-plain el-button--primary" style="margin: 5px !important;" size="small" @click="changeSigning(scope.row, scope.$index)" v-if="$check_option('/refund_request/table', 'examine')  ">
						<span>审核</span>
					</el-button>
				</div>
				</template>
			</el-table-column>

		</el-table>
										<!-- 分页器 -->
		<div class="mt text_center">
			<el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
				:current-page="query.page" :page-sizes="[7, 10, 30, 100]" :page-size="query.size"
				layout="total, sizes, prev, pager, next, jumper" :total="count">
			</el-pagination>
		</div>
		<!-- /分页器 -->
		<el-dialog title="审核" :visible.sync="dialogVisible" width="30%" :show-close="true">
			<el-form ref="verifyForm" :rules="rules" :model="verifyItem">
				<el-form-item label="审核状态" prop="examine_state">
					<el-radio-group v-model="verifyItem.examine_state">
						<el-radio label="已通过" value="已通过"></el-radio>
						<el-radio label="未通过" value="未通过"></el-radio>
					</el-radio-group>
				</el-form-item>
								<el-form-item label="审核回复" prop="reply">
					<el-input type="textarea" placeholder="请填写审核回复" v-model="verifyItem.examine_reply"></el-input>
				</el-form-item>
							</el-form>
			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="assureVerify">确 定</el-button>
			</span>
		</el-dialog>
										<el-dialog title="重要提醒" :visible.sync="showModal" width="400px" :before-close="closeModal">
			<div style="text-align: center">
				<p style="margin-bottom: 16px; font-size: 16px; color: #333;">
				当前有数据达到预警值！
				</p>
				<p style="color: #666;">{{ message }}</p>
			</div>
			<div slot="footer" class="dialog-footer">
				<el-button @click="closeModal">取消</el-button>
				<el-button type="primary" @click="closeModal">确定</el-button>
			</div>
		</el-dialog>


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
				statisticsData: {
      				total: 0,
                				},
																						// 弹框
				showModal: false,
				// 获取数据地址
				url_get_list: "~/api/refund_request/get_list",
				url_del: "~/api/refund_request/del?",

				// 字段ID
				field: "refund_request_id",
				dialogVisible: false,
				verifyIdx: 0,
				verifyItem: {},
				rules: {
				  "examine_state": [
				    { required: true, message: '请选择审核状态', trigger: 'change' },
				  ],
				},
														// 查询
				query: {
					"size":  7,
					"page": 1,
								"order_number": "",
														"user_name": "",
											"examine_state":"",
					"login_time": "",
					"create_time": "",
					"orderby": `CASE WHEN escalate_state = '已申诉' THEN 0 WHEN examine_state = '未审核' THEN 1 ELSE 2 END,create_time desc`
				},

				// 数据
				list: [],
				batchAllState: false,
				batchAllList: [],
																		// 用户列表
				list_user_host_user: [],
											// 用户列表
				list_user_enrolled_user: [],
													message: '',
				// 控制展开状态
				isExpandAll: true,
				// 存储展开的行
				expandKeys: [],
				prevSelection: [],
			}
		},
		methods: {
				previewFile(fileName) {
					if(!fileName){
						return;
					}
					const fileExtension = fileName.split('.').pop().toLowerCase();
					if(fileExtension == 'docx' || fileExtension == 'xlsx' || fileExtension == 'pptx') {
						this.$router.push('/filePreview?url=' + fileName + '&type=' + fileExtension);
						return;
					}
					window.open(this.$fullUrl(fileName), '_blank');
				},
				showPreview(file) {
					if(!file){
						return false;
					}
					let fileType = file.split('.').pop().toLowerCase();
					if(fileType == 'docx' || fileType == 'xlsx' || fileType == 'pptx') {
						return true;
					}else {
						return false;
					}
				},
																	// 关闭弹框
			closeModal(){
				this.showModal = false;
				},
			// 审核弹窗
			changeSigning(query, index) {
			  let beforeQuery=JSON.parse(JSON.stringify(query));
			  this.verifyIdx = index;
			  this.verifyItem = beforeQuery;
				this.verifyItem.examine_state = "";
			  this.batchAllState = false;
			  this.batchAllList = [];
			  this.dialogVisible = true;
			},
			batchAll(list) {
				this.batchAllState = true;
					this.batchAllList = list;
					this.dialogVisible = true;
			},
			assureVerify() {
				//审核
				let _this = this;
				let examineForm = this.$refs["verifyForm"];
				examineForm.validate(async (valid) => {
					if (valid) {
						let apiState = true;
						if (this.batchAllState) {
							if(this.batchAllList.length == 0){
								_this.$toast("请选择要操作的数据", "danger");
								return;
							}
							for (var i = 0; i < this.batchAllList.length; i++) {
								let url = "~/api/refund_request/set?refund_request_id=" +  this.batchAllList[i]["refund_request_id"];
									let json = await _this.$post(url,{
									'examine_state': _this.verifyItem.examine_state,
										'examine_reply': _this.verifyItem.examine_reply,
										  }
								)
									if (json.error) {
									apiState = false;
									_this.$toast(json.error.message, "danger");
									break;
								}
									let message_inform = {
									title: '审核结果',
									type: '通知',
									content: '你在退款申请下提交的内容，审核结果为：' + _this.verifyItem.examine_state,
									state: 1,
									user_id: _this.batchAllList[i].create_by
								}
								_this.$post("~/api/message_inform/add", message_inform)
								}
							if (apiState) {
							  _this.$toast("审核成功！", "success");
							  _this.dialogVisible = false;
							  _this.get_list();
							}
						}else{
							var url = "~/api/refund_request/set?refund_request_id=" + this.verifyItem['refund_request_id']
								_this.$post(url, {
								'examine_state': _this.verifyItem.examine_state,
									'examine_reply': _this.verifyItem.examine_reply,
									}, (json, status) => {
								if (json.result) {
										_this.$toast('审核成功！', 'success');
									_this.dialogVisible = false;
																	let message_inform = {
										title: '审核结果',
										type: '通知',
										content: '你在退款申请下提交的内容，审核结果为：' + _this.verifyItem.examine_state,
										state: 1,
										user_id: _this.verifyItem.create_by
									}
									this.$post("~/api/message_inform/add",message_inform)
																	_this.get_list();
								} else if (json.error) {
									_this.$toast(json.error.message, 'danger');
								}
							})
						}

					}
				})
			},
			/**
			 * @description 获取到列表事件
			 * @param {Object} res 响应结果
			 */
			get_list_after: function get_list_after(res, func, url) {
				let _this = this
																																																	},

			get_list_before(param){
				var user_group = this.user.user_group;
				if(user_group != "管理员"){
						let sqlwhere = "(";
															if(user_group=="主办用户"){
						sqlwhere+= "host_user = " + this.user.user_id + " or ";
					}
																		if(user_group=="普通用户"){
						sqlwhere+= "enrolled_user = " + this.user.user_id + " or ";
					}
																														if (sqlwhere.length>1){
						sqlwhere = sqlwhere.substr(0,sqlwhere.length-4);
						sqlwhere += ")";
						param["sqlwhere"] = sqlwhere;
					}
					}
				return param;
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
					ret = obj.nickname+"-"+obj.username;
					// if(obj.nickname){
					// 	ret = obj.nickname;
					// }
					// else{
					// 	ret = obj.username;
					// }
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
					ret = obj.nickname+"-"+obj.username;
					// if(obj.nickname){
					// 	ret = obj.nickname;
					// }
					// else{
					// 	ret = obj.username;
					// }
				}
				return ret;
			},
													async delInfo() {
				var list = this.selection;
				if (list.length === 0) {
					this.$message({
						type: 'info',
						message: '选择对象不能为空!'
					});
					return;
				}
				for (let i = 0; i < list.length; i++) {
					let type = list[i];
					let res
																																																																																																																																																																																																																																																																				}
				this.$confirm('删除后数据将无法恢复，请确认是否删除？', '提示', {
					confirmButtonText: '确定',
					cancelButtonText: '取消',
					type: 'warning'
				}).then(async () => {
              		await this.delAll(list);
				}).catch(() => {
					this.$message({
						type: 'info',
						message: '已取消删除'
					});
				});
			},
			// 查询方法
			search() {
				this.query.page = 1;
				this.get_list();
							},

			// 重置方法  
			reset() {
				// 原有的重置逻辑
				Object.keys(this.query).forEach(key => {
					if (key !== 'size' && key !== 'page' && key !== 'orderby') {
						if (key.includes('_min') || key.includes('_max')) {
							this.query[key] = '';
						} else {
							this.query[key] = '';
						}
					}
				});
				
																																																																													
				this.query.orderby = "create_time desc";
				this.get_list();
							},
	},
		created() {
									this.get_list_user_host_user();
										this.get_list_user_enrolled_user();
											},
		computed: {
			hasExtraData() {
				return this.list.some(item => item.extra && item.extra.trim() !== '');
			}
		}
	}
</script>

<style type="text/css">
	.bg {
		background: white;
	}

	.form.p_4 {
		padding: 1rem;
	}

	.form .el-input {
		width: initial;
	}

	.mt {
		margin-top: 1rem;
	}

	.text_center {
		text-align: center;
	}

	.float-right {
		float: right;
	}


	.modal_wrap{
		width: 100vw;
		height: 100vh;
		position: fixed;
		top: 0;
		left: 0;
		background: rgba(0,0,0,0.5);
		z-index: 9999999999;
	}
	.el-date-editor .el-range-separator{
		width: 10% !important;
	}
	.num_range {
	  display: flex;
	  align-items: center;
	}

	.num_range_span {
	  font-size: 28px;
	}
	td > .cell > a, td > .cell > span, td > .cell {
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 3;
		overflow: hidden;
		text-overflow: ellipsis;
	}
	.expand-all {
		margin-top: 10px;
	}
	.el-table__indent, .el-table__placeholder {
		display: inline-block !important;
	}
.route-map-dialog {
  display: flex;
  height: 500px;
}

.route-map-left {
  flex: 1;
  position: relative;
  height: 100%;
  background: #f5f5f5;
}

.route-map-container {
  width: 100%;
  height: 100%;
}

.route-map-loading {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.8);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 10;
  color: #409eff;
  font-size: 14px;
}

.route-map-right {
  padding-left: 20px;
  overflow-y: auto;
  border-left: 1px solid #eee;
}

.route-map-info-row {
  margin-bottom: 15px;
  display: flex;
  flex-direction: column;
}

.route-map-info-label {
  font-weight: bold;
  margin-bottom: 5px;
  color: #333;
}

.route-map-info-value {
  color: #666;
  line-height: 1.5;
  font-size: 14px;
}
</style>
