class Promptcmd < Formula
  desc "Turn GenAI prompts into runnable programs"
  homepage "https://promptcmd.sh"
  version "0.4.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tgalal/promptcmd/releases/download/v0.4.10/promptcmd-aarch64-apple-darwin.tar.xz"
      sha256 "e156b3035aceabbb861c2d724316ccbee9b17a93e3b3a27e2ff354a6e753f2c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tgalal/promptcmd/releases/download/v0.4.10/promptcmd-x86_64-apple-darwin.tar.xz"
      sha256 "f3f247d9a0bcb88916d591037c38c24fe3bfb06e7fb17d6fab583ce167db2bc0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/tgalal/promptcmd/releases/download/v0.4.10/promptcmd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "afcb07dc20014af69238e1db72f6cb20fc097fb27428cecc1868286ad927be0e"
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
