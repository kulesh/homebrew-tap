class Aiobscura < Formula
  desc "AI Agent Activity Monitor"
  homepage "https://github.com/kulesh/aiobscura"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.6/aiobscura-aarch64-apple-darwin.tar.xz"
      sha256 "80e009a92d2868a07ba1fce6e4b43a2e726517b6f03549b9d52635990f66a6d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.6/aiobscura-x86_64-apple-darwin.tar.xz"
      sha256 "ba336cfb086a48ddb130e066fe9e872ad0f72d338272dc3b9fecd39a1f813d6f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.6/aiobscura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bb038ae431fae684376bb41869117cf57b13fc279e96b9946eabc979371bdd2c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.6/aiobscura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9e01d3dbbf1c3a9efedac3738f17613d87a109ffe182c3ab84dbc1b6de619764"
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
