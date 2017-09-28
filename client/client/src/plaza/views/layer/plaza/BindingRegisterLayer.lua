--
-- Author: zhong
-- Date: 2016-10-31 15:49:33
--
local ServiceLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.other.ServiceLayer")
local ModifyFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.ModifyFrame")
local NotifyMgr = appdf.req(appdf.EXTERNAL_SRC .. "NotifyMgr")
local BindingRegisterLayer = class("BindingRegisterLayer",function(scene)
        local lay =  display.newLayer()
    return lay
end)

BindingRegisterLayer.BT_REGISTER = 1
BindingRegisterLayer.BT_RETURN   = 2
BindingRegisterLayer.BT_AGREEMENT= 3
BindingRegisterLayer.CBT_AGREEMENT = 4
BindingRegisterLayer.BT_faSongYanZhengMa = 5
BindingRegisterLayer.bAgreement = false
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
function BindingRegisterLayer:onTouchBegan (touch, event)
    return true
end
function BindingRegisterLayer:ctor(scene)
    local this = self
    self._scene = scene
    --条款界面
    self._serviceView = nil
    ExternalFun.registerTouchEvent (self, true)
    local  btcallback = function(ref, type)
        if type == ccui.TouchEventType.ended then
            this:onButtonClickedEvent(ref:getTag(),ref)
        end
    end

    --网络回调
    local modifyCallBack = function(result,message)
        this:onModifyCallBack(result,message)
    end
    --网络处理
    self._modifyFrame = ModifyFrame:create(self,modifyCallBack)

  
    --登录框
    local sp_bj = display.newSprite ("public/bgMiddle11.png")
    :move (yl.WIDTH / 2, yl.HEIGHT / 2)
    :addTo (self)
    self.sp_bj = sp_bj


    ccui.Button:create ("public/closeRound.png")
    :setTag (BindingRegisterLayer.BT_RETURN)
    :move (811, 460)
    :addTo (sp_bj)
    :addTouchEventListener (btcallback)


    display.newSprite ("Regist/title_regist.png")
    :move (441, 481)
    :addTo (sp_bj)
 
 
 
    display.newSprite("Regist/text_regist_account.png")
    :move(179,376)
    :addTo (sp_bj)


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
        :setPlaceholderFontColor(cc.c3b(127,113,217))
    :setFontColor(cc.c3b(229,225,255))
    :setPlaceholderFontSize(24)
    :setMaxLength(13)
    :setInputMode (cc.EDITBOX_INPUT_MODE_NUMERIC)
    :setPlaceHolder("登陆用户名即您的手机号")
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
        :setPlaceholderFontColor(cc.c3b(127,113,217))
    :setFontColor(cc.c3b(229,225,255))
    :setAnchorPoint(cc.p(0.5,0.5))
    :setFontName("fonts/round_body.ttf")
    :setPlaceholderFontName("fonts/round_body.ttf")
    :setFontSize(24)
    :setPlaceholderFontSize(24)
    :setMaxLength(26)
    :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    :setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    :setPlaceHolder(" 6-26位英文字母，数字，下划线组合")
    :addTo (sp_bj)

 
    display.newSprite("Regist/text_regist_confirm.png")
    :move(179,234)
    :addTo (sp_bj)

    --验证码底框
    display.newSprite ("Regist/mg_srk.png")
    :move (426 -10, 236)
    :addTo (sp_bj)
 

    --确认密码输入	
    self.edit_RePassword = ccui.EditBox:create(cc.size(272,67), "tm.png")
    :move (426+30, 236)
    --	:setAnchorPoint(cc.p(0,0.5))
    :setFontName("fonts/round_body.ttf")
    :setPlaceholderFontName("fonts/round_body.ttf")
    :setFontSize(24)
    :setPlaceholderFontSize(24)
    :setMaxLength(26)
        :setPlaceholderFontColor(cc.c3b(127,113,217))
    :setFontColor(cc.c3b(229,225,255))
  --  :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    :setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    :setPlaceHolder("请输入短信验证码")
    :addTo (sp_bj)

    --条款协议
    self.cbt_Agreement = ccui.CheckBox:create("Regist/choose_regist_0.png","","Regist/choose_regist_1.png","","")
    :move (280, 155)
    :setSelected(BindingRegisterLayer.bAgreement)
    :setTag(BindingRegisterLayer.CBT_AGREEMENT)
    :addTo (sp_bj)

    --显示协议
    ccui.Button:create("Regist/bt_regist_agreement.png","")
    :setTag(BindingRegisterLayer.BT_AGREEMENT)
    :move(545,155)
    :addTo (sp_bj)
    :addTouchEventListener(btcallback)
 

    --发送验证码
    local btnyzm= ccui.Button:create ("Regist/bt_reg_fsyzm.png")
    btnyzm:setTag (BindingRegisterLayer.BT_faSongYanZhengMa)
    :move (668 -30 ,234)
    :addTo (sp_bj)
    :addTouchEventListener (btcallback)
    self.btYzm=btnyzm

    --注册按钮
    ccui.Button:create ("Regist/bt_regist_0.png")
    :setTag(BindingRegisterLayer.BT_REGISTER)
    :move(440,82)
    :addTo (sp_bj)
    :addTouchEventListener (btcallback)


    
    self.ttfdjs = cc.Label:createWithTTF ("", "fonts/round_body.ttf", 18)
    :move (668, 234)
    :setAnchorPoint (0, 0.5)
    :setTextColor (cc.c3b (250, 250, 0))
    :addTo (sp_bj)
 
  
    if scene.nnum >  0 then
        btnyzm:setVisible (false)
        self.ttfdjs:setVisible (true)
        self.ttfdjs:setString ("倒计时 :" .. tostring (scene.nnum) .. " 秒")
    else
        btnyzm:setVisible (true)
        self.ttfdjs:setVisible (false)
    end

