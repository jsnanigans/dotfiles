local M = {}

function M.setup()
  local group = vim.api.nvim_create_augroup("PythonUvSupport", { clear = true })
  
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = group,
    pattern = "*.py",
    callback = function()
      local cwd = vim.fn.getcwd()
      local venv_path = cwd .. "/.venv"
      
      if vim.fn.isdirectory(venv_path) == 1 then
        local python_path = venv_path .. "/bin/python"
        if vim.fn.executable(python_path) == 1 then
          vim.g.python3_host_prog = python_path
          
          local pyproject = cwd .. "/pyproject.toml"
          if vim.fn.filereadable(pyproject) == 1 then
            local content = vim.fn.readfile(pyproject)
            local is_uv = false
            for _, line in ipairs(content) do
              if line:match("tool%.uv") or line:match("managed = true") then
                is_uv = true
                break
              end
            end
            
            if is_uv then
              vim.notify("UV project detected, using .venv", vim.log.levels.INFO)
            end
          end
        end
      end
    end,
  })
  
  vim.api.nvim_create_user_command("UvSync", function()
    local cwd = vim.fn.getcwd()
    vim.notify("Syncing uv dependencies...", vim.log.levels.INFO)
    vim.fn.jobstart({ "uv", "sync" }, {
      cwd = cwd,
      on_exit = function(_, exit_code)
        if exit_code == 0 then
          vim.notify("UV sync completed successfully", vim.log.levels.INFO)
          vim.cmd("LspRestart")
        else
          vim.notify("UV sync failed", vim.log.levels.ERROR)
        end
      end,
    })
  end, { desc = "Sync uv dependencies" })
  
  vim.api.nvim_create_user_command("UvInstall", function(opts)
    local package = opts.args
    if package == "" then
      vim.notify("Please provide a package name", vim.log.levels.ERROR)
      return
    end
    
    local cwd = vim.fn.getcwd()
    vim.notify("Installing " .. package .. "...", vim.log.levels.INFO)
    vim.fn.jobstart({ "uv", "add", package }, {
      cwd = cwd,
      on_exit = function(_, exit_code)
        if exit_code == 0 then
          vim.notify("Package installed: " .. package, vim.log.levels.INFO)
          vim.cmd("LspRestart")
        else
          vim.notify("Failed to install: " .. package, vim.log.levels.ERROR)
        end
      end,
    })
  end, { nargs = 1, desc = "Install a package with uv" })
end

return M