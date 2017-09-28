local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local GameListLayer = class("GameListLayer", function(gamelist)
    local gamelist_layer = display.newLayer()
    return gamelist_layer
end )

local Update = appdf.req(appdf.BASE_SRC .. "app.controllers.ClientUpdate")
local QueryDialog = appdf.req(appdf.BASE_SRC .. "app.views.layer.other.QueryDialog")
local LogonFrame = appdf.req(appdf.CLIENT_SRC .. "plaza.models.LogonFrame")

-- 进入场景而且过渡动画结束时候触发。
function GameListLayer:onEnterTransitionFinish()
    -- self._listView:reloadData()
    return self
end

-- 退出场景而且开始过渡动画时候触发。
function GameListLayer:onExitTransitionStart()
    return self
end

function GameListLayer:ctor(gamelist)
    print("============= 游戏列表界面创建 =============")
    self.m_bQuickStart = false

    local this = self

    self:setContentSize(yl.WIDTH, yl.HEIGHT)

    self._gameList = gamelist

    local logonCallBack = function(result, message)
        this:onLogonCallBack(result, message)
    end

    self._logonFrame = LogonFrame:create(self, logonCallBack)


    self:registerScriptHandler( function(eventType)
        if eventType == "enterTransitionFinish" then
            -- 进入场景而且过渡动画结束时候触发。
            this:onEnterTransitionFinish()
        elseif eventType == "exitTransitionStart" then
            -- 退出场景而且开始过渡动画时候触发。
            this:onExitTransitionStart()
        elseif eventType == "exit" then
            if self._logonFrame:isSocketServer() then
                self._logonFrame:onCloseSocket()
            end
        end
    end )

    local page = ccui.PageView:create()
    page:setContentSize(cc.size(yl.WIDTH, 420))
    page:setTouchEnabled(true)
    page:setAnchorPoint(0, 0)
    page:setPosition(cc.p(0, 130 + 22))
    self:addChild(page)
    self._pageView = page

    self:initPageview()
     self:initBtn()

    --page:setCurrentPageIndex(1)
    local aa=page:getCurrentPageIndex()
 
--    page:addEventListener(function(sender,event)
--        if event==ccui.PageViewEventType.turning then
--          print("pageview"..page:getCurrentPageIndex())
--         end
--         print("vvvvvvvvvvvvvvvvvvvv",event)
--    end)

    page:addEventListener(function(sender,event)
        if event==ccui.PageViewEventType.turning then
            local index=page:getCurrentPageIndex()
            this:btnVisible(index)
        end
 
    end)
-- 

--    local this=self
--    performWithDelay(this._pageView, function() 
--        print("==============")
--        local  ss=this._pageView:getCurrentPageIndex()

----        local  ss22=this._pageView: setCurPageIndex()

--    end,3)





    self._txtTips = ccui.Text:create("", "fonts/round_body.ttf", 32)
    :setAnchorPoint(cc.p(1, 0))
    :move(yl.WIDTH, 110)
    :setTextColor(cc.c4b(0, 250, 0, 255))
    :addTo(self)

    self.m_fThird = yl.WIDTH / 3

    -- 下载提示
    self.m_spDownloadMask = nil
    self.m_szMaskSize = cc.size(0, 0)
    self.m_labDownloadTip = nil
    self.m_spDownloadCycle = nil
    self.m_bGameUpdate = false
end

function  GameListLayer:btnVisible(index)
    local nMaxLa=#self._pageView:getItems()
    if index==0   then
        self.btleft:setVisible(false) 
    else
        self.btleft:setVisible(true)  
    end 
    if index+1 >= nMaxLa  then
        self.btright:setVisible(false) 
    else
        self.btright:setVisible(true) 
    end 
  
--    self:xydVisible(index+1)
end
function  GameListLayer:xydVisible(index)
    local nMaxLa=#self._pageView:getItems()
 
    for i=1 ,nMaxLa do
        local xyd=self:getChildByTag(300+i)
        local ttf=xyd:getChildByTag(1)
        if index+300 == xyd:getTag() then
            xyd:initWithFile("GameList/gl_yd_.png")
            ttf:setTextColor(cc.c4b(255,0,255,255))
        else
            xyd:initWithFile("GameList/gl_yd.png")
            ttf:setTextColor(cc.c4b(0,255,255,255))
        end

    end

