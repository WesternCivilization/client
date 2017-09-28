--[[
	欢迎界面
			2015_12_03 C.P
	功能：本地版本记录读取，如无记录，则解压原始大厅及附带游戏
--]]

local WelcomeScene = class("WelcomeScene", cc.load("mvc").ViewBase)

local ClientUpdate = appdf.req("base.src.app.controllers.ClientUpdate")    --client以外的绝对路径
local QueryDialog = appdf.req("base.src.app.views.layer.other.QueryDialog")
local ClientConfig = appdf.req(appdf.BASE_SRC .."app.models.ClientConfig")

local HTTP_URL 
--请求列表
if appdf.isLocalService == 1 then 
	HTTP_URL = "http://114.55.232.112" 
else
	HTTP_URL = "http://get.668yx.com" 		
end



local EXTRA_CMD_KEY = "extra_command_version"
--全局toast函数(ios/android端调用)
cc.exports.g_NativeToast = function (msg)
	local runScene = cc.Director:getInstance():getRunningScene()
	if nil ~= runScene then
		showToastNoFade(runScene, msg, 2)
	end
end

function WelcomeScene:onCreate()
	local this = self
	self:setTag(1)
    self.thuaSe={}

	--/baseupdate/ 为热更新下来的目录，不在加密文件夹ciphercode下,没有更新的话就用base目录下的同名文件。
	--背景
	local newbasepath = cc.FileUtils:getInstance():getWritablePath() .. "/baseupdate/"
	local bgfile = newbasepath .. "base/res/background.png"	
	local sp = cc.Sprite:create(bgfile)
	if nil == sp then
		sp = cc.Sprite:create("background.png")
	end
	if nil ~= sp then
		sp:setPosition(appdf.WIDTH/2,appdf.HEIGHT/2)
		self:addChild(sp)
	end

    local newY=85

    display.newSprite("jiazh.png")
    :move(appdf.WIDTH/2,newY)
    :addTo(self)
    

    display.newSprite("jztb.png")
    :move(770,newY)
    :addTo(self)
    display.newSprite("jztb.png")
    :move(1086,newY)
    :addTo(self)
    :setScale(-1)



    display.newSprite("jzjdm1.png")
    :move(844,newY)
    :addTo(self)
    display.newSprite("jzjdx.png")
    :move(897,newY)
    :addTo(self)
    display.newSprite("jzjdh.png")
    :move(957,newY)
    :addTo(self)
    display.newSprite("jzjdf.png")
    :move(1010,newY)
    :addTo(self)


    local sp1=display.newSprite("jzjdm.png")
    :move(844,newY)
    :addTo(self)
    :setTag(1)
    :setVisible(false)
    local sp2=display.newSprite("jzjdx1.png")
    :move(897,newY)
    :addTo(self)
    :setTag(2)
    :setVisible(false)
    local sp3=display.newSprite("jzjdh1.png")
    :move(957,newY)
    :addTo(self)
    :setTag(3)
    :setVisible(false)
    local sp4=display.newSprite("jzjdf1.png")
    :move(1010,newY)
    :addTo(self)
    :setTag(4)
    :setVisible(false)
    
    table.insert(self.thuaSe,sp1)
    table.insert(self.thuaSe,sp2)
    table.insert(self.thuaSe,sp3)
    table.insert(self.thuaSe,sp4)


    self.nnum=1
    local show=function(this)
        for i=1,#this.thuaSe do
            this.thuaSe[i]:setVisible(this.thuaSe[i]:getTag()==self.nnum)   
        end
 
        this.nnum=this.nnum+1
        if  this.nnum >=5 then
            this.nnum=1
        end

    end
    
    schedule(this,show,0.3)


    --提示文本     "解压文件，请稍候..."， "OK"， 右下角, 绿色黑边
    self._txtTips = cc.Label:createWithTTF("", "fonts/round_body.ttf", 24)
		--:setTextColor(cc.c4b(0,250,0,255))
		:setAnchorPoint(cc.p(1,0.5))
	 	:enableOutline(cc.c4b(0,0,0,255), 1)
    --:move(appdf.WIDTH,0)
    :move(678,newY)
    :addTo(self)


    --健康游戏忠告
    self._healthTips = cc.Label:createWithTTF(
    	"抵制不良游戏，拒绝盗版游戏。\n注意自我保护，谨防受骗上当。\n适度游戏益脑，沉迷游戏伤身。\n合理安排时间，享受健康生活。", 
    	"fonts/round_body.ttf", 40)
    :enableOutline(cc.c4b(0,0,0,255), 1)
    :move(878, 420)
    :addTo(self)




	self.m_progressLayer = display.newLayer(cc.c4b(0, 0, 0, 0))
	self:addChild(self.m_progressLayer)
	self.m_progressLayer:setVisible(false)
	
