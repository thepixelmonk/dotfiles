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

vim.opt.shiftwidth = 4
vim.g.astro_stylus = "enable"
vim.g.astro_typescript = "enable"

vim.api.nvim_set_keymap('n', '<c-w><space>', ':lua FocusFirstFloat()<cr>', bufopts)

lvim.plugins = {
  {
    "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup()
    end
  },
  {
    "ThePrimeagen/harpoon",
      config = function()
        require("harpoon").setup()
    end
  },
  {
    "bloznelis/before.nvim",
      config = function()
        require("before").setup({
          history_size = 10,
          history_wrap_enabled = true,
          telescope_for_preview = true
        })
    end
  },
  {
    "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup()
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

lvim.builtin.which_key.mappings["e"] = {
  name = "+Edits",
  n = { ":lua require('before'):jump_to_next_edit()<cr>", "Next" },
  p = { ":lua require('before'):jump_to_last_edit()<cr>", "Previous" },
  l = { ":lua require('before'):show_edits()<cr>", "List" },
}

lvim.builtin.which_key.mappings["h"] = {
  name = "+Harpoon",
  a = { ":lua require('harpoon'):list():append()<cr>", "Append" },
  m = { ":Telescope harpoon marks<cr>", "Marks" },
  s = { ":lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<cr>", "Scratchpad" },
}

