class AiobscuraWrapped < Formula
  desc "AI Agent Wrapped - Year in Review CLI"
  homepage "https://github.com/kulesh/aiobscura"
  version "0.1.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.11/aiobscura-wrapped-aarch64-apple-darwin.tar.xz"
      sha256 "e2d9955fb0b6252470107816415c671686aee00dc95bd6911061151a27583840"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.11/aiobscura-wrapped-x86_64-apple-darwin.tar.xz"
      sha256 "4b5db6d2d76d0f008a29f0ea1a4508930127c697bc31e0ca5165d2635c3433ba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.11/aiobscura-wrapped-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aeb41a838538c40c7f1fcbcfdfe4767544df650e356379ff25ddfaaad7f85f31"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.11/aiobscura-wrapped-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "164184405cb7292d68800a87030d1ad7662a23b37acbca444921606db9c618cd"
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
