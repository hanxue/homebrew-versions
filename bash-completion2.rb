class BashCompletion2 < Formula
  desc "Programmable completion for Bash 4.0+"
  homepage "https://github.com/scop/bash-completion"
  url "https://github.com/scop/bash-completion/releases/download/2.3/bash-completion-2.3.tar.xz"
  sha256 "b2e081af317f3da4fff3a332bfdbebeb5514ebc6c2d2a9cf781180acab15e8e9"
  head "https://github.com/scop/bash-completion.git"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "608ad3be382f299a63038fbd3558fd1522cc04d6c5903991e5b08584ee2a9ff2" => :el_capitan
    sha256 "eee29853ae6c3d8d00374e725d1e04a919b8dfd7839a75740d4de4973991442f" => :yosemite
    sha256 "acdda6797ccd253618ec200c6f4a3fdd270ad111f674c0d90f62afe6ccf70071" => :mavericks
  end

  conflicts_with "bash-completion"

  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=739835
  # resolves issue with completion of files/directories with spaces in the name.
  patch do
    url "https://anonscm.debian.org/cgit/bash-completion/debian.git/plain/debian/patches/00-fix_quote_readline_by_ref.patch?id=d734ca3bd73ae49b8f452802fb8fb65a440ab07a"
    sha256 "7304f8fb4ad869f1b3d6f3456b2750246ddedef6fc307939bf403bf528f2fdf1"
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

  test do
    system "test", "-f", "#{share}/bash-completion/bash_completion"
  end
end