--总下载的进度
	local total_bg = cc.Sprite:create("wait_frame_0.png")      --进度条背景，紫黑
	self.m_spTotalBg = total_bg
	self.m_progressLayer:addChild(total_bg)
	total_bg:setPosition(appdf.WIDTH/2, 80)
	self.m_totalBar = ccui.LoadingBar:create()
	self.m_totalBar:loadTexture("wait_frame_3.png")	       --进度条， 绿色
	self.m_progressLayer:addChild(self.m_totalBar)
	self.m_totalBar:setPosition(appdf.WIDTH/2, 80)

	--  进度百分比      string.format("%d%%", percent)
	self._totalTips = cc.Label:createWithTTF("", "fonts/round_body.ttf", 20)     
		--:setTextColor(cc.c4b(0,250,0,255))
		:setName("text_tip")
		:enableOutline(cc.c4b(0,0,0,255), 1)
		:move(self.m_totalBar:getContentSize().width * 0.5, self.m_totalBar:getContentSize().height * 0.5)
		:addTo(self.m_totalBar)
	self.m_totalThumb = cc.Sprite:create("thumb_1.png")    --绿色进度条前进的一团粒子
	self.m_totalBar:addChild(self.m_totalThumb)
	self.m_totalThumb:setPositionY(self.m_totalBar:getContentSize().height * 0.5)
	self:updateBar(self.m_totalBar, self.m_totalThumb, 0)

	--单文件进度
	local file_bg = cc.Sprite:create("wait_frame_0.png")    --进度条背景，紫黑
	self.m_spFileBg = file_bg
	self.m_progressLayer:addChild(file_bg)
	file_bg:setPosition(appdf.WIDTH/2, 120)
	self.m_fileBar = ccui.LoadingBar:create()
	self.m_fileBar:loadTexture("wait_frame_2.png")   --进度条，蓝色
	self.m_fileBar:setPercent(0)
	self.m_progressLayer:addChild(self.m_fileBar)
	self.m_fileBar:setPosition(appdf.WIDTH/2, 120)
	--  进度百分比
	self._fileTips = cc.Label:createWithTTF("", "fonts/round_body.ttf", 20)   
		--:setTextColor(cc.c4b(0,250,0,255))
		:setName("text_tip")                 
		:enableOutline(cc.c4b(0,0,0,255), 1)
		:move(self.m_fileBar:getContentSize().width * 0.5, self.m_fileBar:getContentSize().height * 0.5)
		:addTo(self.m_fileBar)
	self.m_fileThumb = cc.Sprite:create("thumb_0.png")       ----蓝色进度条前进的一团粒子
	self.m_fileBar:addChild(self.m_fileThumb)
	self.m_fileThumb:setPositionY(self.m_fileBar:getContentSize().height * 0.5)
	self:updateBar(self.m_fileBar, self.m_fileThumb, 0)
	

	-- 资源同步队列

	self.m_tabUpdateQueue = {}

    if LOCAL_DEVELOP == 1 then    --本地调试
    	local v = (appdf.VersionValue(6,7,0,1))..""
 	    self:getApp()._gameList = {}
 	    self:getApp()._updateUrl = HTTP_URL .. "/"
 	    self._newVersion = v
		self:getApp()._version:setVersion(self._newVersion)
		self:getApp()._version:save()
 	    self:httpNewVersionCallBack(true)
    else
	    
        local nResversion = tonumber(self:getApp()._version:getResVersion())   --大厅版本

        --第一次安装游戏时，会执行
	    if nil == nResversion then     --无版本信息或不对应 解压自带ZIP
	 	    self:onUnZipBase()        
	    else
	    	--版本同步
	        self:httpNewVersion()
	    end
    end
