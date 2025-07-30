local Blitz = require("blitzsearch.blitz")
local BlitzConfigWatch = require("blitzsearch.blitz_config_watch")

local function getWordUnderCursor() 
  return vim.fn.escape(vim.fn.expand('<cword>'), [[\/]])  
end

local function get_visual_selection()
  local lines = selection()
  -- Blitz Search doesn't support multiline searches at the moment.. 
  return lines[1];
  -- return table.concat(lines, '\n')
end


--referenced from  https://github.com/rwtnb/alpha4.nvim
function selection()
	local start_mark, end_mark
	start_mark = "v"
	end_mark = "."
	local _, srow, scol = unpack(vim.fn.getpos(start_mark))
	local _, erow, ecol = unpack(vim.fn.getpos(end_mark))

	-- visual line mode
	if vim.fn.mode() == "V" then
		if srow > erow then
			return vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
		else
			return vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
		end
	end

	-- regular visual mode
	if vim.fn.mode() == "v" then
		if srow < erow or (srow == erow and scol <= ecol) then
			return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
		else
			return vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
		end
	end

	-- visual block mode
	if vim.fn.mode() == "\22" then
		local lines = {}
		if srow > erow then
			srow, erow = erow, srow
		end
		if scol > ecol then
			scol, ecol = ecol, scol
		end
		for i = srow, erow do
			table.insert(
				lines,
				vim.api.nvim_buf_get_text(0, i - 1, math.min(scol - 1, ecol), i - 1, math.max(scol - 1, ecol), {})[1]
			)
		end
		return lines
	end
end

local function getLastFolderName(path)
    -- Normalize path separators to forward slashes for consistent processing
    path = path:gsub("\\", "/")

    -- Remove trailing slashes if present
    path = path:gsub("/+$", "")

    -- Find the last segment after the last forward slash
    local lastSegment = path:match(".*/([^/]+)$")

    -- If no slash was found (e.g., "folderName"), then the path itself is the last folder name
    if not lastSegment then
        lastSegment = path
    end

    return lastSegment
end


local function getSelectedText()
  local mode = vim.api.nvim_get_mode().mode
  local opts = {}
  -- \22 is an escaped version of <c-v> (CTRL-V) for blockwise visual mode
  if mode == "v" or mode == "V" or mode == "\\22" then
    return get_visual_selection()
  end
  return ""
end

local function get_editor_ID()
  local workingDir = vim.fn.getcwd()
  local name = getLastFolderName(workingDir)
  local file_safe_name = string.gsub(workingDir, "\\", "-" )
  file_safe_name = string.gsub(name, ":", "")
  file_safe_name = string.gsub(name, "/", "")
  return {
    ProcessId = vim.fn.getpid(),
    EditorId = {
		Title = name,
		Identity = file_safe_name,
		SolutionPath = workingDir
	},
    SearchBoxString = workingDir
	}
end


local function context_action(action_identifier)
  Blitz.run()
  local data = get_editor_ID()
  local mode = vim.api.nvim_get_mode().mode
  if( mode == 'v' or mode == 'V' or mode == "\22" ) then

    data.SearchBoxString = getSelectedText()
  else
	data.SearchBoxString = "@^" .. getWordUnderCursor()
  end
  BlitzConfigWatch.WriteCommand(action_identifier, vim.json.encode(data))
end

local function send_current_context()

	local workingDir = vim.fn.getcwd()
	local pid = vim.fn.getpid()
	-- "Name":"nvim-blitzsearch",
	-- "SolutionHashFrom":"c:\\nvim-blitzsearch",
	-- "ExeForIcon":"code.cmd","Folders":["c:\\nvim-blitzsearch"],
	-- "ProcessIdentity":49664,
	-- "ProcessPath":"C:\\Users\\Silvers\\AppData\\Local\\Programs\\Microsoft VS Code\\Code.exe"


	local workspace_ID = get_editor_ID()
	local data = {
	Name = workspace_ID.EditorId.Title,
    Folders = {workingDir},
    ExeForIcon = "nvim.exe",
    ProcessIdentity = pid
	}
	local commandFileName = "WORKSPACE_UPDATE," .. workspace_ID.EditorId.Title .. "," .. workspace_ID.EditorId.Identity

	BlitzConfigWatch.WriteCommand(commandFileName, vim.json.encode(data))
end


local function searchthis()
   send_current_context();
   return context_action("SET_CONTEXT_SEARCH")
end

local function replacethis()
   send_current_context();
  return context_action("SET_CONTEXT_REPLACE")
end

return {
  searchthis = searchthis,
  replacethis = replacethis
}
