require("scripts.auto.auto_jinluandian_yijianpiyue")
--[[
]]--

local f_onekeyreadzouzhang_reward_popup = class("f_onekeyreadzouzhang_reward_popup", function()
    return g_game.g_classFactory.newFLuaContainerPanel("f_onekeyreadzouzhang_reward_popup")
end)

-------------------------------------------------------------------------------
-- @function [parent=#f_onekeyreadzouzhang_reward_popup] ctor
-- 构造函数
-------------------------------------------------------------------------------
function f_onekeyreadzouzhang_reward_popup:ctor()    
    self:setSize(cc.size(CONFIG_SCREEN_WIDTH,CONFIG_SCREEN_HEIGHT))
    self.m_type = 0 
 
    self.m_componentTable = createjinluandian_yijianpiyue()   --createzouzhang_reward_popup()
    self.m_panel =  self.m_componentTable["jinluandian_yijianpiyue"]   --["zouzhang_reward_popup"]
    self:appendComponent(self.m_panel)
    self.m_panel:setPositionInContainer(cc.p(CONFIG_SCREEN_WIDTH/2,CONFIG_SCREEN_HEIGHT/2))
    --self.m_panel:setVisible(false)
end


function f_onekeyreadzouzhang_reward_popup:showPanel()

	--self.m_panel:setVisible(true)
	local result = g_game.g_userInfoManager.m_onekeyreadResult

		--self.m_componentTable["type_exp_panel"]:setVisible(false)
		--self.m_componentTable["type_card_panel"]:setVisible(true)
		
		-- --人物奖励  暂时不考虑
		-- local rewardInfo = result["rewardList"][1]
		-- local imagePath, q, name = g_game.g_dictConfigManager:getResByType(rewardInfo["type"], rewardInfo["id"])
		-- self.m_componentTable["num"]:setTextWithInt(rewardInfo["num"]) -- 个数
		
		-- self.m_componentTable["card_name"]:setString(name)
		-- if imagePath ~= nil then
		-- 	self.m_componentTable["card"]:setImage(imagePath)
		-- 	self.m_componentTable["card"]:setExtensionsTextureRect(cc.rect(0,0,90,90))
		-- end
		-- self.m_componentTable["quality"]:setImage(g_game.g_f_quality_image[q])
		
		-- local listNum = result["rewardList_Num"]
		-- -- 更新数据
		-- g_game.g_userInfoManager:updatePackToUser(listNum,result["rewardList"])
		

		--self.m_componentTable["type_exp_panel"]:setVisible(true)
		--self.m_componentTable["type_card_panel"]:setVisible(false)
		
		local userLv = g_game.g_userInfoManager:getUserLv()
		local silver,exp = g_game.g_dictConfigManager:getZouZhangReward(userLv)
		silver = silver
		exp = exp
		
		--显示经验
		self.m_componentTable["show_exp"]:setString(tostring("exp"))
		-- local numAnim1 = require("scripts.game.main.common.f_number_effect").new()
		-- numAnim1:setup(self.m_componentTable["show_exp"], 21, "%d", false, false)
		-- self:appendComponent(numAnim1)
		-- local p = self.m_componentTable["show_exp"]:getPositionInContainer()
		-- numAnim1:setPositionInContainer(p)
		-- numAnim1:play(0,exp,1)
		
		--显示银两
		self.m_componentTable["show_silver"]:setString(tostring("silver"))
		-- local numAnim2 = require("scripts.game.main.common.f_number_effect").new()
		-- --numAnim2:setup(self.m_componentTable["show_silver"], 21, "%d", false, false)
		-- numAnim2:setup(self.m_componentTable["show_silver"], 21, "%d", false, false)
		-- self:appendComponent(numAnim2)
		-- local p2 = self.m_componentTable["show_silver"]:getPositionInContainer()
		-- numAnim2:setPositionInContainer(p2)
		-- numAnim2:play(0,result["silver"],1)

		
--		self.m_componentTable["exp_add"]:setString("+"..exp)
--		self.m_componentTable["yinliang_add"]:setString("+"..silver)
		
		self.m_componentTable["show_archievement"]:setString("0")
		if result["rewardList_Num"] > 0 and result["rewardList"][1]["type"] == 8 then	

			local numAnim3 = require("scripts.game.main.common.f_number_effect").new()
			numAnim3:setup(self.m_componentTable["show_archievement"], 21, "%d", false, false)
			self:appendComponent(numAnim3)
			local p3 = self.m_componentTable["show_archievement"]:getPositionInContainer()
			numAnim3:setPositionInContainer(p3)
			numAnim3:play(0,result["rewardList"][1]["id"],1)

--			self.m_componentTable["gongjizhi_add"]:setString("+"..result["rewardList"][1]["id"])
		end
end

-------------------------------------------------------------------------------
-- @function [parent=#f_onekeyreadzouzhang_reward_popup] onEnter
-- on, 初始化事件监听
-------------------------------------------------------------------------------
function f_onekeyreadzouzhang_reward_popup:onEnter()  
end

function f_onekeyreadzouzhang_reward_popup:onExit()   
    --f_onekeyreadzouzhang_reward_popup:removeFromParentAndCleanup() 
end

function f_onekeyreadzouzhang_reward_popup:onEnterTransitionFinish()
end

function f_onekeyreadzouzhang_reward_popup:onExitTransitionStart()
end

function f_onekeyreadzouzhang_reward_popup:onCleanup()
end


return f_onekeyreadzouzhang_reward_popup
