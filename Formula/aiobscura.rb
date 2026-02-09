class Aiobscura < Formula
  desc "AI Agent Activity Monitor"
  homepage "https://github.com/kulesh/aiobscura"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.8/aiobscura-aarch64-apple-darwin.tar.xz"
      sha256 "91dd22517d5f600f43ea73d52a77cf18663e90dbb1816aea52601c201f23f1f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.8/aiobscura-x86_64-apple-darwin.tar.xz"
      sha256 "a135267cd3d887ae0e4a33cfbc43ff50769e4b960eecf2ef8deaa6e9a8cbd846"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.8/aiobscura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1384de5f1b9b69f42a53a7c9b9ab5d95d79d83c2c8a32ca842ac484c4545190e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.8/aiobscura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1d59d2b1aad6177385119f6a53543a954d9ed2c0b5bf690fc3c5e182004bcbdd"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "aiobscura", "aiobscura-analyze", "aiobscura-collector", "aiobscura-sync"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "aiobscura", "aiobscura-analyze", "aiobscura-collector", "aiobscura-sync"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "aiobscura", "aiobscura-analyze", "aiobscura-collector", "aiobscura-sync"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "aiobscura", "aiobscura-analyze", "aiobscura-collector", "aiobscura-sync"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
