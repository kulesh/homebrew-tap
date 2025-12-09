class Aiobscura < Formula
  desc "AI Agent Activity Monitor"
  homepage "https://github.com/kulesh/aiobscura"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.2/aiobscura-aarch64-apple-darwin.tar.xz"
      sha256 "0247201700d5f51e99a838030725e0996c352acf46d4223a798c32c1406b36cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.2/aiobscura-x86_64-apple-darwin.tar.xz"
      sha256 "3f9dba7b24335b0d9e3ef215fbc464d41d9f5e12b8e178746432bcd5124f4633"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.2/aiobscura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "20e97791a0009b785eda581e71219315cdd24bfb64e323d0a7cfc4d20a0eeb0a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.2/aiobscura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "db17d0968c167d1b79eaafd05d05055949e23099b374cf821e16d5ef22720bb2"
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
