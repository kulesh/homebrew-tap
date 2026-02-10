class AiobscuraWrapped < Formula
  desc "AI Agent Wrapped - Year in Review CLI"
  homepage "https://github.com/kulesh/aiobscura"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.9/aiobscura-wrapped-aarch64-apple-darwin.tar.xz"
      sha256 "e8feed5fd00a58dc0408c25cc17231d45f796db5ffd09c083f7c1433b3265279"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.9/aiobscura-wrapped-x86_64-apple-darwin.tar.xz"
      sha256 "070e9af5e2b5c7d5830e4f4b6c48fd0420b95a7abe6ec372413b71fa937ba8d7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.9/aiobscura-wrapped-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3975915ccf82e924287fa1256b08627f1de72f2982c18824bfae2f3ac1d6b8b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/aiobscura/releases/download/v0.1.9/aiobscura-wrapped-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d094632598c09b1e7d4756dce60953ba5c7976b24bd5a6a63898319caf52f07c"
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
