--[[--
    小米 android sdk
--]]--
local f_android_mi_sdk = class("f_android_mi_sdk", function()
    return fc.FSdkManager:getInstance()
end)


function f_android_mi_sdk:ctor()
	self.json   = require("prescripts.framework.json")
	self.m_vertifiy_server = {["ip"] = "118.192.76.178",  ["port"] = 20003}
	
	self.event_init = function()
		self:init_sdk()
	end
	g_game.g_eventManager:registerLuaEvent(g_game.g_f_lua_game_event.F_LUA_SDK_INIT, self.event_init)
	
	self.event_showLogin = function()
		self:show_sdk_view()
	end
	g_game.g_eventManager:registerLuaEvent(g_game.g_f_lua_game_event.F_LUA_SDK_SHOW_LOGIN, self.event_showLogin)
	
	self.event_changeUser = function()
		self:change_sdk_user()
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
	
	
	self.event_iap_buy = function(data)
		self:iapBuyItem(data)
	end
	g_game.g_eventManager:registerLuaEvent(g_game.g_f_lua_game_event.F_IAP_BUY_ITEM, self.event_iap_buy)
	
	
	self.event_check_native_pay = function()
		self:checkNativePayment()
	end
	g_game.g_eventManager:registerLuaEvent(g_game.g_f_lua_game_event.F_IAP_CHECK_NATIVE_PAY, self.event_check_native_pay)
	
	-- 小米固定入口
	self.event_openUserCenter = function()
		g_game.g_luaj.callStaticMethod("org/cocos2dx/lua/AppActivity", "showGameCenter", {}, "()V")
	end
	g_game.g_eventManager:registerLuaEvent(g_game.g_f_lua_game_event.F_LUA_SDK_PP_OPEN_USER_CENTER, self.event_openUserCenter)
	g_game.g_f_sdk_layout_define["isShowPPUser_center"] = true
	
	self.m_quit_game_panel = nil
	local backKeyCallback = function()
		if self.m_quit_game_panel == nil then
			self.m_quit_game_panel = require("prescripts.common.f_quit_game_panel").new()
			self.m_quit_game_panel:setShowText("退出游戏")
			self.m_quit_game_panel:createCommonTips()
		else
			self.m_quit_game_panel:hide()
			self.m_quit_game_panel = nil
		end
	end
	g_game.g_luaj.callStaticMethod("org/cocos2dx/lua/AppActivity", "setBackKeyHandler", {backKeyCallback}, "(I)V")
end