end

function GameListLayer:initBtn()

    local this=self
    local  btcallback = function(ref, type)
        if type == ccui.TouchEventType.ended then
            ExternalFun.playClickEffect()
            local index=this._pageView:getCurrentPageIndex()
            index= index==-1 and 0 or  index
            local nMaxLa=#this._pageView:getItems()
            if ref:getTag() == 100 then
                if index>0  then
                    index=index-1
                end  
            elseif ref:getTag() == 101 then
                if index+1<nMaxLa  then
                    index=index+1 
                end 
            end 
            this._pageView:setCurrentPageIndex(index)   
            this:btnVisible(index)
        end
    end

    --左箭头
    self.btleft = ccui.Button:create("GameList/btn_left.png",filestr)
    self.btleft:addTo(self)
    :move(33,366)
    :setTag(100)
    :setVisible(false)
    :addTouchEventListener(btcallback)
  
    --右箭头
    self.btright = ccui.Button:create("GameList/btn_right.png",filestr)
    self.btright:addTo(self)
    :move(1293,366)
    :setTag(101)
    :setVisible(false)
    :addTouchEventListener(btcallback)

    local nMaxLa=#this._pageView:getItems()
    if nMaxLa>=2 then
        self.btright:setVisible(true)
    end
    

  --  self:xydVisible(1)
end

 

-- 获取父场景节点(ClientScene)
function GameListLayer:getRootNode()
    return self:getParent():getParent()
end

-- 更新游戏进入记录
function GameListLayer:updateEnterGameInfo(info)
    self:getRootNode():updateEnterGameInfo(info)
end

function GameListLayer:onEnterGame(gameinfo, isQuickStart)

    self:updateEnterGameInfo(gameinfo)
    self.m_bQuickStart = isQuickStart

    -- modified by cgp
    -- dump(gameinfo, "gameinfo", 6)
    -- 判断房间获取
   -- dump(GlobalUserItem, "GlobalUserItem", 6)
    local roomCount = GlobalUserItem.GetGameRoomCount(gameinfo._KindID)
    if not roomCount or 0 == roomCount then
        -- self:onLoadGameList(gameinfo._KindID)
        print("GameListLayer 房间列表为空")
    end
    GlobalUserItem.nCurGameKind = tonumber(gameinfo._KindID)
    GlobalUserItem.szCurGameName = gameinfo._KindName
    if PriRoom and true == PriRoom:getInstance():onLoginEnterRoomList() then
        print(" GameListLayer enter priGame ")
    else
        -- 处理锁表
        local lockRoom = GlobalUserItem.GetGameRoomInfo(GlobalUserItem.dwLockServerID)
        if GlobalUserItem.dwLockKindID == GlobalUserItem.nCurGameKind and nil ~= lockRoom then
            GlobalUserItem.nCurRoomIndex = lockRoom._nRoomIndex
            self:getParent():getParent():onStartGame()
        else
            self:getParent():getParent():onChangeShowMode(yl.SCENE_ROOMLIST, self.m_bQuickStart)
        end
    end
end

 
 
function GameListLayer:onBtnClickedEvent(tag,sender)
    ExternalFun.playClickEffect()
	if GlobalUserItem.isAngentAccount() then
		return
	end

    -- 获取游戏信息
    local index=tonumber(sender:getName())
    local gameinfo = self._gameList[index]
    
    if not gameinfo then
        showToast(self, "未找到游戏信息！", 2)
        return
    end
    

    if appdf.noOpenGame then
        --游戏是否开发完成
        local rst = string.find(appdf.noOpenGame, gameinfo._KindID) 
        if rst then    --字符串找到了，即这个游戏没有开发好
             showToast(self, "敬请期待！", 1)
             return
        end
    end

    gameinfo.gameIndex = index

    -- 下载/更新资源 clientscene:getApp
    local app = self:getParent():getParent():getApp()
    local version = tonumber(app:getVersionMgr():getResVersion(gameinfo._KindID))
    if not version or gameinfo._ServerResVersion > version then
        self:updateGame(gameinfo, index)
    else
        self:onEnterGame(gameinfo, false)
    end

  --  self:updateGame(gameinfo, index)


