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
			<el-col :xs="24" :sm="24" :lg="8" class="el_form_search_wrap">
				<el-form-item label="越级状态">
					<el-select v-model="query.escalate_state">
						<el-option value="">全部</el-option>
						<el-option value="已越级">已越级</el-option>
						<el-option value="未越级">未越级</el-option>
					</el-select>
				</el-form-item>
			</el-col>
				<el-col :xs="24" :sm="24" :lg="8" class="el_form_search_wrap">
					<el-form-item label="支付状态">
						<el-select v-model="query.pay_state">
							<el-option value="">全部</el-option>
							<el-option value="未支付">未支付</el-option>
							<el-option value="已支付">已支付</el-option>
							<el-option value="退款中">退款中</el-option>
							<el-option value="已退款">已退款</el-option>
							</el-select>
					</el-form-item>
				</el-col>

	</el-row>
	<el-row class="rows row2">

		<el-col :xs="24" :sm="24" :lg="24" class="search_btn_wrap search_btns">

				<el-col :xs="24" :sm="10" :lg="8" class="search_btn_1 search_btn_wrap_1 btns">

										<el-button type="primary" @click="search()" class="search_btn_find">查询</el-button>
						<el-button @click="reset()" style="margin-right: 74px;" class="search_btn_reset">重置</el-button>
																						

										<el-button v-if="$check_option('/registration_information/table', 'examine')" @click="batchInfo()" class="examine_btn_state">批量审核</el-button>
														<el-button v-if="$check_action('/registration_information/table','del') || $check_action('/registration_information/view','del')" class="search_btn_del" type="danger" @click="delInfo()">删除</el-button>
								
				</el-col>
		</el-col>
	</el-row >
	<div class="statistics-info" v-if="statisticsData.total > 0">
                                                                                                      </div>

		</el-form>
				<el-table :data="list" @selection-change="selectionChange" @sort-change="$sortChange" style="width: 100%" id="dataTable" row-key="registration_information_id" :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
			:default-expand-all="isExpandAll" ref="tableRef">
					<el-table-column fixed type="selection" tooltip-effect="dark" width="55">
			</el-table-column>
				<el-table-column prop="order_number" @sort-change="$sortChange" label="订单编号" 				v-if="$check_field('get','order_number')" min-width="300">
					<template slot-scope="scope">
							{{ scope.row["order_number"] }}
									</template>
					</el-table-column>
					<el-table-column prop="booth_number" @sort-change="$sortChange" label="展位编号" 				v-if="$check_field('get','booth_number')" min-width="300">
					<template slot-scope="scope">
							{{ scope.row["booth_number"] }}
									</template>
					</el-table-column>
					<el-table-column prop="exhibitionconvention_number" @sort-change="$sortChange" label="会展编号" 				v-if="$check_field('get','exhibitionconvention_number')" min-width="300">
					<template slot-scope="scope">
							{{ scope.row["exhibitionconvention_number"] }}
									</template>
					</el-table-column>
					<el-table-column prop="exhibition_theme" @sort-change="$sortChange" label="会展主题" 				v-if="$check_field('get','exhibition_theme')" min-width="300">
					<template slot-scope="scope">
							{{ scope.row["exhibition_theme"] }}
									</template>
					</el-table-column>
					<el-table-column prop="host_user" @sort-change="$sortChange" label="主办用户" 				v-if="$check_field('get','host_user')" min-width="300">
						<template slot-scope="scope">
					{{ get_user_host_user(scope.row['host_user']) }}
				</template>
					</el-table-column>
					<el-table-column prop="booth_name" @sort-change="$sortChange" label="展位名称" 				v-if="$check_field('get','booth_name')" min-width="300">
					<template slot-scope="scope">
							{{ scope.row["booth_name"] }}
									</template>
					</el-table-column>
					<el-table-column prop="booth_type" @sort-change="$sortChange" label="展位类型" 				v-if="$check_field('get','booth_type')" min-width="300">
					<template slot-scope="scope">
							{{ scope.row["booth_type"] }}
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
					<el-table-column prop="number_of_registrations" @sort-change="$sortChange" label="报名人数" 				v-if="$check_field('get','number_of_registrations')" min-width="300">
					<template slot-scope="scope">
							{{ scope.row["number_of_registrations"] }}
									</template>
					</el-table-column>
					<el-table-column prop="enterprise_qualifications" @sort-change="$sortChange" label="企业资质" 				v-if="$check_field('get','enterprise_qualifications')" min-width="300">
						<template slot-scope="scope">
					<a v-if="scope.row['enterprise_qualifications']" :href="$fullUrl(scope.row['enterprise_qualifications'])" target="_blank" style="color: rgb(64, 158, 255);margin-right: 10px;">点击下载</a>
					<a v-if="showPreview(scope.row['enterprise_qualifications'])" @click="previewFile(scope.row['enterprise_qualifications'])" style="color: rgb(64, 158, 255);">预览</a>
				</template>
					</el-table-column>
					<el-table-column prop="registration_notes" @sort-change="$sortChange" label="报名备注" 				v-if="$check_field('get','registration_notes')" min-width="300">
					<template slot-scope="scope">
							{{ scope.row["registration_notes"] }}
									</template>
					</el-table-column>
					<el-table-column prop="site_plan" @sort-change="$sortChange" label="场地平面图" 				v-if="$check_field('get','site_plan')" min-width="300">
						<template slot-scope="scope">
					<el-image style="width: 100px; height: 100px" :src="$fullUrl(scope.row['site_plan'])"
						:preview-src-list="[$fullUrl(scope.row['site_plan'])]">
						<div slot="error" class="image-slot">
							<img src="../../../public/img/error.png" style="width: 90px; height: 90px" />
						</div>
					</el-image>
				</template>
					</el-table-column>
					<el-table-column prop="exhibitor_documents" @sort-change="$sortChange" label="参展文件" 				v-if="$check_field('get','exhibitor_documents')" min-width="300">
						<template slot-scope="scope">
					<a v-if="scope.row['exhibitor_documents']" :href="$fullUrl(scope.row['exhibitor_documents'])" target="_blank" style="color: rgb(64, 158, 255);margin-right: 10px;">点击下载</a>
					<a v-if="showPreview(scope.row['exhibitor_documents'])" @click="previewFile(scope.row['exhibitor_documents'])" style="color: rgb(64, 158, 255);">预览</a>
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
			<el-table-column label="越级状态" prop="escalate_state" min-width="120">
				<template slot-scope="scope">
					<el-tag v-if="scope.row['escalate_state'] === '已越级'" type="warning" size="mini" effect="dark">
						<i class="el-icon-top"></i> 已越级
					</el-tag>
					<span v-else style="color: #C0C4CC;">-</span>
				</template>
			</el-table-column>
			<el-table-column label="越级原因" prop="escalate_reason" min-width="200">
				<template slot-scope="scope">
					<span v-if="scope.row['escalate_reason']">{{ scope.row['escalate_reason'] }}</span>
					<span v-else style="color: #C0C4CC;">-</span>
				</template>
			</el-table-column>
			<el-table-column label="审核回复" prop="examine_reply" min-width="200">
			</el-table-column>

			<el-table-column label="支付状态" prop="pay_state" min-width="100">
			</el-table-column>

			<el-table-column label="支付类型" prop="pay_type" min-width="100">
			</el-table-column>
			<el-table-column label="报名状态" min-width="120">
				<template slot-scope="scope">
					<el-tag :type="statusTagType(scope.row)">
						{{ normalizeRegistrationStatus(scope.row) }}
					</el-tag>
					<div class="status_hint" v-if="statusHint(scope.row)">
						{{ statusHint(scope.row) }}
					</div>
				</template>
			</el-table-column>
			<el-table-column label="候补序号" prop="waitlist_no" min-width="100">
				<template slot-scope="scope">
					{{ normalizeRegistrationStatus(scope.row) === '候补中' ? (scope.row.waitlist_no || '-') : '-' }}
				</template>
			</el-table-column>
			<el-table-column prop="confirm_time" label="转正时间" min-width="180">
				<template slot-scope="scope">
					{{ scope.row.confirm_time ? $toTime(scope.row["confirm_time"],"yyyy-MM-dd hh:mm:ss") : '-' }}
				</template>
			</el-table-column>
			<el-table-column prop="cancel_time" label="取消时间" min-width="180">
				<template slot-scope="scope">
					{{ scope.row.cancel_time ? $toTime(scope.row["cancel_time"],"yyyy-MM-dd hh:mm:ss") : '-' }}
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







			<el-table-column fixed="right" label="操作" min-width="200" v-if="$check_action('/registration_information/table','set') || $check_action('/registration_information/view','set') || $check_action('/registration_information/view','get')
						|| $check_action('/travel_confirmation/table','add') || $check_action('/travel_confirmation/view','add')
						|| $check_action('/refund_request/table','add') || $check_action('/refund_request/view','add')
						" >


				<template slot-scope="scope">
					<div class="view_a">
					<router-link class="e-button el-button--small is-plain el-button--success" style="margin: 5px !important;"
					v-if="$check_action('/registration_information/table','set') || $check_action('/registration_information/view','set') || $check_action('/registration_information/view','get')"
						:to="'./view?' + field + '=' + scope.row[field]"
						 size="small">
						<span>详情</span>
					</router-link>
						<!--跨表按钮-->
										<el-button class="e-button el-button--small is-plain el-button--primary" style="margin: 5px !important;" size="small" @click="to_table(scope.row,'/travel_confirmation/view')" v-if="($check_action('/travel_confirmation/table','add') || $check_action('/travel_confirmation/view','add')) && canTravel(scope.row)">
						<span>行程确认</span>
					</el-button>
													<el-button class="e-button el-button--small is-plain el-button--primary" style="margin: 5px !important;" size="small" @click="to_table(scope.row,'/refund_request/view')" v-if="($check_action('/refund_request/table','add') || $check_action('/refund_request/view','add')) && canRefund(scope.row)">
						<span>退款申请</span>
					</el-button>
												<el-button class="e-button el-button--small is-plain el-button--primary" style="margin: 5px !important;" size="small" @click="openPayModal(scope.row)" v-if="($check_pay('/registration_information/table')) && canPay(scope.row)">
						<span>支付</span>
					</el-button>
						<el-button class="e-button el-button--small is-plain el-button--warning" style="margin: 5px !important;" size="small" @click="cancelRegistration(scope.row)" v-if="canCancel(scope.row)">
						<span>{{ normalizeRegistrationStatus(scope.row) === '候补中' ? '取消候补' : '取消报名' }}</span>
					</el-button>
						<el-button class="e-button el-button--small is-plain el-button--primary" style="margin: 5px !important;" size="small" @click="changeSigning(scope.row, scope.$index)" v-if="$check_option('/registration_information/table', 'examine')  ">
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
				<div v-if="!batchAllState" class="verify-summary">
					<div class="verify-summary__item">
						<span>订单编号</span>
						<strong>{{ verifyItem.order_number || '-' }}</strong>
					</div>
					<div class="verify-summary__item">
						<span>会展主题</span>
						<strong>{{ verifyItem.exhibition_theme || '-' }}</strong>
					</div>
					<div class="verify-summary__item">
						<span>会展编号</span>
						<strong>{{ verifyItem.exhibitionconvention_number || '-' }}</strong>
					</div>
					<div class="verify-summary__item">
						<span>展位编号</span>
						<strong>{{ verifyItem.booth_number || '-' }}</strong>
					</div>
					<div class="verify-summary__item">
						<span>展位名称</span>
						<strong>{{ verifyItem.booth_name || '-' }}</strong>
					</div>
					<div class="verify-summary__item">
						<span>报名用户</span>
						<strong>{{ getVerifyEnrolledUser(verifyItem) }}</strong>
					</div>
					<div class="verify-summary__item">
						<span>报名状态</span>
						<strong>{{ normalizeRegistrationStatus(verifyItem) }}</strong>
					</div>
					<div class="verify-summary__item">
						<span>支付状态</span>
						<strong>{{ verifyItem.pay_state || '-' }}</strong>
					</div>
					<div class="verify-summary__item">
						<span>候补序号</span>
						<strong>{{ normalizeRegistrationStatus(verifyItem) === '候补中' ? (verifyItem.waitlist_no || '-') : '-' }}</strong>
					</div>
				</div>
				<div v-else class="verify-summary verify-summary--batch">
					已选择 {{ batchAllList.length }} 条报名记录，本次将统一写入审核结果。
				</div>
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
																																																																								<el-dialog title="支付" :visible.sync="payModalVisible" width="500px">
			<div class="pay_step pay_step_one" v-if="pay_step == 1">
				<div class="pay_info">
																																	<div class="pay_info_item">
						<div class="pay_info_item_title">支付内容</div>
						<div class="pay_info_item_content">{{ pay_data.booth_name }}</div>
					</div>
																			<div class="pay_info_item">
						<div class="pay_info_item_title">订单金额</div>
						<div class="pay_info_item_content">¥{{ pay_data.booth_prices }}</div>
					</div>
																																																	<div class="pay_info_item pay_amount">
						<div class="pay_info_item_title">实付金额</div>
						<div class="pay_info_item_content pay_info_amount">¥{{ pay_data.amount_paid }}</div>
					</div>
				</div>
				<div class="pay_type">
					<div class="pay_type_title">支付方式</div>
					<div class="pay_type_list">
						<div class="pay_type_item" v-for="item in pay_source" :class="{'pay_type_item_active': pay_obj.payActiveName == item.name}" @click="pay_obj.payActiveName = item.name">
							<div class="pay_type_img"><img :src="item.img" alt=""></div>
							<div class="pay_type_name">{{ item.name }}</div>
								<!--<div class="pay_type_remark" v-if="item.name == '积分兑换'">可用 {{ user.integral }}</div>-->
						</div>
					</div>
				</div>
				<div class="pay_btn">
					<el-button class="e-button el-button--primary" @click="confirmPayStep()">
						<span>确认</span>
					</el-button>
				</div>
			</div>
			<div class="pay_step pay_step_two" v-if="pay_step == 2">
				<div class="pay_op">
					<el-image v-if="pay_obj.payActiveName == '微信支付'" :src="pay_source[0].pay_img"></el-image>
					<el-image v-if="pay_obj.payActiveName == '支付宝支付'" :src="pay_source[1].pay_img"></el-image>
					<div class="pay_ebank" v-if="pay_obj.payActiveName == '网银支付'">
						<div class="pay_ebank_item">
							<div class="pay_ebank_title">请输入网银账号：</div>
							<el-input class="pay_ebank_input" v-model="pay_obj.account" placeholder="请输入网银账号"></el-input>
						</div>
						<div class="pay_ebank_item">
							<div class="pay_ebank_title">请输入支付密码，6位数字：</div>
							<el-input class="pay_ebank_input" placeholder="请输入密码" v-model="pay_obj.password" show-password maxlength="6"></el-input>
						</div>
					</div>
				</div>
				<div class="pay_btn">
					<el-button class="e-button is-plain el-button--primary" @click="pay_step = 1">
						<span>其他支付方式</span>
					</el-button>
					<el-button class="e-button el-button--primary" @click="submitPay()">
						<span>确认支付</span>
					</el-button>
				</div>
			</div>
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
				url_get_list: "~/api/registration_information/get_list",
				url_del: "~/api/registration_information/del?",

				// 字段ID
				field: "registration_information_id",
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
					"escalate_state":"",
					"pay_state":"",
					"login_time": "",
					"create_time": "",
					"orderby": `CASE WHEN examine_state = '未审核' THEN 1 ELSE 2 END,create_time desc`
				},

				// 数据
				list: [],
				pay_step: 1,
				pay_data: {},
				pay_source: [
					{
						name: "微信支付",
						img: require('../../../public/icon/wechat.svg'),
						pay_img: require('../../../public/wx.png')
					},
					{
						name: "支付宝支付",
						img: require('../../../public/icon/alipay.svg'),
						pay_img: require('../../../public/alipay.png')
					},
					{
						name: "网银支付",
						img: require('../../../public/icon/ebank.svg')
					},
						
				],
				payModalVisible:false,
				pay_obj:{
					payActiveName:"微信支付",
					account:"",
					password:"",
					id:""
				},
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
			normalizeRegistrationStatus(row) {
				if (!row || !row.registration_status) {
					return "已报名";
				}
				return row.registration_status;
			},
			statusTagType(row) {
				let status = this.normalizeRegistrationStatus(row);
				if (status === "已报名") {
					return "success";
				}
				if (status === "候补中") {
					return "warning";
				}
				if (status === "已取消") {
					return "info";
				}
				return "";
			},
			statusHint(row) {
				const status = this.normalizeRegistrationStatus(row);
				if (status === "候补中" && row.examine_state === "已通过" && row.waitlist_no) {
					return "候补第 " + row.waitlist_no + " 位";
				}
				if (status === "候补中" && row.examine_state !== "已通过") {
					return "候补申请待审核";
				}
				if (status === "已报名" && row.examine_state === "已通过" && row.pay_state === "未支付") {
					return "已转为正式报名，请尽快支付";
				}
				if (row.examine_state === "未通过") {
					return "审核不通过";
				}
				return "";
			},
			getVerifyEnrolledUser(row) {
				if (!row) {
					return "-";
				}
				return this.get_user_enrolled_user(row.enrolled_user) || row.user_name || "-";
			},
			canPay(row) {
				return this.normalizeRegistrationStatus(row) === "已报名"
					&& row.pay_state === "未支付"
					&& row.examine_state !== "未通过";
			},
			canTravel(row) {
				return this.normalizeRegistrationStatus(row) === "已报名"
					&& row.examine_state === "已通过"
					&& row.pay_state === "已支付"
					&& !row.travel_confirmation_limit
					&& !row.travel_confirmation_status_limit;
			},
			canRefund(row) {
				return this.normalizeRegistrationStatus(row) === "已报名"
					&& row.examine_state === "已通过"
					&& row.pay_state === "已支付"
					&& !row.refund_request_limit
					&& !row.refund_request_status_limit;
			},
			canCancel(row) {
				if (this.normalizeRegistrationStatus(row) === "候补中") {
					return true;
				}
				return this.normalizeRegistrationStatus(row) === "已报名" && row.pay_state !== "退款中";
			},
			cancelRegistration(row) {
				this.$confirm(
					this.normalizeRegistrationStatus(row) === "候补中" ? "确认取消当前候补资格？" : "确认取消当前报名？",
					"提示",
					{
						confirmButtonText: "确定",
						cancelButtonText: "取消",
						type: "warning",
						cancelButtonClass: "custom-cancel-btn"
					}
				).then(() => {
					this.$post("~/api/registration_information/cancel/" + row.registration_information_id, {}, (json) => {
						if (json && json.result) {
							this.$toast(json.result.message || "操作成功", "success");
							this.get_list();
						} else if (json && json.error) {
							this.$toast(json.error.message, "danger");
						}
					});
				}).catch(() => {});
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
						let successMessage = "审核成功";
						if (this.batchAllState) {
							if(this.batchAllList.length == 0){
								_this.$toast("请选择要操作的数据", "danger");
								return;
							}
							for (var i = 0; i < this.batchAllList.length; i++) {
								let url = "~/api/registration_information/set?registration_information_id=" +  this.batchAllList[i]["registration_information_id"];
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
									if (json.result && json.result.message) {
										successMessage = json.result.message;
									}
									let message_inform = {
									title: '审核结果',
									type: '通知',
									content: '你在报名信息下提交的内容，审核结果为：' + _this.verifyItem.examine_state,
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
							var url = "~/api/registration_information/set?registration_information_id=" + this.verifyItem['registration_information_id']
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
										content: '你在报名信息下提交的内容，审核结果为：' + _this.verifyItem.examine_state,
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
				_this.list.map((item) => {
					if(!item.registration_status){
						_this.$set(item,'registration_status','已报名');
					}
				})

												_this.list.map((item) => {
					let param = {
						source_table: "registration_information",
						source_id: item.registration_information_id,
						source_user_id: _this.user.user_id
					};
					if(item.travel_confirmation_limit_times > 0){
						_this.$get("~/api/travel_confirmation/count?",param,(result)=>{
							if(result){
								if(result.result >= item.travel_confirmation_limit_times){
									_this.$set(item,'travel_confirmation_limit',true);
								}else{
									_this.$set(item,'travel_confirmation_limit',false);
								}
							}
						})
					}else{
						_this.$set(item,'travel_confirmation_limit',false);
					}
					Object.assign(item, param)
				})
								_this.list.map((item) => {
					let param = {
						source_table: "registration_information",
						source_id: item.registration_information_id,
						source_user_id: _this.user.user_id
					};
					if(item.refund_request_limit_times > 0){
						_this.$get("~/api/refund_request/count?",param,(result)=>{
							if(result){
								if(result.result >= item.refund_request_limit_times){
									_this.$set(item,'refund_request_limit',true);
								}else{
									_this.$set(item,'refund_request_limit',false);
								}
							}
						})
					}else{
						_this.$set(item,'refund_request_limit',false);
					}
					Object.assign(item, param)
				})
																																																																																																},

			get_list_before(param){
				var user_group = this.user.user_group;
				var sqlwhere = "(";
				if(user_group != "管理员"){
																													if(user_group=="主办用户"){
					sqlwhere+= "host_user = " + this.user.user_id + " or ";
				}
																											if(user_group=="普通用户"){
					sqlwhere+= "enrolled_user = " + this.user.user_id + " or ";
				}
				sqlwhere = sqlwhere.substr(0,sqlwhere.length-4);
				sqlwhere += ")";
				}

				if(param["escalate_state"] === "未越级"){
					delete param["escalate_state"];
					var escalateWhere = "(escalate_state IS NULL OR escalate_state = '')";
					if(sqlwhere.length > 1){
						sqlwhere = sqlwhere + " AND " + escalateWhere;
					}else{
						sqlwhere = escalateWhere;
					}
				}

				if(sqlwhere.length > 1){
					param["sqlwhere"] = sqlwhere;
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
																			openPayModal(v){
				this.pay_data = v
																												this.pay_data.amount_paid = v.booth_prices
																																this.pay_obj.id = v.registration_information_id
				this.payModalVisible = true
			},
			confirmPayStep() {
				if (this.pay_obj.payActiveName == "微信支付" || this.pay_obj.payActiveName == "支付宝支付" || this.pay_obj.payActiveName == "网银支付") {
					this.pay_step = 2
				}
				},
			submitPay(){
									let message_inform1 = {
						title: '用户支付订单成功',
						type: '消息',
						content: this.user.username + '-' + this.user.nickname + '成功支付了',
						state: 1,
						user_id: '9999'
					}
								let _this = this;
				if(_this.pay_obj.payActiveName == "网银"){
					if(_this.pay_obj.account == ""){
						_this.$toast("请输入网银账号", 'danger');
						return false
					}
					if(_this.pay_obj.password.length < 6){
						_this.$toast("请输入6位数的支付密码", 'danger');
						return false
					}
				}
				let url = this.$toUrl(this.query, "~/api/registration_information/set?registration_information_id="+this.pay_obj.id);
				let name = this.pay_obj.payActiveName;
            	let payType = name.endsWith("支付") ? name.slice(0, -2) : name;
				let param = {"pay_state":"已支付","pay_type":payType}
																																																					this.$post(url, param, function(json, status) {
					console.log("提交结果：" ,json);
					if (json.result) {
							_this.$toast('支付成功！', 'success');
						_this.payModalVisible = false;
													_this.$post("~/api/message_inform/add",message_inform1)
												_this.get_list();
					} else if (json.error) {
						_this.$toast(json.error.message, 'danger');
					}
				});
				setTimeout(() => {
					this.pay_obj.payActiveName = "微信支付"
					this.pay_step = 1
				}, 1000);
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
.status_hint{
	margin-top: 6px;
	font-size: 12px;
	line-height: 1.5;
	color: #8c8c8c;
}
.verify-summary{
	display: grid;
	grid-template-columns: repeat(2, minmax(0, 1fr));
	gap: 10px 14px;
	padding: 0 0 16px;
	margin-bottom: 16px;
	border-bottom: 1px solid #ebeef5;
}
.verify-summary__item{
	display: flex;
	flex-direction: column;
	gap: 4px;
	padding: 10px 12px;
	border-radius: 8px;
	background: #f8fafc;
}
.verify-summary__item span{
	font-size: 12px;
	color: #909399;
}
.verify-summary__item strong{
	font-size: 13px;
	color: #303133;
	font-weight: 600;
	word-break: break-all;
}
.verify-summary--batch{
	display: block;
	padding: 12px 14px;
	border-radius: 8px;
	background: #f8fafc;
	color: #606266;
}
.pay_info .pay_info_item{
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 10px;
}
.pay_info .pay_info_item .pay_info_item_content{
	color: #999;
}
.pay_info .pay_amount{
	margin-top: 100px;
	padding: 10px 0;
	border-top: 1px solid #eee;
	border-bottom: 1px solid #eee;
}
.pay_info .pay_info_item .pay_info_amount{
	font-weight: bold;
	font-size: 16px;
	color: red;
}
.pay_type .pay_type_title{
	color: #999;
	margin-bottom: 10px;
}
.pay_type .pay_type_list{
	display: grid;
	gap: 10px;
	grid-template-columns: repeat(3, 1fr);
}
.pay_type .pay_type_item{
	background: #f1f1f1;
	border: 1px solid #f1f1f1;
	border-radius: 5px;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	padding: 20px 10px;
}
.pay_type .pay_type_item .pay_type_img{
	width: 30px;
	height: 30px;
	margin-bottom: 10px;
}
.pay_type .pay_type_item .pay_type_img img{
	width: 100%;
	height: 100%;
	object-fit: contain;
}
.pay_type .pay_type_item .pay_type_remark{
	font-size: 12px;
	color: #999;
}
.pay_type .pay_type_item_active{
	border: 1px solid #2c70f6;
}
.pay_btn{
	display: flex;
	align-items: center;
	justify-content: space-between;
}
.pay_btn button{
	width: 100%;
	margin-top: 20px;
	height: 42px;
	line-height: 42px;
	padding: 0;
}
.pay_ebank_title{
	margin: 15px 0 10px 0;
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
