class AiobscuraTui < Formula
  desc "AI Agent Activity Monitor - Terminal UI"
  homepage "https://github.com/kulesh/aiobscura"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.1/aiobscura-tui-aarch64-apple-darwin.tar.xz"
      sha256 "b11e50b7839958976a6d75549915b07cba230c363c7907e13605136e117ecf12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.1/aiobscura-tui-x86_64-apple-darwin.tar.xz"
      sha256 "5edf59fa10edb2f812a7c3116412032cf9b68b85020180cfc0625dde3557d0be"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.1/aiobscura-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0b86cd5d2bf69d3d95a6393b415d0ea2c8539aca68c43b1f0e81b334d62444d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.1/aiobscura-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "96ee26514f645037c6812c26afb25b1b77f3a782147aaa5f355133fec7f7958a"
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
    bin.install "aiobscura", "aiobscura-sync" if OS.mac? && Hardware::CPU.arm?
    bin.install "aiobscura", "aiobscura-sync" if OS.mac? && Hardware::CPU.intel?
    bin.install "aiobscura", "aiobscura-sync" if OS.linux? && Hardware::CPU.arm?
    bin.install "aiobscura", "aiobscura-sync" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
