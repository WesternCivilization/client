--
-- Author: zhong
-- Date: 2016-08-30 18:41:26
--
--常见问题页面
local FaqLayer = class("FaqLayer", cc.Layer)
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
function FaqLayer:onTouchBegan (touch, event)
    return true
end

--返回按钮
local BT_EXIT 		= 101
function FaqLayer:ctor( scene )
	self._scene = scene
    ExternalFun.registerTouchEvent (self, true)
    --加载csb资源
    local rootLayer, csbNode = ExternalFun.loadRootCSB("feedback/FaqLayer.csb", self)
	self.m_csbNode = csbNode

	local function btncallback(ref, type)
        if type == ccui.TouchEventType.ended then
         	self:onButtonClickedEvent(ref:getTag(),ref)
        end
    end
    --返回按钮
    local btn = csbNode:getChildByName("btn_back")
    btn:setTag(BT_EXIT)
    btn:addTouchEventListener(btncallback)

	--local tmp = csbNode:getChildByName("sp_public_frame")
	
	--平台判定
	if (device.platform == "ios") or (device.platform == "android") then
		--页面
		self.m_webView = ccexp.WebView:create()

		local difTop = 50   --头部高度的一半
	    self.m_webView:setPosition(display.cx , display.cy - difTop)
	    self.m_webView:setContentSize(cc.size(1260, 600))
	    
	    self.m_webView:setScalesPageToFit(true)
	    local url = yl.HTTP_URL .. "/Mobile/Faq.aspx"
	    self.m_webView:loadURL(url)
	    ExternalFun.visibleWebView(self.m_webView, false)
	    self._scene:showPopWait()

	    self.m_webView:setOnJSCallback(function ( sender, url )
	    	    	
	    end)

	    self.m_webView:setOnDidFailLoading(function ( sender, url )
	    	self._scene:dismissPopWait()
	    	print("open " .. url .. " fail")
	    end)

	    --just this , 
	    --[[
	    /**
	     * Call before a web view begins loading.
	     *
	     * @param callback The web view that is about to load new content.
	     * @return YES if the web view should begin loading content; otherwise, NO.
	     */
	    ]]
	    self.m_webView:setOnShouldStartLoading(function(sender, url)
	        print("----------------------------------------------------------\n onWebViewShouldStartLoading, url is ", url)	        
	        if string.find(url, "668") then   --含有“668"的需要加载，其他不用。
	        	return true
	        else
	        	return false
	   		end
	    end)
	    
	    self.m_webView:setOnDidFinishLoading(function(sender, url)
	    	self._scene:dismissPopWait()
	    	ExternalFun.visibleWebView(self.m_webView, true)
	        print("++++++++++++++++++++++++ onWebViewDidFinishLoading, url is ", url)
	    end)
	    self:addChild(self.m_webView)
	end
end

function FaqLayer:onButtonClickedEvent( tag, sender )
             ExternalFun.playClickEffect()            

	if BT_EXIT == tag then
        --[[if nil ~= self.m_webView then
			if true == self.m_webView:canGoBack() then
				self.m_webView:goBack()
				return
			end
		end]]
        self:removeFromParent()
    end
end

return FaqLayer