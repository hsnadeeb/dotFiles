return function()
  local utils = require("config.utils")
  local map = utils.map

  require("spectre").setup({
    is_open_window = true,
    is_insert_mode = false,
    live_preview = true,
    line_sep = '────────────────────────────────────────────────────────────',
    result_padding = '│  ',
    separator = '├',
    mapping = {
      ['toggle_line'] = 't',
      ['enter_file'] = 'o',
      ['send_to_qf'] = 'q',
      ['toggle_preview'] = 'p',
      ['select_next'] = 'j',
      ['select_prev'] = 'k',
      ['move_up'] = '<Up>',
      ['move_down'] = '<Down>',
      ['toggle_case'] = 'c',
      ['toggle_ignore_case'] = 'I',
      ['toggle_regex'] = 'R',
      ['toggle_hidden'] = 'H',
      ['change_root_dir'] = 'C',
      ['change_search_mode'] = 'S',
      ['change_replace_mode'] = 'M',
      ['toggle_all'] = 'a',
      ['resume_last_search'] = 'n',
      ['run_current_replace'] = 'r',
      ['run_replace'] = 'gr',
      ['toggle_gignore'] = 'g',
    },
  })

  -- Quick search & replace in current file
  map("n", "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, { desc = "Search & Replace word" })
  map("v", "<leader>sw", function() require("spectre").open_visual() end, { desc = "Search & Replace selection" })
  map("n", "<leader>sf", function() require("spectre").open_file_search() end, { desc = "Search & Replace in file" })
  map("n", "<leader>sp", function() require("spectre").open() end, { desc = "Search & Replace in project" })
end
