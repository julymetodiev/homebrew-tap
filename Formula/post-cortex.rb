class PostCortex < Formula
  desc "Production-grade intelligent conversation memory system for AI assistants"
  homepage "https://github.com/julymetodiev/post-cortex"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.3/post-cortex-x86_64-apple-darwin"
      sha256 "cdff56eeb35e6e06f8037bc7cff4a8bda1a86a43517912d98b5525488f3331f0"

      resource "daemon" do
        url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.3/post-cortex-daemon-x86_64-apple-darwin"
        sha256 "9ea9387e695aa69e6d1c1859d683928cc7960f516ab3873f7efa3d9e0613df46"
      end
    else
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.3/post-cortex-aarch64-apple-darwin"
      sha256 "f334832d8fd8a8521d14bde7fa1c7f29dfab2514fae98e74ac4a5d2aa8ef437b"

      resource "daemon" do
        url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.3/post-cortex-daemon-aarch64-apple-darwin"
        sha256 "9ba23ddc2f54eb09f521d9af7584636f7d5459bffa943d280331db7fd6c7db05"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.3/post-cortex-x86_64-unknown-linux-gnu"
      sha256 "58b663a54c3efb3231bd0d78e863d74e81c7f9a614a4faefca7b19849e7ed359"

      resource "daemon" do
        url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.3/post-cortex-daemon-x86_64-unknown-linux-gnu"
        sha256 "82c10341a3d483e906b1c76204a256edbdb5b734b94cc33063d4ade009ea35c5"
      end
    end
  end

  def install
    # Install post-cortex (stdio MCP server)
    if OS.mac? && Hardware::CPU.intel?
      bin.install "post-cortex-x86_64-apple-darwin" => "post-cortex"
    elsif OS.mac? && Hardware::CPU.arm?
      bin.install "post-cortex-aarch64-apple-darwin" => "post-cortex"
    elsif OS.linux?
      bin.install "post-cortex-x86_64-unknown-linux-gnu" => "post-cortex"
    end

    # Install post-cortex-daemon (HTTP daemon)
    resource("daemon").stage do
      if OS.mac? && Hardware::CPU.intel?
        bin.install "post-cortex-daemon-x86_64-apple-darwin" => "post-cortex-daemon"
      elsif OS.mac? && Hardware::CPU.arm?
        bin.install "post-cortex-daemon-aarch64-apple-darwin" => "post-cortex-daemon"
      elsif OS.linux?
        bin.install "post-cortex-daemon-x86_64-unknown-linux-gnu" => "post-cortex-daemon"
      end
    end
  end

  def caveats
    <<~EOS
      Post-Cortex has been installed with TWO binaries:

      1. post-cortex        - Stdio MCP server (simple)
      2. post-cortex-daemon - HTTP daemon (advanced)

      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      📦 STDIO MODE (Simple - Claude Desktop Integration)
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

      Add to Claude Desktop config (~/.claude.json):

      {
        "mcpServers": {
          "post-cortex": {
            "command": "#{bin}/post-cortex"
          }
        }
      }

      Then restart Claude Desktop.

      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      🚀 DAEMON MODE (Advanced - HTTP API + Background Service)
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

      Initialize and start daemon:
        post-cortex-daemon init
        post-cortex-daemon start

      Claude Desktop config:
      {
        "mcpServers": {
          "post-cortex": {
            "type": "sse",
            "url": "http://localhost:3737/sse"
          }
        }
      }

      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      🔧 Service Management (Optional)
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

      For auto-start daemon on boot, see service installation:
      https://github.com/julymetodiev/post-cortex#service-management-daemon-mode

      macOS (launchd):  install/launchd/README.md
      Linux (systemd):  install/systemd/README.md

      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      📚 Full Documentation: https://github.com/julymetodiev/post-cortex
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    EOS
  end

  test do
    # Test stdio server
    assert_predicate bin/"post-cortex", :exist?

    # Test daemon binary
    assert_predicate bin/"post-cortex-daemon", :exist?

    # Test daemon help output
    output = shell_output("#{bin}/post-cortex-daemon help 2>&1")
    assert_match "Post-Cortex Daemon", output
  end
end