-------------------------------------------------------------------------------
-- @function [parent=#f_android_mi_sdk] init_sdk
-- 初始化sdk
-------------------------------------------------------------------------------
function f_android_mi_sdk:init_sdk()
	self:setXMVertifiyServer_android(self.m_vertifiy_server["ip"], self.m_vertifiy_server["port"])
	
	local vertifiyUserInfoCallback = function(type)
		local loginResult = {}
		if type >= 0 then
			loginResult["result"] = 0
			loginResult["account"] = self.m_user_info["userId"]
			loginResult["userid"] = self.m_user_info["userId"]
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
	self:setLoginXMSdkListener_android(vertifiyUserInfoCallback)
end


-------------------------------------------------------------------------------
-- @function [parent=#f_android_mi_sdk] show_sdk_view
-- 显示sdk界面
-------------------------------------------------------------------------------
function f_android_mi_sdk:show_sdk_view()	
	send_lua_event(g_game.g_f_lua_game_event.F_LUA_NETWORK_LOADING)
	
	local loginCallback = function(authCode)
		local resultInfo = self.json.decode(authCode)	
		self.m_user_info["session"] = resultInfo["session"]
		self.m_user_info["userId"] = resultInfo["userId"]
		self.m_user_info["userName"] = resultInfo["userName"]
		
		self:vertifiyXMSession_android(self.m_user_info["session"], self.m_user_info["userId"])
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
	g_game.g_luaj.callStaticMethod("org/cocos2dx/lua/AppActivity", "show_login", args, "(II)V")
end

-------------------------------------------------------------------------------
-- @function [parent=#f_android_mi_sdk] change_sdk_user
-- 更改sdk用户
-------------------------------------------------------------------------------
function f_android_mi_sdk:change_sdk_user()	
	send_lua_event(g_game.g_f_lua_game_event.F_LUA_NETWORK_LOADING)
	
	local loginCallback = function(authCode)	
		local resultInfo = self.json.decode(authCode)	
		self.m_user_info["session"] = resultInfo["session"]
		self.m_user_info["userId"] = resultInfo["userId"]
		self.m_user_info["userName"] = resultInfo["userName"]
		
		self:vertifiyXMSession_android(self.m_user_info["session"], self.m_user_info["userId"])
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
-- @function [parent=#f_android_mi_sdk] loadProductsFromServer
-- 使用产品key列表，刷新商店界面
-------------------------------------------------
function f_android_mi_sdk:loadProductsFromServer(itemList)	
	self.m_products_id_list = itemList
		
	
	self:iapRequestProductsListener(self.m_products_id_list)
end


-------------------------------------------------
-- @function [parent=#f_android_mi_sdk] iapRequestProductsListener
-- 模拟苹果服务器返回列表
-------------------------------------------------
function f_android_mi_sdk:iapRequestProductsListener(data)	
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
-- @function [parent=#f_android_mi_sdk] checkNativePayment
-- 检查本地存储得收据凭证并进行继续验证
-------------------------------------------------
function f_android_mi_sdk:checkNativePayment()	
	local transactionList = g_game.g_dataManager:getPaymentTransaction()
	if transactionList then		
		for i,v in ipairs(transactionList) do
			--进入购买流程，需要loading显示阻挡用户进行其他操作
			self:requestTransitionVertifyFromGameServer(v["transactionIdentifier"])
		end
	end
end


-------------------------------------------------
-- @function [parent=#f_android_mi_sdk] iapBuyItem
-- 请求购买物品的订单id
-------------------------------------------------
function f_android_mi_sdk:iapBuyItem(data)	
	self.m_current_buy_item_data = data
	
	self:requestTransitionInfoFromGameServer()
end

-------------------------------------------------
-- @function [parent=#f_android_mi_sdk] buyResultFromXMServer
-- 接收小米服务器返回的购买结果
-------------------------------------------------
function f_android_mi_sdk:buyResultFromXMServer(result)	

	local resultInfo = self.json.decode(result)	
	local type = resultInfo["result"]
		
	if type < 0 then	
		if self.m_current_save_trascation then			
			g_game.g_dataManager:removePaymentTransaction(self.m_current_save_trascation)
			self.m_current_save_trascation = nil
		end		
	end
	if type == -1 or type == -2 then
		send_lua_event(g_game.g_f_lua_game_event.F_LUA_CLOSE_NETWORK_LOADING)
	end
end

-------------------------------------------------
-- @function [parent=#f_android_mi_sdk] responseTranscationInfoFromGameServer
-- 接收游戏服务器返回的订单号等信息
-------------------------------------------------
function f_android_mi_sdk:responseTranscationInfoFromGameServer(msg)	
	if msg["result"] == 0 then		
		local buyDoneCallback = function(type)
			self:buyResultFromXMServer(type)
		end
		
		local userInfo = g_game.g_userInfoManager:getUserInfo()
		--buy item from 360 sdk here
		local buyItemJson = {}
		buyItemJson["itemPrice"] = self.m_current_buy_item_data["info"]["price"]
		buyItemJson["orderId"] = msg["transactionId"]		
		buyItemJson["userYuanbao"] = tostring(userInfo["gold"])
		buyItemJson["userVip"] = tostring(userInfo["vipLevel"])
		buyItemJson["userLevel"] = tostring(userInfo["level"])
		buyItemJson["userName"] = g_game.g_userInfoManager:getUserName()
		buyItemJson["roleId"] = tostring(userInfo["roleId"])
		buyItemJson["serverName"] = "一服"
		local args = 
		{
			self.json.encode(buyItemJson),
			buyDoneCallback
		}
		g_game.g_luaj.callStaticMethod("org/cocos2dx/lua/AppActivity", "buyItemWithInfo", args, "(Ljava/lang/String;I)V")
			
		self.m_current_save_trascation = msg["transactionId"]
		local transcationInfo = {}
		transcationInfo["transactionIdentifier"] = msg["transactionId"]
		transcationInfo["receipt"] = "none"		
		g_game.g_dataManager:savePaymentTransaction(transcationInfo)
		
		--sdk事件收集
		local eventData = {}
		eventData["orderId"] = msg["transactionId"]
		eventData["iapId"] = self.m_current_buy_item_data["info"]["itemKey"]
		eventData["amount"] = self.m_current_buy_item_data["info"]["price"]
		eventData["currencyType"] = "CNY"
		eventData["paymentType"] = "91支付"
		send_lua_event_param(g_game.g_f_lua_game_event.F_LUA_DATA_USER_CHARGE_START, eventData)
	else
		if self.m_current_buy_item_data["info"]["id"] == g_game.g_f_month_card_info["info"]["id"] then
			g_game.g_utilManager:showMsg("购买月卡失败，请重新购买!")
		else
			g_game.g_utilManager:showMsg("购买元宝失败，请重新购买!")
		end
		send_lua_event_param(g_game.g_f_lua_game_event.F_IAP_BUY_ITEM_RESULT, {["result"] = false, ["productId"] = self.m_current_buy_item_data["info"]["id"]})	
		self.m_current_buy_item_data = nil
	end
end

-------------------------------------------------
-- @function [parent=#f_android_mi_sdk] requestTransitionInfoFromGameServer
-- 向服务器发送购买请求，并获取订单id
-------------------------------------------------
function f_android_mi_sdk:requestTransitionInfoFromGameServer()		
	local dataT = {}
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
-- @function [parent=#f_android_mi_sdk] requestTransitionVertifyFromGameServer
-- 使用本地缓存的未完成订单，向服务器再次验证
-------------------------------------------------
function f_android_mi_sdk:requestTransitionVertifyFromGameServer(transcationId)
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
-- @function [parent=#f_android_mi_sdk] responseBuyResultFromGameServer
-- 从游戏服务器接收购买物品结果
-------------------------------------------------
function f_android_mi_sdk:responseBuyResultFromGameServer(msg)	
-- 		["result"] Type:BYTE Size:1 是否成功
-- 		["errorCode"] Type:INTEGER Size:4 失败代码
-- 		["userGold"] Type:INTEGER Size:4 用户gold数量
-- 		["transactionID"] Type:STRING Size:8 交易ID

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
		chData["currencyType"] = "CNY"
		chData["paymentType"] = "小米支付"		
		send_lua_event_param(g_game.g_f_lua_game_event.F_LUA_DATA_USER_CHARGE_SUCCESS, chData)	
		
	elseif msg["result"] == 1 then
		send_lua_event_param(g_game.g_f_lua_game_event.F_IAP_BUY_ITEM_RESULT, {["result"] = false, ["productId"] = msg["productId"]})
	elseif msg["result"] == 2 then
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

return f_android_mi_sdk