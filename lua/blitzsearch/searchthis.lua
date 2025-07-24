local Blitz = require("blitzsearch.blitz")

local function run_search_string(searchCommand)

end

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


local function getSelectedText()
  local mode = vim.api.nvim_get_mode().mode
  local opts = {}
  -- \22 is an escaped version of <c-v> (CTRL-V) for blockwise visual mode
  if mode == "v" or mode == "V" or mode == "\\22" then
    return get_visual_selection()
  end
  -- return vim.fn.getregion(vim.fn.getpos "v", vim.fn.getpos ".", opts)
  return "no_selection"
end



local function searchthis()
  Blitz.run()
  local mode = vim.api.nvim_get_mode().mode
  if( mode == 'v' or mode == 'V' or mode == "\22" ) then

    print(getSelectedText());
    return true
  end
  -- print("hi")
  wordUnderCursor = getWordUnderCursor()
  print(wordUnderCursor)

  return true
end

return {
  searchthis = searchthis,
}
