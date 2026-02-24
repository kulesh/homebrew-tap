class Aiobscura < Formula
  desc "AI Agent Activity Monitor"
  homepage "https://github.com/kulesh/aiobscura"
  version "0.1.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.10/aiobscura-aarch64-apple-darwin.tar.xz"
      sha256 "aa42522ddad1abf449798f21910d5be673d0f726cd2fc8ae7511eb8fb1861c3c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.10/aiobscura-x86_64-apple-darwin.tar.xz"
      sha256 "9329f3b2915e63f83848f0924cd8478a3177bcf11d4c9f9213dd2dc042bdbf53"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.10/aiobscura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1dd8f2320fde5e360d4ff8893768aa8255d5ecf99dc22acbe6bba0d72033cd1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.10/aiobscura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7f0b27bd181878a6e970f9a413c183c3b136018dbf39335ff290d3a30572f1bd"
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
