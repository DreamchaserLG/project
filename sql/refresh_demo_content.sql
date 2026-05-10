SET NAMES utf8mb4;
START TRANSACTION;

UPDATE `user`
SET `phone` = '13700137000', `email` = 'yonghu1@example.com'
WHERE `user_id` = 2;

UPDATE `user`
SET `phone` = '15500155000', `email` = 'yonghu2@example.com'
WHERE `user_id` = 3;

UPDATE `user`
SET `phone` = '13900139000', `email` = 'yonghu3@example.com'
WHERE `user_id` = 4;

UPDATE `user`
SET `phone` = '18621474900', `email` = 'host4@expo-demo.com'
WHERE `user_id` = 5;

UPDATE `user`
SET `phone` = '18862511186', `email` = 'host5@expo-demo.com'
WHERE `user_id` = 6;

UPDATE `user`
SET `phone` = '18308747556', `email` = 'yonghu6@example.com'
WHERE `user_id` = 7;

UPDATE `exhibition_information`
SET
  `exhibition_and_convention_types` = '专业会议',
  `event_time` = '2026-06-18 09:30',
  `event_venue_name` = '广州琶洲展馆',
  `exhibition_status` = '报名进行中',
  `host_user` = 5,
  `fee_standards` = '<p>标准展位（9㎡）：19800元/个，含基础搭建、楣板、两张参展证与基础用电。</p><p>光地展位（36㎡起）：980元/㎡，须提前10个工作日提交特装方案审核。</p><p>论坛通票：800元/人，含主论坛、环保材料分论坛及商务午餐。</p>',
  `schedule_t` = '<p>6月18日 09:00-10:00 开幕式与嘉宾巡馆。</p><p>6月18日 10:30-12:00 绿色材料与循环包装主题论坛。</p><p>6月18日 14:00-17:00 采购对接会与企业路演。</p><p>6月19日 09:30-16:00 环保技术体验与投融资专场。</p>',
  `hits` = 286,
  `praise_len` = 52,
  `collect_len` = 74
WHERE `exhibition_information_id` = 1;

UPDATE `exhibition_information`
SET
  `exhibition_and_convention_types` = '艺术展览',
  `event_time` = '2026-07-12 13:30',
  `event_venue_name` = '青岛国际会展中心',
  `exhibition_status` = '报名进行中',
  `host_user` = 6,
  `fee_standards` = '<p>标准展位（9㎡）：16800元/个，含基础灯光、洽谈桌椅与展商证件。</p><p>沉浸式互动区（18㎡）：36800元/个，含投影位、电力扩容与现场技术支持。</p><p>专业观众票：120元/人，学生票凭证件可享半价。</p>',
  `schedule_t` = '<p>7月12日 13:30-14:30 开幕导览与策展人分享。</p><p>7月12日 15:00-17:30 数字影像与交互艺术论坛。</p><p>7月13日 10:00-12:00 青年创作者路演。</p><p>7月13日 14:00-16:00 公众沉浸式体验场。</p>',
  `hits` = 254,
  `praise_len` = 48,
  `collect_len` = 69
WHERE `exhibition_information_id` = 2;

UPDATE `exhibition_information`
SET
  `exhibition_and_convention_types` = '消费展览',
  `event_time` = '2026-08-15 10:00',
  `event_venue_name` = '杭州国际博览中心',
  `exhibition_status` = '报名进行中',
  `host_user` = 6,
  `fee_standards` = '<p>标准展位（9㎡）：22800元/个，含基础装饰、LED门楣与品牌桌椅。</p><p>主题舞台区（36㎡）：58800元/个，适合新品发布、互动比赛与签售活动。</p><p>玩家通票：180元/人，含主舞台、试玩区与创作者签售区入场资格。</p>',
  `schedule_t` = '<p>8月15日 10:00-11:00 开幕巡游与IP角色亮相。</p><p>8月15日 13:30-16:30 独立游戏试玩与创作者见面会。</p><p>8月16日 10:00-12:00 动漫配音公开课。</p><p>8月16日 14:00-17:00 电竞互动与衍生品发布。</p>',
  `hits` = 412,
  `praise_len` = 67,
  `collect_len` = 98
WHERE `exhibition_information_id` = 3;

UPDATE `exhibition_information`
SET
  `exhibition_and_convention_types` = '文化节庆',
  `event_time` = '2026-09-20 09:00',
  `event_venue_name` = '深圳会展中心',
  `exhibition_status` = '即将开展',
  `host_user` = 7,
  `fee_standards` = '<p>标准展位（9㎡）：18800元/个，适合文旅机构、城市目的地与特色线路推广。</p><p>城市推介区（18㎡）：39800元/个，含舞台时段、音视频支持与导览服务。</p><p>采购洽谈通票：680元/人，含采购配对及闭门对接场次。</p>',
  `schedule_t` = '<p>9月20日 09:00-10:00 开幕式与文旅资源发布。</p><p>9月20日 10:30-12:00 入境游与目的地营销论坛。</p><p>9月20日 14:00-17:00 城市文旅推介会。</p><p>9月21日 09:30-16:00 采购洽谈与合作签约。</p>',
  `hits` = 198,
  `praise_len` = 36,
  `collect_len` = 58
