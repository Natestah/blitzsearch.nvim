local M = {}

function M.load()
    require("blitzsearch.blitz_config_watch").watch()
end

M.load()
return M
