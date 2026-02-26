 class PostCortex < Formula
  desc "Post-Cortex is an MCP server that gives AI assistants long-term memory. It stores conversations, decisions, and insights in a searchable knowledge base with automatic entity extraction."
  homepage "https://github.com/julymetodiev/post-cortex"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.21/pcx-x86_64-apple-darwin"
      sha256 "7efbb7b19a0b3c7dfa92fdbb3a2ed00d4dcfd57dfedb5fe710f19b947f705f71"
    else
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.21/pcx-aarch64-apple-darwin"
      sha256 "642078da69f53ddf233f3455c008bf05866c724c4554d189c311372681fe0d81"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.21/pcx-x86_64-unknown-linux-gnu"
      sha256 "aab20babe4d793899756eb3e9ba0035e82e7fa763bd46acbea7a96b7a0846fad"
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

      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Full Documentation: https://github.com/julymetodiev/post-cortex
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    EOS
  end

  test do
    # Test stdio server
    assert_predicate bin/"pcx", :exist?

    # Test daemon help output
    output = shell_output("#{bin}/pcx help 2>&1")
    assert_match "Post-Cortex", output
  end
end