WHERE `exhibition_information_id` = 4;

UPDATE `exhibition_information`
SET
  `exhibition_and_convention_types` = '新品发布会',
  `event_time` = '2026-10-18 14:00',
  `event_venue_name` = '台北南港展览馆',
  `exhibition_status` = '招商中',
  `host_user` = 7,
  `fee_standards` = '<p>标准品牌位（9㎡）：25800元/个，含品牌灯箱、挂衣架与基础陈列道具。</p><p>秀场发布区（24㎡）：64800元/个，含走秀时段、后台化妆位与摄影支持。</p><p>专业买手证：980元/人，含趋势论坛、品牌对接会与VIP休息区。</p>',
  `schedule_t` = '<p>10月18日 14:00-15:00 开场秀与趋势发布。</p><p>10月18日 15:30-17:30 设计师新品走秀。</p><p>10月19日 10:00-12:00 选品对接会。</p><p>10月19日 14:00-16:30 时尚供应链闭门洽谈。</p>',
  `hits` = 176,
  `praise_len` = 41,
  `collect_len` = 63
WHERE `exhibition_information_id` = 5;

UPDATE `exhibition_information`
SET
  `exhibition_and_convention_types` = '文化节庆',
  `event_time` = '2026-11-08 09:30',
  `event_venue_name` = '成都世纪城新国际会展中心',
  `exhibition_status` = '即将开展',
  `host_user` = 5,
  `fee_standards` = '<p>非遗标准展位（9㎡）：15800元/个，含木质展架、基础照明与展商证件。</p><p>手作互动区（18㎡）：29800元/个，含体验桌、物料仓储与用水用电支持。</p><p>公众文化票：80元/人，团体票支持预约优惠。</p>',
  `schedule_t` = '<p>11月8日 09:30-10:30 开馆仪式与非遗代表作展示。</p><p>11月8日 10:45-12:00 传统工艺传承论坛。</p><p>11月8日 14:00-17:00 手作体验与城市文创集市。</p><p>11月9日 09:30-16:00 非遗大师公开课。</p>',
  `hits` = 229,
  `praise_len` = 47,
  `collect_len` = 71
WHERE `exhibition_information_id` = 6;

UPDATE `exhibition_information`
SET
  `exhibition_and_convention_types` = '行业峰会',
  `event_time` = '2026-06-28 09:00',
  `event_venue_name` = '厦门国际会展中心',
  `exhibition_status` = '报名进行中',
  `host_user` = 6,
  `fee_standards` = '<p>标准展位（9㎡）：21800元/个，含数字屏门楣、网络基础接入与两张展商证。</p><p>解决方案展示区（18㎡）：42800元/个，适合智慧交通、政务与能源方案演示。</p><p>峰会通票：1280元/人，含主论坛、平行论坛与项目闭门会。</p>',
  `schedule_t` = '<p>6月28日 09:00-10:00 主论坛开场与城市治理趋势发布。</p><p>6月28日 10:30-12:00 智慧交通与低空经济专题。</p><p>6月28日 14:00-17:00 城市数字底座案例路演。</p><p>6月29日 09:30-15:30 政企采购配对专场。</p>',
  `hits` = 335,
  `praise_len` = 58,
  `collect_len` = 81
WHERE `exhibition_information_id` = 7;

UPDATE `exhibition_information`
SET
  `exhibition_and_convention_types` = '教育展览',
  `event_time` = '2026-09-05 10:00',
  `event_venue_name` = '武汉国际博览中心',
  `exhibition_status` = '报名进行中',
  `host_user` = 7,
  `fee_standards` = '<p>标准展位（9㎡）：17800元/个，适合教育装备、软件平台与实训设备展示。</p><p>互动课堂区（18㎡）：38800元/个，含投影、扩声与课桌式布置。</p><p>校长论坛票：680元/人，含论坛议程资料与闭门交流会。</p>',
  `schedule_t` = '<p>9月5日 10:00-11:00 开幕及教育数字化成果发布。</p><p>9月5日 11:00-12:00 教育装备采购政策解读。</p><p>9月5日 14:00-17:00 智慧课堂公开演示。</p><p>9月6日 09:30-16:00 校企合作与实训设备对接。</p>',
  `hits` = 244,
  `praise_len` = 39,
  `collect_len` = 64
WHERE `exhibition_information_id` = 8;

UPDATE `exhibition_information`
SET
  `exhibition_and_convention_types` = '科技博览会',
  `event_time` = '2026-11-20 09:30',
  `event_venue_name` = '南京国际博览中心',
  `exhibition_status` = '招商中',
  `host_user` = 5,
  `fee_standards` = '<p>标准展位（9㎡）：23800元/个，适合整车、零部件与充换电品牌展示。</p><p>整车展示区（36㎡）：56800元/个，含地台、车辆照明与试乘预约支持。</p><p>行业通票：980元/人，含主论坛、供应链闭门交流与试乘预约资格。</p>',
  `schedule_t` = '<p>11月20日 09:30-10:30 新能源汽车趋势发布。</p><p>11月20日 11:00-12:00 三电系统与补能生态论坛。</p><p>11月20日 14:00-17:00 试乘体验与供应链洽谈。</p><p>11月21日 09:30-16:00 国际合作与投资配对。</p>',
  `hits` = 367,
  `praise_len` = 62,
  `collect_len` = 87
