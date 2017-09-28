--[[
  登录界面
      2015_12_03 C.P
      功能：登录/注册
--]]
if not yl then
	appdf.req(appdf.CLIENT_SRC.."plaza.models.yl")
end
if not GlobalUserItem then
	appdf.req(appdf.CLIENT_SRC.."plaza.models.GlobalUserItem")
end

local targetPlatform = cc.Application:getInstance():getTargetPlatform()
local privatemgr = ""
if cc.PLATFORM_OS_WINDOWS == targetPlatform then
	privatemgr = "client/src/privatemode/plaza/src/models/PriRoom.lua"
else
	privatemgr = "client/src/privatemode/plaza/src/models/PriRoom.luac"
end
if cc.FileUtils:getInstance():isFileExist(privatemgr) then
	if not PriRoom then
		appdf.req(appdf.CLIENT_SRC.."privatemode.plaza.src.models.PriRoom")
		PriRoom:getInstance()
	end
end

local LogonScene = class("LogonScene", cc.load("mvc").ViewBase)

local PopWait = appdf.req(appdf.BASE_SRC.."app.views.layer.other.PopWait")   --阻止用户输入
local QueryExit = appdf.req(appdf.BASE_SRC.."app.views.layer.other.QueryDialog")

local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame")
local LogonView = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.logon.LogonView")
local RegisterView = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.logon.RegisterView")
local ServiceLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.other.ServiceLayer")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
appdf.req(appdf.CLIENT_SRC.."plaza.models.FriendMgr")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

LogonScene.BT_EXIT 			= 1
LogonScene.DG_QUERYEXIT 	= 2

--全局处理lua错误
cc.exports.g_LuaErrorHandle = function ()
	cc.exports.bHandlePopErrorMsg = true
	if isDebug() then
		print("debug return")
		return true
	else
		print("release return")
		return false
	end
end

--加载配置
function LogonScene.onceExcute()
	local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
	--文件日志
	LogAsset:getInstance():init(MultiPlatform:getInstance():getExtralDocPath(), true, true)
	
	--配置微信                                   配置种类               配置列表
	MultiPlatform:getInstance():thirdPartyConfig(yl.ThirdParty.WECHAT, yl.WeChat)
	--配置支付宝
	MultiPlatform:getInstance():thirdPartyConfig(yl.ThirdParty.ALIPAY, yl.AliPay)
	--配置竣付通
	MultiPlatform:getInstance():thirdPartyConfig(yl.ThirdParty.JFT, yl.JFT)
	--配置分享
	MultiPlatform:getInstance():configSocial(yl.SocialShare)
	--配置高德
	MultiPlatform:getInstance():thirdPartyConfig(yl.ThirdParty.AMAP, yl.AMAP)
end

--只执行一次
LogonScene.onceExcute()

local FIRST_LOGIN = true
-- 进入场景而且过渡动画结束时候触发。
function LogonScene:onEnterTransitionFinish()
	if nil ~= self._logonView then
		self._logonView:onReLoadUser()
	end
	-- 默认登陆游戏信息
	if #self:getApp()._gameList > 0 then
		local info = self:getApp()._gameList[1]
		GlobalUserItem.nCurGameKind = tonumber(info._KindID)
	end
	
    --自动登录功能去掉，必须用户自己选择一个登录方式
	if FIRST_LOGIN then
		FIRST_LOGIN = false

		if GlobalUserItem.bAutoLogon then
			GlobalUserItem.bVisitor = false
			--self:onLogon(GlobalUserItem.szAccount,GlobalUserItem.szPassword,true,true)
		end
		GlobalUserItem.m_tabOriginGameList = self:getApp()._gameList
	end
    return self
end
-- 退出场景而且开始过渡动画时候触发。
function LogonScene:onExitTransitionStart()
	self._backLayer:unregisterScriptKeypadHandler()
	self._backLayer:setKeyboardEnabled(false)
    return self
end

