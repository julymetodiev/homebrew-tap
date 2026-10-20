class PostCortex < Formula
  desc "MCP server that gives AI assistants long-term, searchable memory"
  homepage "https://github.com/julymetodiev/post-cortex"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.5.0/pcx-x86_64-apple-darwin"
      sha256 "c4210835b52c1a884a48eeb1431566eba73d2e4514a6c05767d65bfc26c9071d"
    else
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.5.0/pcx-aarch64-apple-darwin"
      sha256 "b743c5042454a3140e197dc2bcc5ad91fd1223fd838dd28f9b78fe297a763db8"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.5.0/pcx-x86_64-unknown-linux-gnu"
      sha256 "c450b64c978fd475ef6856f189550892c354b074b7b3f877ac0eaa4e159ec592"
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
      claude mcp add --scope user --transport http post-cortex http://127.0.0.1:3737/mcp \
        --header "X-PCX-Author: claude-code"

      Or stdio transport (no daemon needed)
      claude mcp add --scope user --transport stdio --env PC_AUTHOR=claude-code post-cortex -- pcx

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

      Upgrading to 0.5: back up a SurrealDB backend first; the daemon adds the
      full-text index and the message and card tables on start. RocksDB data
      written by 0.5 is not readable by older binaries.
      From 0.3.x: the 0.4 schema change is forward-only too, and a daemon bound
      to 0.0.0.0 needs allowed_hosts in ~/.post-cortex/daemon.toml.
      This binary has no rerankers (search mode fast); for local or Voyage
      reranking: cargo install post-cortex-daemon \
        --features surrealdb-storage,rerank,rerank-voyage

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
