
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("base/src/")
cc.FileUtils:getInstance():addSearchPath("base/res/")
cc.FileUtils:getInstance():addSearchPath("base/res/client/res/")

print=release_print    --release版本也打印，最终要去掉， added by cgp

--myApp中加入了client/res/   和writablePath
require "config"
require "cocos.init"

local function main()

    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
