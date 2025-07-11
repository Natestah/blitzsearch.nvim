local fwatch = require('fwatch')

local M = {}


--please forgive/correct me on any of this if it's a LUA/NVIM extension nono
local current_file = "";
local line_number = 0;
local column_number = 0;


function M.SwitchToFile()
  local fullpath = vim.fn.fnamemodify(current_file, ":p") -- Get the absolute path.
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do -- Iterate through all buffers.

    local bufname = vim.api.nvim_buf_get_name(bufnr) -- Get the buffer name/path.
    if bufname == fullpath then
      vim.api.nvim_set_current_buf(bufnr)
      vim.api.nvim_win_set_cursor(0, {line_number, column_number})
      return true -- File is open
    end
  end
  vim.api.nvim_command("silent edit +" .. line_number .. " " .. fullpath)
  return false -- File is not open
end

function get_file_name(filepath)
  -- This pattern matches anything after the last '/' or '\'
  -- This makes it adaptable for both Unix-like and Windows paths
  return filepath:match("[^/\\]+$") 
end

function M.stringStartsWith(comparer,comparee)
  return string:sub(comparer, 0, string:len(comparee)) == comparee
end

function M.load()
    ---currently blitz search doesn't offer the context, which would be the between commas here. Solutions and projects are unknown to me so I can't do that yet.
    ---  File names ends up being this. Between the commas would normally be Solution/Workspace,ProcessID in order to make sure other extensions aren't contending.
    --- NVIM_GOTO_JSON,,.txt
    --- NVIM_GOTO_PREVIEW_JSON,,.txt
    
    local programfiles = os.getenv("AppData")
    local shared_config_path = programfiles .. "\\NathanSilvers\\POORMANS_IPC\\"
    fwatch.watch(shared_config_path, 
    {
      on_event = function(filename, events, unwatch)

      -- Responding to both "GOTO_PREVIEW_JSON" and actual "GOTO_JSON", for now.
      -- I believe that NeoVim supports a preview pane, but have not looked into that.
      
      -- if not M.stringStartsWith(filename,"NVIM_GOTO") then
      --   return
      -- end

      fullpath = shared_config_path .. filename

      local file = io.open(fullpath, "r+") -- Open the file in read mode ("r")

      if file then
          local content = file:read("*a") -- Read the entire file contents into the 'content' variable
          file:close() -- Close the file after reading
          local success, myTable = pcall(vim.json.decode, content)
          if success then
            current_file = myTable["FileName"]
            line_number = myTable["Line"]
            column_number = myTable["Column"]
            -- Something about this timer doesn't feel correct.
            timer = vim.loop.new_timer()
            timer:start(40, 0, vim.schedule_wrap(M.SwitchToFile))
          end
      else
          print("Error: Could not open the file " .. current_file) -- Handle cases where the file cannot be opened
      end
      end,
      on_error = function(error, unwatch)
        print("An error occured: " .. error)
      end
    })
end

M.load()
return M
