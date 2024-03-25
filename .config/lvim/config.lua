local bufopts = { noremap = true, silent = true }
local gpt = {
  openai_params = {
    model = "gpt-4",
  },
  openai_edit_params = {
    model = "gpt-4",
  },
}

function FocusFirstFloat()
    local windows = vim.api.nvim_list_wins()
    for _, win in ipairs(windows) do
        local config = vim.api.nvim_win_get_config(win)
        if config.focusable and config.relative ~= "" then
            vim.api.nvim_set_current_win(win) -- Focus the first floating window
            return
        end
    end
end

function OpenFloatDiagnostic()
    local diagnostics = vim.diagnostic.get(0)

    if next(diagnostics) == nil then
        print("No diagnostics available")
        return
    end

    vim.diagnostic.open_float(0, { scope = 'line' })
end

local tconf = require("telescope.config").values
function HarpoonToggle(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = tconf.file_previewer({}),
        sorter = tconf.generic_sorter({}),
    }):find()
end

require("lspconfig").astro.setup({
    init_options = {
      typescript = {
        tsdk = 'node_modules/typescript/lib'
      }
    }
})

vim.opt.shiftwidth = 4
vim.g.astro_stylus = "enable"
vim.g.astro_typescript = "enable"

vim.api.nvim_set_keymap('n', '<c-w><space>', ':lua FocusFirstFloat()<cr>', bufopts)

lvim.plugins = {
  {
    "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup({})
      end
  },
  {
    "ThePrimeagen/harpoon",
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        local harpoon = require('harpoon')
        harpoon.setup({})
        lvim.builtin.which_key.mappings["z"] = { function() harpoon:list():append() end, "Append" }
      end
  },
  {
    "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup({})
    end
  },
  {
    'jinh0/eyeliner.nvim',
      config = function()
        require'eyeliner'.setup({
          highlight_on_key = true
        })
      end
  },
  {
    "laytan/cloak.nvim",
      config = function()
        require("cloak").setup({
          enabled = true,
          cloak_character = '*',
          highlight_group = 'Comment',
          cloak_length = nil,
          try_all_patterns = true,
          patterns = {
            {
              file_pattern = '.env*',
              cloak_pattern = '=.+',
              replace = null,
            },
          },
        })
    end
  },
  {
    "jackMort/ChatGPT.nvim",
      event = "VeryLazy",
      config = function()
        require("chatgpt").setup(gpt)
      end,
      dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "folke/trouble.nvim",
        "nvim-telescope/telescope.nvim"
      }
  }
}

lvim.builtin.which_key.mappings["x"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" }
lvim.builtin.which_key.mappings["t"] = { "<cmd>ToggleTerm<cr>", "Terminal" }
lvim.builtin.which_key.mappings["d"] = { function() OpenFloatDiagnostic() end, "Diagnostics" }

lvim.builtin.which_key.mappings["a"] = {
  name = "+AI",
  c = { ":ChatGPT<cr>", "Chat" },
  e = { ":ChatGPTEditWithInstructions<cr>", "Edit" },
}

lvim.builtin.which_key.mappings["d"] = {
  name = "+Diagnostics",
  c = { function() OpenFloatDiagnostic() end, "Current" },
  l = { ":Telescope diagnostics<cr>", "List" },
}

lvim.builtin.which_key.mappings["h"] = {
  name = "+Harpoon",
  a = { ":lua require('harpoon'):list():append()<cr>", "Append" },
  l = { ":lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<cr>", "List" },
  t = { ":lua HarpoonToggle(require('harpoon'):list())<cr>", "Telescope" },
  s = { ":lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<cr>", "Scratchpad" },
}

