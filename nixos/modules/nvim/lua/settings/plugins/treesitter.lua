require('nvim-treesitter').setup {
  install_dir = vim.fn.stdpath('data') .. '/site',
}

local max_filesize = 100 * 1024 -- 100 KB

local function should_disable(buf)
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  return ok and stats and stats.size > max_filesize
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function(event)
    local buf = event.buf
    local lang = vim.treesitter.language.get_lang(event.match) or event.match

    if should_disable(buf) then
      return
    end

    local ok = pcall(vim.treesitter.start, buf, lang)
    if ok then
      -- optional: keep old regex highlighting alongside treesitter
      vim.bo[buf].syntax = 'on'
    end
  end,
})
