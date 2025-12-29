local vim = vim

vim.cmd('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.cmd('let &packpath = &runtimepath')
vim.cmd('source ~/.vimrc')

require('settings.plugins')

local ts_select = require("nvim-treesitter.incremental_selection")

vim.keymap.set("v", "<M-k>", ts_select.node_incremental, { silent = true })
vim.keymap.set("v", "<M-j>", ts_select.node_decremental, { silent = true })
vim.keymap.set('x', 'p', '"_dP', { noremap = true })

vim.keymap.set("v", "<leader>s", "<Esc>/\\%V", { silent = false })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "nix",
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 2
  end,
})

local function git_cmd(args, cwd)
  local output = vim.fn.systemlist({ "git", unpack(args) }, cwd)
  if vim.v.shell_error ~= 0 then
    error(table.concat(output, "\n"))
  end
  return output[1]
end

_G.build_repo_url = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath == "" then
    print("No file path for current buffer.")
    return
  end

  local repo_root = git_cmd({ "rev-parse", "--show-toplevel" }, vim.fn.fnamemodify(filepath, ":h"))
  local branch = git_cmd({ "rev-parse", "--abbrev-ref", "HEAD" }, repo_root)

  local remote_url = git_cmd({ "remote", "get-url", "origin" }, repo_root)
  local repo_name = remote_url:match("([^/]+)%.git$") or remote_url:match("([^/]+)$") or "unknown-repo"

  local rel_path = filepath:sub(#repo_root + 2)

  local final_url = string.format(
    "https://git.bidderstack.com/bidderstack/%s/src/branch/%s/%s",
    repo_name,
    branch,
    rel_path
  )

  print(final_url)
  vim.fn.setreg("+", final_url)
end

vim.api.nvim_set_keymap(
  "n",
  "<leader>gu",
  "<cmd>lua build_repo_url()<CR>",
  { noremap = true, silent = true }
)

