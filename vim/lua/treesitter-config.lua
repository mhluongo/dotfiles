-- Stable treesitter configuration for nvim-treesitter v0.9.3
-- Compatible with Neovim 0.9.5

require'nvim-treesitter.configs'.setup {
  -- Languages to ensure are installed
  ensure_installed = {
    "markdown",
    "markdown_inline",
    "rust",
    "clojure",
    "typescript",
    "javascript",
    "tsx", -- TSX handles JSX syntax
    "solidity",
    "lua",
    "vim",
    "html",
    "css",
    "json",
    "yaml",
    "toml",
    "bash",
    "gitcommit", -- for git commit messages
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = {},

  -- Highlighting configuration
  highlight = {
    -- Enable treesitter highlighting
    enable = true,

    -- Disable for large files for performance or problematic parsers
    disable = function(lang, buf)
      -- Disable for large files
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end

      -- Temporarily disable Solidity if it causes issues
      -- Remove this line once the parser is stable
      if lang == "solidity" then
        return false -- Set to true if Solidity causes persistent errors
      end

      return false
    end,

    -- Run both treesitter and vim regex highlighting for markdown
    -- This ensures compatibility and full highlighting
    additional_vim_regex_highlighting = { "markdown" },
  },

  -- Indentation configuration
  indent = {
    enable = true,
    -- Disable for languages where treesitter indent is problematic
    disable = { "python", "yaml" },
  },

  -- Incremental selection configuration
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },

  -- Textobjects configuration
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        -- Markdown specific
        ["ah"] = "@heading.outer",
        ["ih"] = "@heading.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
        ["]h"] = "@heading.outer",
        ["]b"] = "@block.outer",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]C"] = "@class.outer",
        ["]H"] = "@heading.outer",
        ["]B"] = "@block.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[h"] = "@heading.outer",
        ["[b"] = "@block.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[C"] = "@class.outer",
        ["[H"] = "@heading.outer",
        ["[B"] = "@block.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
}

-- Configure treesitter folding for all supported languages
-- This works with vim's mkview/loadview system
vim.api.nvim_create_augroup("TreesitterFolding", { clear = true })

-- Check if treesitter is available for current buffer
local function has_treesitter_support()
  local ok, parsers = pcall(require, 'nvim-treesitter.parsers')
  if not ok then
    return false
  end

  local lang = parsers.get_buf_lang()
  if not lang then
    return false
  end

  return parsers.has_parser(lang)
end

-- Set up treesitter folding method after FileType is detected
vim.api.nvim_create_autocmd("FileType", {
  group = "TreesitterFolding",
  pattern = "*",
  callback = function()
    if has_treesitter_support() then
      -- Use treesitter folding
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt_local.foldnestmax = 6  -- Support deep nesting
      vim.opt_local.foldenable = true

      -- Simple, generic fold text that works for all languages
      vim.opt_local.foldtext = "v:lua.simple_fold_text()"

      -- Set default fold level only if no view was loaded (new file)
      -- This allows saved folds to be restored properly
      if not vim.b.view_loaded then
        vim.opt_local.foldlevel = 1  -- Conservative default for all languages
      end
    end
  end,
})

-- Ensure treesitter settings persist after view loading
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = "TreesitterFolding",
  pattern = "*",
  callback = function()
    if has_treesitter_support() then
      -- Reapply treesitter settings after view loads
      vim.schedule(function()
        if has_treesitter_support() then
          vim.opt_local.foldmethod = "expr"
          vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
          vim.opt_local.foldtext = "v:lua.simple_fold_text()"
          -- Mark that view was loaded so we don't override foldlevel
          vim.b.view_loaded = true
        end
      end)
    end
  end,
})

-- Simple, generic fold text function that lets treesitter do the work
function _G.simple_fold_text()
  local line = vim.fn.getline(vim.v.foldstart)
  local line_count = vim.v.foldend - vim.v.foldstart + 1

  -- Clean up the line (remove leading/trailing whitespace)
  line = line:gsub("^%s*", ""):gsub("%s*$", "")

  -- Truncate long lines
  local display_line = line:sub(1, 60)
  if #line > 60 then
    display_line = display_line .. "..."
  end

  return display_line .. " (" .. line_count .. " lines)"
end