-- 初始化界面
function LogonScene:onCreate()
	print("LogonScene:onCreate")
	local this = self
    this.nnum=0

    --功能控制版本号
 	local controlVersion = this:getApp():getVersionMgr():getControlVersion()
 	GlobalUserItem._controlVersion = controlVersion


	--added by cgp for send the machineId:  http://114.55.232.112/WS/IpAddrMgr.ashx?action=setip&mac=abc
	local machineId = MultiPlatform:getInstance():getMachineId()  --机器码
	local params1 = "action=setip&mac="  .. machineId
	print("params1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ", params1)
    appdf.onHttpJsionTable(yl.HTTP_URL .. "/WS/IpAddrMgr.ashx","get", params1, nil)



	self:registerScriptHandler(function(eventType)
		if eventType == "enterTransitionFinish" then	-- 进入场景而且过渡动画结束时候触发。
			this:onEnterTransitionFinish()
		elseif eventType == "exitTransitionStart" then	-- 退出场景而且开始过渡动画时候触发。
			this:onExitTransitionStart()
		elseif eventType == "exit" then
			if self._logonFrame:isSocketServer() then
				self._logonFrame:onCloseSocket()
			end
		end
	end)

	--按钮回调通用
	local  btcallback = function(ref, type)
        if type == ccui.TouchEventType.ended then
         	this:onButtonClickedEvent(ref:getTag(),ref)
        end
    end

    local logonCallBack = function (result,message)
		this:onLogonCallBack(result,message)
	end

	self._channelId =  tonumber(self:getApp():getVersionMgr():getChannelId() )   --渠道号
	self._logonFrame = LogonFrame:create(self,logonCallBack, self._channelId)
	
	
	self._backLayer = display.newLayer()        --大的返回监听层，其他层加在这个层上
		:addTo(self)
	
	--返回键事件
	self._backLayer:registerScriptKeypadHandler(function(event)
		if event == "backClicked" then
			if this._popWait == nit then
				this:onButtonClickedEvent(LogonScene.BT_EXIT)
			end
		end
	end)


	self._backLayer:setKeyboardEnabled(false)
	--self._backLayer:setKeyboardEnabled(true)

	self._topLayer = display.newLayer()    --最上层的显示提示的层
		:addTo(self)

	--背景
    display.newSprite("background_1.png")    --base/res   only base is add to searcher path
        :move(yl.WIDTH/2,yl.HEIGHT/2)
        :addTo(self._backLayer)
 
	--平台logo    556Fun
	display.newSprite("Logon/logon_logo.png")
		:move(yl.WIDTH/2,yl.HEIGHT - 150 - 120)
		:addTo(self._backLayer)

--	--返回按钮，  苹果没有
--	if  device.platform ~= "mac" and device.platform ~= "ios" then
--		ccui.Button:create("bt_return_0.png","bt_return_1.png")
--			:move(75,yl.HEIGHT-51)
--			:setTag(LogonScene.BT_EXIT)
--			:addTo(self._backLayer)
--			:addTouchEventListener(btcallback)
--	end

	--右下角绿色提示
	self._txtTips = cc.Label:createWithTTF("同步服务器信息中...", "fonts/round_body.ttf", 24)
		:setTextColor(cc.c4b(0,250,0,255))
		:setAnchorPoint(cc.p(1,0))
		:setVisible(false)
		:enableOutline(cc.c4b(0,0,0,255), 1)
		:move(yl.WIDTH,0)
		:addTo(self._topLayer)

	--读取配置
	GlobalUserItem.LoadData()

	--背景音乐
	ExternalFun.playPlazzBackgroudAudio()

	-- 激活房卡
	--在后台网站系统， 站点配置， 移动版大厅配置， 第5个字段进行配置，，为1不开启房卡模式。
	GlobalUserItem.bEnableRoomCard = (self:getApp()._serverConfig["isOpenCard"] == 0)   

	GlobalUserItem.bBank =  (self:getApp()._serverConfig["isBank"] == 0)   --是否开启银行功能， bBank : true 开启
	GlobalUserItem.bTransfer =  (self:getApp()._serverConfig["isTransfer"] == 0)    --是否开启转账功能  bTransfer :true 开启
	
	--创建登录界面
	self._logonView = LogonView:create(self:getApp()._serverConfig)      --http请求返回的一堆
		:move(0,0)
		:addTo(self._backLayer)
	self._logonView:showVersion()
end

--按钮事件
function LogonScene:onButtonClickedEvent(tag,ref)
	--退出按钮
	ExternalFun.playClickEffect()
	if tag == LogonScene.BT_EXIT then
			local a =  Integer64.new()

		print(a:getstring())
	
		if self:getChildByTag(LogonScene.DG_QUERYEXIT) then
			return
		end
		QueryExit:create("确认退出APP吗？",function(ok)
				if ok == true then
					os.exit(0)
				end
			end)
			:setTag(LogonScene.DG_QUERYEXIT)
			:addTo(self)
		
	end
