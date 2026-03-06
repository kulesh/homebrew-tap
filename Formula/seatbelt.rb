class Seatbelt < Formula
  desc "macOS CLI that makes sandbox-exec usable by humans"
  homepage "https://github.com/kulesh/seatbelt"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kulesh/seatbelt/releases/download/v0.1.3/seatbelt-bin-aarch64-apple-darwin.tar.xz"
      sha256 "168f195c92a1a4cd770a6f14504aa6de6af13033691e11af54ef8d09c00cf944"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kulesh/seatbelt/releases/download/v0.1.3/seatbelt-bin-x86_64-apple-darwin.tar.xz"
      sha256 "8c66e03480dd85a18c5e68d63951c817672c43d0fd0f265bea69576c6582dfd0"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
    bin.install "seatbelt" if OS.mac? && Hardware::CPU.arm?
    bin.install "seatbelt" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
