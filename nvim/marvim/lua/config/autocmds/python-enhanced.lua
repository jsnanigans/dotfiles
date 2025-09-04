local M = {}

function M.setup()
  local group = vim.api.nvim_create_augroup("PythonEnhanced", { clear = true })
  
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
          
          vim.env.VIRTUAL_ENV = venv_path
          vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH
          
          local pythonpath = venv_path .. "/lib/python3.11/site-packages"
          local pythonpath_alt = venv_path .. "/lib/python3.12/site-packages"
          
          if vim.fn.isdirectory(pythonpath) == 1 then
            vim.env.PYTHONPATH = pythonpath
          elseif vim.fn.isdirectory(pythonpath_alt) == 1 then
            vim.env.PYTHONPATH = pythonpath_alt
          end
          
          vim.notify("Python venv activated: " .. venv_path, vim.log.levels.INFO)
        end
      end
      
      local pyrightconfig = cwd .. "/pyrightconfig.json"
      if vim.fn.filereadable(pyrightconfig) == 0 then
        local config = vim.json.encode({
          include = { "**/*.py" },
          exclude = { "**/node_modules", "**/__pycache__", "**/.*", "venv", ".venv" },
          reportMissingImports = false,
          reportMissingTypeStubs = false,
          pythonVersion = "3.11",
          venvPath = ".",
          venv = ".venv"
        })
        vim.fn.writefile(vim.split(config, "\n"), pyrightconfig)
        vim.notify("Created pyrightconfig.json", vim.log.levels.INFO)
      end
    end,
  })
  
  vim.api.nvim_create_user_command("PythonResetLSP", function()
    vim.cmd("LspStop")
    vim.defer_fn(function()
      vim.cmd("LspStart")
      vim.notify("Python LSP restarted", vim.log.levels.INFO)
    end, 100)
  end, { desc = "Reset Python LSP servers" })
  
  vim.api.nvim_create_user_command("PythonCheckEnv", function()
    local venv = vim.env.VIRTUAL_ENV or "None"
    local pythonpath = vim.env.PYTHONPATH or "None"
    local python_host = vim.g.python3_host_prog or "Default"
    
    local msg = string.format(
      "Python Environment:\n" ..
      "VIRTUAL_ENV: %s\n" ..
      "PYTHONPATH: %s\n" ..
      "Python Host: %s",
      venv, pythonpath, python_host
    )
    vim.notify(msg, vim.log.levels.INFO)
  end, { desc = "Check Python environment settings" })
end

return M