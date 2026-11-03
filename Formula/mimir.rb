class Mimir < Formula
  desc "Call graph of your project for coding agents, with a live view in the browser"
  homepage "https://github.com/julymetodiev/Mimir"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/julymetodiev/Mimir/releases/download/v0.3.0/mimir-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "1a59e5f039c06478adc039b031e0ca64702f1b306648861125d0ba4ab485289e"
    end
    on_intel do
      url "https://github.com/julymetodiev/Mimir/releases/download/v0.3.0/mimir-v0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "6e38dc61c1e43e9f64b959e56ed7b2246111c6a3de298bee750c563ff05e15b9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/julymetodiev/Mimir/releases/download/v0.3.0/mimir-v0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c6b6bfb948636d4ba617f7fcf002cf024fb7d9f685ca472c8645afa961819ea9"
    end
    on_intel do
      url "https://github.com/julymetodiev/Mimir/releases/download/v0.3.0/mimir-v0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "23926000ab2ffc4089cf49469572d2049d3105be0f0ee944236d4b29e6287a77"
    end
  end

  def install
    bin.install "mimir"
  end

  def caveats
    <<~EOS
      For exact answers, Mimir needs rust-analyzer for Rust, and tsrs for TypeScript and JavaScript:
        rustup component add rust-analyzer rust-src
        npm install -g tsrs

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
