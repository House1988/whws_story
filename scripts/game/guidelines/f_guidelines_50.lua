--[[--
    新手指引
  	指向开服有礼关闭按钮  点击关闭
    步骤
--]]--

local f_guidelines_50 = class("f_guidelines_50")
f_guidelines_50.__index = f_guidelines_50

-------------------------------------------------
-- @function [parent=#f_guidelines_50] ctor
-------------------------------------------------
function f_guidelines_50:ctor()	
	self.m_guidelines_manager = nil
	
	self.m_time = 0
	self.m_finish = false
	
	self.STATE_INIT			= 1
	self.STATE_CHECK		= 2
	self.STATE_FINISH		= 4
	self.STATE_EXIT			= 5
	
	self.m_state_function_array = {}
	
	local state_init = function(dt)
		self:state_Init(dt)
	end
	self.m_state_function_array[self.STATE_INIT] = state_init
	
	local state_check = function(dt)
		self:state_Check(dt)
	end
	self.m_state_function_array[self.STATE_CHECK] = state_check
	
	local state_finish = function(dt)
		self:state_Finish(dt)
	end
	self.m_state_function_array[self.STATE_FINISH] = state_finish
	
	local state_exit = function(dt)
		self:state_Exit(dt)
	end
	self.m_state_function_array[self.STATE_EXIT] = state_exit
	
	self.m_current_state	= self.STATE_INIT
	
	self.guidelinesPanel = nil
	
end

-------------------------------------------------------------------------------
-- @function [parent=#f_guidelines_50] setGuidelinesManager
-- 设置新手指引管理
-------------------------------------------------------------------------------
function f_guidelines_50:setGuidelinesManager(manager)	
	self.m_guidelines_manager = manager
end

-------------------------------------------------------------------------------
-- @function [parent=#f_guidelines_50] update
-- 新手指引更新函数
-------------------------------------------------------------------------------
function f_guidelines_50:update(dt)	
	self.m_time = self.m_time + dt
	
	self.m_state_function_array[self.m_current_state](dt)
end

-------------------------------------------------------------------------------
-- @function [parent=#f_guidelines_50] state_Init
-- 初始化当前状态
-------------------------------------------------------------------------------
function f_guidelines_50:state_Init(dt)
	if g_game.g_current_scene_type == g_game.SCENE_TYPE_GAME then
		
		if not g_game.g_panelManager:isUiPanelShow("open_service_ui") then
			return 
		end
	 
	 	local openUi = g_game.g_panelManager:getUiPanel("open_service_ui")
	 	if openUi then
	 			
			local stencilPanel = self.m_guidelines_manager:getComponent()
			stencilPanel:enableAllStencil(true)
			stencilPanel:scaleFullScreen(false)		
			stencilPanel:enableStencil(true)
			
			local closeBtn = openUi.m_componentTable["os_close_btn"]
			
			local posx, posy = closeBtn:getPosition()
			local pos = closeBtn:getParent():convertToWorldSpace(cc.p(posx, posy))			
			stencilPanel:setRectType(pos, closeBtn:getSize(), false, false)
			
			local guideLineBtn = fc.FScaleButton:create()
		    guideLineBtn:setSize(cc.size(44,45))
		    guideLineBtn:setAnchorPoint(cc.p(0.5,0.5))
		    guideLineBtn:setButtonImage("batch_ui/libaoduihuan_guanbijian.png")

	 		stencilPanel:showIndicateComponent(guideLineBtn, pos, closeBtn:getSize())
			stencilPanel:showIndicateAnimation(pos, closeBtn:getSize())
			
			local toFinish = function()
				if self.m_current_state == self.STATE_CHECK then
					self.m_current_state = self.STATE_FINISH
				end
			end
			guideLineBtn:addHandleOfcomponentEvent(toFinish, g_game.g_f_touch_event.F_TOUCH_UPINSIDE )
			
			self.m_current_state = self.STATE_CHECK
	 	end
	 	
	end
end

-------------------------------------------------------------------------------
-- @function [parent=#f_guidelines_50] state_Check
-- 检查是否点击了金銮殿按钮
-------------------------------------------------------------------------------
function f_guidelines_50:state_Check(dt)	
end

-------------------------------------------------------------------------------
-- @function [parent=#f_guidelines_50] state_Finish
-- 结束当前步骤指引
-------------------------------------------------------------------------------
function f_guidelines_50:state_Finish(dt)	
	self.m_current_state = self.STATE_EXIT
	
	--50 跟 49部的结束 记录都是 5  进入后宫，此时已经领取过了 
	g_game.g_userInfoManager:requestRecordGuidleStep(5)
	local stencilPanel = self.m_guidelines_manager:getComponent()
	stencilPanel:setRectType(cc.p(0,0), cc.size(0,0), true, false)
	stencilPanel:hideIndicateAnimation()
	stencilPanel:hideIndicateComponent()
		
	if self.guidelinesPanel then
		stencilPanel:deleteComponent(self.guidelinesPanel)
		self.guidelinesPanel = nil
	end
end

-------------------------------------------------------------------------------
-- @function [parent=#f_guidelines_50] state_Exit
-- 退出当前步骤指引
-------------------------------------------------------------------------------
function f_guidelines_50:state_Exit(dt)	
	self.m_finish = true
end

-------------------------------------------------------------------------------
-- @function [parent=#f_guidelines_50] guidelinesFinish
-- 判断当前指引是否结束
-------------------------------------------------------------------------------
function f_guidelines_50:guidelinesFinish()	
	return self.m_finish
end

-------------------------------------------------------------------------------
-- @function [parent=#f_guidelines_50] guidelinesNextIndex
-- 获取下一步指引index
-------------------------------------------------------------------------------
function f_guidelines_50:guidelinesNextIndex()	
	return 5
	--return 24
end

return f_guidelines_50