<template>
	<div class="diy_edit page_registration_information" id="registration_information_edit">
		<div class='warp'>
			<div class='container'>
				<div class='row diy_edit_content_box'>
					<div class="form-item col-12 col-md-6" v-for="([key, item], index) in Object.entries(extra_info)" v-if="extra_info">
						<div class="diy_title">
							<span>{{ key }}</span>
						</div>
						<div class="diy_field diy_text">
							<span>{{ item }}</span>
						</div>
					</div>
								<div v-if="$check_field('set','order_number') || $check_field('add','order_number') || $check_field('get','order_number')" class="form-item col-12 col-md-6">
						<div class="diy_title">
							<span>
															订单编号:
							</span>
						</div>
								<!-- 文本 -->
									<div class="diy_field diy_text">
							<div class="input-block" v-if="(form['order_number'] && $check_field('set','order_number')) || (!form['order_number'] && $check_field('add','order_number'))">
								<input type="text" id="form_order_number" v-model="form['order_number']" placeholder="请输入订单编号" :disabled="true"/>
															</div>
							<span v-else-if="$check_field('get','order_number')">{{ form['order_number'] }}</span>
						</div>
												</div>
													<div v-if="$check_field('set','booth_number') || $check_field('add','booth_number') || $check_field('get','booth_number')" class="form-item col-12 col-md-6">
						<div class="diy_title">
							<span>
															<span class="asterisk-left" style="color: #F56C6C;">*</span>
															展位编号:
							</span>
						</div>
								<!-- 文本 -->
									<div class="diy_field diy_text">
							<div class="input-block" v-if="(form['booth_number'] && $check_field('set','booth_number')) || (!form['booth_number'] && $check_field('add','booth_number'))">
								<input type="text" id="form_booth_number" v-model="form['booth_number']" placeholder="请输入展位编号" v-if="(form['booth_number'] && $check_field('set','booth_number')) || (!form['booth_number'] && $check_field('add','booth_number'))"  :disabled="disabledObj['booth_number_isDisabled']"/>
															</div>
							<span v-else-if="$check_field('get','booth_number')">{{ form['booth_number'] }}</span>
						</div>
												</div>
													<div v-if="$check_field('set','exhibitionconvention_number') || $check_field('add','exhibitionconvention_number') || $check_field('get','exhibitionconvention_number')" class="form-item col-12 col-md-6">
						<div class="diy_title">
							<span>
															会展编号:
							</span>
						</div>
								<!-- 文本 -->
									<div class="diy_field diy_text">
							<div class="input-block" v-if="(form['exhibitionconvention_number'] && $check_field('set','exhibitionconvention_number')) || (!form['exhibitionconvention_number'] && $check_field('add','exhibitionconvention_number'))">
								<input type="text" id="form_exhibitionconvention_number" v-model="form['exhibitionconvention_number']" placeholder="请输入会展编号" v-if="(form['exhibitionconvention_number'] && $check_field('set','exhibitionconvention_number')) || (!form['exhibitionconvention_number'] && $check_field('add','exhibitionconvention_number'))"  :disabled="disabledObj['exhibitionconvention_number_isDisabled']"/>
															</div>
							<span v-else-if="$check_field('get','exhibitionconvention_number')">{{ form['exhibitionconvention_number'] }}</span>
						</div>
												</div>
													<div v-if="$check_field('set','exhibition_theme') || $check_field('add','exhibition_theme') || $check_field('get','exhibition_theme')" class="form-item col-12 col-md-6">
						<div class="diy_title">
							<span>
															会展主题:
							</span>
						</div>
								<!-- 文本 -->
									<div class="diy_field diy_text">
							<div class="input-block" v-if="(form['exhibition_theme'] && $check_field('set','exhibition_theme')) || (!form['exhibition_theme'] && $check_field('add','exhibition_theme'))">
								<input type="text" id="form_exhibition_theme" v-model="form['exhibition_theme']" placeholder="请输入会展主题" v-if="(form['exhibition_theme'] && $check_field('set','exhibition_theme')) || (!form['exhibition_theme'] && $check_field('add','exhibition_theme'))"  :disabled="disabledObj['exhibition_theme_isDisabled']"/>
															</div>
							<span v-else-if="$check_field('get','exhibition_theme')">{{ form['exhibition_theme'] }}</span>
						</div>
												</div>
											<div v-if="$check_field('set','host_user') || $check_field('add','host_user') || $check_field('get','host_user')" class="form-item col-12 col-md-6">
						<div class="diy_title">
							<span>
								主办用户:
							</span>
						</div>
						<div class="diy_field diy_down">
							<select id="form_host_user" :disabled="disabledObj['host_user_isDisabled']" v-model="form['host_user']" v-if="(form['host_user'] && $check_field('set','host_user')) || (!form['host_user'] && $check_field('add','host_user'))" >
								<option v-for="o in list_user_host_user" :value="o['user_id']">
									{{o['nickname'] + '-' + o['username']}}
								</option>
							</select>
							<span v-else-if="$check_field('get','host_user')">{{ get_user_info("host_user", form['host_user']) }}</span>
						</div>
					</div>
									<div v-if="$check_field('set','booth_name') || $check_field('add','booth_name') || $check_field('get','booth_name')" class="form-item col-12 col-md-6">
						<div class="diy_title">
							<span>
															展位名称:
							</span>
						</div>
								<!-- 文本 -->
									<div class="diy_field diy_text">
							<div class="input-block" v-if="(form['booth_name'] && $check_field('set','booth_name')) || (!form['booth_name'] && $check_field('add','booth_name'))">
								<input type="text" id="form_booth_name" v-model="form['booth_name']" placeholder="请输入展位名称" v-if="(form['booth_name'] && $check_field('set','booth_name')) || (!form['booth_name'] && $check_field('add','booth_name'))"  :disabled="disabledObj['booth_name_isDisabled']"/>
															</div>
							<span v-else-if="$check_field('get','booth_name')">{{ form['booth_name'] }}</span>
						</div>
												</div>
													<div v-if="$check_field('set','booth_type') || $check_field('add','booth_type') || $check_field('get','booth_type')" class="form-item col-12 col-md-6">
						<div class="diy_title">
							<span>
															展位类型:
							</span>
						</div>
								<!-- 文本 -->
									<div class="diy_field diy_text">
							<div class="input-block" v-if="(form['booth_type'] && $check_field('set','booth_type')) || (!form['booth_type'] && $check_field('add','booth_type'))">
								<input type="text" id="form_booth_type" v-model="form['booth_type']" placeholder="请输入展位类型" v-if="(form['booth_type'] && $check_field('set','booth_type')) || (!form['booth_type'] && $check_field('add','booth_type'))"  :disabled="disabledObj['booth_type_isDisabled']"/>
															</div>
							<span v-else-if="$check_field('get','booth_type')">{{ form['booth_type'] }}</span>
						</div>
												</div>
													<div v-if="$check_field('set','booth_prices') || $check_field('add','booth_prices') || $check_field('get','booth_prices')" class="form-item col-12 col-md-6">
						<div class="diy_title">
							<span>
															展位价格:
							</span>
						</div>
								<!-- 数字 -->
						<div class="diy_field diy_number">
							<div class="input-block" v-if="(form['booth_prices'] && $check_field('set','booth_prices')) || (!form['booth_prices'] && $check_field('add','booth_prices'))">
								<input type="number" id="form_booth_prices" v-model.number="form['booth_prices']" placeholder="请输入展位价格" :disabled="disabledObj['booth_prices_isDisabled']" />
															</div>
							<span v-else-if="$check_field('get','booth_prices')">{{ form['booth_prices'] }}</span>
						</div>
									</div>
											<div v-if="$check_field('set','enrolled_user') || $check_field('add','enrolled_user') || $check_field('get','enrolled_user')" class="form-item col-12 col-md-6">
						<div class="diy_title">
							<span>
								报名用户:
							</span>
						</div>
						<div class="diy_field diy_down">
							<select id="form_enrolled_user" :disabled="disabledObj['enrolled_user_isDisabled']" v-model="form['enrolled_user']" v-if="(form['enrolled_user'] && $check_field('set','enrolled_user')) || (!form['enrolled_user'] && $check_field('add','enrolled_user'))" >
								<option v-for="o in list_user_enrolled_user" :value="o['user_id']">
									{{o['nickname'] + '-' + o['username']}}
								</option>
							</select>
							<span v-else-if="$check_field('get','enrolled_user')">{{ get_user_info("enrolled_user", form['enrolled_user']) }}</span>
						</div>
					</div>
									<div v-if="$check_field('set','user_name') || $check_field('add','user_name') || $check_field('get','user_name')" class="form-item col-12 col-md-6">
						<div class="diy_title">
							<span>
															用户姓名:
							</span>
						</div>
								<!-- 文本 -->
									<div class="diy_field diy_text">
							<div class="input-block" v-if="(form['user_name'] && $check_field('set','user_name')) || (!form['user_name'] && $check_field('add','user_name'))">
								<input type="text" id="form_user_name" v-model="form['user_name']" placeholder="请输入用户姓名" v-if="(form['user_name'] && $check_field('set','user_name')) || (!form['user_name'] && $check_field('add','user_name'))"  :disabled="disabledObj['user_name_isDisabled']"/>
															</div>
							<span v-else-if="$check_field('get','user_name')">{{ form['user_name'] }}</span>
						</div>
												</div>
													<div v-if="$check_field('set','users_mobile_phone') || $check_field('add','users_mobile_phone') || $check_field('get','users_mobile_phone')" class="form-item col-12 col-md-6">
						<div class="diy_title">
							<span>
															用户手机:
							</span>
						</div>
								<!-- 文本 -->
									<div class="diy_field diy_text">
							<div class="input-block" v-if="(form['users_mobile_phone'] && $check_field('set','users_mobile_phone')) || (!form['users_mobile_phone'] && $check_field('add','users_mobile_phone'))">
								<input type="text" id="form_users_mobile_phone" v-model="form['users_mobile_phone']" placeholder="请输入用户手机" v-if="(form['users_mobile_phone'] && $check_field('set','users_mobile_phone')) || (!form['users_mobile_phone'] && $check_field('add','users_mobile_phone'))"  :disabled="disabledObj['users_mobile_phone_isDisabled']"/>
															</div>
							<span v-else-if="$check_field('get','users_mobile_phone')">{{ form['users_mobile_phone'] }}</span>
						</div>
												</div>
													<div v-if="$check_field('set','number_of_registrations') || $check_field('add','number_of_registrations') || $check_field('get','number_of_registrations')" class="form-item col-12 col-md-6">
						<div class="diy_title">
							<span>
															报名人数:
							</span>
						</div>
								<!-- 数字 -->
						<div class="diy_field diy_number">
							<div class="input-block" v-if="(form['number_of_registrations'] && $check_field('set','number_of_registrations')) || (!form['number_of_registrations'] && $check_field('add','number_of_registrations'))">
								<input type="number" id="form_number_of_registrations" v-model.number="form['number_of_registrations']" placeholder="请输入报名人数" :disabled="disabledObj['number_of_registrations_isDisabled']" />
															</div>
							<span v-else-if="$check_field('get','number_of_registrations')">{{ form['number_of_registrations'] }}</span>
						</div>
									</div>
													<div v-if="$check_field('set','enterprise_qualifications') || $check_field('add','enterprise_qualifications') || $check_field('get','enterprise_qualifications')" class="form-item col-12 col-md-6">
						<div class="diy_title">
							<span>
															企业资质:
							</span>
						</div>
								<!-- 文件 -->
						<input type="file" style="display: none;" id="form_file_enterprise_qualifications" title="enterprise_qualifications" @change="change_file($event.target.files,'enterprise_qualifications')"/>
						<!-- 修改权限 -->
						<div class="diy_field diy_img" v-if="form['enterprise_qualifications'] && $check_field('set','enterprise_qualifications')">
							<label for="form_file_enterprise_qualifications">
								<!--<span>{{form['enterprise_qualifications']}} </span>-->
								<a :href="$fullUrl(form['enterprise_qualifications'])" target="_blank" style="color: rgb(64, 158, 255);">点击下载</a>
							</label>
						</div>
						<!-- 添加权限 -->
						<div class="diy_field diy_img" v-else-if="!form['enterprise_qualifications'] && $check_field('add','enterprise_qualifications')">
							<label for="form_file_enterprise_qualifications">
								<div class="btn_add_img">
									<span>+</span>
								</div>
							</label>
						</div>
						<!-- 查询权限 -->
						<div class="diy_field diy_img" v-else-if="$check_field('get','enterprise_qualifications')">
							<span>{{form['enterprise_qualifications']}} </span>
						</div>
									</div>
													<div v-if="$check_field('set','registration_notes') || $check_field('add','registration_notes') || $check_field('get','registration_notes')" class="form-item col-12 col-md-6">
						<div class="diy_title">
							<span>
															报名备注:
							</span>
						</div>
								<!-- 多文本 -->
						<div class="diy_field diy_desc">
							<textarea id="form_registration_notes" v-model="form['registration_notes']" v-if="(form['registration_notes'] && $check_field('set','registration_notes')) || (!form['registration_notes'] && $check_field('add','registration_notes'))" :disabled="disabledObj['registration_notes_isDisabled']" />
							<span v-else-if="$check_field('get','registration_notes')">{{ form['registration_notes'] }}</span>
						</div>
									</div>
													<div v-if="$check_field('set','site_plan') || $check_field('add','site_plan') || $check_field('get','site_plan')" class="form-item col-12 col-md-6">
						<div class="diy_title">
							<span>
															场地平面图:
							</span>
						</div>
								<!-- 图片 -->
						<input type="file" :disabled="disabledObj['site_plan_isDisabled']" style="display: none;" id="form_img_site_plan" title="site_plan" @change="change_file($event.target.files,'site_plan')"/>
						<!-- 修改权限 -->
						<div class="diy_field diy_img" v-if="form['site_plan'] && $check_field('set','site_plan')">
							<label for="form_img_site_plan">
								<img :src="$fullUrl(form['site_plan'])" />
							</label>
						</div>
						<!-- 添加权限 -->
						<div class="diy_field diy_img" v-else-if="!form['site_plan'] && $check_field('add','site_plan')">
							<label for="form_img_site_plan">
								<div class="btn_add_img">
									<span>+</span>
								</div>
							</label>
						</div>
						<!-- 查询权限 -->
						<div class="diy_field diy_img" v-else-if="$check_field('get','site_plan')">
							<img :src="$fullUrl(form['site_plan'])" />
						</div>
									</div>
													<div v-if="$check_field('set','exhibitor_documents') || $check_field('add','exhibitor_documents') || $check_field('get','exhibitor_documents')" class="form-item col-12 col-md-6">
						<div class="diy_title">
							<span>
															参展文件:
							</span>
						</div>
								<!-- 文件 -->
						<input type="file" style="display: none;" id="form_file_exhibitor_documents" title="exhibitor_documents" @change="change_file($event.target.files,'exhibitor_documents')"/>
						<!-- 修改权限 -->
						<div class="diy_field diy_img" v-if="form['exhibitor_documents'] && $check_field('set','exhibitor_documents')">
							<label for="form_file_exhibitor_documents">
								<!--<span>{{form['exhibitor_documents']}} </span>-->
								<a :href="$fullUrl(form['exhibitor_documents'])" target="_blank" style="color: rgb(64, 158, 255);">点击下载</a>
							</label>
						</div>
						<!-- 添加权限 -->
						<div class="diy_field diy_img" v-else-if="!form['exhibitor_documents'] && $check_field('add','exhibitor_documents')">
							<label for="form_file_exhibitor_documents">
								<div class="btn_add_img">
									<span>+</span>
								</div>
							</label>
						</div>
						<!-- 查询权限 -->
						<div class="diy_field diy_img" v-else-if="$check_field('get','exhibitor_documents')">
							<span>{{form['exhibitor_documents']}} </span>
						</div>
									</div>
					


					<div v-if="$check_examine()" class="form-item col-12 col-md-6">
						<div class="diy_title">
							<span>
								审核状态:
							</span>
						</div>
						<div class="diy_field diy_select" v-if="$check_action('/registration_information/edit','examine')">
							<!--<span> {{ form['examine_state'] }} </span>-->
							<select v-model="form['examine_state']">
								<option value="未审核">
									未审核
								</option>
								<option value="已通过">
									已通过
								</option>
								<option value="未通过">
									未通过
								</option>
							</select>
						</div>
						<div class="diy_field diy_text" v-else>
							<span>
								{{ form['examine_state'] }}
							</span>
						</div>
					</div>
					<div v-if="$check_examine()" class="form-item col-12 col-md-6">
						<div class="diy_title">
							<span>
								审核回复:
							</span>
						</div>
						<div class="diy_field diy_desc" v-if="$check_action('/registration_information/edit','examine')">
							<textarea v-model="form['examine_reply']"></textarea>
						</div>
						<div class="diy_field diy_text" v-else>
							<span>
								{{ form['examine_reply'] }}
							</span>
						</div>
					</div>


				</div>
				<div class="diy_edit_submit_box row">
					<div class="col-12">
						<div class="btn_box">
							<button class="btn_submit" @click="openPayModal()">提交</button>
						</div>
					</div>
				</div>
			</div>
		</div>
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
              <el-button class="e-button el-button--primary" @click="submit_pay('pay')">
                <span>确认支付</span>
              </el-button>
            </div>
          </div>
        </el-dialog>
		</div>
