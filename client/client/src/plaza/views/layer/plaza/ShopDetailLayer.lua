--[[
	商城详细界面
	2016_07_04 Ravioyla
]]

local ShopDetailLayer = class("ShopDetailLayer", function(scene)
		local shopDetailLayer = display.newLayer(cc.c4b(0, 0, 0, 0))
    return shopDetailLayer
end)
 local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local ShopDetailFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.ShopDetailFrame")

ShopDetailLayer.CBT_BEAN			= 1
ShopDetailLayer.CBT_INGOT			= 2
ShopDetailLayer.CBT_GOLD			= 3
ShopDetailLayer.CBT_LOVELINESS		= 4

ShopDetailLayer.BT_BUY1				= 20    --购买后放入背包，已废弃
ShopDetailLayer.BT_BUY2				= 21    --购买后立即使用
ShopDetailLayer.BT_ADD				= 22
ShopDetailLayer.BT_MIN				= 23
ShopDetailLayer.BT_BLANK            = 24
ShopDetailLayer.BT_BUY3             = 25    --立即赠送
function ShopDetailLayer:onTouchBegan (touch, event)
    return true
end
-- 进入场景而且过渡动画结束时候触发。
function ShopDetailLayer:onEnterTransitionFinish()
    return self
end

-- 退出场景而且开始过渡动画时候触发。
function ShopDetailLayer:onExitTransitionStart()
    return self
end
function ShopDetailLayer:onExit()
    if self._shopDetailFrame:isSocketServer() then
        self._shopDetailFrame:onCloseSocket()
    end
    if nil ~= self._shopDetailFrame._gameFrame then
        self._shopDetailFrame._gameFrame._shotFrame = nil
        self._shopDetailFrame._gameFrame = nil
    end 
    return self
