--[[--
    mycard android sdk
--]]--
local f_android_tw_mycard_sdk = class("f_android_tw_mycard_sdk", function()
    return fc.FSdkManager:getInstance()
end)


function f_android_tw_mycard_sdk:ctor()
	self.json   = require("prescripts.framework.json")
	self.m_vertifiy_server = {["ip"] = "54.255.182.50",  ["port"] = 21000}
	
	self.event_init = function()
		self:init_sdk()
	end
	g_game.g_eventManager:registerLuaEvent(g_game.g_f_lua_game_event.F_LUA_SDK_INIT, self.event_init)
	
	-- 获取上次登录类型
	local ok
	self.lastLoginType = 0
	ok,self.lastLoginType = g_game.g_luaj.callStaticMethod("org.cocos2dx.lua.UtilTool", "getUserLastLoginType", {}, "()I")
	
	-- 默认登录
	self.event_showLogin = function()
		if self.lastLoginType == 1 or self.lastLoginType == 2 then
			self:show_sdk_view(self.lastLoginType, 1)
		else
			send_lua_event(g_game.g_f_lua_game_event.F_LUA_SDK_SHOW_LOGIN_CHOOSE_PANEL)
		end
	end
	g_game.g_eventManager:registerLuaEvent(g_game.g_f_lua_game_event.F_LUA_SDK_SHOW_LOGIN, self.event_showLogin)
	
	-- google登录
	self.event_showLogin = function()
		self:show_sdk_view(1, 0)
	end
	g_game.g_eventManager:registerLuaEvent(g_game.g_f_lua_game_event.F_LUA_SDK_LOGIN_GOOGLE, self.event_showLogin)
	
	-- facebook登录
	self.event_showLogin = function()
		self:show_sdk_view(2, 0)
	end
	g_game.g_eventManager:registerLuaEvent(g_game.g_f_lua_game_event.F_LUA_SDK_LOGIN_FACEBOOK, self.event_showLogin)
	
	self.event_changeUser = function()
		send_lua_event(g_game.g_f_lua_game_event.F_LUA_SDK_SHOW_LOGIN_CHOOSE_PANEL)
	end
	g_game.g_eventManager:registerLuaEvent(g_game.g_f_lua_game_event.F_LUA_SDK_LOGIN_CHANGE_ACCOUNT, self.event_changeUser)
	
	self.m_user_info = {}
	
	--充值
	self.getTransitionInfo= function(msg)
		self:responseTranscationInfoFromGameServer(msg)
	end
	g_game.g_netManager:registerMessage(g_network_message_type.SC_TRANSACTION_INFO,self.getTransitionInfo)
	
		
	self.getBuyResultFromGameServer= function(msg)
		self:responseBuyResultFromGameServer(msg)
	end
	g_game.g_netManager:registerMessage(g_network_message_type.SC_TRANSACTION, self.getBuyResultFromGameServer)
	
	self.event_iap_products_load = function(productsList)
		self:loadProductsFromServer(productsList)
	end
	g_game.g_eventManager:registerLuaEvent(g_game.g_f_lua_game_event.F_IAP_PRODUCLIST_LOAD, self.event_iap_products_load)
	
	-- google支付结果的监听
	self.mycard_ingame_buy = function(result)
		print("========================mycard_ingame_buy======================================")
		self:f_mycard_ingame_buy(result)
	end
	g_game.g_luaj.callStaticMethod("org/cocos2dx/lua/AppActivity", "setMycardIngameBuyHandler", {self.mycard_ingame_buy}, "(I)V")
	
	self.event_iap_buy = function(data)
		self:iapBuyItem(data)
	end
	g_game.g_eventManager:registerLuaEvent(g_game.g_f_lua_game_event.F_IAP_BUY_ITEM, self.event_iap_buy)
	
	
	self.event_check_native_pay = function()
		self:checkNativePayment()
	end
	g_game.g_eventManager:registerLuaEvent(g_game.g_f_lua_game_event.F_IAP_CHECK_NATIVE_PAY, self.event_check_native_pay)
	
	self.m_quit_game_panel = nil
	local backKeyCallback = function()
		if self.m_quit_game_panel == nil then
			self.m_quit_game_panel = require("prescripts.common.f_quit_game_panel").new()
			self.m_quit_game_panel:setShowText("退出遊戲")
			self.m_quit_game_panel:createCommonTips()
		else
			self.m_quit_game_panel:hide()
			self.m_quit_game_panel = nil
		end
	end
	g_game.g_luaj.callStaticMethod("org/cocos2dx/lua/AppActivity", "setBackKeyHandler", {backKeyCallback}, "(I)V")
