class Mimir < Formula
  desc "Call graph of your project for coding agents, with a live view in the browser"
  homepage "https://github.com/julymetodiev/Mimir"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/julymetodiev/Mimir/releases/download/v0.4.1/mimir-v0.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "50b50e7291b929f8bcee795448dd14eab4e7bafa13be75a133b4f4651430fc1e"
    end
    on_intel do
      url "https://github.com/julymetodiev/Mimir/releases/download/v0.4.1/mimir-v0.4.1-x86_64-apple-darwin.tar.gz"
      sha256 "58afec9d6b2092b13fb0a4e38b821d6c87dd0b5f04f68b282c302fcf27385880"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/julymetodiev/Mimir/releases/download/v0.4.1/mimir-v0.4.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7df76b8f97bafe65f2f92686df5e1bd17c10791756420a9f393cb4951b95bc67"
    end
    on_intel do
      url "https://github.com/julymetodiev/Mimir/releases/download/v0.4.1/mimir-v0.4.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f8989b26b6f9108fe1cb60ee6f3381f845c4bd49d5700daa5dd30a48e9e0be3a"
    end
  end

  def install
    bin.install "mimir"
  end

  def caveats
    <<~EOS
      For exact answers, Mimir needs rust-analyzer for Rust, tsrs for TypeScript and JavaScript,
      pyrefly for Python, and go with scip-go and gopls for Go:
        rustup component add rust-analyzer rust-src
        npm install -g tsrs
        pipx install pyrefly
        go install github.com/scip-code/scip-go/cmd/scip-go@latest
        go install golang.org/x/tools/gopls@latest

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
