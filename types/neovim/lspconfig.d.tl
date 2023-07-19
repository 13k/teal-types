local record lspconfig
  record ServerConfig
    name: string
    cmd: {string}
    cmd_cwd: string
    cmd_env: {string: string}
    root_dir: function(filename: string, bufnr: integer): string
    filetypes: {string}
    autostart: boolean
    single_file_support: boolean
    on_new_config: function(new_config: ServerConfig, new_root_dir: string)
    capabilities: vim.lsp.ClientCapabilities
    handlers: {function()}
    init_options: {string: any}
    on_attach: function(client: vim.lsp.Client, bufnr: integer)
    settings: {string: any}
  end

  record Server
    name: string
    default_config: ServerConfig

    setup: function(config: ServerConfig)
  end

  metamethod __index: function(self: lspconfig, key: string): Server
end

return lspconfig