WHERE `exhibition_information_id` = 9;

UPDATE `exhibition_information`
SET
  `exhibition_and_convention_types` = '消费展览',
  `event_time` = '2026-07-25 10:30',
  `event_venue_name` = '中国国际展览中心（北京）',
  `exhibition_status` = '报名进行中',
  `host_user` = 6,
  `fee_standards` = '<p>标准展位（9㎡）：16800元/个，适合健康食品、运动器械与生活方式品牌展示。</p><p>体验区（18㎡）：34800元/个，含试吃试饮、健康检测与品牌直播支持。</p><p>公众入场券：60元/人，家庭套票支持线上预约。</p>',
  `schedule_t` = '<p>7月25日 10:30-11:30 开幕巡馆与健康消费趋势发布。</p><p>7月25日 13:30-15:00 营养管理与家庭健康论坛。</p><p>7月25日 15:30-17:00 健康品牌直播选品会。</p><p>7月26日 09:30-16:00 体验打卡与营养咨询专场。</p>',
  `hits` = 291,
  `praise_len` = 44,
  `collect_len` = 76
WHERE `exhibition_information_id` = 10;

UPDATE `exhibition_information`
SET
  `exhibition_and_convention_types` = '文化节庆',
  `event_time` = '2026-10-03 11:00',
  `event_venue_name` = '香港会议展览中心',
  `exhibition_status` = '即将开展',
  `host_user` = 7,
  `fee_standards` = '<p>标准展位（9㎡）：18800元/个，适合城市餐饮品牌、食材与文旅美食项目。</p><p>美食体验区（18㎡）：42800元/个，含明火审批、冷链接入与演示厨房支持。</p><p>美食嘉年华通票：150元/人，含主展区、舞台表演与试吃活动。</p>',
  `schedule_t` = '<p>10月3日 11:00-12:00 开幕巡馆与国际美食秀。</p><p>10月3日 14:00-16:00 城市风味品牌发布会。</p><p>10月4日 10:00-12:00 厨艺表演与采购配对。</p><p>10月4日 14:00-17:00 夜场美食文化活动。</p>',
  `hits` = 318,
  `praise_len` = 55,
  `collect_len` = 90
WHERE `exhibition_information_id` = 11;

UPDATE `exhibition_information`
SET
  `exhibition_and_convention_types` = '贸易展览',
  `event_time` = '2026-12-12 09:00',
  `event_venue_name` = '国家会展中心（上海）',
  `exhibition_status` = '报名进行中',
  `host_user` = 5,
  `fee_standards` = '<p>标准展位（9㎡）：19800元/个，含基础搭建、品牌门楣与两张参展证。</p><p>创新体验区（18㎡）：39800元/个，含互动演示位、网络接入与舞台时段预约。</p><p>商务参观票：380元/人，含新品路演区与采购洽谈区入场资格。</p>',
  `schedule_t` = '<p>12月12日 09:00-10:00 开幕式与未来生活趋势发布。</p><p>12月12日 10:30-12:00 智能家居与AI终端论坛。</p><p>12月12日 14:00-17:00 创新产品路演与媒体发布。</p><p>12月13日 09:30-16:00 采购配对与投资对接专场。</p>',
  `hits` = 452,
  `praise_len` = 73,
  `collect_len` = 112
WHERE `exhibition_information_id` = 12;

UPDATE `booth_information`
SET
  `exhibitionconvention_number` = 'CONF-2024-A01',
  `exhibition_theme` = '绿色地球环保展',
  `host_user` = 5,
  `booth_name` = '绿色材料特装岛',
  `booth_type` = '特装展位',
  `booth_location` = 'C馆2区',
  `booth_prices` = 52800.00,
  `booth_specifications` = '5x5米特装空地',
  `booth_specificss` = '<p>面向绿色建材、循环包装与低碳设备品牌开放，适合进行样机展示与集中洽谈。</p><p>含接待前台、储物区与基础照明，可申请大功率电力扩容与多媒体屏幕加装。</p>',
  `hits` = 186,
  `praise_len` = 28,
  `collect_len` = 45,
  `registration_information_limit_times` = 6
WHERE `booth_number` = 'C01';

UPDATE `booth_information`
SET
  `exhibitionconvention_number` = 'SHOW-24-B002',
  `exhibition_theme` = '数字艺术创意展',
  `host_user` = 6,
  `booth_name` = '数字互动体验舱',
  `booth_type` = '沉浸式展位',
  `booth_location` = 'B馆1区',
  `booth_prices` = 36800.00,
  `booth_specifications` = '6x6米沉浸式岛型展位',
  `booth_specificss` = '<p>适合数字影像、互动装置与AI艺术内容展示，支持多面投影与观众停留体验。</p><p>现场提供网络接入、基础灯光控制与音视频协助，适合打造沉浸式内容首发场景。</p>',
  `hits` = 173,
  `praise_len` = 31,
  `collect_len` = 49,
  `registration_information_limit_times` = 4
