class VelesCli < Formula
  desc "CLI binary for Veles code search"
  homepage "https://github.com/julymetodiev/Veles"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/julymetodiev/Veles/releases/download/v0.6.0/veles-cli-aarch64-apple-darwin.tar.xz"
      sha256 "55d8c9836f9ab3828eb1f531de4b18a04d999ee92bb027ce7788a4edd6f71120"
    end
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/Veles/releases/download/v0.6.0/veles-cli-x86_64-apple-darwin.tar.xz"
      sha256 "deac8f5d62c1fc33f38b83fb7aa383b8976ed63f712e09725abc8d93e42012a8"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/julymetodiev/Veles/releases/download/v0.6.0/veles-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "a1e0d19676ebf4bb54e2126c192f6ebc74b495b42cdb3b87a789bdde015858cb"
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
