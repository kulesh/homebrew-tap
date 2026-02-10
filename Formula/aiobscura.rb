class Aiobscura < Formula
  desc "AI Agent Activity Monitor"
  homepage "https://github.com/kulesh/aiobscura"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.9/aiobscura-aarch64-apple-darwin.tar.xz"
      sha256 "4dec4ad5fc8dc75dc0ce91ea8046d3f7c3c0ed975991ba304d303c3f0a204dad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.9/aiobscura-x86_64-apple-darwin.tar.xz"
      sha256 "6ef63d4dddca36d3a782411033f3c8743ca356cc9fd6710d7525855cea07344a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.9/aiobscura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4eeb189fd2ff3a5f212a1dcbe2ee3450fc9ec0aa80fda2ddcda60f2e35d8c847"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.9/aiobscura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8d3f093304d6dc5d8eca2dcf0c5920193b2ef4508a9dc4bb1a2bbfcf8de8162a"
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
