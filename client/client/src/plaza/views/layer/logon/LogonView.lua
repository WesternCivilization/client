local LogonView = class("LogonView",function()
		local logonView =  display.newLayer()

    return logonView
end)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")

--BtnTags
LogonView.BT_LOGON = 1        --登录
LogonView.BT_REGISTER = 2     --账号注册
LogonView.CBT_RECORD = 3     --记住密码(button)
LogonView.CBT_AUTO = 4       
LogonView.BT_VISITOR = 5     --游客
LogonView.BT_WEIBO = 6       --微博
LogonView.BT_QQ	= 7          --QQ
LogonView.BT_THIRDPARTY	= 8    --第三方
LogonView.BT_WECHAT	= 9        --微信
LogonView.BT_FGPW = 10 	-- 忘记密码
LogonView.BT_LOGON2 = 11        --真的登录
LogonView.BT_LOGON2_guanbi = 12   --关闭弹窗
 
function LogonView:ctor(serverConfig)
	local this = self
	self:setContentSize(yl.WIDTH,yl.HEIGHT)
    

    --按钮事件
    local  btcallback = function(ref, type)
        if type == ccui.TouchEventType.ended then
         	this:onButtonClickedEvent(ref:getTag(),ref)
        end
    end

 
-----------------------------------------------------------------------



    --账号登录
    ccui.Button:create("Logon/logon_button_0.png", "Logon/logon_button_1.png", "Logon/logon_button_1.png")
		:setTag(LogonView.BT_LOGON)
		:move(cc.p(0,0))
		:setName("btn_1")
		:addTo(self)
		:addTouchEventListener(btcallback)
 
	--游客登录
	ccui.Button:create("Logon/visitor_button_0.png", "Logon/visitor_button_1.png", "Logon/visitor_button_1.png")
		:setTag(LogonView.BT_VISITOR)
		:move(cc.p(0,0))
		:setEnabled(false)
		:setVisible(false)
		:setName("btn_2")
		:addTo(self)
		:addTouchEventListener(btcallback)

	--微信登陆
	ccui.Button:create("Logon/thrid_part_wx_0.png", "Logon/thrid_part_wx_1.png", "Logon/thrid_part_wx_1.png")
		:setTag(LogonView.BT_WECHAT)
		:move(cc.p(0,0))
		:setVisible(false)
		:setEnabled(false)
		:setName("btn_3")
		:addTo(self)
		:addTouchEventListener(btcallback)

-------------------------------------------------------------------------------------


    --健康游戏忠告
    self._healthTips = cc.Label:createWithTTF(
        "抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防受骗上当。适度游戏益脑，沉迷游戏伤身。合理安排时间，享受健康生活。", 
        "fonts/round_body.ttf", 20)
    :enableOutline(cc.c4b(0,0,0,255), 1)
    :move(678, 60)
    :addTo(self)

    --文网文
    self._wenwangwang = cc.Label:createWithTTF(
        "文网文：浙网文[2015]0202-022号     出版物号：ISBN 978-7-7979-3661-3     批准文号：新广出审[2017]76 号", 
        "fonts/round_body.ttf", 20)
    :enableOutline(cc.c4b(0,0,0,255), 1)
    :move(678, 30)
    :addTo(self)

    --版本号
    self._version = cc.Label:createWithTTF(
        "", 
        "fonts/round_body.ttf", 20)
    :enableOutline(cc.c4b(0,0,0,255), 1)
    :move(1250, 730)
    :addTo(self)

    --  local function afterCaptured(succeed, outputFile)
    --     if succeed then
    --         print(".....................ok")     
    --     else
    --         print("..................... oerr")   
    --     end
    -- end
    --    -- performWithDelay
    -- cc.utils:captureScreen(afterCaptured, "logon.png")


    self.m_serverConfig = serverConfig or {}
    self:initLogonKuang()
    self:refreshBtnList()
end

function LogonView:showVersion(  )
    local app = self:getParent():getParent():getApp()
    local resVersion = app:getVersionMgr():getResVersion()
    local strVersion = " " .. appdf.BASE_C_VERSION .. " . " .. resVersion
    self._version:setString(strVersion)
end



