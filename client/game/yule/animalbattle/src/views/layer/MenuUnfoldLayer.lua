local module_pre = "game.yule.sharkSlot.src"
local ExternalFun =  appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local PopupWithCloseBtnLayer=appdf.req(module_pre .. ".views.layer.PopupWithCloseBtnLayer")
local SettingLayer = appdf.req(module_pre .. ".views.layer.SettingLayer")

local MenuUnfoldLayer=class("MenuPopLayer",cc.Layer)
local popZorder=1
function MenuUnfoldLayer:ctor(scene,menuX,menuY)
	
	introBtn=ccui.Button:create("introbtn.png","introbtndown.png")
	setBtn=ccui.Button:create("setbtn.png","setbtndown.png")
	bankBtn=ccui.Button:create("bankbtn.png","bankbtndown.png")
	playerBtn=ccui.Button:create("playerbtn.png","playerbtndown.png")

	assert(nil~=menuY)
	local offy=(shadow:getContentSize()).height/2-menuHeight/2 
	shadow:setPosition(menuX, menuY-offy)

	introBtn:setPosition(menuX,menuY-menuHeight-30)
	setBtn:setPosition(menuX,menuY-3*menuHeight)

	introBtn:addClickEventListener(function() 
		print("introBtn clicked") 
		ExternalFun.playClickEffect()
		scene:addChild(PopupWithCloseBtnLayer:create("introimg.png"),popZorder)
		 end)
	setBtn:addClickEventListener(function()
		ExternalFun.playClickEffect()
	 print("setBtn clicked")
	  scene:addChild(SettingLayer:create("settingbg.jpg"),popZorder) 
	   end)
	bankBtn:addClickEventListener(function() 
		ExternalFun.playClickEffect()
		scene:addChild(BankLayer:create()) 
		end )
	playerBtn:addClickEventListener(function() 
		ExternalFun.playClickEffect()
		scene:addChild(PlayerlistLayer:create()) 
		end )

	self:addChild(playerBtn)
	self:addChild(bankBtn)
	self:addChild(introBtn)
	self:addChild(setBtn)

	ExternalFun.registerTouchEvent(self,true)
end

function MenuUnfoldLayer:onTouchBegan()
	self:removeFromParent()
	return true
end

return MenuUnfoldLayer

