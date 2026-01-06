class Promptcmd < Formula
  desc "Turn GenAI prompts into runnable programs"
  homepage "https://promptcmd.sh"
  version "0.4.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tgalal/promptcmd/releases/download/v0.4.8/promptcmd-aarch64-apple-darwin.tar.xz"
      sha256 "5cec567d6e5f903d30cf8e8cf922efd94944592df91988effa7b704b2017ac60"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tgalal/promptcmd/releases/download/v0.4.8/promptcmd-x86_64-apple-darwin.tar.xz"
      sha256 "c59316fb1b8d2cce5dbdd97d9ce46b2ec3fa70fb910e7aa5bafc41d6ebee9d60"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/tgalal/promptcmd/releases/download/v0.4.8/promptcmd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4dd27148a39eee18f9b30e70b16cdcdd1db9d67e3940069294b4fb3339974621"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "promptcmd", "promptctl" if OS.mac? && Hardware::CPU.arm?
    bin.install "promptcmd", "promptctl" if OS.mac? && Hardware::CPU.intel?
    bin.install "promptcmd", "promptctl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
