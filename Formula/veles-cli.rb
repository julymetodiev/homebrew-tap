class VelesCli < Formula
  desc "CLI binary for Veles code search"
  homepage "https://github.com/julymetodiev/Veles"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/julymetodiev/Veles/releases/download/v0.2.2/veles-cli-aarch64-apple-darwin.tar.xz"
      sha256 "38cb265ea22400f1769cdc04c9ea4c5c33faca1673e8803871d5f73e7c26e0d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/Veles/releases/download/v0.2.2/veles-cli-x86_64-apple-darwin.tar.xz"
      sha256 "50c27639d3dd216e955103e3b35335503f95b13b57a12ee27804f7fad5d03919"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/julymetodiev/Veles/releases/download/v0.2.2/veles-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "35a2c993b141bf282346ee67f059f2d946823ee65d58bb23b26c8e256f14e9ef"
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
