class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.0.0.tar.gz"
  sha256 "886acd7bb7cfb99d105d9f900b93f8cc6e571330838004a75b6bac2a4ac1baca"

  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c119a030cdbe880bb0e29b9b4bec586938566267f6c6c587bcbc5dbcc1d6dd74" => :el_capitan
    sha256 "e97f4343b963f8f261886bafccbe83b818d8aaee7504a7489d61bf6a28be958b" => :yosemite
    sha256 "dbefd00269a65c04f43053120c6b4865dc7cbc0c9cbf24add8076ec2ad5b12ca" => :mavericks
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
