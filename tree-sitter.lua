return {
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "erlang", "elixir", "rust", "javascript", "typescript", "markdown", "nu" },

        auto_install = true,

        highlight = {
          enable = true,
        },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = false,
            scope_incremental = false,
            node_incremental = "v",
            node_decremental = "V",
          },
        },
        textobjects = {
          move = {
            enable = true,
            goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
            goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
            goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
          },
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              -- ["as"] = { query = "@scope", desc = "Scope" },
              -- ["is"] = { query = "@locals.scope", desc = "Scope" },
              -- ["is"] = { query = "@scope.inner", desc = "Select scope contents" },
              -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- nvim_buf_set_keymap) which plugins like which-key display
              -- You can also use captures from other query groups like `locals.scm`
              -- ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
              -- ['@function.outer'] = 'V', -- linewise
              -- ['@function.inner'] = 'v', -- linewise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true or false
            include_surrounding_whitespace = true,
          },
        },
      })
      local ts_utils = require("nvim-treesitter.ts_utils")

      local node_list = {}
      local current_index = nil

      function start_select()
        node_list = {}
        current_index = nil
        current_index = 1
        vim.cmd("normal! v")
      end

      function find_expand_node(node)
        local start_row, start_col, end_row, end_col = node:range()
        local parent = node:parent()
        if parent == nil then
          return nil
        end
        local parent_start_row, parent_start_col, parent_end_row, parent_end_col = parent:range()
        if
            start_row == parent_start_row
            and start_col == parent_start_col
            and end_row == parent_end_row
            and end_col == parent_end_col
        then
          return find_expand_node(parent)
        end
        return parent
      end

      function select_parent_node()
        if current_index == nil then
          return
        end

        local node = node_list[current_index - 1]
        local parent = nil
        if node == nil then
          parent = ts_utils.get_node_at_cursor()
        else
          parent = find_expand_node(node)
        end
        if not parent then
          vim.cmd("normal! gv")
          return
        end

        table.insert(node_list, parent)
        current_index = current_index + 1
        local start_row, start_col, end_row, end_col = parent:range()
        vim.fn.setpos(".", { 0, start_row + 1, start_col + 1, 0 })
        vim.cmd("normal! v")
        vim.fn.setpos(".", { 0, end_row + 1, end_col, 0 })
      end

      function restore_last_selection()
        if not current_index or current_index <= 1 then
          return
        end

        current_index = current_index - 1
        local node = node_list[current_index]
        local start_row, start_col, end_row, end_col = node:range()
        vim.fn.setpos(".", { 0, start_row + 1, start_col + 1, 0 })
        vim.cmd("normal! v")
        vim.fn.setpos(".", { 0, end_row + 1, end_col, 0 })
      end

      vim.api.nvim_set_keymap("v", "v", ":lua select_parent_node()<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "V", ":lua restore_last_selection()<CR>", { noremap = true, silent = true })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects"
  }
}