function LogonView:initLogonKuang ( )
    local this = self
    --按钮事件
    local  btcallback = function (ref, type)
        if type == ccui.TouchEventType.ended then
            this:onButtonClickedEvent (ref:getTag (), ref)
        end
    end
    --复选框事件
    local cbtlistener = function (sender, eventType)
        this:onSelectedEvent (sender, eventType)
    end

    --输入框事件
    local editHanlder = function (name, sender)
        self:onEditEvent (name, sender)
    end

  
 

    local began=   function    (touch, event)
        return true
    end

    self.bj_login = display.newLayer ()
    :move (0,0)
    :addTo (self)
    :setVisible (false)
    self.bj_login:setContentSize (yl.WIDTH, yl.HEIGHT)
    self.bj_login.onTouchBegan=began 
    ExternalFun.registerTouchEvent (self.bj_login, false)



    --半透明的遮罩层, c4b第四个参数为透明度0-255
    self.maskLayer = cc.LayerColor:create(cc.c4b(0,0, 0, 255 * 0.6), 1334, 750)
    :move(cc.p(0,0))
    :addTo(self.bj_login)


    --登录框
    local sp_bj = display.newSprite ("public/bgMiddle11.png")
    :move (yl.WIDTH / 2, yl.HEIGHT / 2)
    :addTo (self.bj_login)
    self.sp_bj=sp_bj

  
    ccui.Button:create ("public/closeRound.png")
    :setTag (LogonView.BT_LOGON2_guanbi)
    :move (811,460)
    :addTo (sp_bj)
    :addTouchEventListener (btcallback)


    --账号抬头 
    display.newSprite ("Logon/title_zhdl.png")
    :move (441 - 18, 481 + 10)
    :addTo (sp_bj)


    --帐号提示
    display.newSprite ("Logon/account_text.png")
    :move (139,375)
    :addTo (sp_bj)

    display.newSprite ("General/edit_bj.png")
    :move (446,375)
    :addTo (sp_bj)

    --账号输入
    self.edit_Account = ccui.EditBox:create (cc.size (470, 63), "tm.png")
    :move (446+30,375)
    :setPlaceHolder("请输入您的账号")
    :setAnchorPoint (cc.p (0.5, 0.5))
    :setFontName ("fonts/round_body.ttf")
    :setPlaceholderFontName ("fonts/round_body.ttf")
    :setFontSize (24)
    :setPlaceholderFontColor(cc.c3b(127,113,217))
    :setFontColor(cc.c3b(229,225,255))
    :setPlaceholderFontSize (24)
    :setMaxLength (31)
    :setInputMode (cc.EDITBOX_INPUT_MODE_SINGLELINE)
    :addTo (sp_bj)
    self.edit_Account:registerScriptEditBoxHandler (editHanlder)

    --密码提示
    display.newSprite ("Logon/password_text.png")
    :move (139,289)
    :addTo (sp_bj)
    display.newSprite ("General/edit_bj.png")
    :move (446,289)
    :addTo (sp_bj)
    --密码输入	
    self.edit_Password = ccui.EditBox:create (cc.size (470, 63), "tm.png")
    :move (446+30,289)
      :setPlaceHolder("请输入您的密码")
    :setAnchorPoint (cc.p (0.5, 0.5))
    :setFontName ("fonts/round_body.ttf")
    :setPlaceholderFontName ("fonts/round_body.ttf")
    :setFontSize (24)
    :setPlaceholderFontSize (24)
    :setMaxLength (26)
        :setPlaceholderFontColor(cc.c3b(127,113,217))
    :setFontColor(cc.c3b(229,225,255))
    :setInputFlag (cc.EDITBOX_INPUT_FLAG_PASSWORD)
    :setInputMode (cc.EDITBOX_INPUT_MODE_SINGLELINE)
    :addTo (sp_bj)

    -- 忘记密码
    ccui.Button:create ("Logon/btn_login_fgpw.png","")
    :setTag (LogonView.BT_FGPW)
    :move (550 + 56 , 213)
    :addTo (sp_bj)
    :addTouchEventListener (btcallback)

    --记住密码， button
    self.cbt_Record = ccui.CheckBox:create ("Logon/rem_password_button.png", "", "Logon/choose_button.png", "", "")
    :move (325 - 19 ,213)
    :setSelected (GlobalUserItem.bSavePassword)
    :setTag (LogonView.CBT_RECORD)
    :addTo (sp_bj)

    -- --自动登录
    -- self.cbt_Auto = ccui.CheckBox:create("cbt_auto_0.png","","cbt_auto_1.png","","")
    -- 	:move(700-93,245)
    -- 	:setSelected(GlobalUserItem.bAutoLogon)
    -- 	:setTag(LogonView.CBT_AUTO)
    -- 	:addTo(self)

    --登录按钮
    ccui.Button:create ("Logon/logon_button_3.png" )
    :setTag (LogonView.BT_LOGON2)
    :move (cc.p (440 - 55, 82 + 10))
    :setName ("btn_11")
    :addTo (sp_bj)
    :addTouchEventListener (btcallback)


    --账号注册
    ccui.Button:create ("Logon/regist_button.png","")
    :setTag (LogonView.BT_REGISTER)
    :move (550 + 45, 190 - 90)
    :addTo (sp_bj)
    :addTouchEventListener (btcallback)

end

