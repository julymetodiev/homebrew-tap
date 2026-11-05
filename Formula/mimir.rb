class Mimir < Formula
  desc "Call graph of your project for coding agents, with a live view in the browser"
  homepage "https://github.com/julymetodiev/Mimir"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/julymetodiev/Mimir/releases/download/v0.5.0/mimir-v0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "b343649918cb7c07d248861c20d3961777a0416b989bf3200c5ab024749a3de3"
    end
    on_intel do
      url "https://github.com/julymetodiev/Mimir/releases/download/v0.5.0/mimir-v0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "8cc66aa39c4a178a354f607ea9a7e9409acd2f4f585154e7595a174a4353b4e2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/julymetodiev/Mimir/releases/download/v0.5.0/mimir-v0.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d8c789a866c0c68abba14aa3553e996e1107e5a64093919eccf7104a7ca0aefb"
    end
    on_intel do
      url "https://github.com/julymetodiev/Mimir/releases/download/v0.5.0/mimir-v0.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "890aa74dce3724bca27dc3c167076073d46984b15877ef670e06c8cd0303a1d3"
    end
  end

  def install
    bin.install "mimir"
  end

  def caveats
    <<~EOS
      For exact answers, Mimir needs rust-analyzer for Rust, tsrs for TypeScript and JavaScript,
      pyrefly for Python, go with scip-go and gopls for Go, and clangd with clangd-indexer for
      C and C++, from https://github.com/clangd/clangd/releases:
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
