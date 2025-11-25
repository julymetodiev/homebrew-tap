class PostCortex < Formula
  desc "Production-grade intelligent conversation memory system for AI assistants"
  homepage "https://github.com/julymetodiev/post-cortex"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.7/pcx-x86_64-apple-darwin"
      sha256 "e55166ea005f87bdc169ab088da16b00ca4de7d2c6b81737efd2980bb385e938"
    else
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.7/pcx-aarch64-apple-darwin"
      sha256 "225c4514d1463f04e5dcb27c5e6f3df97fa0dc9120108e607b970f361f236020"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.7/pcx-x86_64-unknown-linux-gnu"
      sha256 "2c73f7326e00ad2d93592b657eee92f5e38c3c5738a8e3770d4ce21ee3421284"
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
