class VelesCli < Formula
  desc "CLI binary for Veles code search"
  homepage "https://github.com/julymetodiev/Veles"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/julymetodiev/Veles/releases/download/v0.5.0/veles-cli-aarch64-apple-darwin.tar.xz"
      sha256 "2158dce824ec7e17700ce1c8755ba6d07674cbda7c8d4540d4b643a6d7438df8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/Veles/releases/download/v0.5.0/veles-cli-x86_64-apple-darwin.tar.xz"
      sha256 "72dba4c8aa775f629e407bc1133815683952b71279d680d238d1e77a402df7c6"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/julymetodiev/Veles/releases/download/v0.5.0/veles-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "1a20ed9f31a3008ce54160b0298ef4492f4019f972fcc971296b88ca00b31c7e"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "veles" if OS.mac? && Hardware::CPU.arm?
    bin.install "veles" if OS.mac? && Hardware::CPU.intel?
    bin.install "veles" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