WHERE `booth_number` = 'B01';

UPDATE `booth_information`
SET
  `exhibitionconvention_number` = 'EXPO2024-004',
  `exhibition_theme` = '国际动漫游戏展',
  `host_user` = 6,
  `booth_name` = 'IP联名舞台区',
  `booth_type` = '品牌互动展位',
  `booth_location` = 'A馆3区',
  `booth_prices` = 45800.00,
  `booth_specifications` = '9x12米主题展馆',
  `booth_specificss` = '<p>适用于IP联名展示、舞台互动和签售活动，支持角色打卡点与周边陈列区布置。</p><p>场地临近主舞台与试玩区，适合高人流曝光与品牌内容联动。</p>',
  `hits` = 248,
  `praise_len` = 42,
  `collect_len` = 63,
  `registration_information_limit_times` = 5
WHERE `booth_number` = 'A03';

UPDATE `booth_information`
SET
  `exhibitionconvention_number` = 'SHOW-24-B003',
  `exhibition_theme` = '世界旅游文化展',
  `host_user` = 7,
  `booth_name` = '国际文旅洽谈台',
  `booth_type` = '洽谈展位',
  `booth_location` = 'A馆2区',
  `booth_prices` = 32800.00,
  `booth_specifications` = '4x6米双开口展位',
  `booth_specificss` = '<p>适合目的地营销、旅行社资源推介与城市文旅项目洽谈，支持双面形象展示。</p><p>标配接待桌、资料架与双向通行动线，方便开展商务会谈和采购配对。</p>',
  `hits` = 142,
  `praise_len` = 24,
  `collect_len` = 38,
  `registration_information_limit_times` = 6
WHERE `booth_number` = 'A02';

UPDATE `booth_information`
SET
  `exhibitionconvention_number` = 'CONF-2024-A03',
  `exhibition_theme` = '时尚设计潮流展',
  `host_user` = 7,
  `booth_name` = '新品发布秀场',
  `booth_type` = '半岛型展位',
  `booth_location` = 'D馆3区',
  `booth_prices` = 64800.00,
  `booth_specifications` = '6x8米主通道展位',
  `booth_specificss` = '<p>用于设计师品牌新品发布、媒体拍摄与买手选品，临近主通道与媒体区。</p><p>适合配置模特展示、灯光设备和静态陈列墙，便于进行集中品牌传播。</p>',
  `hits` = 214,
  `praise_len` = 37,
  `collect_len` = 57,
  `registration_information_limit_times` = 3
WHERE `booth_number` = 'D03';

UPDATE `booth_information`
SET
  `exhibitionconvention_number` = 'EXPO2024-005',
  `exhibition_theme` = '传统文化复兴展',
  `host_user` = 5,
  `booth_name` = '非遗互动工坊',
  `booth_type` = '体验展位',
  `booth_location` = 'D馆2区',
  `booth_prices` = 29800.00,
  `booth_specifications` = '4x5米体验展位',
  `booth_specificss` = '<p>适用于非遗工艺展示、手作体验与文化衍生品售卖，可进行小规模教学互动。</p><p>含操作台、物料储位与用水用电支持，适合陶艺、扎染、木作等演示项目。</p>',
  `hits` = 157,
  `praise_len` = 26,
  `collect_len` = 41,
  `registration_information_limit_times` = 5
WHERE `booth_number` = 'D02';

UPDATE `booth_information`
SET
  `exhibitionconvention_number` = 'CONF-2024-A02',
  `exhibition_theme` = '智慧城市创新展',
  `host_user` = 6,
  `booth_name` = '城市应用演示区',
  `booth_type` = '商务洽谈区',
  `booth_location` = 'D馆1区',
  `booth_prices` = 42800.00,
  `booth_specifications` = '3x4米L型展位',
  `booth_specificss` = '<p>适合展示智慧交通、数字政务、低碳园区和数据平台解决方案，强调方案讲解与客户接待。</p><p>预留演示终端位和网络接口，方便进行屏幕联动与系统讲解。</p>',
  `hits` = 203,
  `praise_len` = 34,
  `collect_len` = 52,
  `registration_information_limit_times` = 4
WHERE `booth_number` = 'D01';

UPDATE `booth_information`
SET
  `exhibitionconvention_number` = 'EXPO2024-003',
  `exhibition_theme` = '国际教育装备展',
  `host_user` = 7,
  `booth_name` = '教育科技岛',
  `booth_type` = '岛型展位',
  `booth_location` = 'C馆1区',
  `booth_prices` = 38800.00,
  `booth_specifications` = '4x4米岛型展位',
  `booth_specificss` = '<p>适合教育装备、数字课堂系统和实训平台企业展示，支持多方向观众参观。</p><p>可布置互动课堂体验、软件演示和教学设备实操区域，适合教育采购场景。</p>',
  `hits` = 168,
  `praise_len` = 29,
  `collect_len` = 46,
  `registration_information_limit_times` = 5
