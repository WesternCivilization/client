local RankingListLayer = class("RankingListLayer", function(scene)
		local rankingListLayer = display.newLayer(cc.c4b(0, 0, 0, 0))
    return rankingListLayer
end)
local PopupInfoHead = appdf.req(appdf.EXTERNAL_SRC .. "PopupInfoHead")
local ExternalFun = appdf.req (appdf.EXTERNAL_SRC .. "ExternalFun")
--继续游戏
RankingListLayer.BT_CONTINUE = 101
local _enSize = 0    --英文字符宽度
local _cnSize = 0    --中文字符宽度

function RankingListLayer:onTouchBegan (touch, event)
    return true
end
-- 进入场景而且过渡动画结束时候触发。
function RankingListLayer:onEnterTransitionFinish()
	if 0 == #self._rankList then
		self._scene:showPopWait()
		
		--appdf.onHttpJsionTable(yl.HTTP_URL .. "/WS/PhoneRank.ashx","GET","action=getscorerank&pageindex=1&pagesize=20&userid="..GlobalUserItem.dwUserID,function(jstable,jsdata)
		--改成魅力排行
		local param = "action=getloverank&pageindex=1&pagesize=20&userid="..GlobalUserItem.dwUserID
		print("param ",  param)
		appdf.onHttpJsionTable(yl.HTTP_URL .. "/WS/PhoneRank.ashx","GET", param ,function(jstable,jsdata)
			self._scene:dismissPopWait()
			dump(jstable, "jstable", 5)
			if type(jstable) == "table" then
				for i = 1, #jstable do
					if i == 1 then     --我自己的信息
						self._myRank.szNickName = jstable[i]["NickName"]
						--self._myRank.lScore = jstable[i]["Score"]
						self._myRank.lScore = jstable[i]["LoveLiness"]
						self._myRank.rank = jstable[i]["Rank"]..""
					--	self._myRank.lv = jstable[i]["Experience"]
						self._myRank.lv = jstable[i]["Experience"]
					
					else    --通用信息
						local item = {}
						item.szNickName = jstable[i]["NickName"]
						--item.lScore = jstable[i]["Score"]..""
						item.lScore = jstable[i]["LoveLiness"]..""
						item.wFaceID = tonumber(jstable[i]["FaceID"])
					--	item.lv = jstable[i]["Experience"]    --
						item.lv = jstable[i]["Experience"]    --
						item.cbMemberOrder = tonumber(jstable[i]["MemberOrder"])
					--  item.dBeans = tonumber(jstable[i]["Currency"])     --金豆
						item.dBeans = tonumber(jstable[i]["Currency"])     --金豆
					--	item.lIngot = tonumber(jstable[i]["UserMedal"])    --元宝
						item.lIngot = tonumber(jstable[i]["UserMedal"])    --元宝
						item.dwGameID = tonumber(jstable[i]["GameID"])
						item.dwUserID = tonumber(jstable[i]["UserID"])
						item.szSign = jstable[i]["szSign"] or "此人很懒，没有签名"
					--	item.szIpAddress = jstable[i]["ip"]     --           
						item.szIpAddress = jstable[i]["ip"]     --           
						table.insert(self._rankList,item)
					end
				end
				GlobalUserItem.tabRankCache["rankMyInfo"] = self._myRank
				GlobalUserItem.tabRankCache["rankList"] = self._rankList
				self:onUpdateShow()
			else
				showToast(self,"抱歉，获取排行榜信息失败！",2,cc.c3b(250,0,0))
			end
		end)
	else
		self:onUpdateShow()
	end	
    return self
end

-- 退出场景而且开始过渡动画时候触发。
function RankingListLayer:onExitTransitionStart()
    return self
end
 
function RankingListLayer:ctor(scene, preTag)
	
	local this = self

	self._scene = scene
	--上一个页面
	self.m_preTag = preTag
	
 
	self._myRank = GlobalUserItem.tabRankCache["rankMyInfo"] or {name = GlobalUserItem.szNickName,lScore = "0",rank = "0"}
	self._rankList = GlobalUserItem.tabRankCache["rankList"] or {}

 
     ExternalFun.registerTouchEvent (self, true)

    local sp_bj=display.newSprite("General/mg_bj_4.png")
		:move(yl.WIDTH/2,yl.HEIGHT /2)
		:addTo(self)
    
    local sp_bj2=display.newSprite("General/mg_bj_3.png")
		:move(sp_bj:getContentSize().width/2,273)
		:addTo(sp_bj)
    
    
	display.newSprite("Rank/biaoti1.png")
		:move(551,636)
		:addTo(sp_bj)

	ccui.Button:create("General/bt_close_0.png","")
		:move(1017,599)
		:addTo(sp_bj)
		:addTouchEventListener(function(ref, type)
       		 	if type == ccui.TouchEventType.ended then
					scene:removeRanking()
				end
			end)
    local topMy= display.newSprite("Rank/dikuang6.png")
    	:move(546,452)
    	:addTo(sp_bj)

    local y = 61
	--头像
	--[[local texture = display.loadImage("face.png")
	local facex = (GlobalUserItem.cbGender == yl.GENDER_MANKIND and 1 or 0)
	self._myFace = display.newSprite(texture)
		:setTextureRect(cc.rect(facex*200,0,200,200))
		:setScale(46.00/200.00)
		:move(420,y)
		:addTo(self)
	display.newSprite("Rank/dikuang7.png")
		:move(420,y)
		:addTo(self)]]

	local head = PopupInfoHead:createClipHead(GlobalUserItem, 105)
	head:setPosition(62, 65)
	topMy:addChild(head)
	head:setIsGamePop(false)
	--根据会员等级确定头像框
	head:enableHeadFrame(true)
--	head:enableInfoPop(true, cc.p(420, y), cc.p(0, 1))
	self._myFace = head

    local testen = cc.Label:createWithSystemFont("A","Arial", 28)
    _enSize = testen:getContentSize().width
    local testcn = cc.Label:createWithSystemFont("游","Arial", 28)
    _cnSize = testcn:getContentSize().width

    --我上榜后的名字
	self._myName = cc.Label:createWithTTF(string.stringEllipsis(GlobalUserItem.szNickName, _enSize, _cnSize, 300),"fonts/round_body.ttf",28)
	--	self._myName = cc.Label:createWithTTF(GlobalUserItem.szNickName,"fonts/round_body.ttf",26)
    	:move(348,y)
		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		:setAnchorPoint(cc.p(0,0.5))
		:addTo(topMy)

	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onButtonClickedEvent(sender:getTag(), sender);
		end
	end
	-- ccui.Button:create("Rank/anniu3.png","Rank/anniu4.png")
	-- 	:move(870,59)	
	-- 	:setTag(RankingListLayer.BT_CONTINUE)	
	-- 	:addTo(topMy)
	-- 	:addTouchEventListener(btnEvent)

	--我
	 cc.Label:createWithTTF("魅力","fonts/round_body.ttf",28)
		:move(636,61)
		:addTo(topMy)
        :setColor(cc.c3b(0,255,246)) 
        :setAnchorPoint(cc.p(0,0.5))

	self._myRankFlag = display.newSprite("Rank/tubiao8.png")
		:move(224,61)
		:addTo(topMy)
     --   :setAnchorPoint(cc.p(0,0.5))

	-- self._myRankNum = cc.LabelAtlas:_create("10", "Rank/shuzi2.png", 24, 34 , string.byte("0")) 
	-- 		:move(240,y)
	-- 		:setAnchorPoint(cc.p(0.5,0.5))
	-- 		:addTo(self)

	self._myScore = cc.Label:createWithTTF("0","fonts/round_body.ttf",28) 
			:move(756,y)
             :setColor(cc.c3b(251,255,0)) 
			:setAnchorPoint(cc.p(0,0.5))
			:addTo(topMy)

	--游戏列表
	self._listView = cc.TableView:create(cc.size(995, 370))
	self._listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)    
	self._listView:setPosition(cc.p(166,50))
	self._listView:setDelegate()
	self._listView:addTo(self)
	self._listView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)

	self._listView:registerScriptHandler(self.cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
	self._listView:registerScriptHandler(self.tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
	self._listView:registerScriptHandler(self.tableCellTouched, cc.TABLECELL_TOUCHED)
	self._listView:registerScriptHandler(self.numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

end

function RankingListLayer:onUpdateShow()

	local rank = tonumber(self._myRank.rank)
	if rank > 0 and rank < 21 then
		self._myRankFlag:setTexture("Rank/tubiao9.png")
	else
	 	self._myRankFlag:setTexture("Rank/tubiao8.png")
	end 
    local lScore= string.formatNumberThousands(self._myRank.lScore,true,",")
	self._myScore:setString(lScore)
	self._listView:reloadData()
end

function RankingListLayer:onButtonClickedEvent( tag, sender )
             ExternalFun.playClickEffect()            
	
	if RankingListLayer.BT_CONTINUE == tag then
		local enterInfo = self._scene:getEnterGameInfo()
		if nil ~= enterInfo then		
			--回到游戏界面
			GlobalUserItem.nCurGameKind = tonumber(enterInfo._KindID)
			GlobalUserItem.szCurGameName = enterInfo._KindName

			--判断上一个页面是否是房间列表
			if nil ~= self.m_preTag and yl.SCENE_GAMELIST ~= self.m_preTag then
				self._scene:onKeyBack()
			else				
				self._scene:onChangeShowMode(yl.SCENE_ROOMLIST)
			end
		else
			--返回
			self._scene:onKeyBack()
		end
	end
end

---------------------------------------------------------------------

--子视图大小
function RankingListLayer.cellSizeForTable(view, idx)
  	return 995 , 82
end

--子视图数目
function RankingListLayer.numberOfCellsInTableView(view)
	return #view:getParent()._rankList
end
	
--获取子视图
function RankingListLayer.tableCellAtIndex(view, idx)	
	
	local cell = view:dequeueCell()
	
	local item = view:getParent()._rankList[idx+1]

	if not cell then
		local cy = 41
		cell = cc.TableViewCell:new()
		display.newSprite("Rank/dikuang5.png")
			:addTo(cell)
			:move(995/2, cy)
			:setTag(1)

		display.newSprite("Rank/tubiao1.png")
			:move(60,39)
			:setTag(2)
			:addTo(cell)

		--名次数字
          local label = cc.LabelBMFont:create("10", "Rank/pmsz-0.png.fnt")    
        
		--cc.LabelAtlas:_create("10", "Rank/shuzi2.png", 24, 34 , string.byte("0")) 
			label:move(55,25)
			:setTag(3)
			:setAnchorPoint(cc.p(0.5,0.5))
			:addTo(cell)

		display.newSprite("Rank/tubiao7.png")
			:addTo(cell)
			:move(224,39)
 

		cc.Label:createWithTTF("LV0","fonts/round_body.ttf",28)
			:move(248,35)
			:setTag(7)
             :setColor(cc.c3b(2,222,215))
			:setAnchorPoint(cc.p(0,0.5))
			:addTo(cell)
		
		--昵称 
		cc.Label:createWithTTF("游戏玩家", "fonts/round_body.ttf",28)
			:move(348,35)
			:setTag(5)
			:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
			:setAnchorPoint(cc.p(0,0.5))
			:addTo(cell)
		
		--金币标识
		cc.Label:createWithTTF("魅力","fonts/round_body.ttf",28)
			:move(636,38)
			:addTo(cell)
            :setColor(cc.c3b(0,255,246))
             :setAnchorPoint(cc.p(0,0.5))

		--金币
		cc.Label:createWithTTF("0","fonts/round_body.ttf",28)
			:move(756,37)
			:setTag(6)
			:setAnchorPoint(cc.p(0,0.5))
			:addTo(cell)
           :setColor(cc.c3b(251,255,0))
	end
	if cell:getChildByName("cell_face") then
		cell:getChildByName("cell_face"):updateHead(item)
	else
		--头像
		local head = PopupInfoHead:createClipHead(item, 52)
		head:setPosition(143,45)
		head:setIsGamePop(false)
		head:enableHeadFrame(true)
		head:enableInfoPop(true, cc.p(397, 0), cc.p(0, 0.5))
		cell:addChild(head)
		head:setName("cell_face")
	end

	local rankidx = (idx+1)..""
	if  rankidx ~= view:getParent()._myRank.rank then
		cell:getChildByTag(1):setTexture("Rank/dikuang5.png")
	else
		cell:getChildByTag(1):setTexture("Rank/dikuang4.png")
	end

	if idx == 0 then
		cell:getChildByTag(2):setTexture("Rank/tubiao1.png")
		cell:getChildByTag(2):setVisible(true)
		cell:getChildByTag(3):setVisible(false)
	elseif idx == 1 then
		cell:getChildByTag(2):setTexture("Rank/tubiao2.png")
		cell:getChildByTag(2):setVisible(true)
		cell:getChildByTag(3):setVisible(false)
	elseif idx == 2 then 
		cell:getChildByTag(2):setTexture("Rank/tubiao3.png")
		cell:getChildByTag(2):setVisible(true)
		cell:getChildByTag(3):setVisible(false)
	else
		cell:getChildByTag(2):setVisible(false)
		cell:getChildByTag(3):setString((idx+1).."")
		cell:getChildByTag(3):setVisible(true)
	end
	
	--cell:getChildByTag(7):setString("LV"..tostring(item.lv))   
	cell:getChildByTag(7):setString("")  --等级去掉了

	local cutNickName = string.stringEllipsis(item.szNickName, _enSize, _cnSize, 300)
	--cell:getChildByTag(5):setString(item.szNickName)
	cell:getChildByTag(5):setString(cutNickName)
	cell:getChildByTag(6):setString(string.formatNumberThousands(item.lScore,true,","))

	return cell
end

function RankingListLayer.tableCellTouched(view, cell)
	if nil ~= cell then
		local face = cell:getChildByName("cell_face")
		if nil ~= face then
			face:onTouchHead()
		end
	end
end
---------------------------------------------------------------------
return RankingListLayer