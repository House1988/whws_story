--[[
    剧情逻辑1
]]--
local f_story_logic_part1 = class("f_story_logic_part1")
f_story_logic_part1.__index = f_story_logic_part1

-------------------------------------------------
-- @function [parent=#f_story_logic_part1] ctor
-------------------------------------------------
function f_story_logic_part1:ctor()	
	self.STEP_PRELOAD = 1
	self.STEP_LOADPANEL = 2
	self.STEP_RUNNING = 3
	self.STEP_FINISH = 4
	
	self.m_logicState = self.STEP_PRELOAD
	
	self.m_isLogicOver = false
	self.m_logicManager = nil
	self.m_panel = nil
end

-------------------------------------------------
-- @function [parent=#f_story_logic_part1] initLogic
-------------------------------------------------
function f_story_logic_part1:initLogic()
	self.m_logicState = self.STEP_PRELOAD
	self.m_isLogicOver = false
end

-------------------------------------------------
-- @function [parent=#f_story_logic_part1] setLogicManager
-------------------------------------------------
function f_story_logic_part1:setLogicManager(manager)
	self.m_logicManager = manager
end

-------------------------------------------------
-- @function [parent=#f_story_logic_part1] update
-------------------------------------------------
function f_story_logic_part1:update(dt)
	if self.m_logicState == self.STEP_PRELOAD then
		self:storyPreload(dt)
	elseif self.m_logicState == self.STEP_LOADPANEL then
		self:storyLoadPanel(dt)
	elseif self.m_logicState == self.STEP_RUNNING then
		self:storyRunning(dt)
	elseif self.m_logicState == self.STEP_FINISH then
		self:storyFinish(dt)
	end
end

-------------------------------------------------
-- @function [parent=#f_story_logic_part1] storyPreload
-------------------------------------------------
function f_story_logic_part1:storyPreload(dt)
	--release predata
	g_game.g_resourceManager:removeAllAnimation()
	cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
	cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	
	g_game.g_resourceManager:preloadFAnimation(g_game.g_f_main_ui_effect.STORY_STEP2_1[1])

	self.m_logicState = self.STEP_LOADPANEL
end

-------------------------------------------------
-- @function [parent=#f_story_logic_part1] storyLoadPanel
-------------------------------------------------
function f_story_logic_part1:storyLoadPanel(dt)
	local basePanel = self.m_logicManager:getBottomPanel()
	
	local bottomPanel = require("scripts.game.story.f_story_step2_panel").new()
	basePanel:addChildPanel(2,bottomPanel)
	
	self.m_panel = require("scripts.game.story.f_story_step1_panel").new()
	basePanel:addChildPanel(1,self.m_panel)
	
	self.m_logicState = self.STEP_RUNNING
end

-------------------------------------------------
-- @function [parent=#f_story_logic_part1] storyRunning
-------------------------------------------------
function f_story_logic_part1:storyRunning(dt)
	if self.m_panel:isPlayOver() then
		self.m_logicState = self.STEP_FINISH
	end
end

-------------------------------------------------
-- @function [parent=#f_story_logic_part1] storyFinish
-------------------------------------------------
function f_story_logic_part1:storyFinish(dt)
	self.m_isLogicOver = true
end

-------------------------------------------------
-- @function [parent=#f_story_logic_part1] isLogicOver
-------------------------------------------------
function f_story_logic_part1:isLogicOver()
	return self.m_isLogicOver
end

return f_story_logic_part1