WHERE `booth_number` = 'C02';

UPDATE `booth_information`
SET
  `exhibitionconvention_number` = 'EXPO2024-006',
  `exhibition_theme` = '新能源汽车科技展',
  `host_user` = 5,
  `booth_name` = '充电生态展示台',
  `booth_type` = '角位展位',
  `booth_location` = 'C馆3区',
  `booth_prices` = 56800.00,
  `booth_specifications` = '5x6米异型展位',
  `booth_specificss` = '<p>适合充电桩、储能系统和整车配套品牌展示，预留设备摆放与观众讲解空间。</p><p>支持高功率用电申请，适合开展整机演示和技术讲解。</p>',
  `hits` = 276,
  `praise_len` = 46,
  `collect_len` = 68,
  `registration_information_limit_times` = 4
WHERE `booth_number` = 'C03';

UPDATE `booth_information`
SET
  `exhibitionconvention_number` = 'SHOW-24-B001',
  `exhibition_theme` = '健康生活博览会',
  `host_user` = 6,
  `booth_name` = '健康品牌体验舱',
  `booth_type` = '特装展位',
  `booth_location` = 'B馆3区',
  `booth_prices` = 34800.00,
  `booth_specifications` = '3x6米通道型展位',
  `booth_specificss` = '<p>适合营养食品、家用健康设备与生活方式品牌展示，可结合试吃试饮与功能演示。</p><p>临近观众休息区和直播区，便于进行内容传播与现场互动。</p>',
  `hits` = 187,
  `praise_len` = 27,
  `collect_len` = 43,
  `registration_information_limit_times` = 5
WHERE `booth_number` = 'B03';

UPDATE `booth_information`
SET
  `exhibitionconvention_number` = 'EXPO2024-002',
  `exhibition_theme` = '全球美食文化节',
  `host_user` = 7,
  `booth_name` = '国际风味旗舰馆',
  `booth_type` = '双层展位',
  `booth_location` = 'B馆2区',
  `booth_prices` = 72800.00,
  `booth_specifications` = '8x8米旗舰展位',
  `booth_specificss` = '<p>适合国际餐饮品牌、食材供应链和城市美食IP进行集中展示，支持大型视觉包装。</p><p>可布置冷链、试吃和互动舞台区域，适合高曝光品牌活动。</p>',
  `hits` = 312,
  `praise_len` = 51,
  `collect_len` = 76,
  `registration_information_limit_times` = 3
WHERE `booth_number` = 'B02';

UPDATE `booth_information`
SET
  `exhibitionconvention_number` = 'EXPO2024-001',
  `exhibition_theme` = '未来科技生活展',
  `host_user` = 5,
  `booth_name` = '创新前沿',
  `booth_type` = '标准展位',
  `booth_location` = 'A馆1区',
  `booth_prices` = 19800.00,
  `booth_specifications` = '3x3米标准展位',
  `booth_specificss` = '<p>面向AI终端、智能家居和创新消费电子品牌开放，适合新品首发与商务沟通。</p><p>标准位配置门楣、照明、电源与接待台；当前正式名额有限，满额后支持进入候补队列。</p>',
  `hits` = 358,
  `praise_len` = 64,
  `collect_len` = 92,
  `registration_information_limit_times` = 1
WHERE `booth_number` = 'A01';

UPDATE `exhibition_announcement`
SET
  `announcement_title` = '绿色地球环保展招展通知',
  `announcement_type` = '招展通知',
  `host_user` = 5,
  `release_time` = '2026-05-02 10:00:00',
  `announcement_content` = '<p>为保障“绿色地球环保展”展区布局与专业观众接待质量，主办方现正式开放标准展位与特装展位报名。重点面向环保材料、低碳设备、循环包装、绿色供应链服务企业招展。</p><p>请有意参展单位于2026年5月30日前完成资料提交、展位申请与资质审核。通过审核的单位将按提交时间与展区匹配度安排展位，主办方将在3个工作日内反馈结果。</p><p>如需申请主题路演、论坛发言或大功率用电，请在报名表中同步勾选对应需求，便于会务组统一排期与现场保障。</p>',
  `hits` = 98,
  `praise_len` = 16,
  `collect_len` = 24
WHERE `exhibition_announcement_id` = 1;

UPDATE `exhibition_announcement`
SET
  `announcement_title` = '数字艺术创意展参展须知',
  `announcement_type` = '参展须知',
  `host_user` = 6,
  `release_time` = '2026-05-03 09:30:00',
  `announcement_content` = '<p>“数字艺术创意展”将重点展示互动影像、沉浸式装置、AI生成艺术与数字收藏品内容。参展单位需提前申报设备功率、空间尺寸和音视频清单，以便现场技术团队完成布展协调。</p><p>涉及投影、灯光、裸眼3D或同步音响的展位，请最晚于开展前7个工作日提交施工方案与安全承诺书。未经审核的新增设备将无法现场接入。</p><p>主办方建议参展团队在布展日安排1名技术负责人全程在场，以便完成联调、彩排与应急处理。</p>',
  `hits` = 87,
  `praise_len` = 14,
  `collect_len` = 22
