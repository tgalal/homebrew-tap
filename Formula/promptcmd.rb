class Promptcmd < Formula
  desc "Turn GenAI prompts into runnable programs"
  homepage "https://promptcmd.sh"
  version "1.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tgalal/promptcmd/releases/download/v1.0.4/promptcmd-aarch64-apple-darwin.tar.xz"
      sha256 "8a439d273230f0219c3e1bff165931ca6c2a434e78a82e7667f333c03586549f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tgalal/promptcmd/releases/download/v1.0.4/promptcmd-x86_64-apple-darwin.tar.xz"
      sha256 "7c346cdf42fdf92510eef8b177e20406cb349ed7c3c0043397f69491c0f1c24f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/tgalal/promptcmd/releases/download/v1.0.4/promptcmd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ed765959aac48badc2722cd20afd732b1e8b03617284de33a50cfa32794f3433"
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
