class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.3.2.tar.gz"
  sha256 "ccbc27355727090b1fdde7497ab2485c3509e2fd14b48a93276b285b5760d092"

  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f26c0fe6f6436b1459eb4a41b35ad665b9796c94830e1aff111cd485149c0b23" => :sierra
    sha256 "13de8253f868a9f336711be8f94315a99b6f775243c772dc5f702687e1b6eddd" => :el_capitan
    sha256 "7154d9627c4ccb295f95adb6eb3626514b2737e92b7ff9412169f72bf6a5068d" => :yosemite
  end

  depends_on "erlang"

  def install
    system "./bootstrap"
    bin.install "rebar3"

    bash_completion.install "priv/shell-completion/bash/rebar3"
    zsh_completion.install "priv/shell-completion/zsh/_rebar3" => "_rebar3"
    fish_completion.install "priv/shell-completion/fish/rebar3.fish"
  end

  test do
    system bin/"rebar3", "--version"
  end
end
