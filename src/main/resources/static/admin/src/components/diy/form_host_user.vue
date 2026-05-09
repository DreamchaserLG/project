<template>
	<div>
			<el-form-item v-if="$check_register_field('add','company_name','/host_user/view')" label="企业名称" prop="company_name">
				<el-input id="company_name" v-model="form['company_name']" placeholder="请输入企业名称" >
		  		</el-input>
				</el-form-item>
				<el-form-item v-if="$check_register_field('add','company_phone','/host_user/view')" label="企业电话" prop="company_phone">
				<el-input id="company_phone" v-model="form['company_phone']" placeholder="请输入企业电话" type="tel">
		</el-input>
				</el-form-item>
				<el-form-item v-if="$check_register_field('add','qualification_certificate','/host_user/view')" label="资质证明" prop="qualification_certificate">
				<el-upload id="qualification_certificate" class="avatar-uploader" drag
			accept="image/gif, image/jpeg, image/png, image/jpg" action="" :http-request="uploadimg_qualification_certificate"
			:show-file-list="false" >
			<img v-if="form['qualification_certificate']" :src="$fullUrl(form['qualification_certificate'])" class="avatar">
			<i v-else class="el-icon-plus avatar-uploader-icon"></i>
		</el-upload>
				</el-form-item>
	
	</div>
</template>

<script>
	import mixin from "@/mixins/component.js";
	  	  	  					
	export default {
		mixins: [mixin],
		props:{

			form:{
				type: Object,
				default: function(){
					return {
							"company_name":  '' ,
								"company_phone":  '' ,
								"qualification_certificate":  '' ,
						}
				}
			},

		},
		data() {
			return {
				field: "host_user_id",
				url_add: "~/api/host_user/add?",
				url_set: "~/api/host_user/set?",
				url_upload: "~/api/host_user/upload?",
													rules: {
					"company_name": [    {required: true,message: '企业名称不能为空'},  ],
					"company_phone": [  {validator: this.$is_tel,trigger: 'blur'},    {required: true,message: '企业电话不能为空'},  ],
					"qualification_certificate": [    {required: true,message: '资质证明不能为空'},  ],
				}

			}
		},
		methods: {
				
	
		
	
					/**
			 * 上传资质证明
			 * @param {Object} param 图片参数
			 */
			uploadimg_qualification_certificate(param) {
								this.uploadFile(param.file, "qualification_certificate");
							},
	
	
			},
		created() {
											}
	}
</script>
