require("scripts.game.main.reward.f_marketduihuan_card")

local f_market_panel = class("f_market_panel", function()
    return g_game.g_classFactory.newFLuaContainerPanel("f_market_panel")
end)

-- @function [parent=#f_market_panel] ctor
-- 构造函数
-------------------------------------------------------------------------------
function f_market_panel:ctor()    
    self:registerNodeEvent()   
   	
   	self:setSize(cc.size(960, 640))
		
	self:initAllComponent()
end


function f_market_panel:registerNodeEvent(handler)
    if not handler then
        handler = function(event)
                      if event == "enter" then
                          self:onEnter()
                      elseif event == "exit" then
                          self:onExit()
                      elseif event == "enterTransitionFinish" then
                          self:onEnterTransitionFinish()
                      elseif event == "exitTransitionStart" then
                          self:onExitTransitionStart()
                      elseif event == "cleanup" then
                          self:onCleanup()
                      end
                  end
    end
    self:registerScriptHandler(handler)
end

function f_market_panel:onEnterTransitionFinish()
end

function f_market_panel:onExitTransitionStart()
end

function f_market_panel:onCleanup()
end

function f_market_panel:onEnter() 
--	self:enableClipping(true)
	g_game.g_gameManager:addUpdateObj(self)
	-- g_game.g_userInfoManager.m_huodongInTime[g_game.g_huodong_choujiang] = true
end


function f_market_panel:onExit()    
    self:unregisterNodeEvent()
    g_game.g_gameManager:removeUpdateObj(self)
end

function f_market_panel:unregisterNodeEvent(  )
  self:unregisterScriptHandler()
end

function f_market_panel:initAllComponent()	

end


function f_market_panel:setData( datas )
	self.m_datas = datas
	print_lua_table(datas)
	self:fillList()
end


function f_market_panel:fillList()
	self.m_items = {}
	self.m_list = fc.FContainerList:create(2)
  self.m_list:setSize(cc.size(900,460))
  self.m_list:setAnchorPoint(cc.p(0.5,0.5))
  self:appendComponent(self.m_list)
  self.m_list:setPositionInContainer(cc.p(480,384))
  self.m_list:enableClipping(true)
	self.m_list:setListInfo(5, 0, 0, 225, 460)

  local onclick = function(item)
    self:buyItem(item)
  end

	for i = 1, #self.m_datas do
		local data = self.m_datas[i]
		local item = f_marketduihuan_card.static_create()
		item:panelInitBeforePopup()	
		item:setIndex(i)
		item:setData2(data["type"], data["id"], data["des"], data["score"], data["num"], false, "万能名臣球即可兑换")
		item:setCardDuihuanCallback(onclick)				
		self.m_list:appendComponent(item)
		table.insert(self.m_items, item)
	end

  local label_1 = fc.FLabel:createBMFont()
  label_1:setSize(cc.size(900,30))
  label_1:setAnchorPoint(cc.p(0.5,0.5))
  label_1:setFontSize(20)
  label_1:setString("本次豪華市場將持續開放至XX年XX月XX日XX時XX分XX秒，請皇上抓緊時機兌換。")
  label_1:setColor(cc.c3b(255,255,255))
  self:appendComponent(label_1)
  label_1:setPositionInContainer(cc.p(480,140))

  local label_2 = fc.FLabel:createBMFont()
  label_2:setSize(cc.size(900,30))
  label_2:setAnchorPoint(cc.p(0.5,0.5))
  label_2:setFontSize(20)
  label_2:setString("暫無您所需的兌換品？請靜候下次豪華市場开放。萬能球永久有效哦~")
  label_2:setColor(cc.c3b(255,255,255))
  self:appendComponent(label_2)
  label_2:setPositionInContainer(cc.p(480,620))


end

-- 点击兑换按钮
function f_market_panel:buyItem( data )
  local index = data.m_index
  data = self.m_datas[index]
  local price = data["score"]
  local cd = g_game.g_userInfoManager:getHuodongData(g_game.g_huodong_choujiang)
  if g_game.g_userInfoManager.m_baoyin < price then
    g_game.g_utilManager:showMsg("真龙宝印不足")
    return
  end
  g_game.g_userInfoManager:requestBuyLianhuaItem(index)
end


function f_market_panel:update(dt)
	-- self.m_timer = self.m_timer + dt
	-- if self.m_timer >= 1 then
	-- 	self.m_countDownTime = self.m_countDownTime - 1
	-- 	self:setCountDownLabel()
	-- 	self.m_timer = self.m_timer - 1
	-- end
end	


return f_market_panel