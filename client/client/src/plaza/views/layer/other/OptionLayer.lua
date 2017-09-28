--[[
	设置界面
	2015_12_03 C.P
	功能：音乐音量震动等
]]

local OptionLayer = class("OptionLayer", function(scene)
		local optionLayer = display.newLayer(cc.c4b(0, 0, 0, 0))
    return optionLayer
end)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var
local WebViewLayer = appdf.CLIENT_SRC .. "plaza.views.layer.plaza.WebViewLayer"
appdf.req(appdf.CLIENT_SRC.."plaza.models.FriendMgr")
local NotifyMgr = appdf.req(appdf.EXTERNAL_SRC .. "NotifyMgr")
local ModifyFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.ModifyFrame")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")

OptionLayer.CBT_SILENCE 	= 1
OptionLayer.CBT_SOUND   	= 2
OptionLayer.BT_EXIT			= 7

OptionLayer.BT_QUESTION		= 8
OptionLayer.BT_COMMIT		= 9
OptionLayer.BT_MODIFY		= 10
OptionLayer.BT_EXCHANGE		= 11
OptionLayer.BT_LOCK         = 12
OptionLayer.BT_UNLOCK       = 13

OptionLayer.PRO_WIDTH		= yl.WIDTH

--吞噬下面层的效果
function OptionLayer:onTouchBegan (touch, event)
    return true
end

