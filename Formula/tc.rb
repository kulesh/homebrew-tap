class Tc < Formula
  desc "A CLI utility for counting LLM tokens, similar to Unix wc"
  homepage "https://github.com/kulesh/tc"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/tc/releases/download/v0.1.2/token-counter-bin-aarch64-apple-darwin.tar.xz"
      sha256 "7f60b39a708892dc5e4cea23a312a413b62b14dc41c93e4b5b805c88a9b3d11f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/tc/releases/download/v0.1.2/token-counter-bin-x86_64-apple-darwin.tar.xz"
      sha256 "8bae3160b69bc426689ea048e6e3b2f328bd928edb0596a3ea6bc8f3e09faabf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/tc/releases/download/v0.1.2/token-counter-bin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c7cd3b6c578d26df462a316d05749140b3c58827c9cb80eb1bb6e23c04352474"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/tc/releases/download/v0.1.2/token-counter-bin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a0e53d4871119c03c2e1feb74622d4fb9ea53ee7067f8f3f4df958773ebb4420"
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
