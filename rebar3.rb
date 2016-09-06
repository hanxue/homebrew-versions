class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.3.1.tar.gz"
  sha256 "1042ffc90a723f57b9d5a6e3858c33e9c5230fe9ef0c51fafd6ce63618b4afe9"

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