end
function ShopDetailLayer:ctor(scene, gameFrame)
	
	local this = self

	self._scene = scene
    ExternalFun.registerTouchEvent (self, true)

 

	--按钮回调
	self._btcallback = function(ref, type)
        if type == ccui.TouchEventType.ended then
         	this:onButtonClickedEvent(ref:getTag(),ref)
        end
    end

    local cbtlistener = function (sender,eventType)
    	this:onSelectedEvent(sender:getTag(),sender,eventType)
    end

    --网络回调
    local shopDetailCallBack = function(result,message)
		return this:onShopDetailCallBack(result,message)
	end

	--网络处理
	self._shopDetailFrame = ShopDetailFrame:create(self,shopDetailCallBack)
    self._shopDetailFrame._gameFrame = gameFrame
    if nil ~= gameFrame then
        gameFrame._shotFrame = self._shopDetailFrame
    end

    self._select = ShopDetailLayer.CBT_BEAN
    self._item = GlobalUserItem.buyItem
    self._buyNum = 0
    self._toUse = 0
    self._type = yl.CONSUME_TYPE_CASH
    self._isMeili = (GlobalUserItem.buyItem.kind == 13)     --是否是魅力商品，true为魅力商品，界面单独排版

    --背景
    self.spBJ=	display.newSprite("General/mg_bj_4.png")
    self.spBJ:move(yl.WIDTH/2,yl.HEIGHT /2)
    :addTo(self)
     
    --订单的图片
    display.newSprite("Shop/Detail/de_title.png")
    :move(555,621)
    :addTo(self.spBJ)
    
    --内框
    local bj2=display.newSprite("General/mg_bj_8.png")
    :move(546,287)
    :addTo(self.spBJ)
    
    local  parent= this._scene

    --关闭按钮
    ccui.Button:create("General/bt_close_0.png","")
    :move(1017,599)
    :addTo(self.spBJ)
    :addTouchEventListener(function(ref, type)
        if type == ccui.TouchEventType.ended then
            this:removeFromParent()
        end
    end)

    --一条线
    display.newSprite("Shop/Detail/mg_fgx.png")
    :move(405,189)
    :setAnchorPoint(cc.p(0,0.5))
    :addTo(self.spBJ)
 
 
    --物品底框，带光圈的
    local infoKuang = display.newSprite("Shop/Detail/mg_bjk.png")
    :move(194,390)
    :addTo(self.spBJ)
 

    --名字
    frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("text_public_"..self._item.id..".png")
    if nil ~= frame then
        local sp = cc.Sprite:createWithSpriteFrame(frame)
        infoKuang:addChild(sp)
        sp:setPosition(195/2,256-30)
    end

    --图标
    frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("icon_public_"..self._item.id..".png")
    if nil ~= frame then
        local sp = cc.Sprite:createWithSpriteFrame(frame)
        infoKuang:addChild(sp)
        sp:setPosition(195/2,256/2+15)
    end



	local y = 300 -30

    --用什么购买
	--游戏豆
	if self._item.bean ~= 0 then
		cc.Label:createWithTTF(string.formatNumberThousands(self._item.bean,true,",").."游戏豆", "fonts/round_body.ttf", 24)
        	:setAnchorPoint(cc.p(0.0,0.5))
        	:move(144+105,y)
       		:setColor(cc.c3b(255,240,189))
       		:addTo(self)
       	ccui.CheckBox:create("Shop/Detail/cbt_detail_0.png","","Shop/Detail/cbt_detail_1.png","","")
			:move(110+105,y)
			:addTo(self)
			:setSelected(true)
			:setTag(ShopDetailLayer.CBT_BEAN)
			:addEventListener(cbtlistener)

		y = y-52
	end
	--元宝
	if self._item.ingot ~= 0 then
		cc.Label:createWithTTF(string.formatNumberThousands(self._item.ingot,true,",").."元宝", "fonts/round_body.ttf", 24)
        	:setAnchorPoint(cc.p(0.0,0.5))
        	:move(144+105,y)
       		:setColor(cc.c3b(255,240,189))
       		:addTo(self)
       	ccui.CheckBox:create("Shop/Detail/cbt_detail_0.png","","Shop/Detail/cbt_detail_1.png","","")
			:move(110+105,y)
			:addTo(self)
			:setSelected(self._item.bean == 0)
			:setTag(ShopDetailLayer.CBT_INGOT)
			:addEventListener(cbtlistener)

		if self._item.bean == 0 then
			self._select = ShopDetailLayer.CBT_INGOT
		end

		y = y-52
	end
	--游戏币
	if self._item.gold ~= 0 then
		cc.Label:createWithTTF(string.formatNumberThousands(self._item.gold,true,",").."游戏币", "fonts/round_body.ttf", 24)
        	:setAnchorPoint(cc.p(0.0,0.5))
        	:move(144+105,y)
       		:setColor(cc.c3b(255,240,189))
       		:addTo(self)
       	ccui.CheckBox:create("Shop/Detail/cbt_detail_0.png","","Shop/Detail/cbt_detail_1.png","","")
			:move(110+105,y)
			:addTo(self)
			:setSelected(self._item.ingot==0 and self._item.bean==0)
			:setTag(ShopDetailLayer.CBT_GOLD)
			:addEventListener(cbtlistener)

		if self._item.ingot==0 and self._item.bean==0 then
			self._select = ShopDetailLayer.CBT_GOLD
		end

		y = y-52
	end
	--魅力值
	--[[if self._item.loveliness ~= 0 then
		cc.Label:createWithTTF(string.formatNumberThousands(self._item.loveliness,true,",").."魅力值", "fonts/round_body.ttf", 24)
        	:setAnchorPoint(cc.p(0.0,0.5))
        	:move(144,y)
       		:setTextColor(cc.c4b(255,102,0,255))
       		:addTo(self)
       	ccui.CheckBox:create("Shop/Detail/cbt_detail_0.png","","Shop/Detail/cbt_detail_1.png","","")
			:move(110,y)
			:addTo(self)
			:setSelected(self._item.ingot==0 and self._item.bean==0 and self._item.gold==0)
			:setTag(ShopDetailLayer.CBT_LOVELINESS)
			:addEventListener(cbtlistener)

		if self._item.ingot==0 and self。._item.bean==0 and self._item.gold==0 then
			self._select = ShopDetailLayer.CBT_LOVELINESS
		end

		y = y-61
	end]]


   --购买数量
    local spName = "Shop/Detail/text_detail_0.png"
    if self._isMeili then 
        spName = "Shop/Detail/spSendNum.png"
    end 
    display.newSprite(spName)
            :move(503,464)
    :addTo(self.spBJ)
    ccui.Button:create("Shop/Detail/bt_detail_min.png","Shop/Detail/bt_detail_min.png")  --减号
            :move(596,467)
            :setTag(ShopDetailLayer.BT_MIN)
            :addTo(self.spBJ)
            :addTouchEventListener(self._btcallback)
    ccui.Button:create("Shop/Detail/bt_detail_add.png","Shop/Detail/bt_detail_add.png")  --加号
            :move(1008,467)
            :setTag(ShopDetailLayer.BT_ADD)
            :addTo(self.spBJ)
            :addTouchEventListener(self._btcallback)
    local editHanlder = function(event,editbox)
        self:onEditEvent(event,editbox)
    end
    display.newSprite("Shop/Detail/frame_detail_2.png")   --输入框背景
            :move(802,467)
            :addTo(self.spBJ)
    -- 编辑框
    local editbox = ccui.EditBox:create(cc.size(342, 48),"blank.png",UI_TEX_TYPE_PLIST)
        :setPosition(cc.p(802,467))
        :setFontName("fonts/round_body.ttf")
        :setPlaceholderFontName("fonts/round_body.ttf")
        :setFontSize(30)
        :setMaxLength(4)
           :setPlaceholderFontColor(cc.c3b(127,113,217))
    :setFontColor(cc.c3b(255,240,189))
        :setPlaceholderFontSize(30)
        :setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.spBJ:addChild(editbox)
    editbox:setVisible(false)
    editbox:setText("1")
    editbox:registerScriptEditBoxHandler(editHanlder)
    self.m_editNumber = editbox
    --编辑框上的按钮
    local btn = ccui.Button:create("blank.png","blank.png","blank.png", UI_TEX_TYPE_PLIST) 
    btn:setScale9Enabled(true)
    btn:setContentSize(cc.size(342,48))
    btn:setPosition(cc.p(795,455))
    btn:setTag(ShopDetailLayer.BT_BLANK)
    btn:addTouchEventListener(self._btcallback)
    self.spBJ:addChild(btn) 
    --购买数量txt
    self._txtNum =  cc.Label:createWithTTF("0", "fonts/round_body.ttf", 37)
            :setColor(cc.c3b(252,255,31))
            :move(802,467)
            :setAnchorPoint(cc.p(0.5,0.5))
    :addTo(self.spBJ)


    --购买价格 字样  
    local spName = "Shop/Detail/text_detail_4.png"
    if self._isMeili then 
        spName = "Shop/Detail/spSendPrice.png"
    end 
    display.newSprite(spName)
        :move(503,404-(60*(4-1)))
    :addTo(self.spBJ)

    --游戏豆， 对应购买价格后面      --(最后的0,1,2对应  游戏豆，元宝，游戏币)
    self._priceTag4 = display.newSprite("Shop/Detail/text_detail_7_0.png")
            :setAnchorPoint(cc.p(1.0,0.5))
            :move(970,404-(60*(4-1)))
            :addTo(self.spBJ)

    -- 购买价格txt
    self._txtPrice3 =  cc.Label:createWithTTF("0", "fonts/round_body.ttf", 30)
            :setColor(cc.c3b(252,255,31)) 
            :move(820,224) -- 439-(46*(4-1))
            :setAnchorPoint(cc.p(1.0,0.5))
            :addTo(self.spBJ)

    self._buyNum = 1



    --持有
    display.newSprite("Shop/Detail/text_shopdetail_coin.png")
    :move(  503,160)
    :addTo(self.spBJ)
    -- 持有的钱
    self._txtPrice =  cc.Label:createWithTTF(string.formatNumberThousands(GlobalUserItem.lUserScore,true,","), "fonts/round_body.ttf", 30)
    :setColor(cc.c3b(0,252,255))
    :move(820,160)
    :setAnchorPoint(cc.p(1.0,0.5))
    :addTo(self.spBJ)
    
    --游戏豆      持有后面 
    self._priceTag1 = display.newSprite("Shop/Detail/text_detail_5_0.png")
            :setAnchorPoint(cc.p(1.0,0.5))
            :move(970,404-(60*(5-1)))
            :addTo(self.spBJ)



    
    if not self._isMeili then   --不是魅力赠送
        --道具价格，折扣，折后价格，字样  
        for i=1,3 do
               display.newSprite("Shop/Detail/text_detail_"..i..".png")
                :move(503,404-(60*(i-1)))
            :addTo(self.spBJ)
        end   

        --游戏豆/个      道具价格后面
        self._priceTag2 = display.newSprite("Shop/Detail/text_detail_6_0.png")
                :setAnchorPoint(cc.p(1.0,0.5))
                :move(970,404-(60*(1-1)))
                :addTo(self.spBJ)
        -- 道具单价txt
        self._txtPrice1 =    cc.Label:createWithTTF("0", "fonts/round_body.ttf", 30)
                :setColor(cc.c3b(252,255,31)) 
                :move(820,405) -- 439-(46*(1-1))
                :setAnchorPoint(cc.p(1,0.5))
        :addTo(self.spBJ)

       
        --游戏豆/个  折后价格后面
        self._priceTag3 = display.newSprite("Shop/Detail/text_detail_6_0.png")
                :setAnchorPoint(cc.p(1.0,0.5))
                :move(970,404-(60*(3-1)))
                :addTo(self.spBJ)


        local vip = GlobalUserItem.cbMemberOrder or 0
        local bShowDiscount = vip ~= 0
        self.m_discount = 100
        if vip ~= 0 then
            self.m_discount = GlobalUserItem.MemberList[vip]._shop
        end    
        -- 折扣
        self._txtDiscount = cc.Label:createWithTTF(self.m_discount .. "%折扣", "fonts/round_body.ttf", 24)
             :setAnchorPoint(cc.p(1.0,0.5))
                :move(1090,380)
                :setTextColor(cc.c4b(255,0,0,255))
                :setVisible(bShowDiscount)
                :addTo(self)
        -- 会员标识
        local sp_vip = cc.Sprite:create("Information/atlas_vipnumber.png")
        if nil ~= sp_vip then
           sp_vip:setPosition(1090 - self._txtDiscount:getContentSize().width - 20, 380)
            self:addChild(sp_vip)
            sp_vip:setTextureRect(cc.rect(28*vip,0,28,26))
            sp_vip:setVisible(bShowDiscount)
        end
        -- 折后价格
        self._txtPrice2 = cc.Label:createWithTTF("0", "fonts/round_body.ttf", 30)
                :setColor(cc.c3b(252,255,31))  
                :move(820,284) -- 439-(46*(3-1))
                :setAnchorPoint(cc.p(1.0,0.5))
                :addTo(self.spBJ)

         --购买后立即使用按钮
        ccui.Button:create("Shop/Detail/bt_detail_1_0.png","Shop/Detail/bt_detail_1_1.png")
                :move(734,88)
                :setTag(ShopDetailLayer.BT_BUY2)
                :addTo(self.spBJ)
                :addTouchEventListener(self._btcallback)

    else   --魅力商品
        --立即赠送
        ccui.Button:create("Shop/Detail/btnSend_0.png","Shop/Detail/btnSend_1.png")
                :move(734,88)
                :setTag(ShopDetailLayer.BT_BUY3)
                :addTo(self.spBJ)
                :addTouchEventListener(self._btcallback)

        --赠送对象字
        display.newSprite("Shop/Detail/spSendID.png")
        :move(  533,387)
        :addTo(self.spBJ)
        --赠送对象ID
        display.newSprite("Shop/Detail/frame_detail_2.png")   --输入框背景
            :move(802,387)
            :addTo(self.spBJ)
        -- 编辑框
        local editbox = ccui.EditBox:create(cc.size(342, 48),"blank.png",UI_TEX_TYPE_PLIST)
            :setPosition(cc.p(802,387))
            :setFontName("fonts/round_body.ttf")
            :setPlaceholderFontName("fonts/round_body.ttf")
            :setFontSize(30)
            :setMaxLength(8)
            :setPlaceholderFontColor(cc.c3b(127,113,217))
            :setFontColor(cc.c3b(255,240,189))
            :setPlaceholderFontSize(30)
            :setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
        self.spBJ:addChild(editbox)
        --editbox:setVisible(false)
       -- editbox:setText("1")
       -- editbox:registerScriptEditBoxHandler(editHanlder)
        self.m_sendID = editbox


        --银行密码
        --银行密码字
        display.newSprite("Shop/Detail/spBankCode.png")
        :move(  503,307)
        :addTo(self.spBJ)
        display.newSprite("Shop/Detail/frame_detail_2.png")   --输入框背景
            :move(802,307)
            :addTo(self.spBJ)
        -- 编辑框
        local editbox = ccui.EditBox:create(cc.size(342, 48),"blank.png",UI_TEX_TYPE_PLIST)
            :setPosition(cc.p(802,307))
            :setFontName("fonts/round_body.ttf")
            :setPlaceholderFontName("fonts/round_body.ttf")
            :setFontSize(30)
            :setMaxLength(8)
            :setPlaceholderFontColor(cc.c3b(127,113,217))
            :setFontColor(cc.c3b(255,240,189))
            :setPlaceholderFontSize(30)
            :setInputFlag (cc.EDITBOX_INPUT_FLAG_PASSWORD)
            :setInputMode (cc.EDITBOX_INPUT_MODE_SINGLELINE)
        self.spBJ:addChild(editbox)
        --editbox:setVisible(false)
       -- editbox:setText("2")
       -- editbox:registerScriptEditBoxHandler(editHanlder)
        self.m_bankCode = editbox

    end

    self:onUpdatePrice()
    self:onUpdateNum()

	--功能描述
	cc.Label:createWithTTF("功能："..self._item.description, "fonts/round_body.ttf", 22)
        	:setAnchorPoint(cc.p(0.0,0.5))
        	:move(70,102)
             :setLineBreakWithoutSpace(true)
             :setMaxLineWidth (280)
             :setAlignment(cc.TEXT_ALIGNMENT_LEFT)
       		:setTextColor(cc.c4b(136,164,224,255))
    :addTo(self.spBJ)

    -- 通知监听
    self.m_listener = cc.EventListenerCustom:create(yl.RY_USERINFO_NOTIFY,handler(self, self.onUserInfoChange))
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.m_listener, self)
end

