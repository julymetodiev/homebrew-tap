class PostCortex < Formula
  desc "Production-grade intelligent conversation memory system for AI assistants"
  homepage "https://github.com/julymetodiev/post-cortex"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v#{version}/post-cortex-macos-x64"
      sha256 "4daa90e1b9e1ba21485f1cd9144e2051cee9a7ca4366e8bd6b6a5b0517cd491b"
    else
      url "https://github.com/julymetodiev/post-cortex/releases/download/v#{version}/post-cortex-macos-arm64"
      sha256 "079c69d042c9254d51466ab73246420b161c384690aae4908f4f2a26daffbfef"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/post-cortex/releases/download/v#{version}/post-cortex-linux-x64"
      sha256 "b13c9891b85058c56a2c2f83452597624a92193ab0d60843c7a0ff925727139d"
    end
  end

  def install
    bin.install "post-cortex-macos-x64" => "post-cortex" if OS.mac? && Hardware::CPU.intel?
    bin.install "post-cortex-macos-arm64" => "post-cortex" if OS.mac? && Hardware::CPU.arm?
    bin.install "post-cortex-linux-x64" => "post-cortex" if OS.linux?
  end

  def caveats
    <<~EOS
      Post-Cortex MCP server has been installed!

      To use with Claude Desktop, add to your config (~/.claude.json):

      {
        "mcpServers": {
          "post-cortex": {
            "type": "stdio",
            "command": "#{bin}/post-cortex"
          }
        }
      }

      Then restart Claude Desktop.

      Documentation: https://github.com/julymetodiev/post-cortex
    EOS
  end

  test do
    assert_match "post-cortex", shell_output("#{bin}/post-cortex --version 2>&1", 0)
  end
end
