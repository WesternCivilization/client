--[[
	版本保存
]]
local Version = class("Version", function()
     local node = display.newNode()
     return node
end)	

function Version:ctor()
	self:retain()
	local sp = ""
	local fileUitls=cc.FileUtils:getInstance()
	--保存路径
	self._path = device.writablePath..sp.."version.plist"
	--保存信息
	self._versionInfo  = fileUitls:getValueMapFromFile(self._path)
	dump(self._versionInfo, "ver", 3)

	self._downUrl = nil

	--渠道号，功能控制版本号路径
	self._channelPath = "channel_version.plist"      
	self._channelInfo  = fileUitls:getValueMapFromFile(self._channelPath)
	dump(self._channelInfo, "channel", 3)

end

--设置版本， 只有一个参数的是大厅版本
function Version:setVersion(version,kindid)
	if not kindid then
		self._versionInfo["client"] = version
	else
		self._versionInfo["game_"..kindid] = version
	end
end

--获取版本
function Version:getVersion(kindid)
	if not kindid then 
		return self._versionInfo["client"]
	else
		return self._versionInfo["game_"..kindid]
	end
end


--获取渠道号
function Version:getChannelId()
	return  self._channelInfo["channelId"]
end

--获取功能控制版本号
function Version:getControlVersion()
	return  self._channelInfo["controlVersion"]
end

--获取是否是苹果企业版
function Version:getIsAppleEnterprice()
	return  self._channelInfo["isAppleEnterprice"]
end


--设置资源版本
function Version:setResVersion(version,kindid)
	if not kindid then
		self._versionInfo["res_client"] = version
	else
		self._versionInfo["res_game_"..kindid] = version
	end
	self:save()
end

--获取资源版本
function Version:getResVersion(kindid)
	if not kindid then 
		return self._versionInfo["res_client"]
	else
		return self._versionInfo["res_game_"..kindid]
	end
end

--保存版本
function Version:save()
	cc.FileUtils:getInstance():writeToFile(self._versionInfo,self._path)
end

return Version