end

--显示登录 bCheckAutoLogon-是否自动登录
function LogonScene:onShowLogon(bCheckAutoLogon)
	local this = self
 
    if self._registerView ~= nil then
    	self._registerView:removeFromParent()
        self._registerView=nil
    end 
	if nil == self._logonView then
		self._logonView = LogonView:create()
			:move(0,0)
			:addTo(self._backLayer)
	end

	--自动登录判断
	bCheckAutoLogon = false
	if not bCheckAutoLogon then    --默认用户名和密码
		self._logonView:runAction(
			cc.Sequence:create(
			cc.MoveTo:create(0.3,cc.p(0,0)),
			cc.CallFunc:create(function()
					this._logonView:onReLoadUser()
					end
			)))
	else
		self._logonView:runAction(
			cc.Sequence:create(
				cc.MoveTo:create(0.3,cc.p(0,0)),
				cc.CallFunc:create(function()
										this._logonView:onReLoadUser()
										local szAccount = GlobalUserItem.szAccount
										local szPassword = GlobalUserItem.szPassword
										this:onLogon(szAccount,szPassword,true,true) 
								end)
		))
			
	end
end

--显示注册界面
function LogonScene:onShowRegister()
	--取消登录界面
--	if self._logonView ~= nil then
--		self._logonView:runAction(cc.MoveTo:create(0.3,cc.p(yl.WIDTH,0)))
--	end



--	--创建注册界面
--	if self._registerView == nil then
--		self._registerView = RegisterView:create()
--			:move(-yl.WIDTH,0)
--			:addTo(self._backLayer)
--	else
--		self._registerView:stopAllActions()
--	end
--	self._registerView:runAction(cc.MoveTo:create(0.3,cc.p(0,0)))

 
	if self._serviceView ~= nil then
		self._serviceView:removeFromParent()
        self._serviceView=nil
	end

    if self._registerView == nil then
	    self._registerView = RegisterView:create(self)
        :move(0,0)
		:addTo(self._backLayer)
    end
    self._registerView :setVisible(true)
end

--显示用户条款界面
function LogonScene:onShowService()
	--取消注册界面
--	if self._registerView ~= nil then
--		self._registerView:runAction(cc.MoveTo:create(0.3,cc.p(yl.WIDTH,0)))
--	end

--	if self._serviceView == nil then
--		self._serviceView = ServiceLayer:create()
--			:move(yl.WIDTH,0)
--			:addTo(self._backLayer)
--	else
--		self._serviceView:stopAllActions()
--	end
--	self._serviceView:runAction(cc.MoveTo:create(0.3,cc.p(0,0)))

--	if self._registerView ~= nil then
--		self._registerView:runAction(cc.MoveTo:create(0.3,cc.p(yl.WIDTH,0)))
--	end
--	if self._registerView ~= nil then
--	    self._registerView:removeFromParent()
--        self._registerView=nil
--	end
	if self._serviceView == nil then
		self._serviceView = ServiceLayer:create()
			:move(0,0)
			:addTo(self._backLayer)
	end
end

--登录大厅
function LogonScene:onLogon(szAccount,szPassword,bSave,bAuto)
	--输入检测
	if szAccount == nil or szPassword == nil or bSave == nil or bAuto == nil then
		return
	end
	local len = ExternalFun.stringLen(szAccount)--#szAccount
	if len < 6 or len > 31 then
		showToast(self,"游戏帐号必须为6~31个字符，请重新输入!",2,cc.c4b(250,0,0,255));
		return
	end

	len = ExternalFun.stringLen(szPassword)--#szPassword
	if len<6 then
		showToast(self,"密码必须大于6个字符，请重新输入！",2,cc.c4b(250,0,0,255));
		return
	end

	--参数记录
	self._szAccount = szAccount
	self._szPassword = szPassword
	self._bAuto = bAuto
	self._bSave = bSave

	--调用登录
	self:showPopWait()
	self._Operate = 0
	self._logonFrame:onLogonByAccount(szAccount,szPassword)
end

--游客登录
function LogonScene:onVisitor()
	--调用登录
	self:showPopWait()
	self._Operate = 2
	self._logonFrame:onLogonByVisitor()
end

