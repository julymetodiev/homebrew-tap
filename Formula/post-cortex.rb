 class PostCortex < Formula
  desc "Production-grade intelligent conversation memory system for AI assistants"
  homepage "https://github.com/julymetodiev/post-cortex"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.14/pcx-x86_64-apple-darwin"
      sha256 "181ae5fa76610f89142d390e9914ec04b5bcf415019950361f83dbd0ba31d767"
    else
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.14/pcx-aarch64-apple-darwin"
      sha256 "2af4deb41c2fd9adcd21d97599a90abcb63ba3b95447c4d181201d5661378e9d"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.14/pcx-x86_64-unknown-linux-gnu"
      sha256 "dd7f6a1e06a1a324999e5ea401cea34a5279a71619d8978c91de05c05faa507d"
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

      Add to Claude Desktop config (~/.claude.json):

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
      📚 Full Documentation: https://github.com/julymetodiev/post-cortex
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
