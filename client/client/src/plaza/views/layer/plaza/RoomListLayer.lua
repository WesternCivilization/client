local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local RoomListLayer = class("RoomListLayer", function(scene)
	local roomlist_layer = display.newLayer()
    return roomlist_layer
end)

-- 进入场景而且过渡动画结束时候触发。
function RoomListLayer:onEnterTransitionFinish()
    return self
end
-- 退出场景而且开始过渡动画时候触发。
function RoomListLayer:onExitTransitionStart()
    return self
end
function RoomListLayer:onSceneAniFinish()
end


function RoomListLayer:ctor(scene, isQuickStart)
	self._scene = scene
	local this = self
	self.m_bIsQuickStart = isQuickStart or false

	local enterGame = self._scene:getEnterGameInfo()
	--缓存资源
	local modulestr = string.gsub(enterGame._KindName, "%.", "/")
	local path = "game/" .. modulestr .. "res/roomlist/roomlist.plist"	
	if false == cc.SpriteFrameCache:getInstance():isSpriteFramesWithFileLoaded(path) then
		if cc.FileUtils:getInstance():isFileExist(path) then
			cc.SpriteFrameCache:getInstance():addSpriteFrames(path)
		end
	end	

	--区域设置
	self:setContentSize(yl.WIDTH,yl.HEIGHT)
	--加载csb资源
	local rootLayer, csbNode = ExternalFun.loadRootCSB( "RoomList/RoomListNode.csb", self )
	csbNode:setPosition(yl.WIDTH /2,  yl.HEIGHT /2)
	self.mCSBNode = csbNode

	local gameTitleName = "GameList/game_"..enterGame._KindID..".png"
	local imgTitle = csbNode:getChildByName("Image_title")
	imgTitle:loadTexture(gameTitleName)

	self.mListView = csbNode:getChildByName("ListView_roomList")


	--房间列表
	self.m_tabRoomListInfo = {}
	for k,v in pairs(GlobalUserItem.roomlist) do
		if tonumber(v[1]) == GlobalUserItem.nCurGameKind then
			local listinfo = v[2]
			if type(listinfo) ~= "table" then
				break
			end
			local normalList = {}
			for k,v in pairs(listinfo) do
				if v.wServerType ~= yl.GAME_GENRE_PERSONAL then
					table.insert( normalList, v)
				end
			end
			self.m_tabRoomListInfo = normalList
			break
		end
	end	


	--两排listView
	local itemSize = #self.m_tabRoomListInfo
   
	local itemHeigth = 186
	local halfItemWidth = 374 * 0.5
    
    self.mListView:setItemsMargin(itemHeigth + 6)
	for i = 1, itemSize / 2 do   
		local oneNode = cc.CSLoader:createNode("RoomList/RoomCellNode.csb")
		local oneNode2 = cc.CSLoader:createNode("RoomList/RoomCellNode.csb")
		local oneLayout = ccui.Layout:create()
		oneLayout:addChild(oneNode)
		oneLayout:addChild(oneNode2)
		oneNode:setPosition(cc.p(halfItemWidth + 6, -itemHeigth * 0.5));
		oneNode2:setPosition(cc.p(halfItemWidth * 3 + 12 , -itemHeigth * 0.5));

		local imgCell = oneNode:getChildByName("Image_cellBg")
		local txtName = oneNode:getChildByName("Text_roomName")
		local txtNum = oneNode:getChildByName("Text_limitNum")
		local iIndex = 2 * i - 1

		imgCell:setSwallowTouches(false)
		imgCell:addClickEventListener(
			function(sender)
                local beginPos = sender:getTouchBeganPosition()
			    local endPos = sender:getTouchEndPosition()
			  
			    if math.abs(endPos.x - beginPos.x) > 10 
			        or math.abs(endPos.y - beginPos.y) > 10 then
			        print("roomlist:onButtonClickedEvent ==> MoveTouch Filter")
			        return
			    end
		        self:tableCellTouched(iIndex)
		    end)

		txtName:setString(self.m_tabRoomListInfo[iIndex].szServerName)
		txtNum:setString(self.m_tabRoomListInfo[iIndex].lEnterScore)

		local imgCell2 = oneNode2:getChildByName("Image_cellBg")
		local txtName2 = oneNode2:getChildByName("Text_roomName")
		local txtNum2 = oneNode2:getChildByName("Text_limitNum")
		local iIndex2 = 2 * i 

		imgCell2:setSwallowTouches(false)
		imgCell2:addClickEventListener(
			function(sender)
				local beginPos = sender:getTouchBeganPosition()
			    local endPos = sender:getTouchEndPosition()
			  
			    if math.abs(endPos.x - beginPos.x) > 10 
			        or math.abs(endPos.y - beginPos.y) > 10 then
			        print("roomlist:onButtonClickedEvent ==> MoveTouch Filter")
			        return
			    end
		        self:tableCellTouched(iIndex2)
		    end)

		txtName2:setString(self.m_tabRoomListInfo[iIndex2].szServerName)
		txtNum2:setString(self.m_tabRoomListInfo[iIndex2].lEnterScore)

		self.mListView:pushBackCustomItem(oneLayout)
	end

	for i = 1, itemSize % 2 do   
		local oneNode = cc.CSLoader:createNode("RoomList/RoomCellNode.csb")
		local oneLayout = ccui.Layout:create()
		oneLayout:addChild(oneNode)
		oneNode:setPosition(cc.p(halfItemWidth + 6, -itemHeigth * 0.5));

		local imgCell = oneNode:getChildByName("Image_cellBg")
		local txtName = oneNode:getChildByName("Text_roomName")
		local txtNum = oneNode:getChildByName("Text_limitNum")
		local iIndex = 2 * i - 1
		imgCell:addClickEventListener(
			function(sender)
				 local beginPos = sender:getTouchBeganPosition()
			    local endPos = sender:getTouchEndPosition()
			  
			    if math.abs(endPos.x - beginPos.x) > 10 
			        or math.abs(endPos.y - beginPos.y) > 10 then
			        print("roomlist:onButtonClickedEvent ==> MoveTouch Filter")
			        return
			    end
		        self:tableCellTouched(iIndex)
		    end)
		txtName:setString(self.m_tabRoomListInfo[iIndex].szServerName)
		txtNum:setString(self.m_tabRoomListInfo[iIndex].lEnterScore)

		self.mListView:pushBackCustomItem(oneLayout)
	end

	--房间列表
	self:registerScriptHandler(function(eventType)
		if eventType == "enterTransitionFinish" then	-- 进入场景而且过渡动画结束时候触发。
			this:onEnterTransitionFinish()
		elseif eventType == "exitTransitionStart" then	-- 退出场景而且开始过渡动画时候触发。
			this:onExitTransitionStart()
		end
	end)

	if true == self.m_bIsQuickStart then
		self:stopAllActions()
		GlobalUserItem.nCurRoomIndex = 1
		self:onStartGame()
	end


end


function RoomListLayer:tableCellTouched(index)  --从1开始
	 ExternalFun.playClickEffect()
	local roominfo = self.m_tabRoomListInfo[index]
	if not roominfo then
		return
	end
	GlobalUserItem.nCurRoomIndex = roominfo._nRoomIndex
	GlobalUserItem.bPrivateRoom = (roominfo.wServerType == yl.GAME_GENRE_PERSONAL)
	if self._scene:roomEnterCheck() then
		self._scene:onStartGame()
	end	
end



function RoomListLayer:onStartGame(index)
	local iteminfo = GlobalUserItem.GetRoomInfo(index)
	if iteminfo ~= nil then
		self._scene:onStartGame(index)
	end
end

return RoomListLayer