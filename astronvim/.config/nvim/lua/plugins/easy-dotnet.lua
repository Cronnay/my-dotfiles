---@type LazySpec
return {
  {
    "GustavEikaas/easy-dotnet.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      picker = "snacks",
      lsp = { enabled = true },
      debugger = { auto_register_dap = true },
      test_runner = {
        mappings = {
          -- Keep AstroNvim's explorer and debugger mappings available in C# buffers.
          run_test_from_buffer = { lhs = "<Leader>Dt", desc = "Run test under cursor" },
          run_all_tests_from_buffer = { lhs = "<Leader>Df", desc = "Run tests in file" },
          debug_test_from_buffer = { lhs = "<Leader>DD", desc = "Debug test under cursor" },
          get_build_errors = { lhs = "<Leader>De", desc = "Show build errors" },
          peek_stack_trace_from_buffer = { lhs = "<Leader>Dp", desc = "Peek test stack trace" },
        },
      },
    },
    keys = {
      { "<Leader>Db", "<Cmd>Dotnet build quickfix<CR>", desc = "Build project" },
      { "<Leader>Dr", "<Cmd>Dotnet run profile<CR>", desc = "Run project with launch profile" },
      { "<Leader>Dd", "<Cmd>Dotnet debug profile<CR>", desc = "Debug project with launch profile" },
      { "<Leader>DT", "<Cmd>Dotnet testrunner<CR>", desc = "Toggle test runner" },
      { "<Leader>DR", "<Cmd>Dotnet restore<CR>", desc = "Restore solution" },
      { "<Leader>Ds", "<Cmd>Dotnet secrets<CR>", desc = "Edit user secrets" },
      { "<Leader>Da", "<Cmd>Dotnet add package<CR>", desc = "Add NuGet package" },
      { "<Leader>Dc", "<Cmd>Dotnet<CR>", desc = ".NET commands" },
    },
  },
  {
    "AstroNvim/astrocore",
    opts = { mappings = { n = { ["<Leader>D"] = { desc = ".NET" } } } },
  },
}
