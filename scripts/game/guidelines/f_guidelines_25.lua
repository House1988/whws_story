--[[--
    新手指引
    进入选秀界面
    步骤
--]]--

local f_guidelines_25 = class("f_guidelines_25")
f_guidelines_25.__index = f_guidelines_25

-------------------------------------------------
-- @function [parent=#f_guidelines_25] ctor
-------------------------------------------------
function f_guidelines_25:ctor()	
	self.m_guidelines_manager = nil
	
	self.m_time = 0
	self.m_finish = false
	
	self.STATE_INIT			= 1
	self.STATE_CHECK		= 2
	self.STATE_FINISH		= 3
	self.STATE_EXIT			= 4
	
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
end

-------------------------------------------------------------------------------
-- @function [parent=#f_guidelines_25] setGuidelinesManager
-- 设置新手指引管理
-------------------------------------------------------------------------------
function f_guidelines_25:setGuidelinesManager(manager)	
	self.m_guidelines_manager = manager
end

-------------------------------------------------------------------------------
-- @function [parent=#f_guidelines_25] guidelinesNextIndex
-- 获取下一步指引index
-------------------------------------------------------------------------------
function f_guidelines_25:guidelinesNextIndex()	
	return 26
end


-------------------------------------------------------------------------------
-- @function [parent=#f_guidelines_25] guidelinesFinish
-- 判断当前指引是否结束
-------------------------------------------------------------------------------
function f_guidelines_25:guidelinesFinish()	
	return self.m_finish
end


-------------------------------------------------------------------------------
-- @function [parent=#f_guidelines_25] update
-- 新手指引更新函数
-------------------------------------------------------------------------------
function f_guidelines_25:update(dt)	
	self.m_state_function_array[self.m_current_state](dt)
end


-------------------------------------------------------------------------------
-- @function [parent=#f_guidelines_25] state_Init
-- 初始化当前状态
-------------------------------------------------------------------------------
function f_guidelines_25:state_Init(dt)	
	if g_game.g_current_scene_type == g_game.SCENE_TYPE_GAME then		
		if not g_game.g_panelManager:isUiPanelShow("keju_xuanxiu_shangcheng") then
			return 
		end
		
		local shangchengPanel = g_game.g_panelManager:getUiPanel("keju_xuanxiu_shangcheng")
		if shangchengPanel then
			local xuanxiuPanel = shangchengPanel.m_componentTable["xuanxiiu_label"]
			if xuanxiuPanel then
				local stencilPanel = self.m_guidelines_manager:getComponent()
				stencilPanel:enableAllStencil(true)
				stencilPanel:scaleFullScreen(false)		
				stencilPanel:enableStencil(true)
				
				local posx, posy = xuanxiuPanel:getPosition()
				local pos = xuanxiuPanel:getParent():convertToWorldSpace(cc.p(posx, posy))			
				stencilPanel:setRectType(pos, xuanxiuPanel:getSize(), false, false)
				
				local guideLinesPanel = fc.FContainerPanel:create()
				guideLinesPanel:setSize(cc.size(159,45))
				
				local guidelinesBtn = fc.FRadioButton:create()
			    guidelinesBtn:setRadioButtonImage("batch_ui/qieyeanniu_down1.png","batch_ui/qieyeanniu_up1.png")
			    guidelinesBtn:setSize(cc.size(159,45))
			    guidelinesBtn:setAnchorPoint(cc.p(0.5,0.5))
			    guideLinesPanel:appendComponent(guidelinesBtn)
			    guidelinesBtn:setPositionInContainer(cc.p(79.5,22.5))
			    guidelinesBtn:setSwallowsTouches(false)
			    
			    local xuan = fc.FExtensionsImage:create()
			    xuan:setImage("batch_ui/xuan_uizi.png")
			    xuan:setSize(cc.size(32,32))
			    xuan:setAnchorPoint(cc.p(0.5,0.5))
			    guideLinesPanel:appendComponent(xuan)
			    xuan:setPositionInContainer(cc.p(56,22))
			
			    local xiu = fc.FExtensionsImage:create()
			    xiu:setImage("batch_ui/xiu_uizi.png")
			    xiu:setSize(cc.size(32,32))
			    xiu:setAnchorPoint(cc.p(0.5,0.5))
			    guideLinesPanel:appendComponent(xiu)
			    xiu:setPositionInContainer(cc.p(104,22))
			    
			    stencilPanel:showIndicateComponent(guideLinesPanel, pos, guideLinesPanel:getSize())
				stencilPanel:showIndicateAnimation(pos, guideLinesPanel:getSize())
				
				self.guidelinesPanel = f_guidelines_text_show_panel.static_create()
				self.guidelinesPanel:panelInitBeforePopup()		
				stencilPanel:appendComponent(self.guidelinesPanel)
				self.guidelinesPanel:setComponentZOrder(100)
				local sizeT = self.guidelinesPanel:getSize()
				self.guidelinesPanel:setAnchorPoint(cc.p(0.5, 0.5))
				local stencilSize = stencilPanel:getStencilSize() 
				self.guidelinesPanel:setPositionInContainer(cc.p(stencilSize.width/2, stencilSize.height/2))
				self.guidelinesPanel:setSwallowsTouches(false)
				self.guidelinesPanel:showText(self.m_guidelines_manager:getGuidelinesText(25))
				self.guidelinesPanel:setGuidlinesPersonImage(self.m_guidelines_manager:getGuidelinesPerson(25), false)
				
				
				--注册监听函数
				self.event_openXuanxiu = function()
					if self.m_current_state == self.STATE_CHECK then
						self.m_current_state = self.STATE_FINISH
					end
				end
				g_game.g_eventManager:registerLuaEvent(g_game.g_f_lua_game_event.F_LUA_GUIDELINES_OPEN_BEAUTY_XUANXIU, self.event_openXuanxiu)
				
		
				self.m_current_state = self.STATE_CHECK
				self.m_time = 0
			end
		end
		

	end
end

-------------------------------------------------------------------------------
-- @function [parent=#f_guidelines_25] state_Check
-- 检查万岁是否结束
-------------------------------------------------------------------------------
function f_guidelines_25:state_Check(dt)	
	self.m_time = self.m_time + dt
	
end

-------------------------------------------------------------------------------
-- @function [parent=#f_guidelines_25] state_Finish
-- 结束当前步骤指引
-------------------------------------------------------------------------------
function f_guidelines_25:state_Finish(dt)	
	self.m_current_state = self.STATE_EXIT
	
	local stencilPanel = self.m_guidelines_manager:getComponent()
	stencilPanel:setRectType(cc.p(0,0), cc.size(0,0), true, false)
	stencilPanel:hideIndicateAnimation()
	stencilPanel:hideIndicateComponent()
	stencilPanel:setVisible(false)
	if self.guidelinesPanel then
		stencilPanel:deleteComponent(self.guidelinesPanel)
		self.guidelinesPanel = nil
	end
	
	
	g_game.g_eventManager:removeLuaEventFunction(g_game.g_f_lua_game_event.F_LUA_GUIDELINES_OPEN_BEAUTY_XUANXIU, self.event_openXuanxiu)

end

-------------------------------------------------------------------------------
-- @function [parent=#f_guidelines_25] state_Exit
-- 退出当前步骤指引
-------------------------------------------------------------------------------
function f_guidelines_25:state_Exit(dt)	
	self.m_finish = true
end


return f_guidelines_25