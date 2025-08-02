vim.g.python3_host_prog = '/usr/bin/python3'
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.cmd.colorscheme('torte')

vim.opt.number = true
vim.opt.signcolumn = 'yes:1'
vim.opt.showtabline = 2

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.tabstop = 4

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Configure external package dependencies (async).
vim.pack.add({
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
    'https://github.com/nvim-treesitter/nvim-treesitter-context',
    'https://github.com/nvim-lua/plenary.nvim',
    { src = 'https://github.com/nvim-telescope/telescope.nvim', version = '0.1.8' },
})

-- Tabs.
vim.keymap.set('n', '<C-n>', vim.cmd.tabnew)
vim.keymap.set('n', '!@#control-tab$', vim.cmd.tabnext)
vim.keymap.set('n', '!@#control-shift-tab$', vim.cmd.tabprev)

-- File finder (Telescope is something like CtrlP).
--
-- https://github.com/nvim-telescope/telescope.nvim#default-mappings
require 'telescope'.setup {
    defaults = {
        preview = false,
    }
}

function vim.find_file()
    local function is_git_repo()
        vim.fn.system('git rev-parse --is-inside-work-tree')
        return vim.v.shell_error == 0
    end
    if is_git_repo() then
        require('telescope.builtin').git_files()
    else
        require('telescope.builtin').find_files()
    end
end

vim.find_string = require 'telescope.builtin'.live_grep
vim.keymap.set('n', '<C-p>', vim.find_file)
-- :help map-special-keys
vim.keymap.set('n', '<C-_>', vim.find_string, { remap = true }) -- i.e. <C-/>

-- Restore cursor position.
--
-- https://github.com/neovim/neovim/issues/16339#issuecomment-1457394370
vim.api.nvim_create_autocmd('BufRead', {
    callback = function(opts)
        vim.api.nvim_create_autocmd('BufWinEnter', {
            once = true,
            buffer = opts.buf,
            callback = function()
                local ft = vim.bo[opts.buf].filetype
                local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
                if
                    not (ft:match('commit') and ft:match('rebase'))
                    and last_known_line > 1
                    and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
                then
                    vim.api.nvim_feedkeys([[g`"]], 'nx', false)
                end
            end,
        })
    end,
})

-- Configure language servers (LS).
vim.lsp.enable({
    'clangd', 'gopls', 'hyprls', 'jedi_language_server', 'lua_ls',
    'rust_analyzer', 'systemd_ls', 'tinymist', 'tombi',
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        -- No idea what it is.
        vim.lsp.document_color.enable(true, args.buf)

        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method('textDocument/implementation') then
            -- Create a keymap for vim.lsp.buf.implementation ...
        end

        if client:supports_method('textDocument/completion') then
            -- Optional: trigger autocompletion on EVERY keypress. May be slow!
            --
            -- local chars = {}
            -- for i = 32, 126 do table.insert(chars, string.char(i)) end
            -- client.server_capabilities.completionProvider.triggerCharacters = chars
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end

        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end
    end,
})

-- Configure completion options.
vim.o.completeopt = 'menuone,noinsert,popup'
vim.keymap.set(
    'i', "<CR>", "pumvisible() ? '<C-y>' : '<CR>'",
    { noremap = true, expr = true })
vim.keymap.set(
    'i', "<Down>", "pumvisible() ? '<C-n>' : '<Down>'",
    { noremap = true, expr = true })
vim.keymap.set(
    'i', "<Up>", "pumvisible() ? '<C-p>' : '<Up>'",
    { noremap = true, expr = true })
vim.keymap.set(
    'i', "<Tab>", "pumvisible() ? '<C-n>' : '<Tab>'",
    { noremap = true, expr = true })
vim.keymap.set(
    'i', "<S-Tab>", "pumvisible() ? '<C-p>' : '<S-Tab>'",
    { noremap = true, expr = true })

-- Configure tree-sitter (aka TreeSitter, TS).
local ts_langs = {
    'cpp', 'cuda', 'dockerfile', 'git_config', 'git_rebase',
    'gitattributes', 'gitcommit', 'gitignore', 'go', 'gomod', 'gosum', 'html',
    'javascript', 'json', 'make', 'python', 'rust', 'sql',
    'toml', 'typst', 'yaml', 'zsh',
}
require 'nvim-treesitter'.install(ts_langs)

local ts_langs_system = { 'bash', 'c', 'lua', 'markdown', 'vim' }
for _, ts_lang in ipairs(ts_langs_system) do
    ts_langs[#ts_langs + 1] = ts_lang
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = ts_langs,
    callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = 'v:lua.require"nvim-treesitter".indentexpr()'
    end,
})

require 'treesitter-context'.setup {
    enable = true,
    max_lines = 5,
    min_window_height = 20,
    line_numbers = true,
    multiline_threshold = 1,
    trim_scope = 'outer', -- Alternative is `inner`.
    mode = 'topline',     -- Alternative is 'cursor'.
    separator = nil,
    zindex = 20,          -- The Z-index of the context window
}

vim.keymap.set("n", "[c", function()
    require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })
