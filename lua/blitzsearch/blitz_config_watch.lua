
-- File watching, "PoorMans IPC is a configuration shared between Plugins/Extensions for Blitz Search"
-- It is intended for User Invoked commands such as "Blitz Search this" and maybe some contextual.
-- Blitz Search can communicate a "Goto request" which is a JSON dictionary containing details.

local M = {}



function M.GetConfigPath()
  local programfiles = os.getenv("AppData")
  return programfiles .. "\\NathanSilvers\\POORMANS_IPC\\"
end



-- Watch a path for changes, call a callback on every change
--- @param path string
--- @param callback function
function M.watch()
  local handle = vim.uv.new_fs_event()
  local shared_config_path = M.GetConfigPath();

  if handle == nil then
    vim.notify('Error starting watch handle.', vim.log.levels.ERROR)
    return
  end

  local watch_config = {
    stat = false,
    watch_entry = false,
    recursive = true,
  }

  local uv_callback = function(err, filename)
    if err then
      vim.notify(string.format('Error: %s', err), vim.log.levels.ERROR)
      return
    end

    ---currently blitz search doesn't offer the context, which would be the between commas here. Solutions and projects are unknown to me so I can't do that yet.
    
    ---  File names ends up being this. Between the commas would normally be Solution/Workspace,ProcessID in order to make sure other extensions aren't contending.
    --- NVIM_GOTO_JSON,,.txt
    --- NVIM_GOTO_PREVIEW_JSON,,.txt
    --- 

    -- Responding to both "GOTO_PREVIEW_JSON" and actual "GOTO_JSON", for now.
    -- I believe that NeoVim supports a preview pane, but have not looked into that.
    if not filename then
      return
    end

    local fullpath = vim.fs.normalize(vim.fs.joinpath(shared_config_path, filename))

    if string.find(filename, "NVIM_GOTO_JSON", 1, true) ~= nil then
    -- Apply the callback on any event (change, rename, create...)
      vim.schedule(function() M.shared_config_changed(fullpath) end)
      return
    end
  
  end

  vim.uv.fs_event_start(handle, shared_config_path, watch_config, uv_callback)

  -- Stop when exiting neovim
  vim.api.nvim_create_autocmd('VimLeave', {
    callback = function()
      vim.uv.close(handle)
    end,
  })
end

function M.WriteCommand(command, searchText)
  
  local shared_config_path = M.GetConfigPath();
  local fullpath = vim.fs.normalize(vim.fs.joinpath(shared_config_path, command .. ".txt"))
  local file = io.open(fullpath, "w")
  if file then
      file:write(searchText)
      file:close()
  else
  end
end


function M.switch_to_file(blitz_command_json_table)
  local current_file = blitz_command_json_table["FileName"]
  local line_number = blitz_command_json_table["Line"]
  local column_number = blitz_command_json_table["Column"]
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
  -- Note that Blitz Search as of the time of this writing is Windows only, but has asperations for Linux/MAC versions
  return filepath:match("[^/\\]+$") 
end


function M.shared_config_changed(fullpath)
      local file = io.open(fullpath, "r+") -- Open the file in read mode ("r")

      if file then
          local content = file:read("*a") -- Read the entire file contents into the 'content' variable
          file:close() -- Close the file after reading
          local success, myTable = pcall(vim.json.decode, content)
          if success then
            M.switch_to_file(myTable);
          end
      else
          print("Error: Could not open the file " .. current_file) -- Handle cases where the file cannot be opened
      end
end

return M
