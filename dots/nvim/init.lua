vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = false

vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 250

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true

vim.opt.inccommand = "split"

vim.opt.cursorline = true

vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 14

vim.keymap.set("n", "<leader>qq", "ZZ", { desc = "Exit Neovim" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Open [C]ode [Q]uickfixes" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<left>", "")
vim.keymap.set("n", "<right>", "")
vim.keymap.set("n", "<up>", "")
vim.keymap.set("n", "<down>", "")

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move window focus left" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move window focus down" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move window focus up" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move window focus right" })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

require("config.init")
