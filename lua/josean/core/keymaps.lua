vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- keep cursor centered vertically
keymap.set("n", "j", "jzz", { desc = "Keep cursor centered when scrolling down" })
keymap.set("n", "k", "kzz", { desc = "Keep cursor centered when scrolling up" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Search for visually selected text
-- Visually select text, then type // to search for the next occurrence
keymap.set("v", "//", function()
  -- Yank the visually selected text into register "
  vim.cmd("normal! y")
  -- Get the yanked text
  local selected = vim.fn.getreg('"')
  -- Escape special characters and search
  local escaped = vim.fn.escape(selected, "/\\")
  vim.fn.execute("/\\V" .. escaped)
end, { noremap = true })

keymap.set("n", "<leader>cf", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  print("Copied: " .. path)
end, { desc = "Copy relative file path" })

keymap.set("n", "<leader>cF", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("Copied: " .. path)
end, { desc = "Copy absolute file path" })

-- Copy current file's parent folder relative path
keymap.set("n", "<leader>cp", function()
  local current_file = vim.fn.expand("%")
  local parent_folder = vim.fn.fnamemodify(current_file, ":h")
  vim.fn.setreg("+", parent_folder)
  print("Copied parent folder path: " .. parent_folder)
end, { desc = "Copy parent folder relative path" })

-- Create Angular component with --skip-test in current directory
keymap.set("n", "<leader>ngc", function()
  local current_dir = vim.fn.expand("%:p:h")
  vim.ui.input({ prompt = "Component name: " }, function(component_name)
    if component_name and component_name ~= "" then
      local command = string.format("cd %s && ng g c %s --skip-tests", current_dir, component_name)
      vim.fn.system(command)
      if vim.v.shell_error == 0 then
        print("Component created: " .. component_name)
        vim.cmd("edit!") -- Refresh file explorer
      else
        print("Error creating component")
      end
    end
  end)
end, { desc = "Create Angular component (--skip-tests)" })

-- Create Angular service in current directory
keymap.set("n", "<leader>ngs", function()
  local current_dir = vim.fn.expand("%:p:h")
  vim.ui.input({ prompt = "Service name: " }, function(service_name)
    if service_name and service_name ~= "" then
      local command = string.format("cd %s && ng g s %s --skip-tests", current_dir, service_name)
      vim.fn.system(command)
      if vim.v.shell_error == 0 then
        print("Service created: " .. service_name)
        vim.cmd("edit!") -- Refresh file explorer
      else
        print("Error creating service")
      end
    end
  end)
end, { desc = "Create Angular service (--skip-tests)" })

-- Generate routing module
keymap.set("n", "<leader>ngr", function()
  local current_dir = vim.fn.expand("%:p:h")
  vim.ui.input({ prompt = "Routing module name (e.g., app, admin, feature): " }, function(routing_name)
    if routing_name and routing_name ~= "" then
      local command = string.format("cd %s && ng g m %s --routing --flat", current_dir, routing_name)
      vim.fn.system(command)
      if vim.v.shell_error == 0 then
        print("Routing module created: " .. routing_name)
        vim.cmd("edit!") -- Refresh file explorer
      else
        print("Error creating routing module")
      end
    end
  end)
end, { desc = "Generate Angular routing module" })

-- keymap.set("n", "<leader>zkm", function() end, { desc = "Pastes markdown frontmatter metadata" })
keymap.set("n", "<leader>zkm", function()
  local path = "templates/metadata.md"
  local file = io.open(path, "r")
  if not file then
    vim.notify("metadata.md not found", vim.log.levels.WARN)
    return
  end
  local content = file:read("*a")
  file:close()

  vim.cmd("normal! gg")
  vim.fn.setreg("z", content)
  vim.cmd('normal! "zP')

  vim.notify("metadata.md pasted at top", vim.log.levels.INFO)
end, { desc = "Pastes markdown frontmatter metadata at top" })