--微信登陆
function LogonScene:thirdPartyLogin(plat)   
	self._tThirdData = {}
	self:showPopWait()
	self:runAction(cc.Sequence:create(cc.DelayTime:create(5), cc.CallFunc:create(function()
			self:dismissPopWait()
		end)))
	
	--微信授权回调函数定义
	local function loginCallBack ( param )    
		self:dismissPopWait()
		if type(param) == "string" and string.len(param) > 0 then
			local ok, datatable = pcall(function()
					return cjson.decode(param)
			end)
			if ok and type(datatable) == "table" then
				dump(datatable, "微信数据", 5)
				
				local account = datatable["unionid"] or ""
				local nick = datatable["screen_name"] or ""
				self._szHeadUrl = datatable["profile_image_url"] or ""
				local gender = datatable["gender"] or "0"
				gender = tonumber(gender)
				self:showPopWait()
				self._Operate = 3
				self._tThirdData = 
				{
					szAccount = account,
					szNick = nick,
					cbGender = gender,
					platform = yl.PLATFORM_LIST[plat],
				}

			  --added by cgp   保存微信授权的信息
				cc.UserDefault:getInstance():setBoolForKey("weChatSaved",true)
				cc.UserDefault:getInstance():setStringForKey("weChatAccount", account)
				cc.UserDefault:getInstance():setStringForKey("weChatNick", nick)
				cc.UserDefault:getInstance():setStringForKey("weChatHeadUrl", self._szHeadUrl)
				cc.UserDefault:getInstance():setIntegerForKey("weChatGender", gender)
				cc.UserDefault:getInstance():flush()

				--plat 0:yl.ThirdParty.WECHAT    yl.PLATFORM_LIST[plat] = 5
				self._logonFrame:onLoginByThirdParty(account, nick, gender, yl.PLATFORM_LIST[plat])
			end
		end
	end





	--微信已登录过（账号保存过）  
	local weChatSaved = cc.UserDefault:getInstance():getBoolForKey("weChatSaved",false)

	if weChatSaved == false then   --第一次微信登录或切换账号，微信登录时，授权登录。
		MultiPlatform:getInstance():thirdPartyLogin(plat, loginCallBack)
	
	else   --已经有微信授权资料时，直接登录
		local account = cc.UserDefault:getInstance():getStringForKey("weChatAccount", "nil")
		local nick = cc.UserDefault:getInstance():getStringForKey("weChatNick", "nil")
		self._szHeadUrl = cc.UserDefault:getInstance():getStringForKey("weChatHeadUrl", "nil")
		local gender = cc.UserDefault:getInstance():getIntegerForKey("weChatGender", 1)

		self._Operate = 3
		self._tThirdData = 
		{
			szAccount = account,
			szNick = nick,
			cbGender = gender,
			platform = yl.PLATFORM_LIST[plat],
		}


		if "nil" ~= account then
    		self._logonFrame:onLoginByThirdParty(account, nick, gender, yl.PLATFORM_LIST[plat])
    	else
    		print("wechat account == nil !")
    	end
	end
end

--注册账号
function LogonScene:onRegister(szAccount,szPassword,bAgreement,szSpreader,szCORD)
	--输入检测
	if szAccount == nil or szPassword == nil or szCORD == nil then
		return
	end	

	if bAgreement == false then
		showToast(self,"请先阅读并同意《游戏中心服务条款》！",2,cc.c4b(250,0,0,255));
		return
	end
	local len = ExternalFun.stringLen(szAccount)--#szAccount
	if len < 6 or len > 31 then
		showToast(self,"游戏帐号必须为手机号，请重新输入！",2,cc.c4b(250,0,0,255));
		return
	end

	--判断emoji
    if ExternalFun.isContainEmoji(szAccount) then
        showToast(self, "帐号包含非法字符,请重试", 2)
        return
    end

	--判断是否有非法字符
	if true == ExternalFun.isContainBadWords(szAccount) then
		showToast(self, "帐号中包含敏感字符,不能注册", 2)
		return
	end

	len = ExternalFun.stringLen(szPassword)
	if len < 6 or len > 26 then
		showToast(self,"密码必须为6~26个字符，请重新输入！",2,cc.c4b(250,0,0,255));
		return
	end	
            

	-- 与帐号不同
	if string.lower(szPassword) == string.lower(szAccount) then
		showToast(self,"密码不能与帐号相同，请重新输入！",2,cc.c4b(250,0,0,255));
		return
	end

	--[[-- 首位为字母
	if 1 ~= string.find(szPassword, "%a") then
		showToast(self,"密码首位必须为字母，请重新输入！",2,cc.c4b(250,0,0,255));
		return
	end]]

	--参数记录
	self._szAccount = szAccount
	self._szPassword = szPassword
	self._bAuto = true
	self._bSave = true
	self._gender = math.random(1)
	--调用注册
	self:showPopWait()
	self._Operate = 1
	self._logonFrame:onRegister(szAccount,szPassword, self._gender,szSpreader,szCORD)