function OptionLayer:ctor(scene)
	self._scene = scene
	self:setContentSize(yl.WIDTH,yl.HEIGHT)
	local this = self
  
    ExternalFun.registerTouchEvent (self, true)    --吞噬，true;  不吞噬， false
  
    local cbtlistener = function (sender,eventType)
    	this:onSelectedEvent(sender:getTag(),sender,eventType)
    end
	local  btcallback = function(ref, type)
        if type == ccui.TouchEventType.ended then
         	this:onButtonClickedEvent(ref:getTag(),ref)
        end
    end

	local areaWidth = yl.WIDTH
	local areaHeight = yl.HEIGHT

	
	-- display.newSprite("Option/bg_option.png")
	-- 	:move(yl.WIDTH/2,yl.HEIGHT/2)
	-- 	:addTo(self)

	-- --上方背景
 --    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("sp_top_bg.png")
 --    if nil ~= frame then
 --        local sp = cc.Sprite:createWithSpriteFrame(frame)
 --        sp:setPosition(yl.WIDTH/2,yl.HEIGHT-51)
 --        self:addChild(sp)
 --    end
    local difHeight = -10  --高度偏差

    --
    -- local sp_bj = display.newSprite ("General/mg_bj_2.png")
    -- :move (yl.WIDTH / 2, yl.HEIGHT / 2)
    -- :addTo (self)

    --显示背景，屏蔽下方的触摸
    ccui.ImageView:create(("General/mg_bj_2.png"))
    :move (yl.WIDTH / 2, yl.HEIGHT / 2)
    :addTo (self)
    :setTouchEnabled(true)
    :setSwallowTouches(true)

    --底框
    display.newSprite("Option/frame_option_1.png")
     :move(yl.WIDTH/2, 365)
     :addTo(self)

	--标题
	display.newSprite("Option/title_option.png")
		:move(areaWidth/2,yl.HEIGHT- 155 + difHeight)
		:addTo(self)
	
    --返回
	ccui.Button:create("General/bt_close_0.png","")
    	:move(1038, 574 + difHeight)
    	:setTag(OptionLayer.BT_EXIT)
    	:addTo(self)
    	:addTouchEventListener(btcallback)

	--音效开关
	-- display.newSprite("Option/frame_option_0.png")
	-- 	:move(1000,510)
	-- 	:addTo(self)
	display.newSprite("Option/text_sound.png")
		:move(826,329 + difHeight)
		:addTo(self)
	self._cbtSilence = ccui.CheckBox:create("Option/bt_option_switch_0.png","Option/bt_option_switch_0.png","Option/bt_option_switch_1.png","","")
		:move(951,329 + difHeight)
		:setSelected(GlobalUserItem.bSoundAble)
		:addTo(self)
		:setTag(self.CBT_SOUND)
	self._cbtSilence:addEventListener(cbtlistener)

	--音乐开关
	-- display.newSprite("Option/frame_option_0.png")
	-- 	:move(330,510)
	-- 	:addTo(self)
	display.newSprite("Option/text_music.png")
		:move(826,415 + difHeight)
		:addTo(self)
	self._cbtSound = ccui.CheckBox:create("Option/bt_option_switch_0.png","","Option/bt_option_switch_1.png","","")
		:move(951,415 + difHeight)
		:setSelected(GlobalUserItem.bVoiceAble)
		:addTo(self)
		:setTag(self.CBT_SILENCE)
	self._cbtSound:addEventListener(cbtlistener)

	--常见问题
	-- display.newSprite("Option/frame_option_0.png")
	-- 	:move(330,338)
	-- 	:addTo(self)
	-- display.newSprite("Option/text_question.png")
	-- 	:move(170,338)
	-- 	:addTo(self)
	ccui.Button:create("Option/bt_option_check_0.png","Option/bt_option_check_1.png")
		:move(387,329 + difHeight)
		:setTag(OptionLayer.BT_QUESTION)
		:addTo(self)
		:addTouchEventListener(btcallback)

	--游戏反馈
	-- display.newSprite("Option/frame_option_0.png")
	-- 	:move(1000,338)
	-- 	:addTo(self)
	-- display.newSprite("Option/text_feedback.png")
	-- 	:move(837,338)
	-- 	:addTo(self)
	ccui.Button:create("Option/bt_option_commit_0.png","Option/bt_option_commit_1.png")
		:move(621, 329 + difHeight)
		:setTag(OptionLayer.BT_COMMIT)
		:addTo(self)
		:addTouchEventListener(btcallback)
	

	--当前账号
	display.newSprite("Option/text_account.png")
		:move(388,415 + difHeight)
		:addTo(self)

	local testen = cc.Label:createWithSystemFont("A","Arial", 30)
    self._enSize = testen:getContentSize().width
    local testcn = cc.Label:createWithSystemFont("游","Arial", 30)
    self._cnSize = testcn:getContentSize().width
	self._nickname = cc.Label:createWithTTF(string.stringEllipsis(GlobalUserItem.szNickName, self._enSize, self._cnSize, 250), "fonts/round_body.ttf", 30)
        :move(678,415 + difHeight)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
        :setAnchorPoint(cc.p(0.5,0.5))
       	:setWidth(280)
       	:setHeight(50)
       	:setLineBreakWithoutSpace(false)
       	:setTextColor(cc.c4b(240,240,240,255))
       	:addTo(self)

    -- 锁定
    if 1 == GlobalUserItem.cbLockMachine then
        self.m_btnLock = ccui.Button:create("Option/btn_unlockmachine_0.png","Option/btn_unlockmachine_1.png","Option/btn_unlockmachine_0.png")
        self.m_btnLock:setTag(OptionLayer.BT_UNLOCK)
    else
        self.m_btnLock = ccui.Button:create("Option/btn_lockmachine_0.png","Option/btn_lockmachine_1.png","Option/btn_lockmachine_0.png")
        self.m_btnLock:setTag(OptionLayer.BT_LOCK)
    end    
    self.m_btnLock:move(411, 193 + difHeight)        
        :addTo(self)
        :addTouchEventListener(btcallback)

    --修改密码
    ccui.Button:create("Option/bt_option_modify_0.png","Option/bt_option_modify_1.png")
		:move(668, 193 + difHeight)
		:setTag(OptionLayer.BT_MODIFY)
		:addTo(self)
		:addTouchEventListener(btcallback)
	--切换帐号
    ccui.Button:create("Option/bt_option_change_0.png","Option/bt_option_change_1.png")
		:move(925, 193 + difHeight)
		:setTag(OptionLayer.BT_EXCHANGE)
		:addTo(self)
		:addTouchEventListener(btcallback)

    local mgr = self._scene:getApp():getVersionMgr()
    local verstr = mgr:getResVersion() or "0"
    -- 版本号
    cc.Label:createWithTTF("版本号:   " .. appdf.BASE_C_VERSION .. "." .. verstr, "fonts/round_body.ttf", 24)
        :move(325,510)
        :setAnchorPoint(cc.p(0.5, 0.5))
        :addTo(self)
        :setTextColor(cc.c4b(164,133,199,255))
