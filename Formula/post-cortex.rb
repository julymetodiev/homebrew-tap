 class PostCortex < Formula
  desc "Post-Cortex is an MCP server that gives AI assistants long-term memory. It stores conversations, decisions, and insights in a searchable knowledge base with automatic entity extraction."
  homepage "https://github.com/julymetodiev/post-cortex"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.3.1/pcx-x86_64-apple-darwin"
      sha256 "sha256:91c0a3009f83c258ddd53e2a1cca23e5643d02b7e18cbbb31f4a096d6cd446ef"
    else
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.3.1/pcx-aarch64-apple-darwin"
      sha256 "sha256:96e8b7abd0a7beecef8a80bad26bf7c0fc7f7cfbf21bad31a32b2d11d3dc3a81"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.3.1/pcx-x86_64-unknown-linux-gnu"
      sha256 "sha256:eb0e5e8ad6668cd65817a82e0c71860ff945028f316dfa6a62a75abcfb88bc7a"
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
