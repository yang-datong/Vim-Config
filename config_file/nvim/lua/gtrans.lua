---@diagnostic disable: undefined-global

local fn = vim.fn
local keymap = vim.keymap

local M = {}

local SAVED_REGS = { "a", '"', "*", "+" }

local function save_registers()
  local saved = {}
  for _, reg in ipairs(SAVED_REGS) do
    local ok, info = pcall(fn.getreginfo, reg)
    if ok and info then
      saved[reg] = info
    end
  end
  return saved
end

local function restore_registers(saved)
  for reg, info in pairs(saved) do
    pcall(fn.setreg, reg, info)
  end
end

local function build_command(mode)
  if mode == "sp" then
    return { "gtrans", "-s", "--timeout", "5" }
  elseif mode == "zh" then
    return { "gtrans", "--target", "zh", "--timeout", "8" }
  elseif mode == "en" then
    return { "gtrans", "--target", "en", "--timeout", "8" }
  end
  return nil
end

function M.visual_action(mode)
  if fn.executable("gtrans") == 0 then
    vim.notify("gtrans not found in PATH", vim.log.levels.ERROR, { title = "gtrans" })
    return
  end

  local cmd = build_command(mode)
  if not cmd then
    return
  end

  local saved_regs = save_registers()

  local ok, err = pcall(function()
    -- Copy current visual selection into register "a" and exit visual mode
    vim.cmd('noautocmd silent normal! "ay')

    local selected_text = fn.getreg("a")
    local reg_type = fn.getregtype("a")
    if vim.trim(selected_text) == "" then
      return
    end

    local result_text
    local err_msg
    if vim.system then
      local res = vim.system(cmd, { stdin = selected_text, text = true }):wait()
      if res.code ~= 0 then
        err_msg = vim.trim((res.stderr ~= "" and res.stderr) or res.stdout or "gtrans failed")
      else
        result_text = (res.stdout or ""):gsub("[\r\n]+$", "")
      end
    else
      local output = fn.system(cmd, selected_text)
      if vim.v.shell_error ~= 0 then
        err_msg = vim.trim(output)
      else
        result_text = output:gsub("[\r\n]+$", "")
      end
    end

    if err_msg or not result_text or result_text == "" then
      vim.notify(err_msg or "gtrans: empty result", vim.log.levels.ERROR, { title = "gtrans" })
      return
    end

    -- Preserve trailing newline when characterwise visual selection reached EOL (e.g. `v$`)
    if reg_type == "v" and selected_text:sub(-1) == "\n" then
      result_text = result_text .. "\n"
    end

    fn.setreg("a", result_text, reg_type)
    vim.cmd('noautocmd silent normal! gv"ap')
  end)

  restore_registers(saved_regs)

  if not ok then
    vim.notify(tostring(err), vim.log.levels.ERROR, { title = "gtrans" })
  end
end

function M.setup()
  local opts = { silent = true, noremap = true }
  keymap.set("x", "<leader>zh", function()
    M.visual_action("zh")
  end, vim.tbl_extend("force", opts, { desc = "Translate visual selection to Chinese" }))

  keymap.set("x", "<leader>en", function()
    M.visual_action("en")
  end, vim.tbl_extend("force", opts, { desc = "Translate visual selection to English" }))

  keymap.set("x", "<leader>sp", function()
    M.visual_action("sp")
  end, vim.tbl_extend("force", opts, { desc = "Speak visual selection and add US phonetic" }))
end

return M
