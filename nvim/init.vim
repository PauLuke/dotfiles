" add line numbers
set number

" using system clipboard
set clipboard=unnamedplus

" highlight current cursorline
set cursorline

" Status line
function! ModeName()
  let l:mode_map = {
        \ 'n': 'NORMAL',
        \ 'no': 'N·OPERATOR',
        \ 'v': 'VISUAL',
        \ 'V': 'V·LINE',
        \ "\<C-v>": 'V·BLOCK',
        \ 's': 'SELECT',
        \ 'S': 'S·LINE',
        \ "\<C-s>": 'S·BLOCK',
        \ 'i': 'INSERT',
        \ 'ic': 'INSERT',
        \ 'ix': 'INSERT',
        \ 'R': 'REPLACE',
        \ 'Rv': 'V·REPLACE',
        \ 'c': 'COMMAND',
        \ 'cv': 'EX',
        \ 'ce': 'EX',
        \ 'r': '…INPUT',
        \ 'rm': '—MORE',
        \ 't': 'TERMINAL',
        \ }
  return get(l:mode_map, mode(), mode())
endfunction

highlight StatusMode guibg=#45475a guifg=#89b4fa gui=bold
highlight StatusFile guibg=#45475a guifg=#a6e3a1 gui=bold

set laststatus=3
set statusline=
set statusline+=%#StatusMode#
set statusline+=\ %{ModeName()}
set statusline+=%=
set statusline+=%#StatusFile#
set statusline+=\ %f

" Config for tabs
set expandtab " Use spaces instead of tabs
set tabstop=2 " Number of spaces a tab counts for
set softtabstop=2 " Number of spaces a <Tab> feels like
set shiftwidth=2 " Number of spaces for each indentation level

" enable mouse support in (a)ll modes
set mouse=a

" Mapping
" Using space as leader
let mapleader = " "
" Map Ctrl+S to save in normal and insert modes
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>
" Launch plugins
nnoremap <silent> t :Telescope find_files<CR>
nnoremap <silent> <leader>n :Neotree toggle<CR>
nnoremap <silent> <leader>e :ToggleTerm<CR>

" Vim-plug section
" vim-plug is located under ~/.local/share/nvim/site/autoload/ and the plugins
" it installs are located in ~/.local/share/nvim/plugged/ 
call plug#begin()
" My plugins
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'echasnovski/mini.nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'windwp/nvim-ts-autotag' " nvim-ts-autotag will not work unless you have treesitter parsers (like html) installed for a given filetype. To do this you can run :TSInstall <language_to_install>
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'folke/noice.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'saghen/blink.cmp' " require manual intervention. Go to '~/.local/share/nvim/plugged/blink.cmp' and run 'cargo build --release'. This will build the rust fuzzy matcher that blink uses. There is a way to make vim-plug do this automatically, but I don't know how to do it.
Plug 'lukas-reineke/indent-blankline.nvim'
call plug#end()

" Setting theme
colorscheme catppuccin-macchiato " Options: catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha

" integrating Lua code
lua << EOF
require('nvim-ts-autotag').setup()
require('mini.pairs').setup()
require("bufferline").setup{ options = {offsets = {{filetype = "neo-tree", text="Neo Tree", separator= true, text_align = "left" }}}}
require("neo-tree").setup{window = {width = 29}}
require("toggleterm").setup{size = 10, persist_mode = false,
-- Make toggleterm respect neo-tree space:
on_open = function(_)
    local name = vim.fn.bufname("neo-tree")
    local winnr = vim.fn.bufwinnr(name)

    if winnr ~= -1 then
      vim.defer_fn(function()
        local cmd = string.format("Neotree toggle")
        vim.cmd(cmd)
        vim.cmd(cmd)
        vim.cmd("wincmd p")
      end, 100)
    end
  end,
}
require("noice").setup()
require('blink.cmp').setup{keymap = {preset = 'none', ['<Up>'] = { 'select_prev', 'fallback' }, ['<Down>'] = { 'select_next', 'fallback' }, ['<CR>'] = { 'select_and_accept', 'fallback' }, ['<S-Tab>'] = { 'snippet_forward', 'fallback' }}, fuzzy = { implementation = "prefer_rust" }, completion = {documentation = {auto_show = false, window = {min_width = 0, max_width = 0, max_height = 0}}}}
require("ibl").setup()

-- Setup LSP using vim.lsp.config
vim.lsp.config['python'] = {
  -- Command and arguments to start the server.
  cmd = { 'pylsp' },
  -- Filetypes to automatically attach to.
  filetypes = { 'python' },
}
vim.lsp.config['c'] = {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp' },
}
vim.lsp.config['css'] = {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css' },
}
vim.lsp.config['rust'] = {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
}
vim.lsp.config['typescript'] = {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
}

vim.lsp.enable('python')
vim.lsp.enable('c')
vim.lsp.enable('css')
vim.lsp.enable('rust')
vim.lsp.enable('typescript')

EOF

