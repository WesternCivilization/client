
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local GameHelpLayer = class("GameHelpLayer", cc.Layer)
GameHelpLayer.BT_CLOSE = 1

function GameHelpLayer:ctor(viewParent)
	self.m_parent = viewParent

	--加载csb资源
	local csbNode = ExternalFun.loadCSB("Help.csb", self)

	--关闭按钮
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onButtonClickedEvent(sender:getTag(), sender);
		end
	end

	local btn = csbNode:getChildByName("Button_close")
	btn:setTag(GameHelpLayer.BT_CLOSE)
	btn:addTouchEventListener(btnEvent)

	self.m_scrollviewContent = csbNode:getChildByName("ScrollView_content")
    self.m_scrollviewContent:setDirection(ccui.ScrollViewDir.vertical)
    self.m_scrollviewContent:setTouchEnabled(true)

    local spriteHelpText = cc.Sprite:create("game_res/helptext.png")
--    spriteHelpText:setAnchorPoint(1, 1)
 --   self.m_scrollviewContent:addChild(spriteHelpText)
    local innerWidth = self.m_scrollviewContent:getContentSize().width
    local innerHeight = self.m_scrollviewContent:getContentSize().height + spriteHelpText:getContentSize().height

--    self.m_scrollviewContent:setInnerContainerSize(cc.p(innerWidth, innerHeight))   

    spriteHelpText:setPosition(cc.p(innerWidth / 2, spriteHelpText:getContentSize().height-30))
    self.m_scrollviewContent:addChild(spriteHelpText)
 
    
end

function GameHelpLayer:onButtonClickedEvent( tag, sender )
	ExternalFun.playClickEffect()
	if GameHelpLayer.BT_CLOSE == tag then
		self:setVisible(false)
	end
end


return GameHelpLayer