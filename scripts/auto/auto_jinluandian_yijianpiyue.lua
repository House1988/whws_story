function createjinluandian_yijianpiyue()

    local table_jinluandian_yijianpiyue = {}

    --create panel
    local jinluandian_yijianpiyue = fc.FContainerPanel:create()
    jinluandian_yijianpiyue:setSize(cc.size(960,640))
    table_jinluandian_yijianpiyue["jinluandian_yijianpiyue"] = jinluandian_yijianpiyue
    local jld_piyue_bottom_panel = fc.FContainerPanel:create()
    jld_piyue_bottom_panel:setSize(cc.size(534,550))
    jld_piyue_bottom_panel:setAnchorPoint(cc.p(0.5,0.5))
    jinluandian_yijianpiyue:appendComponent(jld_piyue_bottom_panel)
    jld_piyue_bottom_panel:setPositionInContainer(cc.p(485,320))
    table_jinluandian_yijianpiyue["jld_piyue_bottom_panel"] = jld_piyue_bottom_panel

    --显示人物的panel 博士
    local jld_show_doctor_panel = fc.FContainerPanel:create()
    jld_show_doctor_panel:setSize(cc.size(534,550))
    jld_show_doctor_panel:setAnchorPoint(cc.p(0.5,0.5))
    jinluandian_yijianpiyue:appendComponent(jld_show_doctor_panel)
    jld_show_doctor_panel:setPositionInContainer(cc.p(478,319))
    table_jinluandian_yijianpiyue["jld_show_doctor_panel"] = jld_show_doctor_panel

    --显示人物的panel 秀女
    local jld_show_girl_panel = fc.FContainerPanel:create()
    jld_show_girl_panel:setSize(cc.size(534,550))
    jld_show_girl_panel:setAnchorPoint(cc.p(0.5,0.5))
    jinluandian_yijianpiyue:appendComponent(jld_show_girl_panel)
    jld_show_girl_panel:setPositionInContainer(cc.p(500,319))
    table_jinluandian_yijianpiyue["jld_show_girl_panel"] = jld_show_girl_panel

    --圣旨底部遮罩
    local hg_wen_la = fc.FScale9Image:createWithBatchUIFrame("batch_ui/shengzhi_ditu.png",cc.rect(40,63,4,4))
    hg_wen_la:setSize(cc.size(412,500))
    hg_wen_la:setAnchorPoint(cc.p(0.5,0.5))
    jld_piyue_bottom_panel:appendComponent(hg_wen_la)  
    hg_wen_la:setPositionInContainer(cc.p(267,275))
    table_jinluandian_yijianpiyue["hg_wen_la"] = hg_wen_la

     --圣旨的轴
    local zhou_u = fc.FExtensionsImage:create()
    zhou_u:setImage("nobatch/shengzhi_zhou.png")
    zhou_u:setSize(cc.size(52,534))
    zhou_u:setRotation(90)
    zhou_u:setAnchorPoint(cc.p(0.5,0.5))
    jld_piyue_bottom_panel:appendComponent(zhou_u)
    zhou_u:setPositionInContainer(cc.p(267,26))
    table_jinluandian_yijianpiyue["zhou_u"] = zhou_u

    --圣旨的下轴
    local zhou_d = fc.FExtensionsImage:create()
    zhou_d:setImage("nobatch/shengzhi_zhou.png")
    zhou_d:setSize(cc.size(52,534))
    zhou_d:setRotation(90)
    zhou_d:setAnchorPoint(cc.p(0.5,0.5))
    jld_piyue_bottom_panel:appendComponent(zhou_d)
    zhou_d:setPositionInContainer(cc.p(267,524))
    table_jinluandian_yijianpiyue["zhou_d"] = zhou_d

    --标题的底
    local title_di = fc.FScale9Image:createWithBatchUIFrame("batch_ui/xingjikuang_tangquanxinggong.png",cc.rect(72,17,2,2))
    title_di:setSize(cc.size(260,50))
    title_di:setAnchorPoint(cc.p(0.5,0.5))
    title_di:setScaleY(-1)
    jld_piyue_bottom_panel:appendComponent(title_di)
    title_di:setPositionInContainer(cc.p(277,25))
    table_jinluandian_yijianpiyue["title_di"] = title_di


    --写字的白色底，是整个面板的底
    local hyjb_rect111 = fc.FScale9Image:createWithBatchUIFrame("batch_ui/tongyongditu_huodong.png",cc.rect(3,3,2,2))
    hyjb_rect111:setSize(cc.size(384,454))
    hyjb_rect111:setAnchorPoint(cc.p(0.5,0.5))
    jld_piyue_bottom_panel:appendComponent(hyjb_rect111)
    hyjb_rect111:setPositionInContainer(cc.p(267,275))
    table_jinluandian_yijianpiyue["hyjb_rect111"] = hyjb_rect111

    --显示文字的label
    local hg_gongxi_word_label = fc.FLabel:createBMFont()
    hg_gongxi_word_label:setSize(cc.size(280,72))
    hg_gongxi_word_label:setWidth(280)
    hg_gongxi_word_label:setAnchorPoint(cc.p(0.5,0.5))
    hg_gongxi_word_label:setFontSize(24)
    hg_gongxi_word_label:setString("啓奏皇上")
    hg_gongxi_word_label:setColor(cc.c3b(91,24,6))
    jld_piyue_bottom_panel:appendComponent(hg_gongxi_word_label)
    hg_gongxi_word_label:setPositionInContainer(cc.p(267,70))  --cc.p(267,84)
    table_jinluandian_yijianpiyue["hg_gongxi_word_label"] = hg_gongxi_word_label

    --边框
    local hyjb_di1 = fc.FScale9Image:createWithBatchUIFrame("batch_ui/tongyongbiankuang2_ciguan.png",cc.rect(44,15,1,1))
    hyjb_di1:setSize(cc.size(384,454))
    hyjb_di1:setAnchorPoint(cc.p(0.5,0.5))
    jld_piyue_bottom_panel:appendComponent(hyjb_di1)
    hyjb_di1:setPositionInContainer(cc.p(267,275))
    table_jinluandian_yijianpiyue["hyjb_di1"] = hyjb_di1

    --黄色色底
    local hyjb_di2 = fc.FScale9Image:createWithBatchUIFrame("batch_ui/tongyongditu2_huodong.png",cc.rect(3,3,2,2))
    hyjb_di2:setSize(cc.size(380,80))
    hyjb_di2:setAnchorPoint(cc.p(0.5,0.5))
    jld_piyue_bottom_panel:appendComponent(hyjb_di2)
    hyjb_di2:setPositionInContainer(cc.p(267,140.5))  --(cc.p(267,181.5))
    table_jinluandian_yijianpiyue["hyjb_di2"] = hyjb_di2

    --提示台词
    local yijianpiyue_taici_label = fc.FLabel:createBMFont()
    yijianpiyue_taici_label:setSize(cc.size(300,72))
    yijianpiyue_taici_label:setWidth(300)
    yijianpiyue_taici_label:setAnchorPoint(cc.p(0.5,0.5))
    yijianpiyue_taici_label:setFontSize(20)
    yijianpiyue_taici_label:setString("皇上龍體康泰，英明神武，批閱奏章也事半功倍！本次一鍵批閱所得如下:")
    yijianpiyue_taici_label:setColor(cc.c3b(91,24,6))
    jld_piyue_bottom_panel:appendComponent(yijianpiyue_taici_label)
    yijianpiyue_taici_label:setPositionInContainer(cc.p(267,133))
    table_jinluandian_yijianpiyue["yijianpiyue_taici_label"] = yijianpiyue_taici_label

    --确定按钮的黄色底
    local hyjb_di3= fc.FScale9Image:createWithBatchUIFrame("batch_ui/tongyongditu2_huodong.png",cc.rect(3,3,2,2))
    hyjb_di3:setSize(cc.size(380,80))
    hyjb_di3:setAnchorPoint(cc.p(0.5,0.5))
    jld_piyue_bottom_panel:appendComponent(hyjb_di3)
    hyjb_di3:setPositionInContainer(cc.p(267,452))  --(cc.p(267,181.5))
    table_jinluandian_yijianpiyue["hyjb_di2"] = hyjb_di3

   
    --显示元宝经验功绩值
    local yuanbao_double = fc.FExtensionsImage:create()
    yuanbao_double:setImage("batch_ui/yinliangDouble.png")
    yuanbao_double:setSize(cc.size(40,32))  --54,42
    yuanbao_double:setAnchorPoint(cc.p(0.5,0.5))
    jld_piyue_bottom_panel:appendComponent(yuanbao_double)
    yuanbao_double:setPositionInContainer(cc.p(101,204))
    table_jinluandian_yijianpiyue["yuanbao_double"] = yuanbao_double

    local exp_image = fc.FExtensionsImage:create()
    exp_image:setImage("batch_ui/exp.png")
    exp_image:setSize(cc.size(56,32))
    exp_image:setAnchorPoint(cc.p(0.5,0.5))
    jld_piyue_bottom_panel:appendComponent(exp_image)
    exp_image:setPositionInContainer(cc.p(227,204))
    table_jinluandian_yijianpiyue["exp_image"] = exp_image

    local gongjizhiimage = fc.FExtensionsImage:create()
    gongjizhiimage:setImage("batch_ui/gongjizhi.png")
    gongjizhiimage:setSize(cc.size(32,32))
    gongjizhiimage:setAnchorPoint(cc.p(0.5,0.5))
    jld_piyue_bottom_panel:appendComponent(gongjizhiimage)
    gongjizhiimage:setPositionInContainer(cc.p(355,204))
    table_jinluandian_yijianpiyue["gongjizhiimage"] = gongjizhiimage

    --显示元宝的label图片
    local silver_label = fc.FScale9Image:createWithBatchUIFrame("batch_ui/shuruwenzi.png",cc.rect(11,9,47,7))
    silver_label:setSize(cc.size(80,25))
    silver_label:setAnchorPoint(cc.p(0.5,0.5))
    jld_piyue_bottom_panel:appendComponent(silver_label)
    silver_label:setPositionInContainer(cc.p(162,204))
    table_jinluandian_yijianpiyue["silver_label"] = silver_label

    --显示元宝的label
    local show_silver = fc.FLabel:createBMFont()
    show_silver:setSize(cc.size(100,30))
    show_silver:setAnchorPoint(cc.p(0.5,0.5))
    show_silver:setFontSize(20)
    show_silver:setString("1000")
    show_silver:setColor(cc.c3b(255,255,0))
    jld_piyue_bottom_panel:appendComponent(show_silver)
    show_silver:setPositionInContainer(cc.p(162,200.5))
    table_jinluandian_yijianpiyue["show_silver"] = show_silver

    --元宝加号
    local silver_plus = fc.FLabel:createBMFont()
    silver_plus:setSize(cc.size(30,30))
    silver_plus:setAnchorPoint(cc.p(0.5,0.5))
    silver_plus:setFontSize(20)
    silver_plus:setString("+")
    silver_plus:setColor(cc.c3b(255,255,0))
    jld_piyue_bottom_panel:appendComponent(silver_plus)
    silver_plus:setPositionInContainer(cc.p(135,200.5))
    table_jinluandian_yijianpiyue["silver_plus"] = silver_plus


    --显示经验的label图片
    local exp_label = fc.FScale9Image:createWithBatchUIFrame("batch_ui/shuruwenzi.png",cc.rect(11,9,47,7))
    exp_label:setSize(cc.size(80,25))
    exp_label:setAnchorPoint(cc.p(0.5,0.5))
    jld_piyue_bottom_panel:appendComponent(exp_label)
    exp_label:setPositionInContainer(cc.p(292,204))
    table_jinluandian_yijianpiyue["exp_label"] = exp_label

    --显示经验的label
    local show_exp = fc.FLabel:createBMFont()
    show_exp:setSize(cc.size(100,30))
    show_exp:setAnchorPoint(cc.p(0.5,0.5))
    show_exp:setFontSize(20)
    show_exp:setString("1000")
    show_exp:setColor(cc.c3b(255,255,0))
    jld_piyue_bottom_panel:appendComponent(show_exp)
    show_exp:setPositionInContainer(cc.p(292,200.5))
    table_jinluandian_yijianpiyue["show_exp"] = show_exp

    --经验加号
    local exp_plus = fc.FLabel:createBMFont()
    exp_plus:setSize(cc.size(30,30))
    exp_plus:setAnchorPoint(cc.p(0.5,0.5))
    exp_plus:setFontSize(20)
    exp_plus:setString("+")
    exp_plus:setColor(cc.c3b(255,255,0))
    jld_piyue_bottom_panel:appendComponent(exp_plus)
    exp_plus:setPositionInContainer(cc.p(267,200.5))
    table_jinluandian_yijianpiyue["exp_plus"] = exp_plus


    --显示功绩值的label图片
    local archievement_label = fc.FScale9Image:createWithBatchUIFrame("batch_ui/shuruwenzi.png",cc.rect(11,9,47,7))
    archievement_label:setSize(cc.size(80,25))
    archievement_label:setAnchorPoint(cc.p(0.5,0.5))
    jld_piyue_bottom_panel:appendComponent(archievement_label)
    archievement_label:setPositionInContainer(cc.p(411,204))
    table_jinluandian_yijianpiyue["archievement_label"] = archievement_label

    --显示功绩值的label
    local show_archievement = fc.FLabel:createBMFont()
    show_archievement:setSize(cc.size(100,30))
    show_archievement:setAnchorPoint(cc.p(0.5,0.5))
    show_archievement:setFontSize(20)
    show_archievement:setString("1000")
    show_archievement:setColor(cc.c3b(255,255,0))
    jld_piyue_bottom_panel:appendComponent(show_archievement)
    show_archievement:setPositionInContainer(cc.p(411,200.5))
    table_jinluandian_yijianpiyue["show_archievement"] = show_archievement

    --功绩值加号
    local archievement_plus = fc.FLabel:createBMFont()
    archievement_plus:setSize(cc.size(30,30))
    archievement_plus:setAnchorPoint(cc.p(0.5,0.5))
    archievement_plus:setFontSize(20)
    archievement_plus:setString("+")
    archievement_plus:setColor(cc.c3b(255,255,0))
    jld_piyue_bottom_panel:appendComponent(archievement_plus)
    archievement_plus:setPositionInContainer(cc.p(386,200.5))
    table_jinluandian_yijianpiyue["archievement_plus"] = archievement_plus


    --国子监底框
     local jld_doctor_bg = fc.FExtensionsImage:create()
    jld_doctor_bg:setImage("nobatch/lvpinzhi_kuang.png")
    jld_doctor_bg:setSize(cc.size(104,104))
    jld_doctor_bg:setAnchorPoint(cc.p(0.5,0.5))
    jld_show_doctor_panel:appendComponent(jld_doctor_bg)
    -- jld_piyue_bottom_panel:appendComponent(jld_doctor_bg)
    jld_doctor_bg:setPositionInContainer(cc.p(170,300))  --cc.p(267,182)
    table_jinluandian_yijianpiyue["jld_doctor_bg"] = jld_doctor_bg


    --国子监博士的图片
    local jld_doctor_image = fc.FExtensionsImage:create()
    jld_doctor_image:setImage("nobatch/guozijianboshi.png")
     jld_doctor_image:setSize(cc.size(90,90))
    jld_doctor_image:setAnchorPoint(cc.p(0.5,0.5))
    jld_show_doctor_panel:appendComponent(jld_doctor_image)
    --jld_piyue_bottom_panel:appendComponent(jld_doctor_image)
    jld_doctor_image:setPositionInContainer(cc.p(170,300))  --cc.p(267,182)
    table_jinluandian_yijianpiyue["jld_doctor_image"] = jld_doctor_image

    --显示国子监名字的label图片
    local doctor_label = fc.FScale9Image:createWithBatchUIFrame("batch_ui/shuruwenzi.png",cc.rect(11,9,47,7))
    doctor_label:setSize(cc.size(100,25))
    doctor_label:setAnchorPoint(cc.p(0.5,0.5))
    jld_show_doctor_panel:appendComponent(doctor_label)
    -- jld_piyue_bottom_panel:appendComponent(doctor_label)
    doctor_label:setPositionInContainer(cc.p(170,370))
    table_jinluandian_yijianpiyue["doctor_label"] = doctor_label

    --显示国子监名字的label
    local show_doctor_name = fc.FLabel:createBMFont()
    show_doctor_name:setSize(cc.size(100,30))
    show_doctor_name:setAnchorPoint(cc.p(0.5,0.5))
    show_doctor_name:setFontSize(20)
    show_doctor_name:setString("国子监博士")
    show_doctor_name:setColor(cc.c3b(255,255,0))
    jld_show_doctor_panel:appendComponent(show_doctor_name)
    -- jld_piyue_bottom_panel:appendComponent(show_doctor_name)
    show_doctor_name:setPositionInContainer(cc.p(170,366))
    table_jinluandian_yijianpiyue["show_doctor_name"] = show_doctor_name

    --国子监博士的底标label
    local show_doctor_num = fc.FLabel:createBMFont()
    show_doctor_num:setSize(cc.size(10,10))
    show_doctor_num:setAnchorPoint(cc.p(0.5,0.5))
    show_doctor_num:setFontSize(20)
    show_doctor_num:setString("11")
    show_doctor_num:setColor(cc.c3b(255,255,0))
    jld_show_doctor_panel:appendComponent(show_doctor_num)
    -- jld_piyue_bottom_panel:appendComponent(show_doctor_num)
    show_doctor_num:setPositionInContainer(cc.p(128,333))
    table_jinluandian_yijianpiyue["show_doctor_num"] = show_doctor_num

    --秀女底框
     local jld_girl_bg = fc.FExtensionsImage:create()
    jld_girl_bg:setImage("nobatch/lvpinzhi_kuang.png")
    jld_girl_bg:setSize(cc.size(104,104))
    jld_girl_bg:setAnchorPoint(cc.p(0.5,0.5))
    jld_show_girl_panel:appendComponent(jld_girl_bg)
    --jld_piyue_bottom_panel:appendComponent(jld_girl_bg)
    jld_girl_bg:setPositionInContainer(cc.p(360,300))  --cc.p(267,182)
    table_jinluandian_yijianpiyue["jld_girl_bg"] = jld_girl_bg

    --秀女的图片
    local jld_girl_image = fc.FExtensionsImage:create()
    jld_girl_image:setImage("nobatch/xiunv.png")
    jld_girl_image:setSize(cc.size(90,90))
    jld_girl_image:setAnchorPoint(cc.p(0.5,0.5))
    jld_show_girl_panel:appendComponent(jld_girl_image)
    --jld_piyue_bottom_panel:appendComponent(jld_girl_image)
    jld_girl_image:setPositionInContainer(cc.p(360,300))  --cc.p(267,182)
    table_jinluandian_yijianpiyue["jld_girl_image"] = jld_girl_image

     --显示秀女名字的label图片
    local girl_label = fc.FScale9Image:createWithBatchUIFrame("batch_ui/shuruwenzi.png",cc.rect(11,9,47,7))
    girl_label:setSize(cc.size(100,25))
    girl_label:setAnchorPoint(cc.p(0.5,0.5))
    jld_show_girl_panel:appendComponent(girl_label)
    -- jld_piyue_bottom_panel:appendComponent(girl_label)
    girl_label:setPositionInContainer(cc.p(360,370))
    table_jinluandian_yijianpiyue["girl_label"] = girl_label

    --显示秀女名字的label
    local show_girl_name = fc.FLabel:createBMFont()
    show_girl_name:setSize(cc.size(100,30))
    show_girl_name:setAnchorPoint(cc.p(0.5,0.5))
    show_girl_name:setFontSize(20)
    show_girl_name:setString("民间秀女")
    show_girl_name:setColor(cc.c3b(255,255,0))
    jld_show_girl_panel:appendComponent(show_girl_name)
    -- jld_piyue_bottom_panel:appendComponent(show_girl_name)
    show_girl_name:setPositionInContainer(cc.p(360,366))
    table_jinluandian_yijianpiyue["show_girl_name"] = show_girl_name

    --秀女的底标label
    local show_girl_num = fc.FLabel:createBMFont()
    show_girl_num:setSize(cc.size(10,10))
    show_girl_num:setAnchorPoint(cc.p(0.5,0.5))
    show_girl_num:setFontSize(20)
    show_girl_num:setString("10")
    show_girl_num:setColor(cc.c3b(255,255,0))
    jld_show_girl_panel:appendComponent(show_girl_num)
    -- jld_piyue_bottom_panel:appendComponent(show_girl_num)
    show_girl_num:setPositionInContainer(cc.p(318,333))
    table_jinluandian_yijianpiyue["show_girl_num"] = show_girl_num

    --确定按钮
    local hg_hy_queding_button = fc.FScaleButton:create()
    hg_hy_queding_button:setSize(cc.size(120,44))  --(cc.size(144,53))
    hg_hy_queding_button:setAnchorPoint(cc.p(0.5,0.5))
    hg_hy_queding_button:setButtonImage("batch_ui/putonganniu1_up.png")
    jld_piyue_bottom_panel:appendComponent(hg_hy_queding_button)
    hg_hy_queding_button:setPositionInContainer(cc.p(267,451.5))
    table_jinluandian_yijianpiyue["hg_hy_queding_button"] = hg_hy_queding_button

    local hyjb_label_que = fc.FShaderExtensionsImage:create(0)
    hyjb_label_que:setAnchorPoint(cc.p(0.5,0.5))
    hyjb_label_que:setImage("batch_ui/que_uizi.png")
    hyjb_label_que:setSize(cc.size(32,32))
    hg_hy_queding_button:appendComponent(hyjb_label_que)
    hyjb_label_que:setPositionInContainer(cc.p(30,22))
    table_jinluandian_yijianpiyue["hyjb_label_que"] = hyjb_label_que

    local yjpy_label_ren = fc.FShaderExtensionsImage:create(0)
    yjpy_label_ren:setAnchorPoint(cc.p(0.5,0.5))
    yjpy_label_ren:setImage("batch_ui/ding_uizi.png")
    yjpy_label_ren:setSize(cc.size(32,32))
    hg_hy_queding_button:appendComponent(yjpy_label_ren)
    yjpy_label_ren:setPositionInContainer(cc.p(90,22))
    table_jinluandian_yijianpiyue["hyjb_label_ren"] = yjpy_label_ren

      
    --一键批阅奏章标题
    -- local hg_ji_ui = fc.FExtensionsImage:create()
    -- hg_ji_ui:setImage("batch_ui/ji8_uizi.png")
    -- hg_ji_ui:setSize(cc.size(32,32))
    -- hg_ji_ui:setAnchorPoint(cc.p(0.5,0.5))
    -- jld_piyue_bottom_panel:appendComponent(hg_ji_ui)
    -- hg_ji_ui:setPositionInContainer(cc.p(242,25))
    -- table_jinluandian_yijianpiyue["hg_ji_ui"] = hg_ji_ui

    -- local hg_bao_ui = fc.FExtensionsImage:create()
    -- hg_bao_ui:setImage("batch_ui/bao2_uizi.png")
    -- hg_bao_ui:setSize(cc.size(32,32))
    -- hg_bao_ui:setAnchorPoint(cc.p(0.5,0.5))
    -- jld_piyue_bottom_panel:appendComponent(hg_bao_ui)
    -- hg_bao_ui:setPositionInContainer(cc.p(304,25))
    -- table_jinluandian_yijianpiyue["hg_bao_ui"] = hg_bao_ui

    local zb_title_label = fc.FLabel:createBMFont()
    zb_title_label:setSize(cc.size(200,30))
    zb_title_label:setAnchorPoint(cc.p(0.5,0.5))
    zb_title_label:setFontSize(24)
    if LANGUAGE_TYPE == 3 then
        zb_title_label:setString("一鍵批閱奏章")
    else
        zb_title_label:setString("一键批阅奏章")
    end
    zb_title_label:setColor(cc.c3b(255,255,255))
    jld_piyue_bottom_panel:appendComponent(zb_title_label)
    zb_title_label:setPositionInContainer(cc.p(268,25))
    table_jinluandian_yijianpiyue["zb_title_label"] = zb_title_label

    return table_jinluandian_yijianpiyue

end