end


function BindingRegisterLayer:onButtonClickedEvent(tag,ref)
             ExternalFun.playClickEffect()            
    
    if tag == BindingRegisterLayer.BT_RETURN then
        self:removeFromParent()
    elseif tag == BindingRegisterLayer.BT_AGREEMENT then
       
            ServiceLayer:create(self)
            :move(0,0)
            :addTo(self)
 
    elseif tag == BindingRegisterLayer.BT_faSongYanZhengMa then    --发送验证码
            
        local szAccount = self.edit_Account:getText ()

        self._scene:startDjs(szAccount)
 
    elseif tag == BindingRegisterLayer.BT_REGISTER then
        local szAccount = string.gsub(self.edit_Account:getText(), " ", "")
        local szPassword = string.gsub(self.edit_Password:getText(), " ", "")
        local szYzm = string.gsub(self.edit_RePassword:getText(), " ", "")

        local len = ExternalFun.stringLen(szAccount)--#szAccount
        if len < 6 or len > 31 then
            showToast(self,"游戏帐号必须为6~31个字符，请重新输入！",2,cc.c4b(250,0,0,255));
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

        local bAgreement = self.sp_bj:getChildByTag(BindingRegisterLayer.CBT_AGREEMENT):isSelected()
        if bAgreement == false then
            showToast(self,"请先阅读并同意《游戏中心服务条款》！",2,cc.c4b(250,0,0,255));
            return
        end        
          
  
      
        --local szSpreader = string.gsub(self.edit_Spreader:getText(), " ", "")
        local szSpreader = ""
        self._scene:showPopWait()
        self._modifyFrame:onAccountRegisterBinding(szAccount,md5(szPassword),szSpreader,szYzm)
        self.szAccount = szAccount
        self.szPassword = szPassword
    end
end

function BindingRegisterLayer:setAgreement(bAgree)
    self.cbt_Agreement:setSelected(bAgree)
end

--操作结果
function BindingRegisterLayer:onModifyCallBack(result,message)
    print("======== BindingRegisterLayer::onModifyCallBack ========")

    self._scene:dismissPopWait()
    if  message ~= nil and message ~= "" then
        showToast(self,message,2);
    end  
    if result == 2 then
        self._scene:showPopWait()
        GlobalUserItem.setBindingAccount()
        GlobalUserItem.szPassword = self.szPassword
        GlobalUserItem.szAccount = self.szAccount
        --保存数据
        GlobalUserItem.onSaveAccountConfig()
            
    
        self:runAction(cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create(function ()
            self._scene:dismissPopWait()
                  
            --重新登录
            GlobalUserItem.nCurRoomIndex = -1
            self._scene:getApp():enterSceneEx(appdf.CLIENT_SRC.."plaza.views.LogonScene","FADE",1)
            GlobalUserItem.reSetData()
            --读取配置
            GlobalUserItem.LoadData()
            --断开好友服务器
            FriendMgr:getInstance():reSetAndDisconnect()
            --通知管理
            NotifyMgr:getInstance():clear()
            end)))
    end
end

return BindingRegisterLayer