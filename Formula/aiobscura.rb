class Aiobscura < Formula
  desc "AI Agent Activity Monitor"
  homepage "https://github.com/kulesh/aiobscura"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.5/aiobscura-aarch64-apple-darwin.tar.xz"
      sha256 "82b7ff4264f1140a10cd0f2d774c7af360f70e703f8dda14bbb2070846923b86"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.5/aiobscura-x86_64-apple-darwin.tar.xz"
      sha256 "37ad6883001fa1b7733d63c702cd2d5f0b514ac13c1b6f866117357cae95bde2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.5/aiobscura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1744b3603ea5a2cdbd2a588754f6f854c942dc5c75655c193f8c4371228adf9b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.5/aiobscura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5dad5884387e2c7c957d01b09aa76763a8c71474f411b89237073273066099b0"
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
    bin.install "aiobscura", "aiobscura-analyze", "aiobscura-sync" if OS.mac? && Hardware::CPU.arm?
    bin.install "aiobscura", "aiobscura-analyze", "aiobscura-sync" if OS.mac? && Hardware::CPU.intel?
    bin.install "aiobscura", "aiobscura-analyze", "aiobscura-sync" if OS.linux? && Hardware::CPU.arm?
    bin.install "aiobscura", "aiobscura-analyze", "aiobscura-sync" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
