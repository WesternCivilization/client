--[[
	服务条款页面
	2016_06_03 Ravioyla
	功能：显示服务条款
]]
local ExternalFun = appdf.req (appdf.EXTERNAL_SRC .. "ExternalFun")
local ServiceLayer = class("ServiceLayer",function()
	local ServiceLayer =  display.newLayer()
    return ServiceLayer
end)

ServiceLayer.BT_EXIT		= 5

ServiceLayer.BT_CONFIRM		= 8
ServiceLayer.BT_CANCEL		= 9

function ServiceLayer:onTouchBegan (touch, event)
    return true
end
function ServiceLayer:ctor(bindReg)
	self:setContentSize(yl.WIDTH,yl.HEIGHT)
	local this = self
    self.BindingRegister= bindReg
    ExternalFun.registerTouchEvent (self, true)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("public/public.plist")





	local  btcallback = function(ref, type)
        if type == ccui.TouchEventType.ended then
         	this:onButtonClickedEvent(ref:getTag(),ref)
        end
    end

	local areaWidth = yl.WIDTH
	local areaHeight = yl.HEIGHT
 

    --背景    (九宫格,第二个参数为原图片的实际矩形, 第三个参数为原图片去掉4个角后的中间矩形, 整个图片的拉伸通过setContentSize)
    local sp_bj = cc.Scale9Sprite:create("public/commonBg.png",cc.rect(0,0,104,104),cc.rect(30,30,44,44))
        :setContentSize(cc.size(1060, 620))
        :move (yl.WIDTH / 2, yl.HEIGHT / 2)
        :addTo(self)



    --标题
    display.newSprite("Service/title_service.png")
    :move (530, 570)
    :addTo (sp_bj)
   
    --关闭
    ccui.Button:create ("public/closebtn.png")
    :move (1020, 580)      --有26的透明像素
    	:setTag(ServiceLayer.BT_EXIT)
        :addTo (sp_bj)
    	:addTouchEventListener(btcallback)

 
 
    -- 读取文本
    self._scrollView = ccui.ScrollView:create()
									  :setContentSize(cc.size(960,420))
									  :setPosition(cc.p(530,330))
                                      :setAnchorPoint(cc.p(0.5, 0.5))
									  :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
									  :setBounceEnabled(true)
									  :setScrollBarEnabled(false)
    :addTo (sp_bj)
    


    --背景
   -- self._scrollView:setBackGroundImage ("General/mg_bj_1.png")
    --self._scrollView:setBackGroundColorType (LAYOUT_COLOR_GRADIENT)

    local str = cc.FileUtils:getInstance():getStringFromFile("Service/Service.txt")
	self._strLabel = cc.Label:createWithTTF(str, "fonts/round_body.ttf", 25)
							 :setAnchorPoint(cc.p(0.5, 0))
						     :setLineBreakWithoutSpace(true)
                             :setMaxLineWidth (960)
							 :setAlignment(cc.TEXT_ALIGNMENT_LEFT)
							 :setTextColor(cc.c4b(195,199,239,255))
						     :addTo(self._scrollView)
    self._strLabel:setPosition (cc.p (960 /2, 0))
	self._scrollView:setInnerContainerSize(cc.size(1130, self._strLabel:getContentSize().height))


    --拒绝
    ccui.Button:create("Service/bt_service_cancel_0.png")
        :move(410,63)
        :setTag(ServiceLayer.BT_CANCEL)
        :addTo (sp_bj)
        :addTouchEventListener(btcallback)

	--按钮
	ccui.Button:create("Service/bt_service_confirm_0.png")
    	:move(675,63)
    	:setTag(ServiceLayer.BT_CONFIRM)
        :addTo (sp_bj)
    	:addTouchEventListener(btcallback)



end

--按键监听
function ServiceLayer:onButtonClickedEvent(tag,sender)
    ExternalFun.playClickEffect()
    if  self.BindingRegister then
        if tag == ServiceLayer.BT_EXIT then
            self:removeFromParent ()
        elseif tag == ServiceLayer.BT_CONFIRM then
            self.BindingRegister:setAgreement (true)
            self:removeFromParent ()
        elseif tag == ServiceLayer.BT_CANCEL then
            self.BindingRegister:setAgreement (false)
            self:removeFromParent ()
        end
    else
        if tag == ServiceLayer.BT_EXIT then
            self:getParent ():getParent ():onShowRegister ()
        elseif tag == ServiceLayer.BT_CONFIRM then
            self:getParent ():getParent ()._registerView:setAgreement (true)
            self:getParent ():getParent ():onShowRegister ()
        elseif tag == ServiceLayer.BT_CANCEL then
            self:getParent ():getParent ()._registerView:setAgreement (false)
            self:getParent ():getParent ():onShowRegister ()
        end
    end


end

return ServiceLayer