end


-- 创建里面数据
function GameListLayer:initPageview()
    local this=self
    local  btcallback = function(ref, type)
      
        if type == ccui.TouchEventType.began then
            local  posx,posy=ref:getPosition()
            this.beginPoint = ref:getParent():convertToWorldSpace(cc.p(posx,posy))
        end
        if type == ccui.TouchEventType.ended then
--            print("00000000000000000000000000000000000")
            local  posx,posy=ref:getPosition()
            local endPoint = ref:getParent():convertToWorldSpace(cc.p(posx,posy))
            if  this.beginPoint.x == endPoint.x and this.beginPoint.y == endPoint.y then
                this:onBtnClickedEvent(ref:getTag(),ref)
            end
        end
    end


    local ngmlength = #self._gameList
    self.nyeMian = math.ceil(ngmlength / 4)
    local idx = 1
    for i = 1, self.nyeMian do

        local layout = ccui.Layout:create()
--        layout:setBackGroundColor(cc.c3b(255, 0, 0))
--        layout:setBackGroundColorOpacity(200)
--        layout:setBackGroundColorType(LAYOUT_COLOR_SOLID)
      
        self._pageView:addPage(layout)
        --- 一个layout 为一个 page内容

        local nbegin =(i - 1) * 4 + 1
        local nend = i * 4 < ngmlength and i * 4 or ngmlength
        local one = 1
        for j = nbegin, nend do
--            print("============================")
 --           print(nbegin, nend)
            --   local cell = display.newLayer(cc.c4b(0, 0, 0, 0))
            local cell = display.newLayer()
            cell:ignoreAnchorPointForPosition(false)
            cell:setAnchorPoint(0, 0)
            cell:setTag(idx)
            cell:setContentSize(280, 400)
            layout:addChild(cell)

            local cellpos = cc.p(80 +(one - 1) * 20 +(one - 1) * cell:getContentSize().width, 400 * 0.5)
            cell:setPosition(cellpos.x, 10)

            local gameinfo = self._gameList[idx]
            gameinfo.gameIndex = idx
            local filestr = "GameList/game_" .. gameinfo._KindID .. ".png"
            if false == cc.FileUtils:getInstance():isFileExist(filestr) then
                filestr = "GameList/default.png"
            end
            local game = nil
            local mask = nil
            local spTip = nil
  
            --游戏图标,原图,
            game = ccui.Button:create(filestr,filestr)
            game:addTo(cell)
           -- :setScale(0.9)    --added by cgp
            :setScale(1.0)    --added by cgp
            :setSwallowTouches(false)
            :setAnchorPoint(cc.p(0.5, 0))
            :setPosition(cell:getContentSize().width * 0.5, 0 + 20)   --modified by cgp
            :setName(tostring(idx))
            :addTouchEventListener(btcallback)

            local maskSp = cc.Sprite:create(filestr)
            local pos = cc.p(0, 0)
            if nil ~= maskSp then
                maskSp:setColor(cc.BLACK)
                maskSp:setOpacity(100)
                local size = maskSp:getContentSize()
                -- maskSp:setAnchorPoint(cc.p(0, 0))
                maskSp:setPosition(cc.p(size.width * 0.5, size.height * 0.5))
                maskSp:setName("download_mask_sp")


            --变灰的游戏图标
                mask = ccui.Layout:create()
                mask:setClippingEnabled(true)
                mask:setAnchorPoint(cc.p(0.5, 0))
                --mask:setPosition(cc.p(cell:getContentSize().width * 0.5, 0))
                mask:setPosition(cc.p(cell:getContentSize().width * 0.5, 0 + 20))
                mask:setContentSize(size)
                mask:addChild(maskSp)
                cell:addChild(mask)
                mask:setName("download_mask")

                spTip = cc.Label:createWithTTF("", "fonts/round_body.ttf", 32)
                :enableOutline(cc.c4b(0, 0, 0, 255), 1)
                :move(   cell:getContentSize().width/2, cell:getContentSize().height/2)  
                :setName("download_mask_tip")
                :addTo(cell)

                local cycle = cc.Sprite:create("GameList/spinner_circle.png")
                if nil ~= cycle then
                    cycle:move( cell:getContentSize().width/2, cell:getContentSize().height/2) 
                    cycle:setVisible(false)
                    cycle:setScale(1.3)
                    cycle:setName("download_cycle")
                    cell:addChild(cycle)
    
                end
            end

            if nil ~= mask then
                mask:setVisible(not gameinfo._Active)
            end

            if nil ~= spTip then
                spTip:setString("")
            end
            cell:setVisible(true)
            cell:setTag(gameinfo._KindID)
            one = one + 1
            idx=idx+1
        end
    
    end


