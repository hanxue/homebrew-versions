class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.1.1.tar.gz"
  sha256 "432fcb27f6d615655ef432f881a5e38d63fdc6e5c6584cac963d0a1391edafbd"

  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49322605b2fd321a356a63a830f0774a8b81c5338647fac71dedcde8a7c2ebce" => :el_capitan
    sha256 "0176e7a0b4abb0180461fc813c21860a03480be5bff21ee5551b3c775f554564" => :yosemite
    sha256 "e75f4fbaf5dbd5950076546910d95d8934d76d6d4a60a0a6af7e07909873c635" => :mavericks
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
