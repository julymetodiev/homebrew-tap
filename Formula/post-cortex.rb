class PostCortex < Formula
  desc "MCP server that gives AI assistants long-term, searchable memory"
  homepage "https://github.com/julymetodiev/post-cortex"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.7.1/pcx-x86_64-apple-darwin"
      sha256 "026bf364a9ae599177eae78ead6ed082a1afb6d60075540915bcb48cd7f11f77"
    else
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.7.1/pcx-aarch64-apple-darwin"
      sha256 "afb3ee033d849c80e5f2987838e61ec618f5e6a68040628aa090c700b7b11f8f"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.7.1/pcx-x86_64-unknown-linux-gnu"
      sha256 "807aa1da545ce68c50deab2d34d3f1851f0caab9e1e857a7f35f5c48a04ebe7d"
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
