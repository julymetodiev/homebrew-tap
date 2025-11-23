class PostCortex < Formula
  desc "Production-grade intelligent conversation memory system for AI assistants"
  homepage "https://github.com/julymetodiev/post-cortex"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.4/post-cortex-x86_64-apple-darwin"
      sha256 "181addfe16b01d77ab69ea5fe26cc615617dc0083e53a064cf113b7b1dc511d3"

      resource "daemon" do
        url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.4/post-cortex-daemon-x86_64-apple-darwin"
        sha256 "d02aaf31925f83945b553f539a21ba4f55ae556bb8741cbafa628189cfb86806"
      end
    else
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.4/post-cortex-aarch64-apple-darwin"
      sha256 "937654aaf3fe6b14d2ebc268a0293171b68813c707b1581b6c160927a12e95fc"

      resource "daemon" do
        url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.4/post-cortex-daemon-aarch64-apple-darwin"
        sha256 "876bd53aea69a0050216e409c6c5b73f6ffe4e641d7797fd3e5e7ebf8c3e4866"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.4/post-cortex-x86_64-unknown-linux-gnu"
      sha256 "199b3a3ec2ebfcd4ebcbb6f160961b4f592ca3d4fd80411208459d964bd7bfa9"

      resource "daemon" do
        url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.4/post-cortex-daemon-x86_64-unknown-linux-gnu"
        sha256 "65218f870422e9416167d38ed72753deebfd800ffe5084bea90582fa49618b94"
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