end


function OptionLayer:onSelectedEvent(tag,sender,eventType)
	ExternalFun.playClickEffect()
    if tag == OptionLayer.CBT_SILENCE then
		GlobalUserItem.setVoiceAble(eventType == 0)
		--背景音乐
        ExternalFun.playPlazzBackgroudAudio()
	elseif tag == OptionLayer.CBT_SOUND then

		GlobalUserItem.setSoundAble(eventType == 0)
	end
end

--按键监听
function OptionLayer:onButtonClickedEvent(tag,sender)
             ExternalFun.playClickEffect()            

	if tag ~= OptionLayer.BT_EXCHANGE and tag ~= OptionLayer.BT_EXIT then
		if GlobalUserItem.isAngentAccount() then
			return
		end
	end	
	
	if tag == OptionLayer.BT_EXCHANGE then
        -- 删除授权
        if MultiPlatform:getInstance():isAuthorized(yl.ThirdParty.WECHAT) then
            print("OptionLayer 删除微信授权")
            MultiPlatform:getInstance():delAuthorized(yl.ThirdParty.WECHAT)
        end
        --微信需要重新登录
        print("OptionLayer Userdefault weChatSaved false!")
        cc.UserDefault:getInstance():setBoolForKey("weChatSaved",false)
        cc.UserDefault:getInstance():flush()
        self._scene:ExitClient()

    elseif tag == OptionLayer.BT_EXIT then
        self:removeFromParent()
  
    elseif tag == OptionLayer.BT_QUESTION then
        print("##########################\nFaq")
        self._scene:getNewTagLayer(yl.SCENE_FAQ)
	
    elseif tag == OptionLayer.BT_MODIFY then
        if self._scene._gameFrame:isSocketServer() then
            showToast(self,"当前页面无法使用此功能！",1)
            return
        end
        self._scene:getNewTagLayer(yl.SCENE_MODIFY)
	
    elseif tag == OptionLayer.BT_COMMIT then
        print("#####################\nfeedback")
        self._scene:getNewTagLayer(yl.SCENE_FEEDBACK)
    
    elseif tag == OptionLayer.BT_LOCK then
        print("锁定机器")
        self:showLockMachineLayer(self)
    elseif tag == OptionLayer.BT_UNLOCK then
        print("解锁机器")
        self:showLockMachineLayer(self)
	end
end

