---@class BlitzSearchBlitz
local Util = require("lazy.util")
local M = {}

function M.file_exists(file)
  return vim.uv.fs_stat(file) ~= nil
end

function M.run()
--Find the windows installer path.
  local programfiles = os.getenv("programfiles")
  local exe_path = programfiles .. "" .."\\blitz\\Blitz.exe"
  if not M.file_exists(exe_path) then
    print("cant find: " .. exe_path)
    vim.ui.select(
    { 'Yes', 'Cancel' },
    { prompt = 'Blitz Search is not installed, Goto the repository and get release?' },
    function(choice)
        if choice == 'Yes' then
              command = ('silent ! start \"\" ' .. "\"http://github.com/natestah/blitzsearch\"")  vim.cmd(command)
        else
            return false;
        end
    end
    )
    return false
  end
  local command = ('silent ! start \"\" ' .. "\"" .. exe_path .. "\"")  vim.cmd(command)
  return true
end

return M