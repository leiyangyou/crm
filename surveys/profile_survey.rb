# encoding: UTF-8
survey "Profile Survey" do
  section "个人基本信息" do
    q "姓名"
    a :string

    q "性别", :pick => :one
    a_male "男"
    a_female "女"

    q "电话"
    a :string

    q "出生日期", :pick => :one
    a "请选择", :date

    q "通信地址"
    a :text

    q "电子邮箱"
    a :string

    q "职业及工作"
    a :text
  end

  section "一般信息" do
    q "您工作地点离这里近吗？", :pick => :one
    a_1 "是"
    a_2 "否"

    q "您居住地点离这里近吗？", :pick => :one
    a_1 "是"
    a_2 "否"

    q "您希望每周锻炼几次？", :pick => :one
    a_1 "2-3次"
    a_2 "3-4次"
    a_3 "4-5次"
    a_4 "其它"

    q "您听说过奥力英雄馆吗？", :pick => :one
    a_1 "是"
    a_2 "否"
  end

  section "健身历史" do
    q "您以前做过哪方面的锻炼？"
    a :text

    q "您以前的锻炼是否有效果？", :pick => :one
    a_1 "是"
    a_2 "否"

    q "如果有效果，您为何停止锻炼？"
    a :string

    q "您在什么时间达到健身的最佳状态？"
    a :string
  end

  section "健身目标" do
    q "您的工作是保持较多坐姿还是经常走动？", :pick => :one
    a_1 "坐多"
    a_2 "走动多"

    q "工作压力如何影响了您的生活？", :pick => :one
    a_1 "没什么压力"
    a_2 "一般"
    a_3 "压力大"

    q "您的健身目标是什么？"
    a :text

    q "您是基于怎样的条件去选择一家俱乐部？", :pick => :any
    a_1 "距离"
    a_2 "价格"
    a_3 "时间"
    a_4 "家庭"
    a_5 "团体课"
    a_6 "运动项目"
    a_7 "其它", :string
  end
end