---@type vim.lsp.Config
return {
  root_markers = { 'build.zig', 'build.zig.zon' },
  settings = {
    zls = {
      -- Report naming convention violations (e.g. snake_case for fns, PascalCase for types)
      warn_style = true,
      -- Highlight mutable global `var` declarations — Zig discourages them
      highlight_global_var_declarations = true,
      -- Hide redundant inlay hints where the arg name matches the param (e.g. `foo: foo`)
      inlay_hints_hide_redundant_param_names = true,
      -- Also hide when the last field/identifier matches (e.g. `foo: bar.foo`)
      inlay_hints_hide_redundant_param_names_last_token = true,
      -- Enable real compiler diagnostics via `zig build check`.
      -- Only useful if your project has a `check` step in build.zig; zls auto-detects
      -- it, but set explicitly to true if you always want it forced on.
      -- enable_build_on_save = true,
    },
  },
}
