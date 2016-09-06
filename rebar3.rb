class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.3.1.tar.gz"
  sha256 "1042ffc90a723f57b9d5a6e3858c33e9c5230fe9ef0c51fafd6ce63618b4afe9"

  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "41275be003cd0c23d0f3d2bef84791383765ac03ae60b171303f23a604e62bdb" => :el_capitan
    sha256 "204ff844b7fac9b378cdd7c9e1271c5fc5b5614093f4b758ba92abd791564f3f" => :yosemite
    sha256 "6dbb3b75f6e9f1e10e5284238d3fc178061cd5eebe408505c877649d26215b35" => :mavericks
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