WHERE `exhibition_announcement_id` = 2;

UPDATE `exhibition_announcement`
SET
  `announcement_title` = '国际动漫游戏展舞台活动征集',
  `announcement_type` = '活动征集',
  `host_user` = 6,
  `release_time` = '2026-05-04 11:00:00',
  `announcement_content` = '<p>“国际动漫游戏展”现面向参展品牌、创作者社群与合作机构征集舞台发布、签售互动、试玩挑战赛及角色巡游活动方案。主办方将优先安排与展会主题契合度高、互动性强的节目进入主舞台时段。</p><p>活动申请需包含内容简介、参与嘉宾、时长需求、设备需求及现场安全预案。主办方将在审核通过后提供具体时段及现场执行说明。</p><p>为提升观众体验，所有节目请控制在45分钟以内，并预留10分钟场地切换时间。</p>',
  `hits` = 121,
  `praise_len` = 19,
  `collect_len` = 28
WHERE `exhibition_announcement_id` = 3;

UPDATE `exhibition_announcement`
SET
  `announcement_title` = '世界旅游文化展交通与布展指引',
  `announcement_type` = '交通指引',
  `host_user` = 7,
  `release_time` = '2026-05-05 15:00:00',
  `announcement_content` = '<p>“世界旅游文化展”参展商请根据布展证件分时段入馆，货车统一由北侧物流口进入，现场将按照展区顺序组织卸货。建议大型物料运输单位提前与会务组确认到馆时间。</p><p>观众建议优先使用地铁与会展专线抵达展馆，现场停车位有限，周边商务区高峰时段容易拥堵。布展期间请勿占用消防通道和主观众动线。</p><p>若涉及冷链、液体展示、舞台搭建等特殊需求，请提前向主办方提交申请，未经审批不得自行施工。</p>',
  `hits` = 76,
  `praise_len` = 12,
  `collect_len` = 20
WHERE `exhibition_announcement_id` = 4;

UPDATE `exhibition_announcement`
SET
  `announcement_title` = '时尚设计潮流展发布秀排期说明',
  `announcement_type` = '日程通知',
  `host_user` = 7,
  `release_time` = '2026-05-06 09:00:00',
  `announcement_content` = '<p>“时尚设计潮流展”主舞台发布秀场次将采用“品牌申请 + 现场彩排 + 统一审核”的排期机制。每家品牌默认可申请1个正式发布时段，单场建议控制在25分钟以内。</p><p>需使用模特走秀、灯光编程或同步视频素材的品牌，请在彩排前48小时提交技术需求表和背景素材。现场不接受临时更换主素材。</p><p>主办方将按品牌调性、内容完整度与现场执行可行性综合排期，并在审核通过后通过站内消息及邮箱同步通知。</p>',
  `hits` = 69,
  `praise_len` = 11,
  `collect_len` = 18
WHERE `exhibition_announcement_id` = 5;

UPDATE `exhibition_announcement`
SET
  `announcement_title` = '传统文化复兴展非遗体验报名提醒',
  `announcement_type` = '报名提醒',
  `host_user` = 5,
  `release_time` = '2026-05-06 16:30:00',
  `announcement_content` = '<p>“传统文化复兴展”将设置非遗手作、传统染织、木作雕刻和文化讲堂等互动体验环节。观众可通过前台活动页面提前预约体验场次，现场名额将根据空位补录。</p><p>报名成功后请按预约时间提前15分钟签到。涉及用火、陶艺烧制和锋利工具的体验项目仅对符合年龄要求的观众开放。</p><p>如需团队预约或学校参观，请联系会务组提交团队名单与带队信息，主办方可协助安排分时段导览。</p>',
  `hits` = 82,
  `praise_len` = 13,
  `collect_len` = 21
WHERE `exhibition_announcement_id` = 6;

UPDATE `exhibition_announcement`
SET
  `announcement_title` = '智慧城市创新展采购对接开放预约',
  `announcement_type` = '采购对接',
  `host_user` = 6,
  `release_time` = '2026-05-07 10:30:00',
  `announcement_content` = '<p>为提高“智慧城市创新展”政企对接效率，主办方已开放采购对接预约入口。参展单位可根据需求选择智慧交通、低碳园区、城市治理、数据安全等专题专场。</p><p>采购方预约后，系统将根据方案关键词、预算规模和应用场景自动匹配候选展商，匹配结果将以站内通知形式推送。</p><p>请参展单位保持联系人、公司简介和方案资料更新，以免影响匹配效率和对接效果。</p>',
  `hits` = 109,
  `praise_len` = 18,
  `collect_len` = 26
WHERE `exhibition_announcement_id` = 7;

