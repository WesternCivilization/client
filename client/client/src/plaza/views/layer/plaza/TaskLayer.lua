--[[
	手游任务界面
	2016_06_12 Ravioyla
]]
local ExternalFun = appdf.req (appdf.EXTERNAL_SRC .. "ExternalFun")
local logincmd = appdf.req(appdf.HEADER_SRC .. "CMD_LogonServer")
local TaskLayer = class("TaskLayer", function(scene)
		local taskLayer = display.newLayer(cc.c4b(0, 0, 0, 0))
    return taskLayer
end)

local TaskFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.TaskFrame")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")

TaskLayer.BT_EXIT			= 3
TaskLayer.BT_CELL			= 15
function TaskLayer:onTouchBegan (touch, event)
    return true
end

-- 进入场景而且过渡动画结束时候触发。
function TaskLayer:onEnterTransitionFinish()
	self._scene:showPopWait()
	self._taskFrame:onTaskLoad()
	
    return self
end

-- 退出场景而且开始过渡动画时候触发。
function TaskLayer:onExitTransitionStart()
    return self
end
function TaskLayer:onExit()
    if self._taskFrame:isSocketServer() then
        self._taskFrame:onCloseSocket()
    end

    if nil ~= self._taskFrame._gameFrame then
        self._taskFrame._gameFrame._shotFrame = nil
        self._taskFrame._gameFrame = nil
    end
end

function TaskLayer:ctor(scene, gameFrame)	
	local this = self

	self._scene = scene
    ExternalFun.registerTouchEvent (self, true)
    
 

	--按钮回调
	self._btcallback = function(ref, type)
        if type == ccui.TouchEventType.ended then
         	this:onButtonClickedEvent(ref:getTag(),ref)
        end
    end
	
	--网络回调
    local taskCallBack = function(result,message)
		return this:onTaskCallBack(result,message)
	end

	--网络处理
	self._taskFrame = TaskFrame:create(self,taskCallBack)
    self._taskFrame._gameFrame = gameFrame
    if nil ~= gameFrame then
        gameFrame._shotFrame = self._taskFrame
    end

	self._wTaskID = 0
	self._wCommand = 0

    self.spBJ=	display.newSprite("General/mg_bj_4.png")
		self.spBJ:move(yl.WIDTH/2,yl.HEIGHT /2)
		:addTo(self)
     
    
	    display.newSprite("Task/frame_task_top.png")
		:move(547,639)
		:addTo(self.spBJ)
    
    	local bj2=display.newSprite("General/mg_bj_3.png")
		:move(546,287)
		:addTo(self.spBJ)
    
        local  parent= this._scene
    	ccui.Button:create("General/bt_close_0.png","")
		:move(1017,599)
		:addTo(self.spBJ)
		:addTouchEventListener(function(ref, type)
       		 	if type == ccui.TouchEventType.ended then
                    self._scene:removeTaskLayer()
                      print("vvvvvvvvvvvv")
				end
			end)
        
	--金币和元宝
--	display.newSprite("Task/frame_task_3.png")
--		:move(842,699)
--		:addTo(self)
--	display.newSprite("Task/icon_task_gold_0.png")
--		:move(727,699)
--		:addTo(self)
--	display.newSprite("Task/frame_task_4.png")
--		:move(1158,699)
--		:addTo(self)
--	display.newSprite("Task/icon_task_ingot_0.png")
--		:move(1039,699)
--		:addTo(self)

