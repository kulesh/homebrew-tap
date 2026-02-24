class AiobscuraWrapped < Formula
  desc "AI Agent Wrapped - Year in Review CLI"
  homepage "https://github.com/kulesh/aiobscura"
  version "0.1.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.10/aiobscura-wrapped-aarch64-apple-darwin.tar.xz"
      sha256 "1bca1a591e6135f8ae72edd3a58683bdfeb178a11542d0de05650f6fddee5d56"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.10/aiobscura-wrapped-x86_64-apple-darwin.tar.xz"
      sha256 "268ea0b25d0712994666bed5aa77cda140d7efbd3b5f49f76df3f8ac5cc5fbc4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.10/aiobscura-wrapped-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3bac9e32b6fcf30f77162baa8be43633ab86228fea6c24f74974ef07368154b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.10/aiobscura-wrapped-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c7286d9676cd0df5bfbb76234b89e0216d18f7e8c7ecec6d7948bd7053294869"
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
