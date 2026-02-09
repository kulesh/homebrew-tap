class AiobscuraWrapped < Formula
  desc "AI Agent Wrapped - Year in Review CLI"
  homepage "https://github.com/kulesh/aiobscura"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.8/aiobscura-wrapped-aarch64-apple-darwin.tar.xz"
      sha256 "0fbeb4b2bd3b109ae8f852af05efa3075163a89739e70b7d56ec7c2582bb9c92"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.8/aiobscura-wrapped-x86_64-apple-darwin.tar.xz"
      sha256 "e58e5f4a6fa3a78b2e54cae36211fff7becca459a212f6deee41ec81fb46e05f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.8/aiobscura-wrapped-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d095c00f4406a3fd2cb375bfb617a0707fe25b2d89dbf2176086b137e82546a8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.8/aiobscura-wrapped-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0cd7ee4dd09fc7ba96cd96ebcd2d89d138d6fd840bb1500319c7e97ffccc2d2f"
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
