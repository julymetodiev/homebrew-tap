class VelesCli < Formula
  desc "CLI binary for Veles code search"
  homepage "https://github.com/julymetodiev/Veles"
  version "0.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/julymetodiev/Veles/releases/download/v0.4.2/veles-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a0c8c767849314f23092151d025a256c4b7444c2d8bc5f90892a96b8cf3d2274"
    end
    if Hardware::CPU.intel?
      url "https://github.com/julymetodiev/Veles/releases/download/v0.4.2/veles-cli-x86_64-apple-darwin.tar.xz"
      sha256 "bbfe91c226ad526810bf24086abae92a38f668a918d2af0049ff9e4da8669b9c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/julymetodiev/Veles/releases/download/v0.4.2/veles-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "d722dbf5eeeab314cad5633d8925450d207d50a7bf39432a7d04e3f89cdc844a"
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
