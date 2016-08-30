class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.3.0.tar.gz"
  sha256 "9bafcaccd363eaa35fb8de51ea1e9baf6181569f2f29a1e9fdffbb0469b1b505"

  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a27dda8e5a22564bfd46729e0649fce5d0051eed5aa3aacaa5304e90fccaf39a" => :el_capitan
    sha256 "463fd4da98b0ab274a7e39d19796e07f33ab32ff5a11aaf6be574acc9bb8d3ed" => :yosemite
    sha256 "33c26eec9f4e5907c8cd6f293cb551006244623a8d59695b4a0f60c329126b64" => :mavericks
  end

  depends_on "erlang"

  def install
    system "./bootstrap"
    bin.install "rebar3"
  end

  test do
    system bin/"rebar3", "--version"
  end
end
