local sudo_write = function()
  local tmpfile = vim.fn.tempname()
  local filepath = vim.fn.expand "%"
  if #filepath == 0 then
    vim.api.nvim_err_writeln "E32: No file name"
    return
  end
  local ok, _ = pcall(vim.cmd, "w")
  if ok then
    return
  end
  local msg = vim.api.nvim_exec("w! " .. tmpfile, true)
  vim.fn.inputsave()
  local out = vim.fn.system(
    "sudo -p '' -S "
      .. string.format(
        "dd if=%s of=%s bs=1048576",
        vim.fn.shellescape(tmpfile),
        vim.fn.shellescape(filepath)
      ),
    vim.fn.inputsecret "Password: "
  )
  local status = vim.v.shell_error == 0
  vim.fn.inputrestore()
  print "\n"
  if status then
    print(msg:gsub(tmpfile, filepath))
    vim.cmd "e!"
    vim.fn.delete(tmpfile)
  else
    vim.api.nvim_err_writeln("E208: " .. out)
    tmpfile = vim.fn.fnamemodify(tmpfile, ":h:t")
    local tmp = vim.split(vim.fn.expand "%:t", "%.")
    tmp[1] = tmp[1] .. tmpfile
    local storefile = "/var/tmp/" .. table.concat(tmp, ".")
    vim.api.nvim_exec("w! " .. storefile, true)
    print("Couldn't save, temporary file saved in " .. storefile)
  end
end

vim.api.nvim_create_user_command(
  "W",
  sudo_write,
  { desc = "Write to file with proper permissions, preserve on error." }
)
