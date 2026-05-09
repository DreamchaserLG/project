<template>
	<el-main class="bg table_wrap comtabel_t">
		<el-form label-position="right" :model="query" class="form p_4" label-width="120">
			<el-row class="rows row1">



							<el-col :xs="24" :sm="24" :lg="8" class="el_form_search_wrap" v-if="$check_field('get','announcement_title')">
					<el-form-item label="公告标题">
									<el-input v-model="query.announcement_title"></el-input>
								</el-form-item>
				</el-col>
									<el-col :xs="24" :sm="24" :lg="8" class="el_form_search_wrap" v-if="$check_field('get','announcement_type')">
					<el-form-item label="公告类型">
									<el-select v-model="query.announcement_type">
				                            <el-option v-for="o in list_announcement_type" :key="o" :label="o"
                            	:value="o">
                            </el-option>
										</el-select>
								</el-form-item>
				</el-col>
																						</el-row>
	<el-row class="rows row2">

		<el-col :xs="24" :sm="24" :lg="24" class="search_btn_wrap search_btns">

				<el-col :xs="24" :sm="10" :lg="8" class="search_btn_1 search_btn_wrap_1 btns">

										<el-button type="primary" @click="search()" class="search_btn_find">查询</el-button>
						<el-button @click="reset()" style="margin-right: 74px;" class="search_btn_reset">重置</el-button>
																						

														<el-button v-if="$check_action('/exhibition_announcement/table','del') || $check_action('/exhibition_announcement/view','del')" class="search_btn_del" type="danger" @click="delInfo()">删除</el-button>
								
				</el-col>
		</el-col>
	</el-row >
	<div class="statistics-info" v-if="statisticsData.total > 0">
                                                      </div>

		</el-form>
				<el-table :data="list" @selection-change="selectionChange" @sort-change="$sortChange" style="width: 100%" id="dataTable" row-key="exhibition_announcement_id" :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
			:default-expand-all="isExpandAll" ref="tableRef">
					<el-table-column fixed type="selection" tooltip-effect="dark" width="55">
			</el-table-column>
				<el-table-column prop="announcement_title" @sort-change="$sortChange" label="公告标题" 				v-if="$check_field('get','announcement_title')" min-width="300">
					<template slot-scope="scope">
							{{ scope.row["announcement_title"] }}
									</template>
					</el-table-column>
					<el-table-column prop="announcement_type" @sort-change="$sortChange" label="公告类型" 				v-if="$check_field('get','announcement_type')" min-width="300">
					<template slot-scope="scope">
							{{ scope.row["announcement_type"] }}
									</template>
					</el-table-column>
					<el-table-column prop="exhibitionconvention_number" @sort-change="$sortChange" label="会展编号" 				v-if="$check_field('get','exhibitionconvention_number')" min-width="300">
					<template slot-scope="scope">
							{{ scope.row["exhibitionconvention_number"] }}
									</template>
					</el-table-column>
					<el-table-column prop="host_user" @sort-change="$sortChange" label="主办用户" 				v-if="$check_field('get','host_user')" min-width="300">
						<template slot-scope="scope">
					{{ get_user_host_user(scope.row['host_user']) }}
				</template>
					</el-table-column>
					<el-table-column prop="release_time" @sort-change="$sortChange" label="发布时间" 				v-if="$check_field('get','release_time')" min-width="300">
						<template slot-scope="scope">
									                	{{ $toTime(scope.row["release_time"],"yyyy-MM-dd hh:mm:ss") }}
																		</template>
					</el-table-column>
					<el-table-column prop="announcement_image" @sort-change="$sortChange" label="公告图片" 				v-if="$check_field('get','announcement_image')" min-width="300">
						<template slot-scope="scope">
					<el-image style="width: 100px; height: 100px" :src="$fullUrl(scope.row['announcement_image'])"
						:preview-src-list="[$fullUrl(scope.row['announcement_image'])]">
						<div slot="error" class="image-slot">
							<img src="../../../public/img/error.png" style="width: 90px; height: 90px" />
						</div>
					</el-image>
				</template>
					</el-table-column>
					<el-table-column prop="announcement_vuser_ideo" @sort-change="$sortChange" label="公告视频" 				v-if="$check_field('get','announcement_vuser_ideo')" min-width="300">
						<template slot-scope="scope">
					<a href="javascript:void(0)" @click="announcement_vuser_ideoVideoPlay($fullUrl(scope.row['announcement_vuser_ideo']))" >点此播放</a>
				</template>
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







			<el-table-column fixed="right" label="操作" min-width="200" v-if="$check_action('/exhibition_announcement/table','set') || $check_action('/exhibition_announcement/view','set') || $check_action('/exhibition_announcement/view','get')
						" >


				<template slot-scope="scope">
					<div class="view_a">
					<router-link class="e-button el-button--small is-plain el-button--success" style="margin: 5px !important;"
					v-if="$check_action('/exhibition_announcement/table','set') || $check_action('/exhibition_announcement/view','set') || $check_action('/exhibition_announcement/view','get')"
						:to="'./view?' + field + '=' + scope.row[field]"
						 size="small">
						<span>详情</span>
					</router-link>
						<router-link v-if="$check_comment('/exhibition_announcement/table')" class="e-button el-button--small is-plain el-button--primary"
								  :to="'../comment/table?size=10&page=1&source_table=exhibition_announcement&source_field=' + field + '&source_id=' + scope.row[field]" size="small">
						<span>查看评论</span>
					</router-link>
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
										<el-dialog
					title="视频详情"
					:visible.sync="announcement_vuser_ideoPlayerModalVisible"
					width="30%"
			>
				<video id="announcement_vuser_ideoPlayer" :src="announcement_vuser_ideoVideoUrl" autoplay="autoplay" width="100%" controls>
					您的浏览器不支持Video标签。
				</video>
				<span slot="footer" class="dialog-footer">
				<el-button @click="announcement_vuser_ideoCancelModalVisible">取 消</el-button>
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
				url_get_list: "~/api/exhibition_announcement/get_list",
				url_del: "~/api/exhibition_announcement/del?",

				// 字段ID
				field: "exhibition_announcement_id",
														// 查询
				query: {
					"size":  7,
					"page": 1,
								"announcement_title": "",
											"announcement_type": "",
														"login_time": "",
					"create_time": "",
					"orderby": `create_time desc`
				},

				// 数据
				list: [],
											announcement_vuser_ideoPlayerModalVisible:false,
				announcement_vuser_ideoVideoUrl:"",
									// 公告类型列表
				list_announcement_type: ['活动变更','注意事项','展后总结'],
												// 用户列表
				list_user_host_user: [],
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
											announcement_vuser_ideoVideoPlay(v) {
				this.announcement_vuser_ideoVideoUrl = v
				this.announcement_vuser_ideoPlayerModalVisible = true
			},

			announcement_vuser_ideoCancelModalVisible(){
				this.announcement_vuser_ideoVideoUrl = ""
				this.announcement_vuser_ideoPlayerModalVisible = false
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
