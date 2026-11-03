class Mimir < Formula
  desc "Call graph of your project for coding agents, with a live view in the browser"
  homepage "https://github.com/julymetodiev/Mimir"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/julymetodiev/Mimir/releases/download/v0.2.0/mimir-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "83e6f414c62c1acc30363cb970da67782378fb7311b76faeb72239ab713904ad"
    end
    on_intel do
      url "https://github.com/julymetodiev/Mimir/releases/download/v0.2.0/mimir-v0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "28a78068973b76368d789196d03e11519952e9d7371dbb2fe6ed3d4df1200fe0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/julymetodiev/Mimir/releases/download/v0.2.0/mimir-v0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4fffe66090d617720c7b410e201f8b7ef02c151a5cb9b2193e020c5333d0005e"
    end
    on_intel do
      url "https://github.com/julymetodiev/Mimir/releases/download/v0.2.0/mimir-v0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "42ed676726097d1ae6e8d679033ef240c7faee6d058ecfc6d24f710b693db60a"
    end
  end

  def install
    bin.install "mimir"
  end

  def caveats
    <<~EOS
      For exact answers, Mimir needs rust-analyzer:
        rustup component add rust-analyzer rust-src

      In Claude Code:
        /plugin marketplace add julymetodiev/Mimir
        /plugin install mimir@mimir

      For other agents, and to see the graph with `mimir view`:
        https://github.com/julymetodiev/Mimir
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mimir --version")
  end
end
