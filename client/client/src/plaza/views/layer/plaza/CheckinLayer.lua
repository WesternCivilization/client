--[[
	签到界面
	2016_06_16 Ravioyla
]]

 local CheckinLayer = class("CheckinLayer", function(scene)
		local checkinLayer = display.newLayer(cc.c4b(0, 0, 0, 0))
    return checkinLayer
end)

local CheckinFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.CheckinFrame")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

CheckinLayer.CHECKIN_NUMBER		= 7 		--连续签到天数

-- 进入场景而且过渡动画结束时候触发。
function CheckinLayer:onEnterTransitionFinish()
	if false == GlobalUserItem.bQueryCheckInData then
		self._scene:showPopWait()
		self._checkinFrame:onCheckinQuery()
	else
		self:onCheckinCallBack(1, nil, nil)
	end
    return self
end

-- 退出场景而且开始过渡动画时候触发。
function CheckinLayer:onExitTransitionStart()
    return self
end

function CheckinLayer:onExit()
	if self._checkinFrame:isSocketServer() then
		self._checkinFrame:onCloseSocket()
	end
end

function CheckinLayer:ctor(scene)
	--注册触摸事件
	ExternalFun.registerTouchEvent(self, true)
	
	local this = self

	self._scene = scene

	--网络回调
    local checkinCallBack = function(result,message,subMessage)
		return this:onCheckinCallBack(result,message,subMessage)
	end

	--网络处理
	self._checkinFrame = CheckinFrame:create(self,checkinCallBack)

	local frame

	--加载csb资源
	local rootLayer, csbNode = ExternalFun.loadRootCSB( "Checkin/checkinNode.csb", self )
	csbNode:setPosition(yl.WIDTH /2,  yl.HEIGHT /2)
	self.mCSBNode = csbNode

	local closeBtn = csbNode:getChildByName("Button_close")
	closeBtn:addClickEventListener(
			function(sender)
				ExternalFun.playClickEffect()
				scene:removeCheckinLayer()
		    end)

	self.checkBtn = csbNode:getChildByName("Button_check")
	self.checkBtn:addClickEventListener(
			function(sender)
	            ExternalFun.playClickEffect()            
				self._scene:showPopWait()
				ExternalFun.enableBtn(self.checkBtn, false)
				self._checkinFrame:onCheckinDone()
		    end)

	for i=1, 7 do
		local gold = GlobalUserItem.lRewardGold[i] or 0
		local oneNode = csbNode:getChildByName("Node_" .. i)
		oneNode:getChildByName("disableCell"):setVisible(true)
		oneNode:getChildByName("already"):setVisible(false)
		oneNode:getChildByName("Text_CoinNum"):setString("" .. gold)
	end

	self.txtWeekDay = csbNode:getChildByName("Text_weekDay")
	self.txtToday = csbNode:getChildByName("Text_today")

	--礼物列表
	self.m_giftList = nil
	self.m_spListFrame = nil
	self.m_memberGiftLayer = nil
	self.m_tabGiftList = {}
	self.m_fSix = 0
end

--操作结果
function CheckinLayer:onCheckinCallBack(result, message, subMessage)
	local bRes = false
	self._scene:dismissPopWait()
	if  message ~= nil and message ~= "" then
		showToast(self,message,2)
	end

	if result == 1 then
		self:reloadCheckin()
	end

	if result == 10 and GlobalUserItem.bTodayChecked then
		self._scene:coinDropDownAni(function()
			ExternalFun.enableBtn(self._btConfig, not GlobalUserItem.bTodayChecked)
			self:reloadCheckin()
			local reword = GlobalUserItem.lRewardGold[GlobalUserItem.wSeriesDate] or 0
			showToast(self,"恭喜您获得" .. reword .. "游戏币" ,2)
		end)
	end

	return bRes
end

function CheckinLayer:reloadCheckin()

    --当天
    if not GlobalUserItem.bTodayChecked then    --没有签到，

		local oneNode = self.mCSBNode:getChildByName("Node_" .. (GlobalUserItem.wSeriesDate + 1))
		oneNode:getChildByName("already"):setVisible(false)
		oneNode:getChildByName("disableCell"):setVisible(false)
    	
    	-- self.already    [GlobalUserItem.wSeriesDate]:setVisible(false)
    	-- self.disableCell[GlobalUserItem.wSeriesDate]:setVisible(false)
    end

	--以前的天数, 已签到过
	local haveCheck = nil
	if GlobalUserItem.wSeriesDate ~= 0 then
		for i = 0,GlobalUserItem.wSeriesDate - 1 do
			local oneNode = self.mCSBNode:getChildByName("Node_" .. (i + 1))
			oneNode:getChildByName("already"):setVisible(true)
			oneNode:getChildByName("disableCell"):setVisible(false)
		end		
	end

	--以后的天数
	for i = GlobalUserItem.wSeriesDate + 1, 6 do
		
		local oneNode = self.mCSBNode:getChildByName("Node_" .. (i + 1))
	--	oneNode:getChildByName("already"):setVisible(false)
		oneNode:getChildByName("disableCell"):setVisible(true)

		--self.disableCell[i]:setVisible(true)  --灰色
	end

	if GlobalUserItem.bTodayChecked == true then		
		ExternalFun.enableBtn(self.checkBtn, false)
	else
		ExternalFun.enableBtn(self.checkBtn, true)
	end

end

return CheckinLayer