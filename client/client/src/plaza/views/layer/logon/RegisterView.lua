local ExternalFun = appdf.req (appdf.EXTERNAL_SRC .. "ExternalFun")
local RegisterView = class("RegisterView",function()
		local registerView =  display.newLayer()
    return registerView
end)

RegisterView.BT_REGISTER = 1
RegisterView.BT_RETURN	 = 2
RegisterView.BT_AGREEMENT= 3
RegisterView.CBT_AGREEMENT = 4
RegisterView.BT_faSongYanZhengMa = 5

RegisterView.bAgreement = true
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
function RegisterView:onTouchBegan (touch, event)
    return true
end
function RegisterView:ctor (_parent)
    local  parent = _parent
    local this = self
	self:setContentSize(yl.WIDTH,yl.HEIGHT)
	cc.SpriteFrameCache:getInstance():addSpriteFrames("public/public.plist")

    ExternalFun.registerTouchEvent (self, true)

    local  btcallback = function(ref, type)
        if type == ccui.TouchEventType.ended then
         	this:onButtonClickedEvent(ref:getTag(),ref)
        end
    end


        --半透明的遮罩层
    cc.LayerColor:create(cc.c4b(0, 0, 0, 95), 1334, 750)
    :move(cc.p(0,0))
    :addTo(self)


    --登录框
    local sp_bj = display.newSprite ("public/bgMiddle11.png")
    :move (yl.WIDTH / 2, yl.HEIGHT / 2)
    :addTo (self)
    self.sp_bj = sp_bj


    ccui.Button:create ("public/closeRound.png")
    :setTag (RegisterView.BT_RETURN)
    :move (811, 460)
    :addTo (sp_bj)
    :addTouchEventListener (btcallback)


    --账号注册标题
    display.newSprite ("Regist/title_regist.png")
    :move (441 - 18, 481 + 10)
    :addTo (sp_bj)
 
 
 
	display.newSprite("Regist/text_regist_account.png")
		:move(179,376)
    :addTo (sp_bj)


    --背景
    display.newSprite ("General/edit_bj.png")
    :move (525, 379)
    :addTo (sp_bj)
 


    --账号输入
    self.edit_Account = ccui.EditBox:create(cc.size(470,63), "tm.png")
         :move (525+30, 379)
		:setAnchorPoint(cc.p(0.5,0.5))
		:setFontName("fonts/round_body.ttf")
		:setPlaceholderFontName("fonts/round_body.ttf")
		:setFontSize(24)
		:setPlaceholderFontSize(24)
		:setMaxLength(13)
            :setPlaceholderFontColor(cc.c3b(127,113,217))
    :setFontColor(cc.c3b(229,225,255))
      :setInputMode (cc.EDITBOX_INPUT_MODE_NUMERIC)
		:setPlaceHolder("请输入手机号码")
    :addTo (sp_bj)
 
	display.newSprite("Regist/text_regist_password.png")
		:move(179,305)
    :addTo (sp_bj)

    display.newSprite ("General/edit_bj.png")
    :move (525, 308)
    :addTo (sp_bj)

    --密码输入	
    self.edit_Password = ccui.EditBox:create(cc.size(490,67), "tm.png")
    :move (525+30, 308)
		:setAnchorPoint(cc.p(0.5,0.5))
		:setFontName("fonts/round_body.ttf")
		:setPlaceholderFontName("fonts/round_body.ttf")
		:setFontSize(24)
		:setPlaceholderFontSize(24)
		:setMaxLength(26)
            :setPlaceholderFontColor(cc.c3b(127,113,217))
    :setFontColor(cc.c3b(229,225,255))
		:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
		:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
		:setPlaceHolder(" 6-26位英文字母，数字，下划线组合")
    :addTo (sp_bj)

 
	display.newSprite("Regist/text_regist_confirm.png")
		:move(179,234)
    :addTo (sp_bj)

    --验证码底框
    display.newSprite ("Regist/mg_srk.png")
    :move (426 - 10, 236)
    :addTo (sp_bj)
 

    --确认密码输入	
    self.edit_RePassword = ccui.EditBox:create(cc.size(272,67), "tm.png")
    :move (426+30, 236)
	    :setPlaceholderFontColor(cc.c3b(127,113,217))
    :setFontColor(cc.c3b(229,225,255))
		:setFontName("fonts/round_body.ttf")
		:setPlaceholderFontName("fonts/round_body.ttf")
		:setFontSize(24)
		:setPlaceholderFontSize(24)
		:setMaxLength(26)
 
		:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
		:setPlaceHolder("请输入短信验证码")
    :addTo (sp_bj)

	--条款协议
	self.cbt_Agreement = ccui.CheckBox:create("Regist/choose_regist_0.png","","Regist/choose_regist_1.png","","")
    :move (280, 155)
		:setSelected(RegisterView.bAgreement)
		:setTag(RegisterView.CBT_AGREEMENT)
    :addTo (sp_bj)

	--显示协议
	ccui.Button:create("Regist/bt_regist_agreement.png","")
		:setTag(RegisterView.BT_AGREEMENT)
		:move(545,155)
    :addTo (sp_bj)
		:addTouchEventListener(btcallback)

    --获取送验证码
   local btnyzm= ccui.Button:create ("Regist/bt_reg_fsyzm.png")
    btnyzm:setTag (RegisterView.BT_faSongYanZhengMa)
        :move (668 - 30,234)
        :addTo (sp_bj)
        :addTouchEventListener (btcallback)
    self.btYzm=btnyzm

    --注册按钮
    ccui.Button:create ("Regist/bt_regist_0.png")
		:setTag(RegisterView.BT_REGISTER)
		:move(440,82)
        :addTo (sp_bj)
    :addTouchEventListener (btcallback)


    
        self.ttfdjs = cc.Label:createWithTTF ("", "fonts/round_body.ttf", 18)
    :move (668, 234)
        :setAnchorPoint (0, 0.5)
        :setTextColor (cc.c3b (250, 250, 0))
    :addTo (sp_bj)
 
 


    if parent.nnum >  0 then
        btnyzm:setVisible (false)
        self.ttfdjs:setVisible (true)
        self.ttfdjs:setString ("倒计时 :" .. tostring (parent.nnum) .. " 秒")
    else
        btnyzm:setVisible (true)
        self.ttfdjs:setVisible (false)
    end


