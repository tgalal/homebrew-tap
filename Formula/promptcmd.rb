class Promptcmd < Formula
  desc "Turn GenAI prompts into runnable programs"
  homepage "https://promptcmd.sh"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tgalal/promptcmd/releases/download/v0.6.1/promptcmd-aarch64-apple-darwin.tar.xz"
      sha256 "a3fa8d0ab1bd8bfc06d6632268a1ea0257ca661a09141081358515ed6efe6363"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tgalal/promptcmd/releases/download/v0.6.1/promptcmd-x86_64-apple-darwin.tar.xz"
      sha256 "a15b07203cdedcc63b30fb473de721025865b9b58511cc0a60f0326fba70f948"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/tgalal/promptcmd/releases/download/v0.6.1/promptcmd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "63b404c047ebcec548a274078ca546dbbf3aa2945aeb2f077a9d3cea4f28dabc"
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
