return {
  "alex35mil/pi.nvim",

  -- Optional: required only for `:PiPasteImage` (clipboard image paste).
  dependencies = { "HakonHarnes/img-clip.nvim" },

  -- if you're fine with defaults:
  config = true,

  -- or, if you want to customize:
  opts = {
    models = { ... },
    layout = { ... },
  },
}
