class Aiobscura < Formula
  desc "AI Agent Activity Monitor"
  homepage "https://github.com/kulesh/aiobscura"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.7/aiobscura-aarch64-apple-darwin.tar.xz"
      sha256 "edee12204885b3331e77205cb0601f14dcb191625092d8892363beac99de3e1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.7/aiobscura-x86_64-apple-darwin.tar.xz"
      sha256 "3e4327132c2c1a4e94893367d6b82e2fe86849faa9633bf0e186d2732c69bf74"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.7/aiobscura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "676f46a149f4744dfd6257b57dbd9744d1fb1a1d995fe261228bde9b87b4c0c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.7/aiobscura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c02ab58dfefbcf3f16ba296e432be5a20b3d929fe2c72d11871cc6b497f4b514"
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