end

-------------------------------------------------------------------------------
-- @function [parent=#f_android_tw_mycard_sdk] init_sdk
-- 初始化sdk
-------------------------------------------------------------------------------
function f_android_tw_mycard_sdk:init_sdk()
	self:setMycardVertifiyServer_android(self.m_vertifiy_server["ip"], self.m_vertifiy_server["port"])
	
	local vertifiyUserInfoCallback = function(type)
		local loginResult = {}
		if type >= 0 then
			loginResult["result"] = 0
			loginResult["account"] = self.m_user_info["uid"]
			loginResult["userid"] = self.m_user_info["uid"]
			loginResult["error_des"] = ""
		else
			loginResult["account"] = ""
			loginResult["userid"] = ""
			
			if type == -1 then
				loginResult["error_des"] = "未知错误"
				loginResult["result"] = g_game.g_f_lua_game_event.F_LUA_SDK_UNKNOW_ERROR
			elseif type == -11 then
				loginResult["error_des"] = "用户未登录,请登录平台帐号!"
				loginResult["result"] = g_game.g_f_lua_game_event.F_LUA_SDK_USER_NEED_LOGIN
			elseif type == -13 then
				loginResult["error_des"] = "用户校验失败,请重新登录平台帐号!"
				loginResult["result"] = g_game.g_f_lua_game_event.F_LUA_SDK_USER_ACCESS_FAILED
			end
		end
		send_lua_event_param(g_game.g_f_lua_game_event.F_LUA_SDK_LOGIN_CALLBACK, loginResult)
	end
	self:setLoginMycardSdkListener_android(vertifiyUserInfoCallback)
end


-------------------------------------------------------------------------------
-- @function [parent=#f_android_tw_mycard_sdk] show_sdk_view
-- 显示sdk界面
-------------------------------------------------------------------------------
function f_android_tw_mycard_sdk:show_sdk_view(loginType, isDefault)
	send_lua_event(g_game.g_f_lua_game_event.F_LUA_NETWORK_LOADING)
	
	local loginCallback = function(resStr)
		local resultInfo = self.json.decode(resStr)
		self.m_user_info["flag"] = resultInfo["flag"]
		self.m_user_info["appId"] = resultInfo["appId"]
		self.m_user_info["token"] = resultInfo["token"]
		self.m_user_info["uid"] = resultInfo["uid"]
		
		self:vertifiyMycardAccount_android(self.m_user_info["flag"], self.m_user_info["appId"], self.m_user_info["uid"], self.m_user_info["token"])
	end
	
	local loginFailedCallback = function(strCode)
		local resultInfo = self.json.decode(strCode)
		local loginResult = {}
		local type = resultInfo["errorCode"]
		loginResult["account"] = ""
		loginResult["userid"] = ""
		if type == -1 then
			loginResult["error_des"] = "未知錯誤"
			loginResult["result"] = g_game.g_f_lua_game_event.F_LUA_SDK_UNKNOW_ERROR
		elseif type == -11 then
			loginResult["error_des"] = "用戶未登錄,請登錄賬號!"
			loginResult["result"] = g_game.g_f_lua_game_event.F_LUA_SDK_USER_NEED_LOGIN
		elseif type == -13 then
			loginResult["error_des"] = "用戶驗證失敗,請重新登錄賬號!"
			loginResult["result"] = g_game.g_f_lua_game_event.F_LUA_SDK_USER_ACCESS_FAILED
		end
	
		send_lua_event_param(g_game.g_f_lua_game_event.F_LUA_SDK_LOGIN_CALLBACK, loginResult)
	end
	
	local args = 
	{
		loginType,
		isDefault,
		loginCallback,
		loginFailedCallback
	}
	g_game.g_luaj.callStaticMethod("org/cocos2dx/lua/AppActivity", "show_login", args, "(IIII)V")
end

-------------------------------------------------------------------------------
-- @function [parent=#f_android_tw_mycard_sdk] change_sdk_user
-- 更改sdk用户
-------------------------------------------------------------------------------
function f_android_tw_mycard_sdk:change_sdk_user()
	send_lua_event(g_game.g_f_lua_game_event.F_LUA_NETWORK_LOADING)
	
	local loginCallback = function(resStr)		
		local resultInfo = self.json.decode(resStr)	
		self.m_user_info["flag"] = resultInfo["flag"]
		self.m_user_info["appId"] = resultInfo["appId"]
		self.m_user_info["webId"] = resultInfo["webId"]
		self.m_user_info["token"] = resultInfo["token"]
		self.m_user_info["uid"] = resultInfo["uid"]
		
		self:vertifiyMycardAccount_android(self.m_user_info["flag"], self.m_user_info["appId"], self.m_user_info["webId"], self.m_user_info["token"])
	end
	
	local loginFailedCallback = function(strCode)
		local resultInfo = self.json.decode(strCode)	
		
		local loginResult = {}
		local type = resultInfo["errorCode"]
		loginResult["account"] = ""
		loginResult["userid"] = ""
		if type == -1 then
			loginResult["error_des"] = "未知错误"
			loginResult["result"] = g_game.g_f_lua_game_event.F_LUA_SDK_UNKNOW_ERROR
		elseif type == -11 then
			loginResult["error_des"] = "用户未登录,请登录平台帐号!"
			loginResult["result"] = g_game.g_f_lua_game_event.F_LUA_SDK_USER_NEED_LOGIN
		elseif type == -13 then
			loginResult["error_des"] = "用户校验失败,请重新登录平台帐号!"
			loginResult["result"] = g_game.g_f_lua_game_event.F_LUA_SDK_USER_ACCESS_FAILED
		end
	
		send_lua_event_param(g_game.g_f_lua_game_event.F_LUA_SDK_LOGIN_CALLBACK, loginResult)
	end
	local args = 
	{
		loginCallback,
		loginFailedCallback
	}
	g_game.g_luaj.callStaticMethod("org/cocos2dx/lua/AppActivity", "show_login_switch_user", args, "(II)V")
end


---------------------------------------------------------------------------------
--充值部分

-------------------------------------------------
-- @function [parent=#f_android_tw_mycard_sdk] loadProductsFromServer
-- 使用产品key列表，刷新商店界面
-------------------------------------------------
function f_android_tw_mycard_sdk:loadProductsFromServer(itemList)	
	self.m_products_id_list = itemList
		
	
	self:iapRequestProductsListener(self.m_products_id_list)
end


-------------------------------------------------
-- @function [parent=#f_android_tw_mycard_sdk] iapRequestProductsListener
-- 模拟苹果服务器返回列表
-------------------------------------------------
function f_android_tw_mycard_sdk:iapRequestProductsListener(data)	
	self.m_products_array = {}	

	for key, value in ipairs(data) do 
		local itemInfo = {} 
		itemInfo["iap"] = value["itemKey"]
		itemInfo["info"] = value
		
		table.insert(self.m_products_array, itemInfo)
	end 	
	send_lua_event_param(g_game.g_f_lua_game_event.F_IAP_INIT_SHOP_ITEM, self.m_products_array)
	
end


-------------------------------------------------
-- @function [parent=#f_android_tw_mycard_sdk] checkNativePayment
-- 检查本地存储得收据凭证并进行继续验证
-------------------------------------------------
function f_android_tw_mycard_sdk:checkNativePayment()	
	local transactionList = g_game.g_dataManager:getPaymentTransaction()
	if transactionList then		
		for i,v in ipairs(transactionList) do
			--进入购买流程，需要loading显示阻挡用户进行其他操作
			self:requestTransitionVertifyFromGameServer(v["transactionIdentifier"])
		end
	end
end

-------------------------------------------------
-- @function [parent=#f_android_tw_mycard_sdk] iapBuyItem
-- 请求购买物品的订单id
-------------------------------------------------
function f_android_tw_mycard_sdk:iapBuyItem(data)	
	self.m_current_buy_item_data = data
	
	self:requestTransitionInfoFromGameServer()
end

-------------------------------------------------
-- @function [parent=#f_android_tw_mycard_sdk] buyResultFrom360Server
-- 接收服务器返回的购买结果
-------------------------------------------------
function f_android_tw_mycard_sdk:buyResultFrom360Server(result)	
	
	local resultInfo = self.json.decode(result)	
	local typeX = resultInfo["result"]
	
	if typeX < 0 then	
		if self.m_current_save_trascation then			
			g_game.g_dataManager:removePaymentTransaction(self.m_current_save_trascation)
			self.m_current_save_trascation = nil
		end		
	end
	if typeX == -1 or typeX == -2 then
		send_lua_event(g_game.g_f_lua_game_event.F_LUA_CLOSE_NETWORK_LOADING)
	end
end

-------------------------------------------------
-- @function [parent=#f_android_tw_mycard_sdk] responseTranscationInfoFromGameServer
-- 接收游戏服务器返回的订单号等信息
-------------------------------------------------
function f_android_tw_mycard_sdk:responseTranscationInfoFromGameServer(msg)
	if msg["result"] == 0 then
		local userInfo = g_game.g_userInfoManager:getUserInfo()
		local args = 
		{
			userInfo["roleId"],
			self.m_current_buy_item_data["info"]["price"],
			msg["transactionId"]
		}
		g_game.g_luaj.callStaticMethod("org/cocos2dx/lua/AppActivity", "buyItemWithInfo", args, "(Ljava/lang/String;ILjava/lang/String;)V")
	else
		if self.m_current_buy_item_data["info"]["id"] == g_game.g_f_month_card_info["info"]["id"] then
			g_game.g_utilManager:showMsg("購買月卡失敗，請重新購買!")
		else
			g_game.g_utilManager:showMsg("購買元寶失敗，請重新購買!")
		end
		send_lua_event_param(g_game.g_f_lua_game_event.F_IAP_BUY_ITEM_RESULT, {["result"] = false, ["productId"] = self.m_current_buy_item_data["info"]["id"]})	
		self.m_current_buy_item_data = nil
	end
	send_lua_event(g_game.g_f_lua_game_event.F_LUA_CLOSE_NETWORK_LOADING)
end

---------------------------------------------------------------------------
-- @function [parent=#f_android_tw_mycard_sdk] f_mycard_ingame_buy
---------------------------------------------------------------------------
function f_android_tw_mycard_sdk:f_mycard_ingame_buy(data)
	printlua("f_mycard_ingame_buy")
	-- print_lua_table(data)
	local resultInfo = self.json.decode(data)
	local iapType = resultInfo["type"]
	
	-- 1 点卡购买
	local userInfo = g_game.g_userInfoManager:getUserInfo()
	printlua(iapType)
	if iapType == 1 then
		printlua(DEBUG_SDK_TYPE)
		print("我进入了   f_android_tw_mycard_sdk:f_mycard_ingame_buy(！！！！！！！！！！！！")
		local dataT = {}
		dataT["roleId"] = userInfo["roleId"]
 		dataT["cardId"] = resultInfo["cardId"]
 		dataT["password"] = resultInfo["pwd"]
 		dataT["transactionId"] = resultInfo["orderId"]
 		dataT["productId"] = tostring(self.m_current_buy_item_data["info"]["id"])

 		local cc1=userInfo["roleId"]
 		local cc2=resultInfo["cardId"]
 		local cc3=resultInfo["pwd"]
 		local cc4=resultInfo["orderId"]
 		local cc5=tostring(self.m_current_buy_item_data["info"]["id"])
        printlua(cc1)
        printlua(cc2)
        printlua(cc3)
        printlua(cc4)
        printlua(cc5)

		print("我进入了   f_android_tw_mycard_sdk:f_mycard_ingame_buy(！！！！！！！！！！！！")
		g_game.g_netManager:send_message(g_network_message_type.CS_MYCARD_TRANSACTION, dataT)

			
	end
	
	self.m_current_save_trascation = resultInfo["orderId"]
	local transcationInfo = {}
	transcationInfo["transactionIdentifier"] = resultInfo["orderId"]
	transcationInfo["receipt"] = "none"		
	g_game.g_dataManager:savePaymentTransaction(transcationInfo)
	
	--sdk事件收集
	local eventData = {}
	eventData["orderId"] = resultInfo["orderId"]
	eventData["iapId"] = self.m_current_buy_item_data["info"]["itemKey"]
	eventData["amount"] = self.m_current_buy_item_data["info"]["price"]
	eventData["currencyType"] = "NT$"
	eventData["paymentType"] = "mycard支付"
	send_lua_event_param(g_game.g_f_lua_game_event.F_LUA_DATA_USER_CHARGE_START, eventData)
	print("我进入了  F_LUA_DATA_USER_CHARGE_START  ！！！！！！！！！！！！")
	send_lua_event(g_game.g_f_lua_game_event.F_LUA_NETWORK_LOADING)
end

-------------------------------------------------
-- @function [parent=#f_android_tw_mycard_sdk] requestTransitionInfoFromGameServer
-- 向服务器发送购买请求，并获取订单id
-------------------------------------------------
function f_android_tw_mycard_sdk:requestTransitionInfoFromGameServer()
	local userInfo = g_game.g_userInfoManager:getUserInfo()
	local dataT = {}
	dataT["roleId"] = userInfo["roleId"]
	dataT["transactionID"] = "none"
	dataT["receipt"] = "none"
	dataT["productId"] = self.m_current_buy_item_data["info"]["id"]
	dataT["flag"] = 0
	g_game.g_netManager:send_message(g_network_message_type.CS_TRANSACTION, dataT)
end

-------------------------------------------------
-- @function [parent=#f_android_tw_mycard_sdk] requestTransitionVertifyFromGameServer
-- 使用本地缓存的未完成订单，向服务器再次验证
-------------------------------------------------
function f_android_tw_mycard_sdk:requestTransitionVertifyFromGameServer(transcationId)	
	local dataT = {}
	local userInfo = g_game.g_userInfoManager:getUserInfo()
	local dataT = {}
	dataT["roleId"] = userInfo["roleId"]
	dataT["transactionID"] = transcationId
	dataT["receipt"] = "none"
	dataT["productId"] = "none"
	dataT["flag"] = 1
	g_game.g_netManager:send_message(g_network_message_type.CS_TRANSACTION, dataT)
end

-------------------------------------------------
-- @function [parent=#f_android_tw_mycard_sdk] responseBuyResultFromGameServer
-- 从游戏服务器接收购买物品结果
-------------------------------------------------
function f_android_tw_mycard_sdk:responseBuyResultFromGameServer(msg)	
-- 		["result"] Type:BYTE Size:1 是否成功
-- 		["errorCode"] Type:INTEGER Size:4 失败代码
-- 		["userGold"] Type:INTEGER Size:4 用户gold数量
-- 		["transactionID"] Type:STRING Size:8 交易ID
    local xx=msg["result"] 
    printlua("结果！！！！！")
	printlua(xx)
	printlua("结果！！！！！")
	if msg["result"] == 0 then	--   -2 服务器数据库错误  －1 正在验证   0 成功  1  未验证  2  失败
		g_game.g_userInfoManager:updateUserGold(msg["userGold"])
		
		local transactionId = msg["transactionID"]
		g_game.g_dataManager:removePaymentTransaction(transactionId)
		
		send_lua_event(g_game.g_f_lua_game_event.F_LUA_UPDATE_SHOP_GOLD)
		send_lua_event_param(g_game.g_f_lua_game_event.F_IAP_BUY_ITEM_RESULT, {["result"] = true, ["productId"] = msg["productId"]})
		
		--sdk事件收集
		local eventData = {}
		eventData["orderId"] = msg["transactionID"]
		send_lua_event_param(g_game.g_f_lua_game_event.F_LUA_DATA_USER_CHARGE_BUYITEM_SUCCESS, eventData)
		
		local chData = {}
		chData["currencyAmount"] = msg["money"]
		chData["currencyType"] = "NT$"
		chData["paymentType"] = "mycard支付"		
		send_lua_event_param(g_game.g_f_lua_game_event.F_LUA_DATA_USER_CHARGE_SUCCESS, chData)	
		
	elseif msg["result"] == 1 then
		send_lua_event_param(g_game.g_f_lua_game_event.F_IAP_BUY_ITEM_RESULT, {["result"] = false, ["productId"] = msg["productId"]})
	elseif msg["result"] == 2 then
		printlua("失败了！！！！！！！！！！！！")
		local transactionId = msg["transactionID"]
		g_game.g_dataManager:removePaymentTransaction(transactionId)
		
		send_lua_event_param(g_game.g_f_lua_game_event.F_IAP_BUY_ITEM_RESULT, {["result"] = false, ["productId"] = msg["productId"]})
	elseif msg["result"] == -2 or msg["result"] == -1 then
		send_lua_event_param(g_game.g_f_lua_game_event.F_IAP_BUY_ITEM_RESULT, {["result"] = false, ["productId"] = msg["productId"]})
	else
		send_lua_event_param(g_game.g_f_lua_game_event.F_IAP_BUY_ITEM_RESULT, {["result"] = false, ["productId"] = msg["productId"]})
	end
	send_lua_event(g_game.g_f_lua_game_event.F_LUA_CLOSE_NETWORK_LOADING)
end

return f_android_tw_mycard_sdk
