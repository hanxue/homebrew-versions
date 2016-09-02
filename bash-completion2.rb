class BashCompletion2 < Formula
  desc "Programmable completion for Bash 4.0+"
  homepage "https://github.com/scop/bash-completion"
  url "https://github.com/scop/bash-completion/releases/download/2.4/bash-completion-2.4.tar.xz"
  sha256 "c0f76b5202fec9ef8ffba82f5605025ca003f27cfd7a85115f838ba5136890f6"
  head "https://github.com/scop/bash-completion.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d09547e2899fa8ebb91737a60fbb67d5fa0f7b4bab5c15b50c4cfacb533974e9" => :el_capitan
    sha256 "bf5de0393acf3041e2801981017f53a62cb2d34435e63519ef352f507f26d361" => :yosemite
    sha256 "3f7d127ea60af0e26d4c5b0621b3eeabe4550d49a59411e72ff3a03e28cd05b7" => :mavericks
  end

  conflicts_with "bash-completion"

  def install
    inreplace "bash_completion", "readlink -f", "readlink"

    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    ENV.deparallelize
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Add the following to your ~/.bash_profile:
      if [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
        . $(brew --prefix)/share/bash-completion/bash_completion
      fi
    EOS
  end

  test do
    system "test", "-f", "#{share}/bash-completion/bash_completion"
  end
end
