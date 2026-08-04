local api = vim.api
local fn = vim.fn
local g = vim.g

local M = {}

local nerdtree_sync_in_progress = false

local nerdtree_current_file_highlight = {
	fg = "#ffffff",
	bg = "#3b5f73",
	bold = true,
	ctermfg = 255,
	ctermbg = 24,
}

function M.flag_enabled(name)
	local value = g[name]
	return value == nil or value == 1
end

function M.create_augroup(name)
	return api.nvim_create_augroup(name, { clear = true })
end

function M.nerdcommenter_toggle_normal()
	fn["nerdcommenter#Comment"]("n", "toggle")
	vim.cmd("normal 0j")
end

function M.nerdcommenter_toggle_visual_keep()
	fn["nerdcommenter#Comment"]("x", "invert")
end

function M.nerdcommenter_toggle_visual_move()
	fn["nerdcommenter#Comment"]("x", "invert")
	vim.cmd("normal 0j")
end

function M.set_nerdtree_current_file_highlight()
	api.nvim_set_hl(0, "NERDTreeCurrentFile", nerdtree_current_file_highlight)
end

local function nerdtree_window()
	for _, win in ipairs(api.nvim_list_wins()) do
		local buf = api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "nerdtree" then
			return win
		end
	end
end

local function tagbar_window()
	for _, win in ipairs(api.nvim_list_wins()) do
		local buf = api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "tagbar" then
			return win
		end
	end
end

local function layout_nerdtree_and_tagbar()
	local tree_win = nerdtree_window()
	local tagbar_win = tagbar_window()
	if not tree_win or not tagbar_win then
		return
	end

	api.nvim_win_call(tree_win, function()
		vim.cmd("vertical resize " .. (g.NERDTreeWinSize or 30))
		local sidebar_height = api.nvim_win_get_height(tree_win) + api.nvim_win_get_height(tagbar_win)
		vim.cmd("resize " .. math.floor(sidebar_height / 2))
	end)
end

function M.open_tagbar_below_nerdtree()
	local source_win = api.nvim_get_current_win()
	local tree_win = nerdtree_window()
	if tree_win then
		api.nvim_set_current_win(tree_win)
	end

	vim.cmd("TagbarOpen")
	layout_nerdtree_and_tagbar()

	if api.nvim_win_is_valid(source_win) then
		api.nvim_set_current_win(source_win)
	end
end

function M.toggle_tagbar_with_nerdtree_layout()
	if tagbar_window() then
		vim.cmd("TagbarClose")
		return
	end

	M.open_tagbar_below_nerdtree()
end

function M.mark_nerdtree_current_file()
	local tree_win = nerdtree_window()
	if not tree_win then
		return
	end

	local line = api.nvim_win_get_cursor(tree_win)[1]
	api.nvim_win_call(tree_win, function()
		local has_previous, match_id = pcall(api.nvim_win_get_var, tree_win, "nerdtree_current_file_match_id")
		if has_previous then
			pcall(fn.matchdelete, match_id)
		end

		match_id = fn.matchaddpos("NERDTreeCurrentFile", { { line } }, 100)
		api.nvim_win_set_var(tree_win, "nerdtree_current_file_match_id", match_id)
	end)
end

function M.should_sync_nerdtree_current_file(buf)
	return not nerdtree_sync_in_progress and vim.bo[buf].buftype == "" and vim.bo[buf].filetype ~= "nerdtree"
end

function M.sync_nerdtree_current_file()
	if nerdtree_sync_in_progress then
		return
	end

	local source_win = api.nvim_get_current_win()
	local source_buf = api.nvim_win_get_buf(source_win)
	if not nerdtree_window() or vim.bo[source_buf].buftype ~= "" or vim.bo[source_buf].filetype == "nerdtree" then
		return
	end

	nerdtree_sync_in_progress = true
	local ok, err = pcall(vim.cmd, "NERDTreeFind")
	if ok then
		M.mark_nerdtree_current_file()
	end
	if api.nvim_win_is_valid(source_win) then
		api.nvim_set_current_win(source_win)
	end
	nerdtree_sync_in_progress = false

	if not ok then
		vim.notify(err, vim.log.levels.WARN)
	end
end

return M
