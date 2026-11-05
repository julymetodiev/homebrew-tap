class LanternLattice < Formula
  desc "The call graph from your compiler or type checker, for humans and coding agents"
  homepage "https://github.com/julymetodiev/lantern-lattice"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/julymetodiev/lantern-lattice/releases/download/v0.6.0/latt-v0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "63d32a13499587fe20a60d04b51976a0692038f34adc652e54a561f37c8ce279"
    end
    on_intel do
      url "https://github.com/julymetodiev/lantern-lattice/releases/download/v0.6.0/latt-v0.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "c07f14698f7cf364f6d408ad164e66ee985ceb9b3103604a43308ae74bf102fb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/julymetodiev/lantern-lattice/releases/download/v0.6.0/latt-v0.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "af3862218670ab1ffc4e11d4a4928ff7584efed6c986613233621157eedc5bab"
    end
    on_intel do
      url "https://github.com/julymetodiev/lantern-lattice/releases/download/v0.6.0/latt-v0.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "76a565f9640740e5a0eb343bbc14b335aa31d17f66ea4316e078283258866778"
    end
  end

  def install
    bin.install "latt"
  end

  def caveats
    <<~EOS
      For exact answers, Lantern Lattice needs rust-analyzer for Rust, tsrs for TypeScript and JavaScript,
      pyrefly for Python, go with scip-go and gopls for Go, and clangd with clangd-indexer for
      C and C++, from https://github.com/clangd/clangd/releases:
        rustup component add rust-analyzer rust-src
        npm install -g tsrs
        pipx install pyrefly
        go install github.com/scip-code/scip-go/cmd/scip-go@latest
        go install golang.org/x/tools/gopls@latest

      In Claude Code:
        /plugin marketplace add julymetodiev/lantern-lattice
        /plugin install latt@latt

      For other agents, and to see the graph with `latt view`:
        https://github.com/julymetodiev/lantern-lattice
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/latt --version")
  end
end
