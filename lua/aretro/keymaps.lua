local map = vim.keymap.set

map("n", "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true })
map("n", "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true })

map("n", "<C-h>", "<C-w>h", { desc = "Go to the left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to the window below" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to the above window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to the right window" })

map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window breadth" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window breadth" })

map("n", "<A-j>", ":m .+1<cr>==", { desc = "Move down" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("i", "<A-j>", "<Esc>:m .+1<cr>==gi", { desc = "Move down" })
map("n", "<A-k>", ":m .-2<cr>==", { desc = "Move up" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })
map("i", "<A-k>", "<Esc>:m .-2<cr>==gi", { desc = "Move up" })

map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("n", "<A-r>", [[:%s/\V<C-r>///g<left><left>]], { desc = "Replace text searched" })
map("v", "<A-r>", [[:'<,'>s/\V<C-r>///g<left><left>]], { desc = "Replace text searched" })

map({ "n", "x" }, "c", [["_c]])
map("n", "cc", [["_cc]])
map("n", "x", [["_x]])
map("n", "<A-s>", "<cmd>silent %y+<cr>", { silent = true })

map("v", ">", ">gv")
map("v", "<", "<gv")
