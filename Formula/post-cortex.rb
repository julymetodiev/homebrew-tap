class PostCortex < Formula
  desc "MCP server that gives AI assistants long-term, searchable memory"
  homepage "https://github.com/julymetodiev/post-cortex"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.7.0/pcx-x86_64-apple-darwin"
      sha256 "dd513b1590599801f72602b623afebc09cb29e6e9ed5be36e56d0eb42b68fd59"
    else
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.7.0/pcx-aarch64-apple-darwin"
      sha256 "78cebf2621dd025ab716252675b00c02c47f9210190768b75a3f03890b8e38d6"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.7.0/pcx-x86_64-unknown-linux-gnu"
      sha256 "45540cba6da459435abb87af4c692211df76a793194da8d7a690b021e119a360"
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
      Post-Cortex (pcx) is installed.

      1. Start the daemon:      pcx start
      2. Check it:              pcx status
      3. Point your agent at it:
         Claude Code: set the post-cortex plugin's url to http://127.0.0.1:3737
         Other agents: pcx setup --self-hosted

      Data: ~/.post-cortex/data · MCP: http://127.0.0.1:3737/mcp
      Docs: https://docs.pcx.is/daemon/install/
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
