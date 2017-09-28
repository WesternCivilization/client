--
-- Author: zhong
-- Date: 2016-08-09 09:40:00
--

--魅力游戏转盘界面
 
local TableMeiliLayer = class("TableMeiliLayer", function(scene)
		local tableLayer = display.newLayer(cc.c4b(0, 0, 0, 64))
    return tableLayer
end)


local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
local ostime = os.time()

function TableMeiliLayer:ctor(scene)
	self._scene = scene

	--注册触摸事件
	ExternalFun.registerTouchEvent(self, true)

	--加载csb资源
	local rootLayer, csbNode = ExternalFun.loadRootCSB("tableMeili/TableMeiliLayer.csb", self)

	--转盘指针
	self.m_SpPointer = csbNode:getChildByName("sp_pointer")

	--开始按钮
	self.m_btnStart = csbNode:getChildByName("start_btn")
    self.m_btnStart:addClickEventListener(function (  )
        ExternalFun.playClickEffect()
        self.m_btnStart:setEnabled(false)
        self:onStartTable()
    end)

    --魅力输入框
    self.mMeiliInput = csbNode:getChildByName("TextField_meili")

    --当前魅力值
    self.mNowMeili = csbNode:getChildByName("Text_meili")

    --活动说明的页面
    self.mImgDesc = csbNode:getChildByName("Image_actDescBg")
    self.mImgDesc:addClickEventListener(function (  )
            ExternalFun.playClickEffect()
            self.mImgDesc:setVisible(not self.mImgDesc:isVisible())
        end)

    --活动说明按钮
    self.mBtnDesc = csbNode:getChildByName("btn_actDesc")
                :addClickEventListener(function (  )
                    ExternalFun.playClickEffect()
                    self.mImgDesc:setVisible(not self.mImgDesc:isVisible())
                end)



    --关闭按钮
    self.mCloseBtn = csbNode:getChildByName("Button_close")
    self.mCloseBtn:addClickEventListener(function ()
        ExternalFun.playClickEffect()
        self:removeFromParent()
    end)

	--是否转盘结束
	 self.m_bRotateOver = true

end

function TableMeiliLayer:onKeyBack( )
	if false == self.m_bRotateOver then
		showToast(self, "暂时不可返回", 2)
		return true
	end
	return false
end

--进入界面执行
function TableMeiliLayer:onEnterTransitionFinish( )
    self:showPopWait()
	--获取魅力值
	local url = yl.HTTP_URL .. "/WS/LovelinessLottery.ashx"
    local params = "action=getlove&userid=" .. GlobalUserItem.dwUserID .. "&time=".. ostime .. "&signature=".. GlobalUserItem:getSignature(ostime)
    print("params --------------------------------------\n ", params)
 	appdf.onHttpJsionTable(url ,"GET", params ,function(jstable,jsdata)
            dump(jstable, "jstable", 6)

            if type(jstable) == "table" then
                local data = jstable["data"]
                if type(data) == "table" then
                    local valid = data["valid"]
                    if nil ~= valid and true == valid then
                        GlobalUserItem.dwLoveLiness = data["CurLove"]
                        self.mNowMeili:setString(GlobalUserItem.dwLoveLiness)
                    end
                end
            end
            self:dismissPopWait()
 	  end)
end



--点击开始按钮
function TableMeiliLayer:onStartTable(  )
    self.m_SpPointer:setRotation(0)
    local  loveLess = tonumber(self.mMeiliInput:getString ())   --输入的魅力值
    if loveLess  and loveLess > 0   and loveLess < 5001 then    --
        local url = yl.HTTP_URL .. "/WS/LovelinessLottery.ashx"
        local params = "action=lovelottery&LtLove=" ..loveLess.. "&userid=" .. GlobalUserItem.dwUserID .. "&time=".. ostime .. "&signature=".. GlobalUserItem:getSignature(ostime)
        print("params --------------------------------------\n ", params)
        appdf.onHttpJsionTable(url ,"GET", params,function(jstable,jsdata)
                dump(jstable, "jstable", 6)
                if type(jstable) == "table" then
                    local data = jstable["data"]
                    if type(data) == "table" then
                        local valid = data["valid"]
                        if nil ~= valid and true == valid then
                            local rotate = tonumber(data["rotate"])    --抽奖指针循转角度
                            self.mResultMsg = data["msg"]              --抽奖结果消息

                            self.mCurScore = data["score"]   --当前金币

                            if not rotate then  --rotate为空
                                self.m_btnStart:setEnabled(true)
                                return
                            end
                            if rotate ~= 0 then
                                self:rotateTo(rotate)
                                GlobalUserItem.dwLoveLiness = GlobalUserItem.dwLoveLiness - loveLess
                                self.mNowMeili:setString(tonumber(GlobalUserItem.dwLoveLiness))
                                self.mMeiliInput:setString("")
                            else
                                showToast(self, self.mResultMsg, 2) 
                                self.m_btnStart:setEnabled(true)
                                self.mMeiliInput:setString("")
                            end
                        end
                    end
                end

            end)
    else  --输入的不合法
        showToast(self, "抽奖魅力范围1~5000，当前输入不在范围！", 2)
        self.m_btnStart:setEnabled(true)
    end
                    
end


--转到那个角度，0为错误，  36,72, ..., 360共10个
function TableMeiliLayer:rotateTo( angles )    --服务器下发的角度
    if 0 == angles then
        self.m_bRotateOver = true
        self.m_btnStart:setEnabled(true)
        return
    end
	print("tableMeli rotate to " .. angles)

	local angle = angles + 360 * 4 
	local act = cc.RotateTo:create(6, angle)
	local easeRotate = cc.EaseCircleActionOut:create(act)
	local call = cc.CallFunc:create(function( )
		print("rotate over")
        AudioEngine.playEffect("sound/cat_coins_fall.wav",false)
		self.m_btnStart:setEnabled(true)
        self._scene:coinDropDownAni(function()
            self.m_bRotateOver = true  
            showToast(self, self.mResultMsg, 2) 
        end)
        
        GlobalUserItem.lUserScore = self.mCurScore or GlobalUserItem.lUserScore
        --通知更新        
		local eventListener = cc.EventCustom:new(yl.RY_USERINFO_NOTIFY)
	    eventListener.obj = yl.RY_MSG_USERWEALTH
	    cc.Director:getInstance():getEventDispatcher():dispatchEvent(eventListener)
	end)
	local seq = cc.Sequence:create(easeRotate, call)
	self.m_SpPointer:stopAllActions()
	self.m_SpPointer:runAction(seq)
end

function TableMeiliLayer:showPopWait()
	self._scene:showPopWait()
end

function TableMeiliLayer:dismissPopWait()
	self._scene:dismissPopWait()
end

return TableMeiliLayer