UPDATE `exhibition_announcement`
SET
  `announcement_title` = '国际教育装备展论坛议程更新',
  `announcement_type` = '议程更新',
  `host_user` = 7,
  `release_time` = '2026-05-07 15:45:00',
  `announcement_content` = '<p>“国际教育装备展”主论坛新增“AI课堂工具应用实践”与“校企协同实训基地建设”两场专题分享，原定下午场次整体顺延30分钟。</p><p>已报名论坛的嘉宾无需重新报名，系统将自动同步更新个人行程。若因时间调整无法参会，可在个人中心行程确认页面取消勾选对应场次。</p><p>主办方建议参会观众提前查看最新议程并保存电子签到码，以便快速入场。</p>',
  `hits` = 94,
  `praise_len` = 15,
  `collect_len` = 23
WHERE `exhibition_announcement_id` = 8;

UPDATE `exhibition_announcement`
SET
  `announcement_title` = '新能源汽车科技展试乘展示安全须知',
  `announcement_type` = '安全须知',
  `host_user` = 5,
  `release_time` = '2026-05-08 09:20:00',
  `announcement_content` = '<p>“新能源汽车科技展”整车试乘与补能设备演示将按照场次分流组织。观众参加试乘前需完成现场登记并听取安全说明，未成年人须由监护人陪同。</p><p>所有演示车辆、充电设备和高压系统均由展商技术团队统一操作，观众不得擅自触碰设备接口和控制终端。</p><p>如遇雨天或突发管控，户外试乘环节将根据现场安全条件调整，具体安排以主办方实时通知为准。</p>',
  `hits` = 134,
  `praise_len` = 22,
  `collect_len` = 31
WHERE `exhibition_announcement_id` = 9;

UPDATE `exhibition_announcement`
SET
  `announcement_title` = '健康生活博览会观众报名通道开启',
  `announcement_type` = '报名通知',
  `host_user` = 6,
  `release_time` = '2026-05-08 13:10:00',
  `announcement_content` = '<p>“健康生活博览会”公众报名通道现已开启。观众可在首页“会展信息”或“平台公告”中查看报名入口，填写基础信息后即可完成预约。</p><p>活动现场将开放健康检测、营养咨询、品牌直播和家庭健身体验等专区。建议观众根据兴趣提前预约互动场次，避免高峰时段排队。</p><p>团体报名和企业福利采购客户可联系会务组申请专属接待和导览安排。</p>',
  `hits` = 88,
  `praise_len` = 14,
  `collect_len` = 20
WHERE `exhibition_announcement_id` = 10;

UPDATE `exhibition_announcement`
SET
  `announcement_title` = '全球美食文化节展商用电与冷链申请说明',
  `announcement_type` = '展商服务',
  `host_user` = 7,
  `release_time` = '2026-05-08 16:40:00',
  `announcement_content` = '<p>“全球美食文化节”涉及冷链、冷柜、加热设备、演示厨房等特殊用电需求的展商，请在布展前提交《用电与冷链服务申请表》。</p><p>主办方将根据展位所在区域和现场供电能力安排配套服务，临时增加大功率设备将无法保障接入。涉及明火或燃气设备的品牌必须提交额外安全审批材料。</p><p>所有生鲜与试吃物料请严格按照食品安全规范存放和展示，主办方将进行现场抽查。</p>',
  `hits` = 96,
  `praise_len` = 15,
  `collect_len` = 22
WHERE `exhibition_announcement_id` = 11;

UPDATE `exhibition_announcement`
SET
  `announcement_title` = '未来科技生活展候补名额与支付提醒',
  `announcement_type` = '支付提醒',
  `host_user` = 5,
  `release_time` = '2026-05-09 09:00:00',
  `announcement_content` = '<p>“未来科技生活展”部分热门展位已进入满额状态，系统将自动开启候补机制。候补申请审核通过后，系统会按照同一展位的候补顺序依次递补，不会出现跳号或重复占位。</p><p>当正式报名名额因取消或退款释放时，第1位候补将自动转为正式报名，并同步更新为“待支付”状态。请相关用户及时在个人中心查看通知并完成支付。</p><p>若候补申请未通过审核，系统会保留审核结果并展示在报名记录中，不影响其他展位的正常报名。</p>',
  `hits` = 141,
  `praise_len` = 24,
  `collect_len` = 34
WHERE `exhibition_announcement_id` = 12;

UPDATE `article`
SET
  `tag` = '国际展会',
  `source` = '会展行业资讯',
  `description` = '聚焦海外置业、移民与留学市场复苏趋势，介绍北京展会规模、论坛安排和专业观众组织亮点。'
WHERE `article_id` = 1;

UPDATE `article`
SET
  `tag` = '行业资讯',
  `source` = '会展行业资讯',
  `description` = '围绕2025广东国际泵阀展预登记启动，梳理展会规模、展品范围与上下游合作机会。'
WHERE `article_id` = 2;

UPDATE `article`
SET
  `tag` = '国际交流',
  `source` = '会展行业资讯',
  `description` = '从游客增长、签证便利和航班恢复三个方面，解读FITUR 2025对中西旅游合作的带动作用。'
WHERE `article_id` = 3;

UPDATE `article`
SET
  `tag` = '贸易展会',
  `source` = '会展行业资讯',
  `description` = '梳理第136届广交会在线上线下融合办展、企业参展规模和国际采购商预登记等方面的新变化。'
