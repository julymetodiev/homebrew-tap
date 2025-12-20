 class PostCortex < Formula
  desc "Production-grade intelligent conversation memory system for AI assistants"
  homepage "https://github.com/julymetodiev/post-cortex"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.12/pcx-x86_64-apple-darwin"
      sha256 "f9efa746af3298fc700c10581250173223d71d1bbefd01448c61009e12e2a590"
    else
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.12/pcx-aarch64-apple-darwin"
      sha256 "b025dc19b06c210a2290870508f504408fac15a225d8b9f9e6cb2bed1ac4eb69"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.12/pcx-x86_64-unknown-linux-gnu"
      sha256 "45b46991590da2e72b73405a4a6fb2d42597babf7792f5669b8e6b6d3b4fbfad"
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

      For SSE:
      {
        "mcpServers": {
          "post-cortex": {
            "url": "http://localhost:3737/sse"
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
