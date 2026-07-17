local md_augroup = vim.api.nvim_create_augroup("MarkdownDateModified", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.md",
  group = md_augroup,
  callback = function()
    vim.b._pre_write_changedtick = vim.b.changedtick
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.md",
  group = md_augroup,
  callback = function()
    if vim.b._pre_write_changedtick == vim.b.changedtick then
      return
    end

    local relpath = vim.fn.expand("%")
    if relpath == "templates/metadata.md" then
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local now = os.date("%d-%m-%Y %H:%M:%S")
    local in_frontmatter = false

    for i, line in ipairs(lines) do
      if line:match("^---$") then
        if not in_frontmatter then
          in_frontmatter = true
        else
          break
        end
      elseif in_frontmatter and line:match("^date modified:") then
        local new_line = "date modified: " .. now
        if line ~= new_line then
          vim.api.nvim_buf_set_lines(bufnr, i - 1, i, false, { new_line })
          vim.cmd("noautocmd w")
        end
        break
      end
    end
  end,
})