end
 
---------------------------------------------------------------------

-- 链接游戏
function GameListLayer:onLoadGameList(nKindID)
    if not nKindID then
        self:dismissPopWait()
        local ru = cc.Director:getInstance():getRunningScene()
        if nil ~= ru then
            showToast(ru, "游戏ID有误！", 1)
        end
        return
    end
    GlobalUserItem.nCurGameKind = tonumber(nKindID)
    -- 如果是有游客
    if GlobalUserItem.bVisitor then
        if self._logonFrame:onLogonByVisitor() then
            self:showPopWait()
        end
        -- 如果是第三方
    elseif GlobalUserItem.bThirdPartyLogin then
        local td = GlobalUserItem.thirdPartyData
        -- szAccount, szNick, cbgender, platform
        if self._logonFrame:onLoginByThirdParty(td.szAccount, td.szNick, td.cbGender, td.platform) then
            self:showPopWait()
        end
    else
        if self._logonFrame:onLogonByAccount(GlobalUserItem.szAccount, GlobalUserItem.szPassword) then
            self:showPopWait()
        end
    end
end

-- 链接游戏回掉
function GameListLayer:onLogonCallBack(result, message)
    self:dismissPopWait()
    if message ~= nil and type(message) == "string" then
        local ru = cc.Director:getInstance():getRunningScene()
        if nil ~= ru then
            showToast(ru, message, 2)
        end
    end
    if result == 0 then
        self:onUpdataNotify()
    elseif result == 1 then
        local clientscene = self:getParent():getParent()
        -- 判断是否是快速开始
        if nil ~= clientscene.m_bQuickStart and true == clientscene.m_bQuickStart then
            local roominfo = GlobalUserItem.GetRoomInfo(GlobalUserItem.nCurRoomIndex)
            if nil == roominfo then
                return
            end
            if bit:_and(roominfo.wServerKind, yl.GAME_GENRE_PERSONAL) ~= 0 then
                -- showToast(self, "房卡房间不支持快速开始！", 2)
                return
            end
            clientscene:onStartGame()
        else
            if PriRoom and true == PriRoom:getInstance():onLoginEnterRoomList() then
                print("GameListLayer:onLogonCallBack:GameListLayer enter priGame ")
            else
                -- 处理锁表
                local lockRoom = GlobalUserItem.GetGameRoomInfo(GlobalUserItem.dwLockServerID)
                if GlobalUserItem.dwLockKindID == GlobalUserItem.nCurGameKind and nil ~= lockRoom then
                    GlobalUserItem.nCurRoomIndex = lockRoom._nRoomIndex
                    clientscene:onStartGame()
                else
                    clientscene:onChangeShowMode(yl.SCENE_ROOMLIST, self.m_bQuickStart)
                end
            end
        end
    end
end

-- 显示等待
function GameListLayer:showPopWait(isTransparent)
    self:getParent():getParent():showPopWait(isTransparent)
end

function GameListLayer:showGameUpdateWait()
    self.m_bGameUpdate = true
    ExternalFun.popupTouchFilter(1, false, "游戏更新中,请稍候！")
end

function GameListLayer:dismissGameUpdateWait()
    self.m_bGameUpdate = false
    ExternalFun.dismissTouchFilter()
end

-- 关闭等待
function GameListLayer:dismissPopWait()
    self:getParent():getParent():dismissPopWait()
end

