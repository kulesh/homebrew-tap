class Aiobscura < Formula
  desc "AI Agent Activity Monitor"
  homepage "https://github.com/kulesh/aiobscura"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.3/aiobscura-aarch64-apple-darwin.tar.xz"
      sha256 "648170108cacd918173b0c4501970ac841bedee043169b852380c1074456dc42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.3/aiobscura-x86_64-apple-darwin.tar.xz"
      sha256 "03f19f5b7daa28ce8ac6205fe3b9c4be2cdc781eb5cfa1d45c291d6cd7f29987"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.3/aiobscura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "605374ecc4ad6486a10de9e342d6d2f63cf7b1e20abf91d1a85873df49eabdad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.3/aiobscura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "99adf5e434ba2d58f143e17880f63e224a7429c116b29844deda5d2e6ef9a087"
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