function ShopDetailLayer:onUserInfoChange( event  )
    local msgWhat = event.obj

    if nil ~= msgWhat and msgWhat == yl.RY_MSG_USERWEALTH then
        --更新财富
        self:onUpdatePrice()
    end
end

--按键监听
function ShopDetailLayer:onButtonClickedEvent(tag,sender)
             ExternalFun.playClickEffect()            

	if tag == ShopDetailLayer.BT_ADD then
        if self._buyNum < 9998 then
            self._buyNum = self._buyNum+1
            self.m_editNumber:setText(self._buyNum .. "")
            self:onUpdateNum()
        end
	elseif tag == ShopDetailLayer.BT_MIN then
		if self._buyNum > 1 then
            self.m_editNumber:setText(self._buyNum .. "")
			self._buyNum = self._buyNum-1
			self:onUpdateNum()
		end
	elseif tag == ShopDetailLayer.BT_BUY1 then
        if GlobalUserItem.cbInsureEnabled == 0 and self._type == yl.CONSUME_TYPE_GOLD then
            showToast(self, "未设置银行密码，无法使用", 3)
            return
        end
		self._toUse = 0
        self._scene:showPopWait()
		self._shopDetailFrame:onPropertyBuy(self._type, self._buyNum, self._item.id, 0)
	
    elseif tag == ShopDetailLayer.BT_BUY2 then
        if GlobalUserItem.cbInsureEnabled == 0 and self._type == yl.CONSUME_TYPE_GOLD then
            showToast(self, "未设置银行密码，无法使用", 3)
            return
        end
        
        self._scene:showPopWait()
        --判断是否是消耗小喇叭
        if self._item.id == yl.SMALL_TRUMPET then
        else
            self._toUse = 1
            self._shopDetailFrame:onPropertyBuy(self._type,self._buyNum,self._item.id,1)
        end

    --立即赠送   --走另外一条发送消息(logon server)
    elseif tag == ShopDetailLayer.BT_BUY3 then
        if GlobalUserItem.cbInsureEnabled == 0 and self._type == yl.CONSUME_TYPE_GOLD then
            showToast(self, "未设置银行密码，无法使用", 3)
            return
        end
        self._scene:showPopWait()
        local gameidStr = self.m_sendID:getText()
        if string.len(gameidStr) < 6 then 
            showToast(self, "赠送对象ID为6位数字，请重新输入", 3)
            self._scene:dismissPopWait()
            return
        end
        local gameid = tonumber(gameidStr)
        if gameid == nil then
            showToast(self, "赠送对象ID为6位数字，请重新输入2", 3)
            self._scene:dismissPopWait()
            return
        end

        local password = self.m_bankCode:getText()
        --gameID, count, id, password
        print("gameid,  self._buyNum, self._item.id, password", gameid,  self._buyNum, self._item.id, password)
        self._shopDetailFrame:onLovelinessSend(gameid,  self._buyNum, self._item.id, password)

    elseif tag == ShopDetailLayer.BT_BLANK then   --编辑框下面的按钮
        self.m_editNumber:setVisible(true)
        self.m_editNumber:touchDownAction(self.m_editNumber, ccui.TouchEventType.ended)
	end
