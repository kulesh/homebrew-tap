class Tc < Formula
  desc "A CLI utility for counting LLM tokens, similar to Unix wc"
  homepage "https://github.com/kulesh/tc"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/tc/releases/download/v0.1.4/token-counter-bin-aarch64-apple-darwin.tar.xz"
      sha256 "7fed57ba2d8fde711d0bed873493386de0b52cd20164b4ad1868207dfd186f86"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/tc/releases/download/v0.1.4/token-counter-bin-x86_64-apple-darwin.tar.xz"
      sha256 "d01da99acadf0d3480c1e6b15be53fcab3651dc0a90eb554ba014fe16f4eaa27"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/tc/releases/download/v0.1.4/token-counter-bin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "15f0482f14b977d637a85bf2c7caf37295f0ff981361e0f3626380682ff747a1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/tc/releases/download/v0.1.4/token-counter-bin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5672955546bf5e69fbf264874fe68dccc42cfd372adabb108921f0f71cab952e"
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
