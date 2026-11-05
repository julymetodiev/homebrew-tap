class LanternLattice < Formula
  desc "The call graph from your compiler or type checker, for humans and coding agents"
  homepage "https://github.com/julymetodiev/lantern-lattice"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/julymetodiev/lantern-lattice/releases/download/v0.6.1/latt-v0.6.1-aarch64-apple-darwin.tar.gz"
      sha256 "dce34c406f9eaee1ecc988d6c4eae58df10883579f0862f8f98ef209c442a2b8"
    end
    on_intel do
      url "https://github.com/julymetodiev/lantern-lattice/releases/download/v0.6.1/latt-v0.6.1-x86_64-apple-darwin.tar.gz"
      sha256 "d01821a104d84ed025d57bf8d7b15303b480131e19738484d600d35071803377"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/julymetodiev/lantern-lattice/releases/download/v0.6.1/latt-v0.6.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b18d1bf80bdab00d2f0faed3b2ef43599e9deea00131f30f1ecd3c5effb9557d"
    end
    on_intel do
      url "https://github.com/julymetodiev/lantern-lattice/releases/download/v0.6.1/latt-v0.6.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0da6b1f1360c329fa015021467d818339a3a5face6efd3de672b852c0f707329"
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
