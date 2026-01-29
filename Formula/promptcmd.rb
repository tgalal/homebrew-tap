class Promptcmd < Formula
  desc "Turn GenAI prompts into runnable programs"
  homepage "https://promptcmd.sh"
  version "1.0.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tgalal/promptcmd/releases/download/v1.0.7/promptcmd-aarch64-apple-darwin.tar.xz"
      sha256 "d703979c76c1077f1b4cb96479725683782325939786f182f5abfba3ab86918c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tgalal/promptcmd/releases/download/v1.0.7/promptcmd-x86_64-apple-darwin.tar.xz"
      sha256 "88f17af542df89cdd61b7c3448201633ac6f7de9e17475286676121c0925342b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/tgalal/promptcmd/releases/download/v1.0.7/promptcmd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b819848acf022257c1744777c1356d97a8ef5eb3e399b6d254b28c9224b395ed"
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
