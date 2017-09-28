--[[
	我的代理界面
	2016_06_23 Ravioyla
]]
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local AgentLayer = class("AgentLayer", function(scene)
		local agentLayer = display.newLayer(cc.c4b(0, 0, 0, 0))
    return agentLayer
end)

AgentLayer.WEB_AGENT_INFO			= 1
AgentLayer.WEB_AGENT_SCALEINFO		= 2
AgentLayer.WEB_AGENT_CHILDINFO		= 3
AgentLayer.WEB_AGENT_PAYINFO		= 4
AgentLayer.WEB_AGENT_REVENUEINFO	= 5
AgentLayer.WEB_AGENT_PAYBACKINFO	= 6
function AgentLayer:onTouchBegan (touch, event)
    return true
end
-- 进入场景而且过渡动画结束时候触发。
function AgentLayer:onEnterTransitionFinish()
    return self
end

-- 退出场景而且开始过渡动画时候触发。
function AgentLayer:onExitTransitionStart()
    return self
end

function AgentLayer:ctor(scene)
	
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

    self._webSelect = AgentLayer.WEB_AGENT_INFO

    self._webList = {
    	"/Mobile/Agent/AgentInfo.aspx",
    	"/Mobile/Agent/AgentScaleInfo.aspx",
    	"/Mobile/Agent/AgentChildInfo.aspx",
    	"/Mobile/Agent/AgentPayInfo.aspx",
    	"/Mobile/Agent/AgentRevenueInfo.aspx",
    	"/Mobile/Agent/AgentPayBackInfo.aspx"
	}

 
    display.newSprite("Agent/ag_daili.jpg")
    	:move(yl.WIDTH/2,yl.HEIGHT/2)
    	:addTo(self)

        ccui.Button:create("General/bt_close_0.png","")
		:move(yl.WIDTH-51,yl.HEIGHT-45)
		:addTo(self)
		:addTouchEventListener(function(ref, type)
       		 	if type == ccui.TouchEventType.ended then
					 self:removeFromParent()
				end
			end)

 

	--代理信息
    ccui.CheckBox:create("Agent/bt_agent_0_0.png","","Agent/bt_agent_0_1.png","","")
		:move(147,589)
		:addTo(self)
		:setSelected(true)
		:setTag(AgentLayer.WEB_AGENT_INFO)
		:addEventListener(cbtlistener)

	--分成信息
    ccui.CheckBox:create("Agent/bt_agent_1_0.png","","Agent/bt_agent_1_1.png","","")
		:move(147,490)
		:addTo(self)
		:setSelected(false)
		:setTag(AgentLayer.WEB_AGENT_SCALEINFO)
		:addEventListener(cbtlistener)

	--注册信息
    ccui.CheckBox:create("Agent/bt_agent_2_0.png","","Agent/bt_agent_2_1.png","","")
		:move(147,391)
		:addTo(self)
		:setSelected(false)
		:setTag(AgentLayer.WEB_AGENT_CHILDINFO)
		:addEventListener(cbtlistener)

	--充值信息
    ccui.CheckBox:create("Agent/bt_agent_3_0.png","","Agent/bt_agent_3_1.png","","")
		:move(147,292)
		:addTo(self)
		:setSelected(false)
		:setTag(AgentLayer.WEB_AGENT_PAYINFO)
		:addEventListener(cbtlistener)

	--税收信息
    ccui.CheckBox:create("Agent/bt_agent_4_0.png","","Agent/bt_agent_4_1.png","","")
		:move(147,193)
		:addTo(self)
		:setSelected(false)
		:setTag(AgentLayer.WEB_AGENT_REVENUEINFO)
		:addEventListener(cbtlistener)

	--返现信息
    ccui.CheckBox:create("Agent/bt_agent_5_0.png","","Agent/bt_agent_5_1.png","","")
		:move(147,94)
		:addTo(self)
		:setSelected(false)
		:setTag(AgentLayer.WEB_AGENT_PAYBACKINFO)
		:addEventListener(cbtlistener)

	-- self:getURL(AgentLayer.WEB_AGENT_INFO)
	-- self._webView = ccexp.WebView:create()
	-- 	:setScalesPageToFit(true)
	-- 	:loadURL(self:getURL(AgentLayer.WEB_AGENT_INFO))
	-- 	:setContentSize(cc.size(970,520))
	-- 	:setPosition(788,320)

	-- self._webView:reload()
	--平台判定
	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_ANDROID == targetPlatform) then
		--反馈页面
		self.m_webView = ccexp.WebView:create()
	    self.m_webView:setPosition(810,335)
	    self.m_webView:setContentSize(1020,640)
	    
	    self.m_webView:setScalesPageToFit(true)
	    
        if ExternalFun.visibleWebView(self.m_webView, false) then
            self._scene:showPopWait()
        end
	    self.m_webView:loadURL(self:getURL(self._webSelect))

	    self.m_webView:setOnDidFailLoading(function ( sender, url )
	    	self._scene:dismissPopWait()
	    	print("open " .. url .. " fail")
	    end)
	    self.m_webView:setOnShouldStartLoading(function(sender, url)
	        print("onWebViewShouldStartLoading, url is ", url)	        
	        return true
	    end)
	    self.m_webView:setOnDidFinishLoading(function(sender, url)
	    	self._scene:dismissPopWait()
            ExternalFun.visibleWebView(self.m_webView, true)
	        print("onWebViewDidFinishLoading, url is ", url)
	    end)

	    self.m_webView:setOnJSCallback(function ( sender, url )
	    	    	
	    end)
	    self:addChild(self.m_webView)
	end
end

--按键监听
function AgentLayer:onButtonClickedEvent(tag,sender)

end

function AgentLayer:onSelectedEvent(tag,sender,eventType)
	ExternalFun.playClickEffect()
	if self._webSelect == tag then
		return
	end

	self._webSelect = tag

	for i=1,#self._webList do
		if i ~= tag then
			self:getChildByTag(i):setSelected(false)
		end
	end

	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_ANDROID == targetPlatform) then
		
        if ExternalFun.visibleWebView(self.m_webView, false) then
            self._scene:showPopWait()
        end
        
		self.m_webView:loadURL(self:getURL(tag))
	end	
end

--获取网址
function AgentLayer:getURL(tag)
	local url = yl.HTTP_URL .. "/SyncLogin.aspx?userid="..GlobalUserItem.dwUserID.."&time="..os.time().."&signature="..GlobalUserItem:getSignature(os.time()).."&url="..self._webList[tag]
	print(url)
	return url
end

return AgentLayer