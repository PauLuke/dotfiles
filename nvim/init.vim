" add line numbers
set number

" use system clipboard
set clipboard=unnamedplus

" highlight current cursorline
set cursorline

" enable mouse support in (a)ll modes
set mouse=a

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

"""""""""""""""""
"" Status line ""
"""""""""""""""""
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


"""""""""""""
"" Mapping ""
"""""""""""""

" Using space as leader
let mapleader = " "

" Map Ctrl+S to save in normal and insert modes
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>

" Launch plugins
nnoremap <silent> t :Telescope find_files<CR>
nnoremap <silent> <leader>n :Neotree toggle<CR>

" open terminal
nnoremap <C-t> :10sp term://bash \| set nobuflisted<CR>
" make terminal open at the bottom
set splitbelow


""""""""""""""
"" Vim-plug ""
""""""""""""""

" vim-plug is located under ~/.local/share/nvim/site/autoload/ and the plugins it installs are in ~/.local/share/nvim/plugged/ 
call plug#begin()
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install' }
Plug 'nvim-telescope/telescope.nvim', { 'tag': 'v0.2.1' } " The official repo recommend pinning to the latest release tag (go to Github to see what the latest release tag is)
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'echasnovski/mini.nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'folke/noice.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'saghen/blink.cmp', " Rust fuzzy implementation require manual intervention. Go to '~/.local/share/nvim/plugged/blink.cmp' and run 'cargo build --release'. This will build the rust fuzzy matcher that blink uses. An alternative is to use Lua fuzzy implementation.
Plug 'lukas-reineke/indent-blankline.nvim'
Plug '3rd/image.nvim'
call plug#end()


"""""""""""
"" Theme ""
"""""""""""
colorscheme catppuccin-macchiato " Options: catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha


""""""""""""""
"" Lua code ""
""""""""""""""

lua << EOF
require'nvim-treesitter'.install { 'c', 'markdown', 'markdown_inline' }
require('mini.pairs').setup()
require("bufferline").setup{ options = {offsets = {{filetype = "neo-tree", text="Neo Tree", separator= true, text_align = "left" }}}}
require("neo-tree").setup{window = {width = 29}}
require("noice").setup()
require("notify").setup{render = "compact", timeout = 5000}
require("ibl").setup()
require("image").setup()
require('blink.cmp').setup({
  keymap = {
    preset = 'none',
    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<CR>'] = { 'select_and_accept', 'fallback' },
    ['<S-Tab>'] = { 'snippet_forward', 'fallback' }
  },
  fuzzy = {
    implementation = "lua"
  }
})

 -- Setup LSP using vim.lsp.config
vim.lsp.config['python'] = { 
  cmd = { 'pylsp' }, -- Command and arguments to start the server.
  filetypes = { 'python' }, -- Filetypes to automatically attach to.
}

vim.lsp.config['c'] = {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp' },
}

vim.lsp.config['rust'] = {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
}

vim.lsp.enable('python')
vim.lsp.enable('c')
vim.lsp.enable('rust')

-- Show diagnostic messages
vim.keymap.set('n', '<leader>d', function()
  vim.diagnostic.open_float()
end, { desc = "Show diagnostic" })

EOF