end

--登录注册回调 （登录服务器成功后，关闭socket，再用http请求个人信息）
function LogonScene:onLogonCallBack(result,message)
	print("onLogonCallBack result, message  ", result,  message)
	if result == 1 then --1：成功；  从onRoomListEvent中调用来
		--本地保存
		if self._Operate == 2 then 					--游客登录
			GlobalUserItem.bAutoLogon = false
			GlobalUserItem.bSavePassword = false
			GlobalUserItem.szPassword = "668pwd.668yx.com"
			--GlobalUserItem.szAccount = GlobalUserItem.szNickName
		elseif self._Operate == 3 then 				--微信登陆
			
			GlobalUserItem.szThirdPartyUrl = self._szHeadUrl
			GlobalUserItem.szPassword = "668pwd.668yx.com"
			GlobalUserItem.bThirdPartyLogin = true
			GlobalUserItem.thirdPartyData = self._tThirdData
			--GlobalUserItem.szAccount = GlobalUserItem.szNickName
		
		else        --账号登录
			GlobalUserItem.bAutoLogon = self._bAuto         --自动登录（界面去掉了）
			GlobalUserItem.bSavePassword = self._bSave      --记住密码
			GlobalUserItem.onSaveAccountConfig()
		end


		if yl.HTTP_SUPPORT then
			local ostime = os.time()
			appdf.onHttpJsionTable(yl.HTTP_URL .. "/WS/MobileInterface.ashx","GET","action=GetMobileShareConfig&userid=" .. GlobalUserItem.dwUserID .. "&time=".. ostime .. "&signature=".. GlobalUserItem:getSignature(ostime),function(jstable,jsdata)
				--LogAsset:getInstance():logData("action=GetMobileShareConfig&userid=" .. GlobalUserItem.dwUserID .. "&time=".. ostime .. "&signature=".. GlobalUserItem:getSignature(ostime))
				dump(jstable, "GetMobileShareConfig", 6)
				local msg = nil
				if type(jstable) == "table" then
					local data = jstable["data"]
					msg = jstable["msg"]
					if type(data) == "table" then
						local valid = data["valid"]
						if valid then
							local count = data["FreeCount"] or 0
							GlobalUserItem.nTableFreeCount = tonumber(count)
							local sharesend = data["SharePresent"] or 0
							GlobalUserItem.nShareSend = tonumber(sharesend)

							--推广链接
							GlobalUserItem.szSpreaderURL = data["SpreaderUrl"]
							if nil == GlobalUserItem.szSpreaderURL or "" == GlobalUserItem.szSpreaderURL then
								GlobalUserItem.szSpreaderURL = yl.HTTP_URL ..  "/Mobile/Register.aspx"
							else
								GlobalUserItem.szSpreaderURL = string.gsub(GlobalUserItem.szSpreaderURL, " ", "")
							end
							-- 微信平台推广链接
							GlobalUserItem.szWXSpreaderURL = data["WxSpreaderUrl"]
							if nil == GlobalUserItem.szWXSpreaderURL or "" == GlobalUserItem.szWXSpreaderURL then
								GlobalUserItem.szWXSpreaderURL = yl.HTTP_URL ..  "/Mobile/Register.aspx"
							else
								GlobalUserItem.szWXSpreaderURL = string.gsub(GlobalUserItem.szWXSpreaderURL, " ", "")
							end

							
							if table.nums(self._logonFrame.m_angentServerList) > 0 then   --整理代理游戏列表
								self:arrangeGameList(self._logonFrame.m_angentServerList)
							else
								self:getApp()._gameList = GlobalUserItem.m_tabOriginGameList
							end

							-- 每日必做列表
							GlobalUserItem.tabDayTaskCache = {}
							local dayTask = data["DayTask"]
							if type(dayTask) == "table" then
								for k,v in pairs(dayTask) do
									if tonumber(v) == 0 then
										GlobalUserItem.tabDayTaskCache[k] = 1
										GlobalUserItem.bEnableEveryDay = true
									end
								end
							end
							GlobalUserItem.bEnableCheckIn = (GlobalUserItem.tabDayTaskCache["Field1"] ~= nil)
							GlobalUserItem.bEnableTask = (GlobalUserItem.tabDayTaskCache["Field6"] ~= nil)
							
							-- 邀请送金
							local sendcount = data["RegGold"]
							GlobalUserItem.nInviteSend = tonumber(sendcount) or 0

							--进入游戏列表
							self:getApp():enterSceneEx(appdf.CLIENT_SRC.."plaza.views.ClientScene","FADE",1)
							FriendMgr:getInstance():reSetAndLogin()
							return
						end
					end
				end
				self:dismissPopWait()
				local str = "游戏登陆异常"
				if type(msg) == "string" then
					str = str .. ":" .. msg
				end
				showToast(self, str, 3, cc.c3b(250,0,0))
			end)
		else
			--整理代理游戏列表
			if table.nums(self._logonFrame.m_angentServerList) > 0 then
				self:arrangeGameList(self._logonFrame.m_angentServerList)
			else
				self:getApp()._gameList = GlobalUserItem.m_tabOriginGameList
			end

			--进入游戏列表
			self:getApp():enterSceneEx(appdf.CLIENT_SRC.."plaza.views.ClientScene","FADE",1)
			--FriendMgr:getInstance():reSetAndLogin()
		end		
	elseif result == -1 then --失败
		self:dismissPopWait()
		if type(message) == "string" and message ~= "" then
			showToast(self._topLayer,message,2,cc.c4b(250,0,0,255));
		end
    elseif result == -2 then --验证码提示
	   
	    if type(message) == "string" and message ~= "" then
		    showToast(self._topLayer,message,2,cc.c4b(125,0,0,255));
    	end
	elseif result == 10 then --重复绑定
		showToast(self._topLayer, message, 2, cc.c4b(250,0,0,255));

		--关闭游客登录socket
		if self._logonFrame:isSocketServer() then
			self._logonFrame:onCloseSocket()
		end
		if self._logonView ~= nil and nil ~= self._logonView.refreshBtnList then
			self._logonView:refreshBtnList()
			self:dismissPopWait()
		end
	end
