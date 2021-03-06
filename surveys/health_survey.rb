# encoding: UTF-8
survey "Health Survey" do
  section "个人基本信息" do
    label "此表的目的是为了让我们更了解你的身体状况，以便使您的训练更加安全、更有效。我们会维护您的隐私权，绝不会泄露此表的内容"

    q "姓名"
    a :string

    q "性别", :pick => :one
    a_male "男"
    a_female "女"

    q "出生日期", :pick => :one
    a "请选择", :date

    q "血型", :pick => :one
    a_1 "A"
    a_2 "B"
    a_3 "O"
    a_4 "AB"

    q "会员号"
    a :string

    q "家庭住址", :custom_class => 'address'
    a :text, :custom_class => 'mapper'

    q "紧急情况联系人姓名"
    a :string

    q "电话"
    a :string

    q "关系"
    a :string
  end

  section "个人健康状况" do
    q "如果您有以下疾病请在后面画勾" , :pick => :any
    a_1 "高血压"
    a_2 "心筋梗塞"
    a_3 "心绞痛"
    a_4 "贫血"
    a_5 "阑尾炎"
    a_6 "关节炎"
    a_7 "肺炎"
    a_8 "支气管炎"
    a_9 "消化不良"
    a_10 "糖尿病"
    a_11 "癫痫"
    a_12 "癌"
    a_13 "胆结石"
    a_14 "白血病"
    a_15 "肝炎"
    a_16 "营养不良"
    a_17 "偏头疼"
    a_18 "神经衰弱"
    a_19 "风湿病"
    a_20 "坐股神经疼"

    q "是否有其它疾病？"
    a :string

    q "关节、韧带和肌肉是否有过损伤？"
    a :string

    q "现在是否使用药物？"
    a :string

    q "最近您的体重是否有大幅度变化？（例如在一段时间内，体重大幅增加或减少）"
    a :string

    q "您有何过敏史"
    a :string

    q "您是否还有任何其它理由不能参加体育运动？"
    a :string
  end

  section "生活习惯情况" do
    q "您吸烟吗？" , :pick => :one
    a_1 "是"
    a_2 "否"

    q "如果吸烟，一天几支？"
    a :string

    q "您喝酒吗？" , :pick => :one
    a_1 "是"
    a_2 "否"

    q "如果喝酒，多长时间一次？" , :pick => :one
    a_1 "每天"
    a_2 "每周"
    a_3 "每月"

    q "您平均每晚睡眠几小时？"
    a :string

    q "您觉得您的整体压力程度如何？" , :pick => :one
    a_1 "很大"
    a_2 "一般"
    a_3 "很轻松"

    q "您觉得您的整体健康状况如何？" , :pick => :one
    a_1 "不好"
    a_2 "一般"
    a_3 "很好"
  end

  section "运动习惯情况" do
    q "您曾经参加过何种体育训练？"
    a :string

    q "您喜欢每周进行几次，每次几个小时的运动？"
    a :string

    q "有何种活动或事情会影响您的训练课程？"
    a :string

    q "你喜欢每天中的那个时间段进行练习？"
    a :string
  end

  section "饮食习惯情况" do
    q "您早餐通常吃什么？"
    a :string

    q "您午餐通常吃什么？"
    a :string

    q "您晚餐通常吃什么？"
    a :string

    q "您平时吃什么零食？"
    a :string

    q "您现在是否服用何种运动补剂？"
    a :string

    q "您现在是否使用何种饮食计划？"
    a :string

    q "您健身的目的？" , :pick => :any
    a_1 "塑身"
    a_2 "增加肌肉力量"
    a_3 "提高心肺功能"
    a_4 "改善饮食状况"
    a_5 "改善心态"
    a_6 "充实生活"
    a_7 "其它"
  end

  section "健康问卷声明" do
    label "本人自愿参加运动训练课程，以尝改善和提高自己的身体健康水平。本人意识到所有的练习活动都会导致人体胜利负荷量的改变，并有可能引起技能水平出现某些异常现象。"

    label "本人意识到运动训练的目的是为了发展和保持心肺功能、体质比例、柔韧性及力量水平。训练计划是根据学员本身的需要与兴趣，以及专家的建议所编写的。"

    label "本人意识到在运动训练过程中，本人必须负责监察自己的身体状况，如果感到任何的不正常征兆，如肌肉拉伤、软组织损伤、眩晕、心脏病等，本人会立即停止练习并将情况告知健身教练。"

    label "在签署协议之前，本人已经详细阅读了以上内容并明白了训练的宗旨，并对训练课程中所有的疑问已经获得了满意的答复。"

    label "本人在做身体状况评定测理和参加此课程之前，已咨询过医生的意见，并征得了医生的同意。介于本人获准参加俱乐部所提供的运动训练课程，本人同意对训练过程中可能造成的一切不良后果承担全部法律责任。"

    q "会员签字/日期"
    a :string

    q "教练签字/日期"
    a :string

  end
end