WHERE `article_id` = 4;

UPDATE `article`
SET
  `tag` = '汽车科技',
  `source` = '会展行业资讯',
  `description` = '围绕北京车展的新车发布与智能网联技术展示，呈现汽车产业电动化、智能化的最新趋势。'
WHERE `article_id` = 5;

UPDATE `article`
SET
  `tag` = '医药健康',
  `source` = '会展行业资讯',
  `description` = '介绍成都药交会的产业背景、展示方向、论坛安排与面向西部市场的商贸合作价值。'
WHERE `article_id` = 6;

UPDATE `registration_information` AS ri
JOIN `booth_information` AS bi ON ri.booth_number = bi.booth_number
SET
  ri.exhibitionconvention_number = bi.exhibitionconvention_number,
  ri.exhibition_theme = bi.exhibition_theme,
  ri.host_user = bi.host_user,
  ri.booth_name = bi.booth_name,
  ri.booth_type = bi.booth_type,
  ri.booth_prices = bi.booth_prices
WHERE ri.order_number LIKE 'ORD%';

UPDATE `registration_information`
SET
  `registration_status` = '已取消',
  `pay_state` = '已退款',
  `examine_state` = '已通过'
WHERE `order_number` LIKE 'ORD%';

UPDATE `registration_information` AS ri
JOIN `booth_information` AS bi ON ri.booth_number = bi.booth_number
SET
  ri.exhibitionconvention_number = bi.exhibitionconvention_number,
  ri.exhibition_theme = bi.exhibition_theme,
  ri.host_user = bi.host_user,
  ri.booth_name = bi.booth_name,
  ri.booth_type = bi.booth_type,
  ri.booth_prices = bi.booth_prices
WHERE ri.order_number LIKE 'WAITDEMO%';

UPDATE `registration_information`
SET `user_name` = 'yonghu1', `users_mobile_phone` = '13700137000'
WHERE `order_number` = 'WAITDEMO001';

UPDATE `registration_information`
SET `user_name` = 'yonghu2', `users_mobile_phone` = '15500155000'
WHERE `order_number` = 'WAITDEMO002';

UPDATE `registration_information`
SET `user_name` = 'yonghu3', `users_mobile_phone` = '13900139000'
WHERE `order_number` = 'WAITDEMO003';

UPDATE `refund_request` AS rr
LEFT JOIN `registration_information` AS ri ON rr.order_number = ri.order_number
SET
  rr.host_user = COALESCE(ri.host_user, rr.host_user),
  rr.booth_prices = COALESCE(ri.booth_prices, rr.booth_prices),
  rr.examine_state = '已通过'
WHERE rr.order_number LIKE 'ORD%' OR rr.order_number LIKE 'WAITDEMO%';

UPDATE `refund_request`
SET `reason_for_application` = '项目档期调整，原定参展计划延后，申请撤回展位订单。'
WHERE `refund_request_id` = 1;

UPDATE `refund_request`
SET `reason_for_application` = '市场预算重排，暂缓参加本期展会，申请退款。'
WHERE `refund_request_id` = 2;

UPDATE `refund_request`
SET `reason_for_application` = '品牌新品发布时间变更，无法按原计划参展，申请取消。'
WHERE `refund_request_id` = 3;

UPDATE `refund_request`
SET `reason_for_application` = '参展团队行程冲突，无法完成布展，申请撤单退款。'
WHERE `refund_request_id` = 4;

UPDATE `refund_request`
SET `reason_for_application` = '合作方临时调整推广节奏，申请取消当前展位。'
WHERE `refund_request_id` = 5;

UPDATE `refund_request`
SET `reason_for_application` = '样机生产周期延迟，无法按期展示，申请退款处理。'
WHERE `refund_request_id` = 6;

UPDATE `refund_request`
SET `reason_for_application` = '内部审批未按时完成，参展计划取消，申请退款。'
WHERE `refund_request_id` = 7;

UPDATE `refund_request`
SET `reason_for_application` = '现场活动排期冲突，决定放弃本次报名名额。'
WHERE `refund_request_id` = 8;

UPDATE `refund_request`
SET `reason_for_application` = '人员安排与物流准备不足，申请撤销订单。'
WHERE `refund_request_id` = 9;

UPDATE `refund_request`
SET `reason_for_application` = '公司参展主题调整，拟改投后续场次，申请退款。'
WHERE `refund_request_id` = 10;

UPDATE `refund_request`
SET `reason_for_application` = '预算转移至其他区域推广活动，申请退回本次展位费用。'
WHERE `refund_request_id` = 11;

UPDATE `refund_request`
SET `reason_for_application` = '展品交付延期，无法按期完成布展，申请退款。'
WHERE `refund_request_id` = 12;

UPDATE `refund_request`
SET
  `user_name` = 'yonghu1',
  `users_mobile_phone` = '13700137000',
  `reason_for_application` = '候补递补演示：正式报名用户主动取消订单并申请退款。',
  `examine_reply` = '退款审核通过，系统已释放名额并自动递补候补用户。'
WHERE `refund_request_id` = 14;

COMMIT;