end

--显示等待
function LogonScene:showPopWait()
	if not self._popWait  then
		self._popWait = PopWait:create()
			:show(self._topLayer,"请稍候！")    --whichLayer, txt
	end
end

--关闭等待
function LogonScene:dismissPopWait()
	if self._popWait ~= nil then
		self._popWait:dismiss()
		self._popWait = nil
	end
end

--整理游戏列表
--[[
serverList = 
{
	KindID = {KindID, SortID},
	KindID2 = {KindID2, SortID},
}
]]
function LogonScene:arrangeGameList(serverList)	
	local originList = GlobalUserItem.m_tabOriginGameList
	local newList = {}
	for k,v in pairs(originList) do
		local serverGame = serverList[tonumber(v._KindID)]
		if nil ~= serverGame then
			v._SortId = serverGame.SortID
			table.insert(newList, v)
		end
	end
	table.sort(newList,	function(a, b)
		return a._SortId > b._SortId
	end)
	self:getApp()._gameList = newList
end

function LogonScene:startDjs()
     --发送验证码请求

    local this = self
    this.nnum = yl.YZM

    this._registerView.btYzm:setVisible (false)
    this._registerView.ttfdjs:setVisible (true)
    this._registerView.ttfdjs:setString ("倒计时 :" .. tostring (this.nnum+1) .. " 秒")
    local fundjs = function ()
        if this._registerView and this._registerView.ttfdjs then
            this._registerView.ttfdjs:setString ("倒计时 :" .. tostring (this.nnum) .. " 秒")
        end 

        if  this.nnum <= 0 and this.djs then
                this:getActionManager ():removeAction (this.djs)
                this.djs = nil
               
                if this._registerView   then
                    this._registerView.btYzm:setVisible(true)
                    this._registerView.ttfdjs:setVisible(false)
                end
                return 
                print ("vvvvvvvvvvv")
        end
        this.nnum = this.nnum - 1

    end
    this.djs = schedule (this, fundjs, 1)
end


--注册账号
function LogonScene:onCORD(szAccount)
	--输入检测
	if szAccount == nil or szAccount == ""  then
		return
	end	
    local filter = ExternalFun.CheckIsMobile (szAccount)
        if false == filter then
            showToast (self, "手机号格式错误, 请重试!", 1)
        return
    end     
	self._logonFrame:onCORD(szAccount)

    self:startDjs()

end





return LogonScene