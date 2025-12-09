class AiobscuraWrapped < Formula
  desc "AI Agent Wrapped - Year in Review CLI"
  homepage "https://github.com/kulesh/aiobscura"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.0/aiobscura-wrapped-aarch64-apple-darwin.tar.xz"
      sha256 "c92dfb59bdac7c5469668d414e66aa51644dcccf3d6b666d1d71f6a9473563dc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.0/aiobscura-wrapped-x86_64-apple-darwin.tar.xz"
      sha256 "ac6e1a871b34678c909e7917a4bbf8ee21f54cb533b563745a0c70211584a02f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.0/aiobscura-wrapped-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fe56b259cb902dfef13eba6543e0dbb03271708e5b7b6269ab75a1edf44b15c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.0/aiobscura-wrapped-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6047bf1ea04d8bd5f31be4ea9efc5b62f69466d15c24fdd1278d63a9cd5e1f47"
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
    bin.install "aiobscura-wrapped" if OS.mac? && Hardware::CPU.arm?
    bin.install "aiobscura-wrapped" if OS.mac? && Hardware::CPU.intel?
    bin.install "aiobscura-wrapped" if OS.linux? && Hardware::CPU.arm?
    bin.install "aiobscura-wrapped" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
