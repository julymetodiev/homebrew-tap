class LanternLattice < Formula
  desc "The call graph from your compiler or type checker, for humans and coding agents"
  homepage "https://github.com/julymetodiev/lantern-lattice"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/julymetodiev/lantern-lattice/releases/download/v0.6.2/latt-v0.6.2-aarch64-apple-darwin.tar.gz"
      sha256 "164f7185a2fcd13a79da98c26c9989fb717e796e260ac36dc27ce91f479410d5"
    end
    on_intel do
      url "https://github.com/julymetodiev/lantern-lattice/releases/download/v0.6.2/latt-v0.6.2-x86_64-apple-darwin.tar.gz"
      sha256 "64b9c1e02983cc96b38fa878e7f150ce5f640880d024fcecc4d2cb3b61381ad5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/julymetodiev/lantern-lattice/releases/download/v0.6.2/latt-v0.6.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0cb62b414eb774dea40d2e403def713a3b08dab5ab9bc9dd0c15a02ea75daf0a"
    end
    on_intel do
      url "https://github.com/julymetodiev/lantern-lattice/releases/download/v0.6.2/latt-v0.6.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "00c3b32f094fe38a25052b422efbbb1958e83ae74986310242ab73cbebd4a94c"
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
