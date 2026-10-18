class PostCortex < Formula
  desc "MCP server that gives AI assistants long-term, searchable memory"
  homepage "https://github.com/julymetodiev/post-cortex"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.4.0/pcx-x86_64-apple-darwin"
      sha256 "fe2291a1216c7f226f06414b0fc6103d8b4f02fffb4fa2c0154ab500619c674c"
    else
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.4.0/pcx-aarch64-apple-darwin"
      sha256 "9beb9b77823bc3dde161a662c3276512ef81a000ed89e0bb155c7a9d1a14c876"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.4.0/pcx-x86_64-unknown-linux-gnu"
      sha256 "74192dd226fd356d74321b1588a333b00ab8eb6c4ca60e012ddebb65609dda1b"
    end
  end

  def install
    # Install post-cortex (stdio MCP server)
    if OS.mac? && Hardware::CPU.intel?
      bin.install "pcx-x86_64-apple-darwin" => "pcx"
    elsif OS.mac? && Hardware::CPU.arm?
      bin.install "pcx-aarch64-apple-darwin" => "pcx"
    elsif OS.linux?
      bin.install "pcx-x86_64-unknown-linux-gnu" => "pcx"
    end
  end

  def caveats
    <<~EOS
      Post-Cortex has been installed:

      1. Configure MCP (once, globally)

      HTTP transport (recommended, requires daemon running)
      claude mcp add --scope user --transport http post-cortex http://127.0.0.1:3737/mcp

      Or stdio transport (no daemon needed)
      claude mcp add --scope user --transport stdio post-cortex -- pcx

      This registers Post-Cortex for all projects on your machine.

      2. Set Up Your Project

      pcx setup

      For stdio:
      {
        "mcpServers": {
          "post-cortex": {
            "command": "pcx"
          }
        }
      }
      For HTTP:
      {
        "mcpServers": {
          "post-cortex": {
            "type": "http",
            "url": "http://localhost:3737/mcp"
          }
        }
      }

      Upgrading from 0.3.x: back up a SurrealDB backend first (the 0.4 schema
      change is forward-only). If the daemon binds 0.0.0.0, set allowed_hosts
      in ~/.post-cortex/daemon.toml, or remote clients get 403.

      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Full Documentation: https://github.com/julymetodiev/post-cortex
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    EOS
  end

  test do
    # Test stdio server
    assert_path_exists bin/"pcx"

    # Test daemon help output
    output = shell_output("#{bin}/pcx help 2>&1")
    assert_match "Post-Cortex", output
  end
end