end



--解压自带ZIP
function WelcomeScene:onUnZipBase()
	local this = self

	if self._unZip == nil then --大厅解压
		-- 状态提示
		self._txtTips:setString("解压文件，请稍候...")
		self._unZip = 0
		--解压
		local dst = device.writablePath
		unZipAsync(cc.FileUtils:getInstance():fullPathForFilename("client.zip"),dst,function(result)
				this:onUnZipBase()
			end)
	elseif self._unZip == 0 then --默认游戏解压
		self._unZip = 1
		--解压
		local dst = device.writablePath
		unZipAsync(cc.FileUtils:getInstance():fullPathForFilename("game.zip"),dst,function(result)
				this:onUnZipBase()
			end)
	else 			-- 解压完成
		self._unZip = nil
		--设置大厅资源版本号，存本地 
		self:getApp()._version:setResVersion(appdf.BASE_C_RESVERSION)
		
		--设置自带游戏资源版本号，存本地
		for k ,v in pairs(appdf.BASE_GAME) do
			self:getApp()._version:setResVersion(v.version,v.kind)
		end
		self._txtTips:setString("解压完成！")

		--版本同步
	    self:httpNewVersion()
		return	
	end

end



--同步版本
function WelcomeScene:httpNewVersion()	
	self._txtTips:setString("获取服务器信息...")
	local this = self

	--数据解析
	local vcallback = function(datatable)
	 	local succeed = false
	 	local msg = "网络获取失败！"
	 	if type(datatable) == "table" then	 		
            local databuffer = datatable["data"]
            if databuffer then
            	dump(databuffer, "databuffer", 6)   --modified by cgp
                --返回结果
	 		    succeed = databuffer["valid"]   --是否有效
	 		    --提示文字
	 		    local tips = datatable["msg"]
	 		    if tips and tips ~= cjson.null then
	 			    msg = tips
	 		    end
	 		    print("tips ", tips, "succeed", succeed)
	 		    --获取信息
	 		    if succeed == true then	 
	 		    	this:getApp()._serverConfig = databuffer		
	 		    	--含有wxLogon, isBank, isTransfer 控制信息
	 		    	

 				    --下载地址
 				    this:getApp()._updateUrl = databuffer["downloadurl"]								--test zhong "http://172.16.4.140/download/"


 				    --大厅版本
 				    this._newVersion = tonumber(databuffer["clientversion"])          						--test zhong  0
 				    --大厅资源版本
 				    this._newResVersion = tonumber(databuffer["resversion"])
 				   
 				    --苹果大厅更新地址
 				    this._iosUpdateUrl = databuffer["ios_url"]
 				    if device.platform == "ios" then    --appstore版本不更新包体，直接去苹果商店下载
 				    	this._iosUpdateUrl = nil
 				    end

 				    appdf.noOpenGame = databuffer["NoOpenList"]


 				    local nNewV = self._newResVersion
					local nCurV = tonumber(self:getApp()._version:getResVersion())

					print("大厅资源版本号 ",  nNew, nCurV, appdf.noOpenGame)

					if nNewV and nCurV then      
						if nNewV > nCurV then      --服务器下发的版本 > 客户端本地存储的版本
							-- 更新配置
		 				    local updateConfig = {}
					 		updateConfig.isClient = true
					 		updateConfig.newfileurl = this:getApp()._updateUrl.."/client/res/filemd5List.json"
							
							updateConfig.downurl = this:getApp()._updateUrl .. "/"

							updateConfig.dst = device.writablePath
							local targetPlatform = cc.Application:getInstance():getTargetPlatform()
							if cc.PLATFORM_OS_WINDOWS == targetPlatform then
								updateConfig.dst = device.writablePath .. "download/client/"
							end		

							updateConfig.src = device.writablePath.."client/res/filemd5List.json"
					 		table.insert(self.m_tabUpdateQueue, updateConfig)
						end
					end		 

 				    --游戏列表
 				    local rows = databuffer["gamelist"]
 				    this:getApp()._gameList = {}
 				    for k,v in pairs(rows) do
 					    local gameinfo = {}
 					    gameinfo._KindID = v["KindID"]
 					    gameinfo._KindName = string.lower(v["ModuleName"]) .. "."     --  "yule.oxsixex."
 					    gameinfo._Module = string.gsub(gameinfo._KindName, "[.]", "/")      -- "yule/oxsixex/"
 					    gameinfo._KindVersion = v["ClientVersion"]                    --单个游戏的模板版本号
 					    gameinfo._ServerResVersion = tonumber(v["ResVersion"])        --单个游戏的资源版本号
 					    gameinfo._Type = gameinfo._Module
 					    gameinfo._TypeID = tonumber( v["TypeID"])

 					    --检查本地文件是否存在
 					    local path = device.writablePath .. "game/" .. gameinfo._Module
 					    gameinfo._Active = cc.FileUtils:getInstance():isDirectoryExist(path)
 					    local e = string.find(gameinfo._KindName, "[.]")
 					    
 					    --yule 和 qipai
 					    if e then
 					    	gameinfo._Type = string.sub(gameinfo._KindName,1,e - 1)
 					    end

 					    -- 排序
 					    gameinfo._SortId = tonumber(v["SortID"]) or 0

 					    table.insert(this:getApp()._gameList, gameinfo)

 				    end

 				    --降序
 				    table.sort( this:getApp()._gameList, function(a, b)
 				    	return a._SortId > b._SortId
 				    end)


 				    print("#gameList ", #this:getApp()._gameList )
 				    -- 只有一个游戏，加入下载队列
 				    if 1 == #this:getApp()._gameList then
 				    	local gameInfo = this:getApp()._gameList[1]
 				    	local version = tonumber(this:getApp():getVersionMgr():getResVersion(gameInfo._KindID))
 				    	if not version or gameInfo._ServerResVersion > version then    --服务器下发的游戏资源版本号 > 本地存储的资源版本号
 				    		local updateConfig2 = {}
					 		updateConfig2.isClient = false


					 		updateConfig2.newfileurl = this:getApp()._updateUrl.."/game/"..gameInfo._Module.."/res/filemd5List.json"
							updateConfig2.downurl = this:getApp()._updateUrl .. "/game/" .. gameInfo._Type .. "/"   

							updateConfig2.dst = device.writablePath .. "game/" .. gameInfo._Type .. "/"
							if cc.PLATFORM_OS_WINDOWS == targetPlatform then
								updateConfig2.dst = device.writablePath .. "download/game/" .. gameInfo._Type .. "/"
							end	
							updateConfig2.src = device.writablePath.."game/"..gameInfo._Module.."/res/filemd5List.json"
					 		
					 		updateConfig2._ServerResVersion = gameInfo._ServerResVersion
					 		updateConfig2._KindID = gameInfo._KindID
					 		table.insert(self.m_tabUpdateQueue, updateConfig2)
 				    	end 				    	
 				    end


	 		    end
            end	 		
	 	end

	 	self._txtTips:setString("")
	 	
	 	
	 	if succeed then    --http请求成功时 ， 执行附加脚本
	 		self:excuteExtraCmd()
	 	else
	 		this:httpNewVersionCallBack(succeed,msg)      --不成功false时重连，
	 	end	 
	
	end

	--是否是苹果企业版
	appdf.isAppleEnterprice = this:getApp():getVersionMgr():getIsAppleEnterprice()
 

 	--控制版本号
 	local controlVersion = this:getApp():getVersionMgr():getControlVersion()
 	local TypeID = 1
 	if device.platform == "ios" then
 		TypeID  = 1
 	else
 		TypeID = 2     --windows和Android都走android 控制渠道
 	end

 	local params = "action=getgamelist&Ver=" .. controlVersion .. "&TypeID=" ..TypeID
 	print("+++++++++++++++++++++++++++++++++++++++++++++++++++++      params  ", params)
	appdf.onHttpJsionTable(HTTP_URL .. "/WS/MobileInterface.ashx","get", params, vcallback)
	
end

--执行附加脚本,   用于更新base部分的logo资源
function WelcomeScene:excuteExtraCmd()
	local url = self:getApp()._updateUrl .. "/command/extra_command.luac"
	local localver = cc.UserDefault:getInstance():getIntegerForKey(EXTRA_CMD_KEY, 0)
	local savePath = device.writablePath .. "command/"
	local extramodule = "command.extra_command"
	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	if cc.PLATFORM_OS_WINDOWS == targetPlatform then
		savePath = device.writablePath .. "download/command/"
	end

	--调用C++下载 --fileurl, filename, dstpath,callback
    downFileAsync(url, "extra_command.luac", savePath, function(main,sub)
        --下载回调
        if main == appdf.DOWN_PRO_INFO then --进度信息
            
        elseif main == appdf.DOWN_COMPELETED then --下载完毕
        	print("extra_cmd download")
            --执行、下载附加命令脚本
			local extra = savePath .. "/extra_command"
			if cc.FileUtils:getInstance():isFileExist(extra .. ".luac") then
				print("cmd exist")
				local extracmd = appdf.req(extramodule)
				
				--成功的话在extra_command.lua中执行 listener:onCommandExcuted(EXTRA_COMMAND_VER)  
				if (nil == extracmd.excute) or (false == extracmd.excute(localver, self, self:getApp()._updateUrl)) then
					
            		self:onCommandExcuted(localver)    --失败
				end
			else
				print("cmd not exist")
				--跳过执行
            	self:onCommandExcuted(localver)
			end
        else     --下载失败，删除luac
        	print("extra_command.luac down error")
        	cc.FileUtils:getInstance():removeFile(savePath .. "extra_command.luac")
            --跳过执行
            self:onCommandExcuted(localver)
        end
    end)	
end

-- 附加脚本执行完毕， 写本地版本号， 执行更新
function WelcomeScene:onCommandExcuted(NEW_VER)
	cc.UserDefault:getInstance():setIntegerForKey(EXTRA_CMD_KEY, NEW_VER)

	--同步、更新
	self:httpNewVersionCallBack(true)
end

--服务器版本返回
function WelcomeScene:httpNewVersionCallBack(result,msg)
    local this = self
    
    --获取失败， 重连
    if not result then
	    self._txtTips:setString("")
	    QueryDialog:create(msg.."\n是否重试？",function(bReTry)
			    if bReTry == true then
				    this:httpNewVersion()
			    else
				    os.exit(0)
			    end
		    end)
	    	:setCanTouchOutside(false)
		    :addTo(self)
    else
	    --升级判断
	    local bUpdate = false

	    --device.platform ~= "windows"     
	    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
		if cc.PLATFORM_OS_WINDOWS ~= targetPlatform then
			bUpdate = self:updateClient()    --更新 , 成功返回true
		else
			self:getApp()._version:setResVersion(self._newResVersion)    --设置大厅资源版本号
		end
		

		--进入登录界面
	    if not bUpdate then
		   
            self._txtTips:setString("服务器登录中")
		    self:runAction(cc.Sequence:create(
			    cc.DelayTime:create(1),
			    cc.CallFunc:create(function()
				    this:EnterClient()
			    end)
			    ))
	    end
    end
end


--
function WelcomeScene:updateClient()
	local newV = self._newVersion
	local curV = appdf.BASE_C_VERSION
 --大厅基础版本下发 > 本地基础版本    与apk对应		
	if newV and curV then	   
		--更新APP
		if newV > curV then     
			if device.platform == "ios" and (type(self._iosUpdateUrl) ~= "string" or self._iosUpdateUrl == "") then
				print("ios update fail, url is nil or empty")
			else
				self._txtTips:setString("")
				QueryDialog:create("有新的版本，是否现在下载升级？",function(bConfirm)
	                    if bConfirm == true then                    	
							self:upDateBaseApp()				    
						else
							os.exit(0)
	                    end					
					end)
					:setCanTouchOutside(false)
					:addTo(self)	
				return true
			end				
		end
	end

	--队列下载  （大厅资源， 游戏）
	if 0 ~= #self.m_tabUpdateQueue then
		self:goUpdate()
		return true
	end
	print("version did not need to update")
end

--更新包体
function WelcomeScene:upDateBaseApp()
	self.m_progressLayer:setVisible(true)
	self.m_totalBar:setVisible(false)
	self.m_spTotalBg:setVisible(false)
	self.m_fileBar:setVisible(true)
	self.m_spFileBg:setVisible(true)

	if device.platform == "android" then
		local this = self
		local argsJson 
		local url = ""
		print("debug .. => " .. DEBUG)
		if isDebug() then
			url = self:getApp()._updateUrl .."/".. appdf.AppName .. "-debug.apk"	
		else			
			url = self:getApp()._updateUrl .."/".. appdf.AppName .. ".apk"	
		end
		print(url)	
	    --调用C++下载
	    local luaj = require "cocos.cocos2d.luaj"
		local className = "org/cocos2dx/lua/AppActivity"


	    local sigs = "()Ljava/lang/String;"
   		local ok,ret = luaj.callStaticMethod(className,"getSDCardDocPath",{},sigs)
   		if ok then

   			local dstpath = ret .. "/update/"
   			local filepath = dstpath .. "ry_client.apk"
   			--/storage/emulated/0/Android/data/foxuc.qp.Glory.jlzl/files/update/ry_client.apk
		   
		    if cc.FileUtils:getInstance():isFileExist(filepath) then
		    	cc.FileUtils:getInstance():removeFile(filepath)
		    end
		    if false == cc.FileUtils:getInstance():isDirectoryExist(dstpath) then
		    	cc.FileUtils:getInstance():createDirectory(dstpath)
		    end
		    self:updateBar(self.m_fileBar, self.m_fileThumb, 0)
--	static void DownFile(const char* szUrl,const char* szFileName,const char* szSavePath,int nHandler);

			downFileAsync(url,"ry_client.apk",dstpath,function(main,sub)
					--下载回调
					if main == appdf.DOWN_PRO_INFO then --进度信息
						self:updateBar(self.m_fileBar, self.m_fileThumb, sub)
					elseif main == appdf.DOWN_COMPELETED then --下载完毕
						self._txtTips:setString("下载完成")
						self.m_progressLayer:setVisible(false)

						--安装apk						
						local args = {filepath}
						sigs = "(Ljava/lang/String;)V"
		   				ok,ret = luaj.callStaticMethod(className, "installClient",args, sigs)
		   				if ok then
		   					os.exit(0)
		   				end
					else
						QueryDialog:create("下载失败,code:".. main .."\n是否重试？",function(bReTry)
							if bReTry == true then
								this:upDateBaseApp()
							else
								os.exit(0)
							end
						end)
						:setCanTouchOutside(false)
						:addTo(self)
					end
				end)
		else
			os.exit(0)
   		end	    
	elseif device.platform == "ios" then
		local luaoc = require "cocos.cocos2d.luaoc"
		local ok,ret  = luaoc.callStaticMethod("AppController","updateBaseClient",{url = self._iosUpdateUrl})
	    if not ok then
	        print("luaoc error:" .. ret)        
	    end
	end
end

--队列下载,  在updateResult中，如果队列不为空，会再次被调用
function WelcomeScene:goUpdate( )
	self.m_progressLayer:setVisible(true)

	local config = self.m_tabUpdateQueue[1]
	--更新队列为空，延时1s 进入大厅
	if nil == config then     
		self.m_progressLayer:setVisible(false)
		self._txtTips:setString("服务器登录中")
		self:runAction(cc.Sequence:create(
				cc.DelayTime:create(1),
				cc.CallFunc:create(function()
					self:EnterClient()
				end)
		))
	else
		--正式更新，       远程的filelistMD5,  本地路径，  本地filelistMD5,   远程路径
		ClientUpdate:create(config.newfileurl, config.dst, config.src, config.downurl)
			:upDateClient(self)
	end	
end

--下载进度
function WelcomeScene:updateProgress(sub, msg, mainpersent)

				--bar, thumb, percent
	self:updateBar(self.m_fileBar, self.m_fileThumb, sub)     --单个文件
	self:updateBar(self.m_totalBar, self.m_totalThumb, mainpersent)   --filemd5List.json中的总文件
end

--下载结果， ClientUpdate.lua中调用
function WelcomeScene:updateResult(result,msg)
	local this = self

	if result == true then  --单个filemd5List.json中的文件被下载完

		--置零
		self:updateBar(self.m_fileBar, self.m_fileThumb, 0)
		self:updateBar(self.m_totalBar, self.m_totalThumb, 0)

		--更新本地版本号
		local config = self.m_tabUpdateQueue[1]
		if nil ~= config then
			if true == config.isClient then

				self:getApp()._version:setResVersion(self._newResVersion)
			else
				self:getApp()._version:setResVersion(config._ServerResVersion, config._KindID)
				for k,v in pairs(self:getApp()._gameList) do
					if v._KindID == config._KindID then
						v._Active = true
					end
				end
			end
			table.remove(self.m_tabUpdateQueue, 1)     --移除下载队列
			self:goUpdate()     --继续更新
		else
            --进入登录界面
            self._txtTips:setString("服务器登录中")
			self:runAction(cc.Sequence:create(
					cc.DelayTime:create(1),
					cc.CallFunc:create(function()
						this:EnterClient()
					end)
			))	
		end
	else     --下载失败
		self.m_progressLayer:setVisible(false)
		self:updateBar(self.m_fileBar, self.m_fileThumb, 0)
		self:updateBar(self.m_totalBar, self.m_totalThumb, 0)

		--重试询问
		self._txtTips:setString("")
		QueryDialog:create(msg.."\n是否重试？",function(bReTry)
				if bReTry == true then
					this:goUpdate()
				else
					os.exit(0)
				end
			end)
			:setCanTouchOutside(false)
			:addTo(self)
	end
end

function WelcomeScene:updateBar(bar, thumb, percent)
	if nil == bar or nil == thumb then
		return
	end
	local text_tip = bar:getChildByName("text_tip")
	if nil ~= text_tip then
		local str = string.format("%d%%", percent)
		text_tip:setString(str)
	end

	bar:setPercent(percent)
	local size = bar:getVirtualRendererSize()
	thumb:setPositionX(size.width * percent / 100)
end

--进入登录界面
function  WelcomeScene:EnterClient()
	--重置大厅与游戏
	for k ,v in pairs(package.loaded) do
		if k ~= nil then 
			if type(k) == "string" then
				if string.find(k,"plaza.") ~= nil or string.find(k,"game.") ~= nil then
					print("package kill:"..k) 
					package.loaded[k] = nil     --重新加载lua文件
				end
			end
		end
	end	
	--场景切换
	self:getApp():enterSceneEx(appdf.CLIENT_SRC.."plaza.views.LogonScene","FADE",1)
end

return WelcomeScene