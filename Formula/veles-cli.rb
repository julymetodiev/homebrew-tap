class VelesCli < Formula
  desc "CLI binary for Veles code search"
  homepage "https://github.com/julymetodiev/Veles"
  version "0.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/julymetodiev/Veles/releases/download/v0.4.4/veles-cli-aarch64-apple-darwin.tar.xz"
      sha256 "01d3e8697d26aba570268476eaa9acd42c6b1953e819b1eb6c96f1d646295c38"
    end
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/Veles/releases/download/v0.4.4/veles-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5061a901a3f161c0b8d710cefbcb5d37bc1a726c7ad6ee9bb637102c5c320676"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/julymetodiev/Veles/releases/download/v0.4.4/veles-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "170e601ed9ee048f67c19ad719a94709c6d9804bea6743f0ce85d83490dfc3fe"
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
