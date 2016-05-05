class Jpeg9 < Formula
  desc "JPEG image manipulation library"
  homepage "http://www.ijg.org"
  url "http://www.ijg.org/files/jpegsrc.v9b.tar.gz"
  version "9.1"
  sha256 "240fd398da741669bf3c90366f58452ea59041cacc741a489b99f2f6a0bad052"

  bottle do
    cellar :any
    sha256 "9061df1faf981bb9e064d58a6a72b0339cf00b0824da8f09b911026a3740fef0" => :yosemite
    sha256 "969b3b006f8eddbd66c4d293d4732783510ed04346151497d204c1da3ad46c04" => :mavericks
    sha256 "be2a94a1715e16a4097ac00c7d9b5f3d4ebc64e96027bc4a40b321bb5da27eea" => :mountain_lion
  end

  keg_only "Conflicts with jpeg in main repository."

  option :universal

  def install
    ENV.universal_binary if build.universal?

    # Builds static and shared libraries.
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/djpeg", test_fixtures("test.jpg")
  end
end
