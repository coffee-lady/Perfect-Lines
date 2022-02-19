local Selector = require('src.libs.tools.easings.selector.selector')
local Binds = require('src.libs.tools.easings.bind.bind')

local EasingsLib = {}

EasingsLib.go = Selector(Binds.Go)
EasingsLib.gui = Selector(Binds.Gui)

return EasingsLib
