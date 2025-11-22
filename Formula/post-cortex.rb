class PostCortex < Formula
  desc "Production-grade intelligent conversation memory system for AI assistants"
  homepage "https://github.com/julymetodiev/post-cortex"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.4/post-cortex-x86_64-apple-darwin"
      sha256 "8360f9edb80b216d769338c5d15c693503ed5a8039611f40b470e8e94989564f"

      resource "daemon" do
        url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.4/post-cortex-daemon-x86_64-apple-darwin"
        sha256 "1cd2ea5fb82948a1a743aaf231887016811705f18f4e6be7140b3c136dc181d1"
      end
    else
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.4/post-cortex-aarch64-apple-darwin"
      sha256 "ddeb32474952c317fbc1754ffab7a309353886d508ffd17401bbc06949c57e74"

      resource "daemon" do
        url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.4/post-cortex-daemon-aarch64-apple-darwin"
        sha256 "2ddd9e264367f7179b85b0d6d51711cb9c2c2023912f7dff564a47fc3769176f"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.4/post-cortex-x86_64-unknown-linux-gnu"
      sha256 "ff15652a77d7442ad03a9cbc15c8f79f36ad4138aca7938d4c473009a934c984"

      resource "daemon" do
        url "https://github.com/julymetodiev/post-cortex/releases/download/v0.1.4/post-cortex-daemon-x86_64-unknown-linux-gnu"
        sha256 "6bbf8ff941b41ae4460cd4e3b45adb945cb5dcbeee03ba4a99dfa170336ab11b"
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