</template>

<script>
	import mixin from "@/mixins/page.js";
																                                																	export default {
		mixins: [mixin],
		components: {
																																																																																				},
		data() {
			return {
				url_get_obj: "~/api/registration_information/get_obj?",
				url_add: "~/api/registration_information/add?",
				url_set: "~/api/registration_information/set?",
				url_upload: "~/api/registration_information/upload?",
				url_get_list: "~/api/registration_information/get_list?",
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
				payModalVisible: false,
				pay_obj: {
					payActiveName: "微信支付",
					account: "",
					password: "",
					id: "",
				},
				// 登录权限
				oauth: {
					"signIn": true,
					"user_group": []
				},

				// 查询条件
				query: {
						"order_number": "",
							"booth_number": "",
							"exhibitionconvention_number": "",
							"exhibition_theme": "",
							"host_user": 0,
							"booth_name": "",
							"booth_type": "",
							"booth_prices": 0,
							"enrolled_user": 0,
							"user_name": "",
							"users_mobile_phone": "",
							"number_of_registrations": 0,
							"enterprise_qualifications": "",
							"registration_notes": "",
							"site_plan": "",
							"exhibitor_documents": "",
						"registration_information_id": 0,
				},

				obj: {
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
							"number_of_registrations":  0, // 报名人数
							"enterprise_qualifications":  '', // 企业资质
							"registration_notes":  '', // 报名备注
							"site_plan":  '', // 场地平面图
							"exhibitor_documents":  '', // 参展文件
						"examine_state": "未审核",
					"examine_reply": "",
					"registration_information_id": 0,
					"create_by": this.$store.state.user.user_id,
				},

				// 表单字段
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
							"number_of_registrations":  0, // 报名人数
							"enterprise_qualifications":  '', // 企业资质
							"registration_notes":  '', // 报名备注
							"site_plan":  '', // 场地平面图
							"exhibitor_documents":  '', // 参展文件
						"examine_state": "未审核",
					"examine_reply": "",
					"registration_information_id": 0,
					},
				disabledObj:{
						"order_number_isDisabled": false,
							"booth_number_isDisabled": false,
							"exhibitionconvention_number_isDisabled": false,
							"exhibition_theme_isDisabled": false,
							"host_user_isDisabled": false,
							"booth_name_isDisabled": false,
							"booth_type_isDisabled": false,
									"enrolled_user_isDisabled": false,
							"user_name_isDisabled": false,
							"users_mobile_phone_isDisabled": false,
									"enterprise_qualifications_isDisabled": false,
							"registration_notes_isDisabled": false,
							"site_plan_isDisabled": false,
							"exhibitor_documents_isDisabled": false,
					},

																		// 用户列表
				list_user_host_user: [],
																	// 用户列表
				list_user_enrolled_user: [],
																							
				// ID字段
				field: "registration_information_id",

																				extra_info: {},
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
																																																																																																																																																																						formatDateValue(value) {
		  const date = new Date(value);
		  return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;
		},
		confirmPayStep() {
            if (this.pay_obj.payActiveName == "微信支付" || this.pay_obj.payActiveName == "支付宝支付" || this.pay_obj.payActiveName == "网银支付") {
              this.pay_step = 2
            }
            },
		async openPayModal(){
						let param = this.form;
			param.create_by = this.$store.state.user.user_id;
												var pm = this.events("submit_before", Object.assign({}, param)) || param;
			var msg = await this.events("submit_check", pm);
			if (msg) {
				this.$toast(msg, 'danger');
				this.payModalVisible = false
			} else {
																																																																																																																																																																																							let submitForm = JSON.parse(JSON.stringify(pm));
					this.pay_data = pm
                                                                                                                                                            this.pay_data.amount_paid = pm.booth_prices
			delete submitForm.amount_paid
                                                                                                                                                                  						this.$post("~/api/registration_information/add", submitForm, (res) => {
					if(res.error){
						this.$toast(res.error.message || '提交失败', 'danger');
						this.payModalVisible = false
						return
					}
					if (res.result) {
						let result = res.result
						if (result.registration_information_id) {
							this.pay_obj.id = result.registration_information_id;
						}
						if (result.registration_status === '候补中') {
							this.payModalVisible = false
							this.$toast(result.message || '已加入候补队列', 'success');
							history.back()
							return
						}
						this.payModalVisible = true
						return
																																																																																							  																																																																																										this.$get("~/api/registration_information/get_list", { pay_state: "未支付", orderby: "create_time desc" },(json) => {
							if (json.result && json.result.list) {
								this.pay_obj.id = json.result.list[0].registration_information_id;
								}
							this.payModalVisible = true
						});
						
					} else if (res.error) {
						this.$toast(res.error.message || '提交失败', 'danger');
						this.payModalVisible = false
						console.error(res.error);
					}
				});
			}
		},
		  
		submit_pay(payTyep){
					let message_inform1 = {
				title: '用户支付订单成功',
				type: '消息',
				content: this.$store.state.user.username + '-' + this.$store.state.user.nickname + '成功支付了',
				state: 1,
				user_id: '9999'
			}
			let message_inform2 = {
				title: '报名信息',
				type: '消息',
				content: this.$store.state.user.username + '-' + this.$store.state.user.nickname + '提交了一条报名信息数据',
				state: 1,
				user_id:'9999'
			}
					if (payTyep == "pay") {
					let payName = this.pay_obj.payActiveName;
            	let payType = payName.endsWith("支付") ? payName.slice(0, -2) : payName;
					let param = {
					pay_state: '已支付',
						pay_type: payType,
					}
																																																					// 更新支付状态
				this.$post("~/api/registration_information/set?registration_information_id="+this.pay_obj.id, param, (res) => {
						this.payModalVisible = false;
					this.$toast('提交成功', 'success');
					history.back()
				})
							this.$post("~/api/message_inform/add",message_inform1)
				this.$post("~/api/message_inform/add",message_inform2)
						}else{
							this.$post("~/api/message_inform/add",message_inform2)
							history.back()
			}
		},
		async submit(param, func){
					if (!param) {
				param = this.form;
			}
			param.create_by = this.$store.state.user.user_id;
													if(this.extra_info && Object.keys(this.extra_info).length > 0){
					param.extra = JSON.stringify(this.extra_info);
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
		if(!this.form.registration_information_id){
																																																						  																																																			setTimeout(() => {
				this.$toast("提交成功", 'success');
				this.$router.go(-1);
			}, 1000);
		}
		else{
			this.$toast("提交成功", 'success');
			this.$router.go(-1);
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
					async get_user_session_enrolled_user(){
				var _this = this;
				var json = await this.$get("~/api/user_group/get_obj?name=普通用户");
				if(json.result && json.result.obj){
					var source_table = json.result.obj.source_table;
					var user_id = _this.$store.state.user.user_id;
					if (user_id){
						var url = "~/api/"+source_table+"/get_obj?"
						this.$get(url, {"user_id":_this.$store.state.user.user_id}, function(res) {
							if (res.result && res.result.obj) {
								var arr = []
								for (let key in res.result.obj) {
									arr.push(key)
								}
								var arrForm = []
								for (let key in _this.form) {
									arrForm.push(key)
								}
								_this.form["enrolled_user"] = user_id
								_this.disabledObj['enrolled_user' + '_isDisabled'] = true
								for (var i=0;i<arr.length;i++){
                  if (arr[i]!=='examine_state' && arr[i]!=='examine_reply') {
                    for (var j = 0; j < arrForm.length; j++) {
                      if (arr[i] === arrForm[j]) {
                        if (arr[i] !== "enrolled_user" && arr[i] !== "create_by") {
                          _this.form[arrForm[j]] = res.result.obj[arr[i]]
                          _this.disabledObj[arrForm[j] + '_isDisabled'] = true
                          break;
                        }
                      }
                    }
                  }
								}
							}
						});
					}
				}
				else if(json.error){
					console.error(json.error);
				}
			},
	
				
				
				
				
				
				
				
		  		get_user_info(name,id){
				var obj = null;
          				  if (name == 'host_user'){
					  obj = this.list_user_host_user.getObj({"user_id":id});
				  }
          				  if (name == 'enrolled_user'){
					  obj = this.list_user_enrolled_user.getObj({"user_id":id});
				  }
                				var ret = "";
				if(obj){
				  ret = obj.nickname+"-"+obj.username;
				}
				return ret;
			},
			/**
			 * 修改文件
			 * @param { Object } files 上传文件对象
			 * @param { String } str 表单的属性名
			 */
			change_file(files, str) {
				var form = new FormData();
				form.append("file", files[0]);
				this.$post("~/api/registration_information/upload?", form, (res) => {
					if (res.result) {
						this.form[str] = res.result.url;
					} else if (res.error) {
						this.$toast(res.error.message);
					}
				});
			},
			
			/**
			 * 修改文件
			 * @param { Object } files 上传文件对象
			 * @param { String } str 表单的属性名
			 */
			change_file_multiple(files, str) {
				let _this = this;
				var form = new FormData();
				for (var i = 0; i < files.length; i++) {
					form.set("file", files[i]);
					_this.$post("~/api/registration_information/upload?", form, (res) => {
						if (res.result) {
							if (_this.form[str].length > 0) {
								_this.form[str].push(res.result.url);
							} else {
								_this.form[str] = [res.result.url];
							}
						} else if (res.error) {
							_this.$toast(res.error.message);
						}
					});
				}
			},

			/**
			 * 获取对象后获取缓存表单
			 * @param {Object} json
			 * @param {Object} func
			 */
			get_obj_before(param){
				var extra_info = $.db.get("extra_info");
				if (extra_info) {
					this.extra_info = extra_info;
				}
				$.db.del("extra_info");
				var form = $.db.get("form");
				// if (form) {
        //   delete(form.examine_state)
        //   delete(form.examine_reply)
        //   this.obj = $.push(this.obj ,form);
				// 	this.form = $.push(this.form ,form);
				// }
				// var arr = []
				// for (let key in form) {
				// 	arr.push(key)
				// }
				// for (var i=0;i<arr.length;i++){
				// 	this.disabledObj[arr[i] + '_isDisabled'] = true
				// }
        if (form) {
          var arr = []
          for (let key in form) {
            arr.push(key)
          }
          var arrForm = []
          for (let key in this.form) {
            arrForm.push(key)
          }
          for (var i=0;i<arr.length;i++){
            if (arr[i]!=='examine_state' && arr[i]!=='examine_reply' && arr[i] !== "create_by") {
              for (var j = 0; j < arrForm.length; j++) {
                if (arrForm[j] === arr[i]) {
                  this.form[arrForm[j]] = form[arr[i]]
                  this.obj[arrForm[j]] = form[arr[i]]
                  this.disabledObj[arrForm[j] + '_isDisabled'] = true
                  break;
                }
              }
			  if(arr[i] === "source_table"){
			  	this.form['source_table'] = form[arr[i]]
			  }
			  if(arr[i] === "source_id"){
			  	this.form['source_id'] = form[arr[i]]
			  }
			  if(arr[i] === "source_user_id"){
			  	this.form['source_user_id'] = form[arr[i]]
			  }
            }
          }
        }
																																																																
        $.db.del("form");
				return param;
			},
																			/**
			 * 获取对象后获取缓存表单
			 * @param {Object} json
			 * @param {Object} func
			 */
			get_obj_after(json ,func){
				// var form = $.db.get("form");
				// var obj = Object.assign({} ,form ,this.obj);
				// if (obj) {
        //   delete(obj.examine_state)
        //   delete(obj.examine_reply)
				// 	this.obj = $.push(this.obj ,obj);
				// }
				// if (form) {
        //   delete(form.examine_state)
        //   delete(form.examine_reply)
				// 	this.form = $.push(this.form ,form);
				// }

				if(func){
					func(json);
				}
			},

																																																																																			},
		created() {
																		this.get_list_user_host_user();
																	this.get_user_session_enrolled_user();
					this.get_list_user_enrolled_user();
																																																								},
	}
</script>

<style>
	.diy_compute{
		line-height: 40px;
	}
	.diy_field.diy_img_multiple{
		margin: 0;
	}
	.diy_field.diy_img_multiple div{
		float: left;
		position: relative;
		margin: 0 10px 10px 0;
	}
	.diy_field.diy_img_multiple img{
		height: 100px;
		width: auto;
	}
	.diy_field.diy_img_multiple span{
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



.not-pay{
	width: 100%;
	background-color: #409eff;
	color: white;
	font-size: 14px;
	text-align: center;
	line-height: 40px;
	cursor: pointer;
	margin-bottom: 10px;
}
.confirm-pay{
	width: 100%;
	background-color: #409eff;
	color: white;
	font-size: 14px;
	text-align: center;
	line-height: 40px;
	cursor: pointer;
}
.input-block{
    display: flex;
    align-items: center;
}
.input-block .units{
    font-size: 14px;
    color: #666;
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
</style>
