class BashCompletion2 < Formula
  desc "Programmable completion for Bash 4.0+"
  homepage "https://bash-completion.alioth.debian.org/"
  url "https://mirrors.kernel.org/debian/pool/main/b/bash-completion/bash-completion_2.1.orig.tar.bz2"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/b/bash-completion/bash-completion_2.1.orig.tar.bz2"
  sha256 "2b606804a7d5f823380a882e0f7b6c8a37b0e768e72c3d4107c51fbe8a46ae4f"
  revision 2

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "608ad3be382f299a63038fbd3558fd1522cc04d6c5903991e5b08584ee2a9ff2" => :el_capitan
    sha256 "eee29853ae6c3d8d00374e725d1e04a919b8dfd7839a75740d4de4973991442f" => :yosemite
    sha256 "acdda6797ccd253618ec200c6f4a3fdd270ad111f674c0d90f62afe6ccf70071" => :mavericks
  end

  conflicts_with "bash-completion"

  # All three fix issues with GNU extended regexs
  patch do
    url "https://anonscm.debian.org/gitweb/?p=bash-completion/bash-completion.git;a=patch;h=f230cfddbd12b8c777040e33bac1174c0e2898af"
    sha256 "b557b2f71a1376b51bf2de1c56f181b27111381cb3cac727144d65d94ab1758a"
  end

  patch do
    url "https://anonscm.debian.org/gitweb/?p=bash-completion/bash-completion.git;a=patch;h=3ac523f57e8d26e0943dfb2fd22f4a8879741c60"
    sha256 "b680b347d8f1330cbae47b76ec6d9e9ec15459a7c89c2c767855e47afbebed96"
  end

  patch do
    url "https://anonscm.debian.org/gitweb/?p=bash-completion/bash-completion.git;a=patch;h=50ae57927365a16c830899cc1714be73237bdcb2"
    sha256 "7a5dda29cb0c0ba4fc747fd2163c8041efe4b157b71708b4e9db5a0048588e6b"
  end

  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=739835
  # resolves issue with completion of files/directories with spaces in the name.
  patch do
    url "https://anonscm.debian.org/cgit/bash-completion/debian.git/plain/debian/patches/00-fix_quote_readline_by_ref.patch?id=d734ca3bd73ae49b8f452802fb8fb65a440ab07a"
    sha256 "7304f8fb4ad869f1b3d6f3456b2750246ddedef6fc307939bf403bf528f2fdf1"
  end

  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=739835
  # https://bugs.launchpad.net/ubuntu/+source/bash-completion/+bug/1289597
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/9d38db2889e3af2deba8edabca368e4e02d0f73e/bash-completion2/bug-739835.patch"
    sha256 "126e535c2da21f67ec54522c3deaf210921c3ee89a863fbb585e7dde39d67aeb"
  end

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
end