end

function ShopDetailLayer:onSelectedEvent(tag,sender,eventType)
    ExternalFun.playClickEffect()
	if self._select == tag then
		self:getChildByTag(tag):setSelected(true)
		return
	end

	self._select = tag
	self:onUpdatePrice()
	self:onUpdateNum()

	for i=1,ShopDetailLayer.CBT_LOVELINESS do
		if i ~= tag then
			if self:getChildByTag(i) then
				self:getChildByTag(i):setSelected(false)
			end
		end
	end

end

function ShopDetailLayer:onUpdatePrice()

    if not self._isMeili then   --不是魅力
        self._priceTag1:setTexture("Shop/Detail/text_detail_5_"..(self._select-1)..".png")   --持有
        self._priceTag2:setTexture("Shop/Detail/text_detail_6_"..(self._select-1)..".png")   --道具
        self._priceTag3:setTexture("Shop/Detail/text_detail_6_"..(self._select-1)..".png")   --折后
        self._priceTag4:setTexture("Shop/Detail/text_detail_7_"..(self._select-1)..".png")   --购买
    else
        self._priceTag1:setTexture("Shop/Detail/text_detail_5_"..(self._select-1)..".png")   --持有
        self._priceTag4:setTexture("Shop/Detail/text_detail_7_"..(self._select-1)..".png")
    end


	local priceStr = ""
	if self._select == ShopDetailLayer.CBT_BEAN then
		self._type = yl.CONSUME_TYPE_CASH
		priceStr = string.formatNumberThousands(GlobalUserItem.dUserBeans,true,",")
	
    elseif self._select == ShopDetailLayer.CBT_INGOT then
		self._type = yl.CONSUME_TYPE_USEER_MADEL
		priceStr = string.formatNumberThousands(GlobalUserItem.lUserIngot,true,",")
	
    elseif self._select == ShopDetailLayer.CBT_GOLD then
		self._type = yl.CONSUME_TYPE_GOLD
		priceStr = string.formatNumberThousands(GlobalUserItem.lUserScore,true,",")
	
    elseif self._select == ShopDetailLayer.CBT_LOVELINESS then
		self._type = yl.CONSUME_TYPE_LOVELINESS
		priceStr = string.formatNumberThousands(GlobalUserItem.dwLoveLiness,true,",")
	end

	self._txtPrice:setString(priceStr)
