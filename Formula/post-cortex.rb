class PostCortex < Formula
  desc "MCP server that gives AI assistants long-term, searchable memory"
  homepage "https://github.com/julymetodiev/post-cortex"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.6.1/pcx-x86_64-apple-darwin"
      sha256 "dddd26ab03c4a4c7d186617e8402b9ff4ce007ab459479f013ffc31ddc643aed"
    else
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.6.1/pcx-aarch64-apple-darwin"
      sha256 "ea5b2690474aa4432c2695d7f73b9eefa8b0510111ddf68123cd3df1f40aa197"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v0.6.1/pcx-x86_64-unknown-linux-gnu"
      sha256 "3d136155aee52e9743864a0b4e260bba4550a7355ab31d2f57156d8e24508a5b"
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
