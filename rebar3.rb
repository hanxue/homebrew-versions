class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.0.0.tar.gz"
  sha256 "886acd7bb7cfb99d105d9f900b93f8cc6e571330838004a75b6bac2a4ac1baca"

  head "https://github.com/rebar/rebar3.git"

  depends_on "erlang"

  def install
    system "./bootstrap"
    bin.install "rebar3"
  end

  test do
    system bin/"rebar3", "--version"
  end
end