end

function ShopDetailLayer:onUpdateNum()
    self._txtNum:setVisible(true)
    self._txtNum:setString(string.formatNumberThousands(self._buyNum,true,","))

	local itemPrice = 0
	if self._select == ShopDetailLayer.CBT_BEAN then
		itemPrice = self._item.bean
	elseif self._select == ShopDetailLayer.CBT_INGOT then
		itemPrice = self._item.ingot
	elseif self._select == ShopDetailLayer.CBT_GOLD then
		itemPrice = self._item.gold
	elseif self._select == ShopDetailLayer.CBT_LOVELINESS then
		itemPrice = self._item.loveliness
	end


   
    --购买价格
    if not self._isMeili then   --不是魅力
        self._txtPrice1:setString(string.formatNumberThousands(itemPrice,true,","))     --道具价格
        self._txtPrice2:setString(string.formatNumberThousands(itemPrice * (self.m_discount * 0.01) ,true,","))     --折后价格
	    self._txtPrice3:setString(string.formatNumberThousands(itemPrice * self._buyNum  * (self.m_discount * 0.01),true,","))   --购买价格
  
    --modified by cgp
    else  --魅力商品
        self._txtPrice3:setString(string.formatNumberThousands(itemPrice * self._buyNum, true,","))
    end
end

--操作结果
function ShopDetailLayer:onShopDetailCallBack(result,message)
	print("======== ShopDetailLayer:onShopDetailCallBack ========", result,  message )
    
    local bRes = false
	self._scene:dismissPopWait()
	if type(message) == "string" and message ~= "" then
        showToast(self,message,2)		
        if message == "赠送魅力成功！" then  --赠送成功，关闭赠送界面
            print("赠送魅力成功！")
            self:removeFromParent()
        end
            
	end

    --大喇叭购买且消费
    if result == yl.SUB_GP_PROPERTY_BUY_RESULT and 1 == self._toUse and message == yl.LARGE_TRUMPET then 
        self._toUse = 0    
        if nil ~= self._scene.getTrumpetSendLayer then
            bRes = true
            self._scene:getTrumpetSendLayer()
        end        
    end
    return bRes
end

function ShopDetailLayer:onEditEvent(event,editbox)
    if event == "began" then
        self._txtNum:setVisible(false)
    elseif event == "return" then
        local ndst = tonumber(editbox:getText())
        if "number" == type(ndst) then
            self._buyNum = ndst
        end
        editbox:setVisible(false)
        self:onUpdateNum()
    end
end

return ShopDetailLayer