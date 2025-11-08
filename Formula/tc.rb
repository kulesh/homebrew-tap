class Tc < Formula
  desc "A CLI utility for counting LLM tokens, similar to Unix wc"
  homepage "https://github.com/kulesh/tc"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/tc/releases/download/v0.1.5/token-counter-bin-aarch64-apple-darwin.tar.xz"
      sha256 "f7228e49d8ade288cbee938bf810da29fc2f0aa224be5c11b9f1e7c76e63ab75"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/tc/releases/download/v0.1.5/token-counter-bin-x86_64-apple-darwin.tar.xz"
      sha256 "3378d15148c589f978b633ba22ebe7e817b2f68679e765692200fc434f29c576"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/tc/releases/download/v0.1.5/token-counter-bin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "11f35af0f1edacb1299eafafbcadd3e8fef5d41870ea1fdc406e3abcdfe20626"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/tc/releases/download/v0.1.5/token-counter-bin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6ac284b93720909445087c6c5a7ea412836369356aa717bb29c9e18f3da99e35"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
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
    bin.install "tc" if OS.mac? && Hardware::CPU.arm?
    bin.install "tc" if OS.mac? && Hardware::CPU.intel?
    bin.install "tc" if OS.linux? && Hardware::CPU.arm?
    bin.install "tc" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
