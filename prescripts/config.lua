APP_VERSION = 110
RESOURCE_VERSION = 104
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 0
DEBUG_FPS = true
DEBUG_USE_NATIVE_SERVER = false	--是否使用本地服务器
DEBUG_USE_DEFAULT_USER = false	--是否使用默认帐户
DEBUG_USE_US_SERVER = false	--是否使用正式服务器
DEBUG_ENABLE_SOUND = true	--是否开启音乐
DEBUG_ENABLE_GUIDELINES = true	--是否开启新手指引
DEBUG_DEVICE_IOS_JAILBREAKING = false	--是否ios越狱版本
DEBUG_ENABLE_DYN_UPDATE = true	--是否开启动态资源更新


---------------------------------------------
DEBUG_SDK_TYPE=50
DEBUG_IS_FULL_PACK= false	--是否为全包(只有google支付版本使用)
---------------------------------------------
--sdk
---------------------------------------------
--0 don't use dk  

---------------------------------------------
--ios sdk
---------------------------------------------
--1 cmge sdk ios
--2 cmge越狱sdk ios
--3 91 sdk ios
--4 cmge web sdk ios
--5 cmge wap sdk ios
--6 pp助手sdk ios
--7 itools sdk ios
--8 ky sdk ios
--9 同步推 sdk ios
--10 为正版
--11 艾斯
--12 海马 cmge
--13 xy sdk ios

---------------------------------------------
--ios 台湾
---------------------------------------------
--14 台湾正版

---------------------------------------------
--android sdk
---------------------------------------------
--20 cmge sdk android
--21 360 sdk
--22 91 sdk
--23 豌豆夹
--24 多酷
--25 小米
--26 UC
--27 安智
--28 联想
--29 oppo
--30 当乐
--31 VIVO
--32 华为
--33 优酷
--34 应用汇
--35 魅族
--36 酷派
--37 PPS
--38 taiwan google
--39 taiwan mycard

-- design resolution
CONFIG_SCREEN_WIDTH  = 960
CONFIG_SCREEN_HEIGHT = 640

LANGUAGE_TYPE = 3
-- 起始从 2开始
-- 2简体中文
-- 3繁体

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_HEIGHT"

--10.50.2.252 9900
g_server_list_request_url = 
{
	{"http://whwsgm.cmge.com/app_update/server_list/ios.json", "/app_update/server_list/ios.json"},--苹果appstore 版本服务器列表
	{"http://whwsgm.cmge.com/app_update/server_list/server_list.json", "/app_update/server_list/server_list.json"},--ios越狱和android版本服务器列表
	{"http://whwsgm.cmge.com/app_update/server_list/inner_server_list.json", "/app_update/server_list/inner_server_list.json"},--内部测试服务器列表
	--台湾正式服务器列表
	{"http://54.169.3.199/app_update/server_list/server_list.json", "/app_update/server_list/server_list.json"},
	--台湾测试服务器列表
	{"http://54.255.182.50/app_update/server_list/inner_server_list.json", "/app_update/server_list/inner_server_list.json"},
	--台湾正版 ios 测试
	{"http://54.169.3.199/app_update/server_list/ios.json", "/app_update/server_list/ios.json"},
}

g_version_list_request_url = 
{
	-- 大陆测试
	{"http://whwsgm.cmge.com/app_version/c_", "/app_version/c_"},
	-- 台湾正式
	{"http://54.169.3.199/app_version/c_", "/app_version/c_"},
	-- 台湾测试
	{"http://54.255.182.50/app_version/c_", "/app_version/c_"}
}

g_native_data_file = 
{
	{"data", "baofei"},
	{"pay", "baofei"},
	{"server", "baofei"}
}

g_default_user = 
{
	--"铮哥",
	"xzz03"
	--"xzz901"
}


g_game_time_info = {}
g_game_time_info.ping_time = 5.0 --单位秒
g_game_time_info.disconnect_ping_count = 3 --间隔时间超过60.0秒认为断开服务器