function GameListLayer:updateGame(gameinfo, index)
    local cell = nil
    if nil ~= index then
        local  nym= math.ceil(index / 4)
        local  dd=self._pageView:getItems()
        local uiLayer=dd[nym]
        cell=uiLayer:getChildByTag(gameinfo._KindID)
    end

    self:onGameUpdate(gameinfo)
    if nil ~= cell then
        self.m_spDownloadMask = cell:getChildByName("download_mask")
        if nil ~= self.m_spDownloadMask then
            self.m_szMaskSize = self.m_spDownloadMask:getContentSize()
        end
        self.m_labDownloadTip = cell:getChildByName("download_mask_tip")
        if nil ~= self.m_labDownloadTip then
            self.m_labDownloadTip:setString("0%")
        end
        self.m_spDownloadCycle = cell:getChildByName("download_cycle")
        if nil ~= self.m_spDownloadCycle then
            self.m_spDownloadCycle:stopAllActions()
            self.m_spDownloadCycle:setVisible(true)
            self.m_spDownloadCycle:runAction(cc.RepeatForever:create(cc.RotateBy:create(1.0, 360)))
        end
    end
end

-- 更新游戏
function GameListLayer:onGameUpdate(gameinfo)
    -- 失败重试
    if not gameinfo and self._update ~= nil then
        self:showGameUpdateWait()
        -- self._txtTips:setString("同步服务器信息中...")
        self._update:UpdateFile()
        return
    end

    if not gameinfo and not self._downgameinfo then
        showToast(self, "无效游戏信息！", 1)
        return
    end

    self:showGameUpdateWait()
    -- self._txtTips:setString("同步服务器信息中...")

    -- 记录
    if gameinfo ~= nil then
        self._downgameinfo = gameinfo
    end

    -- 更新参数
    local newfileurl = self:getParent():getParent():getApp()._updateUrl .. "/game/" .. self._downgameinfo._Module .. "/res/filemd5List.json"
    local dst = device.writablePath .. "game/" .. self._downgameinfo._Type .. "/"
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if cc.PLATFORM_OS_WINDOWS == targetPlatform then
        dst = device.writablePath .. "download/game/" .. self._downgameinfo._Type .. "/"
    end

    local src = device.writablePath .. "game/" .. self._downgameinfo._Module .. "/res/filemd5List.json"
    local downurl = self:getParent():getParent():getApp()._updateUrl .. "/game/" .. self._downgameinfo._Type .. "/"

    -- 创建更新
    self._update = Update:create(newfileurl, dst, src, downurl)
    self._update:upDateClient(self)
end

function GameListLayer:onUpdataNotify()
    showToast(self, "游戏版本信息错误！", 1)
end

-- 更新进度
function GameListLayer:updateProgress(sub, msg, mainpersent)
    local permsg = string.format("%d%%", mainpersent)
    if nil ~= self.m_spDownloadMask then
        local scale =(95 - mainpersent) / 100
        self.m_spDownloadMask:setContentSize(self.m_szMaskSize.width, self.m_szMaskSize.height * scale)
    end

    if nil ~= self.m_labDownloadTip then
        self.m_labDownloadTip:setString(permsg)
    end
end

-- 更新结果
function GameListLayer:updateResult(result, msg)
    if nil ~= self.m_spDownloadCycle then
        self.m_spDownloadCycle:stopAllActions()
        self.m_spDownloadCycle:setVisible(false)
    end
    self:dismissGameUpdateWait()

    if result == true then
        local app = self:getParent():getParent():getApp()

        -- 更新版本号
        for k, v in pairs(app._gameList) do
            if v._KindID == self._downgameinfo._KindID then
                app:getVersionMgr():setResVersion(v._ServerResVersion, v._KindID)
                v._Active = true
                break
            end
        end

        self._txtTips:setString("OK")
        self:onEnterGame(self._downgameinfo)
    else
        local runScene = cc.Director:getInstance():getRunningScene()
        if nil ~= runScene then
            if nil ~= self.m_spDownloadMask then
                self.m_spDownloadMask:setContentSize(self.m_szMaskSize.width, self.m_szMaskSize.height)
            end

            if nil ~= self.m_labDownloadTip then
                self.m_labDownloadTip:setString("")
            end

            self._txtTips:setString("")
            QueryDialog:create(msg .. "\n是否重试？", function(bReTry)
                if bReTry == true then
                    self:onGameUpdate(self._downgameinfo)
                end
            end )
            :addTo(runScene)
        end
    end
end

function GameListLayer:onKeyBack()
    return self.m_bGameUpdate ~= false
end

return GameListLayer