class Aiobscura < Formula
  desc "AI Agent Activity Monitor"
  homepage "https://github.com/kulesh/aiobscura"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.4/aiobscura-aarch64-apple-darwin.tar.xz"
      sha256 "382a217d79e2ad708e167d3435b9b4cc225d969abe115374d4482e54a1ec02a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.4/aiobscura-x86_64-apple-darwin.tar.xz"
      sha256 "4217e0f5454e10b4062e791856894a793711900775d7c65eeda973daec33c377"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.4/aiobscura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1a91ea017c7f9f40a685d3d651278063a35059c40910c1350ed45e9fb1d92312"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.4/aiobscura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c225c5b6fadd8b6218cb88a36339876b80e38c5ca31e2b732ef6101d35c19e5a"
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
