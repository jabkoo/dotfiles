return {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "latte",
      dim_inactive = { enabled = true, percentage = 0.25 },
      integrations = {
        alpha = false,
        dashboard = false,
        flash = false,
        nvimtree = false,
        ts_rainbow = false,
        ts_rainbow2 = false,
        barbecue = false,
        indent_blankline = false,
        navic = false,
        dropbar = false,
        aerial = true,
        dap = { enabled = true, enable_ui = true },
        headlines = true,
        mason = true,
        native_lsp = { enabled = true, inlay_hints = { background = false } },
        neogit = true,
        neotree = true,
        noice = true,
        notify = true,
        sandwich = true,
        semantic_tokens = true,
        symbols_outline = true,
        telescope = { enabled = true, style = "nvchad" },
        which_key = true,
      },
    },
  }
  