end


function RegisterView:onButtonClickedEvent(tag,ref)
    ExternalFun.playClickEffect()
	
    --返回
    if tag == RegisterView.BT_RETURN then
		self:getParent():getParent():onShowLogon()
   
    --发送验证码
    elseif tag == RegisterView.BT_faSongYanZhengMa then   

        local szAccount = self.edit_Account:getText ()
                
        self:getParent():getParent():onCORD(szAccount)

    elseif tag == RegisterView.BT_AGREEMENT then    --服务条款
		self:getParent():getParent():onShowService()
	
	elseif tag == RegisterView.BT_REGISTER then
        -- 判断 非 数字、字母、下划线、中文 的帐号
        local szAccount = self.edit_Account:getText ()
      --  szAccount = string.gsub (szAccount, " ", "")
        local filter = ExternalFun.CheckIsMobile (szAccount)
        if false== filter then
			showToast(self, "手机号格式错误, 请重试!", 1)
			return
		end 
		local szPassword = string.gsub(self.edit_Password:getText(), " ", "")
		local szCORD = string.gsub(self.edit_RePassword:getText(), " ", "")
        local bAgreement = self.sp_bj:getChildByTag(RegisterView.CBT_AGREEMENT):isSelected()
       -- local szSpreader = string.gsub (self.edit_Spreader:getText (), " ", "")
        local szSpreader =""
        self:getParent():getParent():onRegister(szAccount,szPassword,bAgreement,szSpreader,szCORD)
	end
end
 





function RegisterView:setAgreement(bAgree)
	self.cbt_Agreement:setSelected(bAgree)
end

return RegisterView