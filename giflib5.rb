class Giflib5 < Formula
  desc "Library and utilities for processing GIFs"
  homepage "http://giflib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-5.1.3.tar.bz2"
  sha256 "5096d27805283599b01074d487ad3f8e02bd26b84d759b9017be876ca3d5b81d"

  bottle do
    cellar :any
    sha256 "d5539114f8aea22d0e0559e7feb47faca1423622fd9c9fc79938e55c76865811" => :el_capitan
    sha256 "9a346ec04be4662c1662c3b96e919d8387aec55cf7da58bf64671bcb14438fb4" => :yosemite
    sha256 "86a048dbaf112e748fe8b8c72a00fe456b5f1f8fe2dc2fc5a932e8d5ad67d6d8" => :mavericks
  end

  keg_only "Conflicts with giflib in main repository."

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match /Screen Size - Width = 1, Height = 1/, shell_output("#{bin}/giftext #{test_fixtures("test.gif")}")
  end
end