local TAG_MASK = 101
local BTN_CLOSE = 102
function OptionLayer:showLockMachineLayer( parent )
    if nil == parent then
        return
    end
    --网络回调
    local modifyCallBack = function(result,message)
        self:onModifyCallBack(result,message)
    end
    --网络处理
    self._modifyFrame = ModifyFrame:create(self,modifyCallBack)

    -- 加载csb资源
    local csbNode = ExternalFun.loadCSB("Option/LockMachineLayer.csb", parent )

    local touchFunC = function(ref, tType)

        if tType == ccui.TouchEventType.ended then
            ExternalFun.playClickEffect()
            local tag = ref:getTag()
            if TAG_MASK == tag or BTN_CLOSE == tag then
                csbNode:removeFromParent()
            elseif OptionLayer.BT_LOCK == tag then
                local txt = csbNode.m_editbox:getText()
                if txt == "" then
                    showToast(self, "密码不能为空!", 2)
                    return 
                end
                self._modifyFrame:onBindingMachine(1, txt)
                csbNode:removeFromParent()
            elseif OptionLayer.BT_UNLOCK == tag then
                local txt = csbNode.m_editbox:getText()
                if txt == "" then
                    showToast(self, "密码不能为空!", 2)
                    return 
                end
                self._modifyFrame:onBindingMachine(0, txt)
                csbNode:removeFromParent()
            end
        end
    end

    -- 遮罩
    local mask = csbNode:getChildByName("panel_mask")
    mask:setTag(TAG_MASK)
    mask:addTouchEventListener( touchFunC )

    local image_bg = csbNode:getChildByName("image_bg")
    image_bg:setSwallowTouches(true)

    -- 输入
    local tmp = image_bg:getChildByName("sp_lockmachine_bankpw")
    local editbox = ccui.EditBox:create(cc.size(tmp:getContentSize().width - 10, tmp:getContentSize().height - 10),"blank.png",UI_TEX_TYPE_PLIST)
        :setPosition(tmp:getPosition())
        :setFontName("fonts/round_body.ttf")
        :setPlaceholderFontName("fonts/round_body.ttf")
        :setFontSize(30)
        :setPlaceholderFontSize(30)
        :setMaxLength(32)
            :setPlaceholderFontColor(cc.c3b(127,113,217))
    :setFontColor(cc.c3b(229,225,255))
        :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
        :setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        :setPlaceHolder("请输入密码")
    image_bg:addChild(editbox)
    csbNode.m_editbox = editbox

    -- 锁定/解锁
    local btn = image_bg:getChildByName("btn_lock")
    btn:setTag(OptionLayer.BT_LOCK)
    btn:addTouchEventListener( touchFunC )
    local normal = "Option/btn_lockmachine_0.png"
    local disable = "Option/btn_lockmachine_1.png"
    local press = ""
    local locktitle =  image_bg:getChildByName("sp_lockmachine_title_2")    --标题
    local imgTitleName = "Option/sp_lockmachine_title.png"

    if 1 == GlobalUserItem.cbLockMachine then
        btn:setTag(OptionLayer.BT_UNLOCK)
        normal = "Option/btn_unlockmachine_0.png"
        disable = "Option/btn_unlockmachine_1.png"
        press = ""
        imgTitleName = "Option/sp_unlockmachine_title.png"
    end
    btn:loadTextures(disable,normal,press)
 
 
    locktitle:loadTexture(imgTitleName)

    btn = image_bg:getChildByName("btn_cancel")
    btn:setTag(BTN_CLOSE)
    btn:addTouchEventListener( touchFunC )

    -- 关闭
    btn = image_bg:getChildByName("btn_close")
    btn:setTag(BTN_CLOSE)
    btn:addTouchEventListener( touchFunC )
end

function OptionLayer:onModifyCallBack(result, tips)
    if type(tips) == "string" and "" ~= tips then
        showToast(self, tips, 2)
    end 

    local normal = "Option/btn_lockmachine_0.png"
    local disable = "Option/btn_lockmachine_1.png"
    local press = "Option/btn_lockmachine_0.png"
    if self._modifyFrame.BIND_MACHINE == result then
        if 0 == GlobalUserItem.cbLockMachine then
            GlobalUserItem.cbLockMachine = 1
            self.m_btnLock:setTag(OptionLayer.BT_UNLOCK)
            normal = "Option/btn_unlockmachine_0.png"
            disable = "Option/btn_unlockmachine_1.png"
            press = "Option/btn_unlockmachine_0.png"
        else
            GlobalUserItem.cbLockMachine = 0
            self.m_btnLock:setTag(OptionLayer.BT_LOCK)
        end
    end   
    self.m_btnLock:loadTextures(disable,normal,press) 
end

return OptionLayer