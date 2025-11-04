class TokenCounterBin < Formula
  desc "A CLI utility for counting LLM tokens, similar to Unix wc"
  homepage "https://github.com/kulesh/tc"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/tc/releases/download/v0.1.1/token-counter-bin-aarch64-apple-darwin.tar.xz"
      sha256 "2e08f32a8c496c594374123c7fede1c38915c8ed084c75238c2db53ee3021988"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/tc/releases/download/v0.1.1/token-counter-bin-x86_64-apple-darwin.tar.xz"
      sha256 "9d97bdc923e080d712307e0f7a33328f0f62d32a349e1ba46af4fc521c6993ed"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/tc/releases/download/v0.1.1/token-counter-bin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ae4b7880a95e8f6e1a2ba3eb3dcc4c2b2dc19be115b7515be4aedbd579f498ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/tc/releases/download/v0.1.1/token-counter-bin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7837b14b67496c3651eae6621cbf9b5320ee5c3247467967f16cfc89c89ec4c7"
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