--控制登录的几个按钮的显示与位置
function LogonView:refreshBtnList( )
	for i = 1, 3 do
		local btn = self:getChildByName("btn_" .. i)
		if btn ~= nil then
			btn:setVisible(false)
			btn:setEnabled(false)
		end
	end
	
	local btncount = 1
	local btnpos = 
	{
		--分别为1， 2， 3个按钮时的布局
		{cc.p(667, 147), cc.p(0, 0), cc.p(0, 0)},        
        {cc.p(463-70, 147), cc.p(868+70, 147), cc.p(0, 0)},
        {cc.p(222+80, 147), cc.p(667, 147), cc.p(1112-80, 147)}
	}	
	-- 1:帐号 2:游客 3:微信
	local btnlist = {"btn_1"}
	if false == GlobalUserItem.getBindingAccount() then
		table.insert(btnlist, "btn_2")
	end

	--微信有？
	local enableWeChat = self.m_serverConfig["wxLogon"] or 1
	if 0 == enableWeChat then
		table.insert(btnlist, "btn_3")
	end

	local poslist = btnpos[#btnlist]
	for k,v in pairs(btnlist) do
		local tmp = self:getChildByName(v)
		if nil ~= tmp then
			tmp:setEnabled(true)
			tmp:setVisible(true)

			local pos = poslist[k]
            if nil ~= pos then
            	tmp:setPosition(pos)
            end
		end
	end
end

function LogonView:onEditEvent(name, editbox)
	--print(name)
	if "changed" == name then
		if editbox:getText() ~= GlobalUserItem.szAccount then
			self.edit_Password:setText("")
		end		
	end
end

--显示用户名和密码暗文
function LogonView:onReLoadUser()
	if GlobalUserItem.szAccount ~= nil and GlobalUserItem.szAccount ~= "" then
		self.edit_Account:setText(GlobalUserItem.szAccount)
	else
		self.edit_Account:setPlaceHolder("请输入您的游戏帐号")
	end

	if GlobalUserItem.szPassword ~= nil and GlobalUserItem.szPassword ~= "" then
		self.edit_Password:setText(GlobalUserItem.szPassword)
	else
		self.edit_Password:setPlaceHolder("请输入您的游戏密码")
	end
end
 
--登录界面的按钮点击事件
function LogonView:onButtonClickedEvent(tag,ref)
    ExternalFun.playClickEffect()

    --账号注册
	if tag == LogonView.BT_REGISTER then
		GlobalUserItem.bVisitor = false
		self:getParent():getParent():onShowRegister()       --LogonScene 注册

	elseif tag == LogonView.BT_VISITOR then   --游客
        GlobalUserItem.bVisitor = true
        GlobalUserItem.custom.logonType = 2      --登录类型   0:微信，   1：账号，     2：游客
        self:getParent():getParent():onVisitor()     --logonView 在_backLayer上，_backLayer在logonScene上

    elseif tag == LogonView.BT_LOGON then   --账号登录
         self.bj_login:setVisible (true)
         GlobalUserItem.custom.logonType = 1
         self.bj_login._listener:setSwallowTouches(true)

    elseif tag == LogonView.BT_LOGON2_guanbi then   --关闭当前弹窗
        self.bj_login:setVisible (false)
        self.bj_login._listener:setSwallowTouches(false)
   
    elseif tag == LogonView.BT_LOGON2 then   --弹框中的登录
        GlobalUserItem.bVisitor = false
        local szAccount = string.gsub (self.edit_Account:getText (), " ", "")
        local szPassword = string.gsub (self.edit_Password:getText (), " ", "")
        local bAuto = self.sp_bj:getChildByTag(LogonView.CBT_RECORD):isSelected()
        local bSave = self.sp_bj:getChildByTag(LogonView.CBT_RECORD):isSelected()
        self:getParent():getParent():onLogon(szAccount, szPassword, bSave, bAuto)

    elseif tag == LogonView.BT_THIRDPARTY then
		self.m_spThirdParty:setVisible(true)
	
	elseif tag == LogonView.BT_WECHAT then     --微信登录
        if(1)then
            return
        end

        
        GlobalUserItem.custom.logonType = 0
        if (device.platform == "ios") or (device.platform == "android") then
            self:getParent():getParent():thirdPartyLogin(yl.ThirdParty.WECHAT)  --WECHAT :0
        else
            --showToast:屏幕中间的系统提示， 长条   ， p1:listerner  p2:txt  p3:时间
            showToast(self, "不支持的登录平台 ==> " .. device.platform, 1)
        end
	
    --忘记密码
	elseif tag == LogonView.BT_FGPW then
		MultiPlatform:getInstance():openBrowser(yl.HTTP_URL .. "/Mobile/RetrievePassword.aspx")
	end
end

----function LogonView:onTouchBegan(touch, event)
----	return self:isVisible()
----end

----function LogonView:onTouchEnded(touch, event)
----	local pos = touch:getLocation();
----	local m_spBg = self.m_spThirdParty
----    pos = m_spBg:convertToNodeSpace(pos)
----    local rec = cc.rect(0, 0, m_spBg:getContentSize().width, m_spBg:getContentSize().height)
----    if false == cc.rectContainsPoint(rec, pos) then
----        self.m_spThirdParty:setVisible(false)
----    end
----end

return LogonView