--	self._txtGold = cc.LabelAtlas:_create(string.formatNumberThousands(GlobalUserItem.lUserScore,true,"/"), "Task/num_task_0.png", 16, 22, string.byte("/")) 
--    		:move(765,699)
--    		:setAnchorPoint(cc.p(0,0.5))
--    		:addTo(self)
--    self._txtIngot = cc.LabelAtlas:_create(string.formatNumberThousands(GlobalUserItem.lUserIngot,true,"/"), "Task/num_task_0.png", 16, 22, string.byte("/")) 
--    		:move(1087,699)
--    		:setAnchorPoint(cc.p(0,0.5))
--    		:addTo(self)
 


 

	--游戏列表
	self._listView = cc.TableView:create(cc.size(1039, 520))
	self._listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)    
	self._listView:setPosition(cc.p(20,0))
	self._listView:setDelegate()
	self._listView:addTo(bj2)
	self._listView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	self._listView:registerScriptHandler(self.cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
	self._listView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
	self._listView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

end

--操作任务
function TaskLayer:onHandleTask(wTaskID,cbTaskStatus)
	self._scene:showPopWait()
	if cbTaskStatus == yl.TASK_STATUS_WAIT then
		self._wCommand = yl.SUB_GP_TASK_TAKE
		self._taskFrame:onTaskTake(wTaskID)
	elseif cbTaskStatus == yl.TASK_STATUS_UNFINISH or cbTaskStatus == yl.TASK_STATUS_FAILED then
		self._wCommand = yl.SUB_GP_TASK_GIVEUP
		self._taskFrame:onTaskGiveup(wTaskID)
	elseif cbTaskStatus == yl.TASK_STATUS_SUCCESS then
		self._wCommand = yl.TASK_STATUS_SUCCESS
		self._taskFrame:onTaskReward(wTaskID)
	end
end

--按键监听
function TaskLayer:onButtonClickedEvent(tag,sender)
             ExternalFun.playClickEffect()            

	if tag == TaskLayer.BT_CELL then
		local idx = sender:getParent():getParent():getIdx()
		local item = self._taskFrame:getTastList()[idx+1]
        if nil ~= item then
            self._wTaskID = item.wTaskID
            self:onHandleTask(item.wTaskID,item.cbTaskStatus)
        end		
	end
end

--操作结果
function TaskLayer:onTaskCallBack(result,message)
	print("======== TaskLayer:onTaskCallBack ========")
    local bRes = false
	self._scene:dismissPopWait()
	if  message ~= nil and message ~= "" then
		showToast(self,message,2)
	end

    if result == 1 then
        self._listView:reloadData()
	elseif result == 2 then
        print(" taskid " .. self._wTaskID .. " command " .. self._wCommand)
        self._taskFrame:updateTask(self._wTaskID, self._wCommand)
		self._listView:reloadData()

--        self._txtGold:setString(string.formatNumberThousands(GlobalUserItem.lUserScore,true,"/"))
--        self._txtIngot:setString(string.formatNumberThousands(GlobalUserItem.lUserIngot,true,"/"))

        --bRes = true
	end
    return bRes
end

---------------------------------------------------------------------

--子视图大小
function TaskLayer.cellSizeForTable(view, idx)
  	return 1001,125
end

--子视图数目
function TaskLayer:numberOfCellsInTableView(view)
    return #self._taskFrame:getTastList()
end
	
--获取子视图
function TaskLayer:tableCellAtIndex(view, idx)	
	local cell = view:dequeueCell()
	local item = self._taskFrame:getTastList()[idx+1]

	if not cell then		
		cell = cc.TableViewCell:new()
    else
        cell:removeAllChildren()
	end
    if nil == item then
        return cell
    end

    self:createTaskItem(cell, item, view)
    local spChang=cell:getChildByTag(1)
	spChang:getChildByTag(3):setTexture("Task/icon_task_"..item.wTaskType..".png")

	if item.dwTimeLimit ~= 0 then
		local hour = math.floor(item.dwTimeLimit/3600)
		local minute = math.floor((item.dwTimeLimit-hour*3600)/60)
		local second = item.dwTimeLimit-hour*3600-minute*60
        local str = ""

        if 0 ~= hour then
            str = hour .. " 小时"
        end
        if 0 ~= minute then
            str = (str ~= "") and (str .. ":") or str
            str = str .. minute .. " 分钟"
        end
        if 0 ~= second then
            str = (str ~= "") and (str .. ":") or str
            str = str .. second .. " 秒"
        end
		--cell:getChildByTag(8):setString(""..hour.."："..minute.."："..second.."")
        spChang:getChildByTag(8):setString(str)
	else
		spChang:getChildByTag(8):setString("无时限")
	end
    --dump(item, "item", 7)

    --按钮处理
    local btn = spChang:getChildByTag(TaskLayer.BT_CELL)
	if nil ~= btn then
        btn:setEnabled(true)
        btn:setVisible(true)
        if item.cbTaskStatus == yl.TASK_STATUS_UNFINISH then
            btn:loadTextureNormal("Task/bt_task_giveup_0.png")
            btn:loadTexturePressed("Task/bt_task_giveup_1.png")
            btn:loadTextureDisabled("Task/bt_task_giveup_0.png")
        elseif item.cbTaskStatus == yl.TASK_STATUS_WAIT then
            btn:loadTextureNormal("Task/bt_task_take_0.png")
            btn:loadTexturePressed("Task/bt_task_take_1.png")
            btn:loadTextureDisabled("Task/bt_task_take_0.png")
        elseif item.cbTaskStatus == yl.TASK_STATUS_FAILED then
            btn:loadTextureNormal("Task/bt_task_fail_0.png")
            btn:loadTexturePressed("Task/bt_task_fail_1.png")
            btn:loadTextureDisabled("Task/bt_task_fail_0.png")
            btn:setEnabled(false)        
        elseif item.cbTaskStatus == yl.TASK_STATUS_SUCCESS then            
            btn:loadTextureNormal("Task/bt_task_reward_0.png")
            btn:loadTexturePressed("Task/bt_task_reward_1.png")
            btn:loadTextureDisabled("Task/bt_task_reward_0.png")
        else
            btn:setVisible(false)
            btn:setEnabled(false)
        end
    end    

	--进度条处理
	if  item.wTaskObject > 0 then
		local scalex = (item.wTaskProgress*1.0)/(item.wTaskObject*1.0)
		if scalex > 1 then
			scalex = 1
		end
		spChang:getChildByTag(6):setTextureRect(cc.rect(0,0,218*scalex,20))
	else
		spChang:getChildByTag(6):setTextureRect(cc.rect(0,0,1,20))
	end
	spChang:getChildByTag(7):setString(""..item.wTaskProgress.."/"..item.wTaskObject)

	return cell
end

function TaskLayer:createTaskItem(cell, item, view)
    local cy =121/2-15  
    local cellwidth = 1001
    --背景条
    local spChang=display.newSprite("Task/frame_task_2.png")
        :addTo(cell)
        :move(cellwidth/2, cy)
        :setTag(1)

    -- display.newsprite("task/frame_task_5.png")
    --     :move(90,cy)
    --     :settag(2)
    --     :addto(cell)
    --任务图标
    display.newSprite("Task/icon_task_0.png")
        :move(60,121/2)
        :setTag(3)
        :addTo(spChang)

    --任务名称
    display.newSprite("Task/text_task_task.png")
        :setAnchorPoint(cc.p(0,0.5))
        :move(139,80)
        :setTag(4)
        :addTo(spChang)
    local cpName = ClipText:createClipText(cc.size(210,30), item.szTaskName, "fonts/round_body.ttf", 25)
    cpName:setAnchorPoint(cc.p(0, 0.5))
    cpName:setPosition(213, 80)
    cpName:setTag(5)
    spChang:addChild(cpName)

    --任务进度
    display.newSprite("Task/text_task_progress.png")
        :setAnchorPoint(cc.p(0, 0.5))
        :addTo(spChang)
        :move(139,40)
    display.newSprite("Task/frame_task_progress_0.png")
        :addTo(spChang)
      --  :setAnchorPoint(cc.p(0, 0.5))
        :move(310,40)
    --进度条
    display.newSprite("Task/frame_task_progress_1.png")
        :setTextureRect(cc.rect(0,0,1,20))
        :setAnchorPoint(cc.p(0,0.5))
        :move(179.5,40)
        :setTag(6)
        :addTo(spChang)
    --进度文字
    cc.Label:createWithTTF(""..item.wTaskProgress.."/"..item.wTaskObject, "fonts/round_body.ttf", 14)
            :setAnchorPoint(cc.p(0.5,0.5))
            :move(310,40)
            :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
            :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
            :setWidth(100)
            :setHeight(15)
            :setTag(7)
            :setLineBreakWithoutSpace(false)
            :setTextColor(cc.c4b(255,255,255,255))
            :addTo(spChang)

    --时间限制
    display.newSprite("Task/text_task_time.png")
        :setAnchorPoint(cc.p(0,0.5))
        :move(436,80)
        :addTo(spChang)
    cc.Label:createWithTTF("无时限", "fonts/round_body.ttf", 24)
            :setAnchorPoint(cc.p(0,0.5))
            :move(511,80)
            :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
            :setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
            :setWidth(300)
            :setHeight(30)
            :setTag(8)
            :setLineBreakWithoutSpace(false)
            :setTextColor(cc.c4b(255,255,255,255))
            :addTo(spChang)

    --任务奖励
    display.newSprite("Task/text_task_reward.png")
        :setAnchorPoint(cc.p(0,0.5))
        :move(436,40)
        :addTo(spChang)

    display.newSprite("Task/icon_task_gold_1.png")
        :move(530,40)
        :addTo(spChang)
    cc.LabelAtlas:_create(string.formatNumberThousands(item.lStandardAwardGold,true,"/"), "Task/num_task_1.png", 16, 20, string.byte("/")) 
        :move(548,40)
        :setAnchorPoint(cc.p(0,0.5))
        :addTo(spChang)

    display.newSprite("Task/icon_task_ingot_1.png")
        :move(646,42)
        :addTo(spChang)
    cc.LabelAtlas:_create(string.formatNumberThousands(item.lStandardAwardMedal,true,"/"), "Task/num_task_1.png", 16, 20, string.byte("/")) 
        :move(662,41)
        :setAnchorPoint(cc.p(0,0.5))
        :addTo(spChang)

    --操作按钮
    ccui.Button:create("Task/bt_task_take_0.png","Task/bt_task_take_1.png","Task/bt_task_take_0.png")
        :move(870,58)
        :setTag(TaskLayer.BT_CELL)
        :addTo(spChang)
        :addTouchEventListener(self._btcallback)
end
---------------------------------------------------------------------
return TaskLayer