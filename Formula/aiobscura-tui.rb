class AiobscuraTui < Formula
  desc "AI Agent Activity Monitor - Terminal UI"
  homepage "https://github.com/kulesh/aiobscura"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.0/aiobscura-tui-aarch64-apple-darwin.tar.xz"
      sha256 "a3d298e6bf7f576709c6000c046dee777198a8baa98c506f15c9558aa4d454a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.0/aiobscura-tui-x86_64-apple-darwin.tar.xz"
      sha256 "ff9c0308d3cfe12a3a2b208b0388879a53cdabbf8af0a7fb3f29694d2ddff059"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.0/aiobscura-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b32ad8cc93686ff6586c5f0891155e176e0fb8ecaadcf061c83e5e247ca13ddd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.0/aiobscura-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "41d68bf38d5b1fed22f424332c7d5bc6dfd3fe90fa708f7659c98993bf00934c"
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
      bin.install "aiobscura", "aiobscura-debug-claude", "aiobscura-debug-claude-watch", "aiobscura-debug-codex",
"aiobscura-debug-codex-watch", "aiobscura-sync"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "aiobscura", "aiobscura-debug-claude", "aiobscura-debug-claude-watch", "aiobscura-debug-codex",
"aiobscura-debug-codex-watch", "aiobscura-sync"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "aiobscura", "aiobscura-debug-claude", "aiobscura-debug-claude-watch", "aiobscura-debug-codex",
"aiobscura-debug-codex-watch", "aiobscura-sync"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "aiobscura", "aiobscura-debug-claude", "aiobscura-debug-claude-watch", "aiobscura-debug-codex",
"aiobscura-debug-codex-watch", "aiobscura-sync"
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
