return {
  {
    "hat0uma/csvview.nvim",
    opts = {
      parser = {
        comments = { "#", "//" },
      },
      view = {
        display_mode = "border",
      },
    },
    cmd = {
      "CsvViewEnable",
      "CsvViewDisable",
      "CsvViewToggle",
    },
  },
}
