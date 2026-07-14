require("josean.core")
require("josean.lazy")

vim.api.nvim_create_user_command("Wsync", function()
  local job_id = vim.fn.jobstart({ vim.fn.expand("~/.local/bin/wowsync") }, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify("WoW AddOns synced successfully", vim.log.levels.INFO)
      else
        vim.notify("WoW sync failed (exit code " .. exit_code .. ")", vim.log.levels.ERROR)
      end
    end,
  })
  if job_id == -1 then
    vim.notify("Could not start wowsync — is it on PATH?", vim.log.levels.ERROR)
  end
end, {})
