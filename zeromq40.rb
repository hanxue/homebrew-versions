class Zeromq40 < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "http://www.zeromq.org/"
  url "http://download.zeromq.org/zeromq-4.0.7.tar.gz"
  sha256 "e00b2967e074990d0538361cc79084a0a92892df2c6e7585da34e4c61ee47b03"

  bottle do
    cellar :any
    sha256 "675e48dfb203cf6d3e08660e9481cabf43759147cf3a0ef61240cba96df04a6e" => :el_capitan
    sha256 "7bc06564f4a0e31fc1e390926ed86e79298dee6edc49e6710a9dcac62679744f" => :yosemite
    sha256 "910a39ad58338eed771327083b5ec97f95dc77339e7e6ff246b2380ce5cacfcc" => :mavericks
  end

  option :universal
  option "with-libpgm", "Build with PGM extension"

  depends_on "pkg-config" => :build
  depends_on "libpgm" => :optional
  depends_on "libsodium" => :optional

  conflicts_with "zeromq", :because => "Differing version of the same formula"

  def install
    ENV.universal_binary if build.universal?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    if build.with? "libpgm"
      # Use HB libpgm-5.2 because their internal 5.1 is b0rked.
      ENV["OpenPGM_CFLAGS"] = `pkg-config --cflags openpgm-5.2`.chomp
      ENV["OpenPGM_LIBS"] = `pkg-config --libs openpgm-5.2`.chomp
      args << "--with-system-pgm"
    end

    if build.with? "libsodium"
      args << "--with-libsodium"
    else
      args << "--without-libsodium"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <zmq.h>

      int main()
      {
        zmq_msg_t query;
        assert(0 == zmq_msg_init_size(&query, 1));
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lzmq", "-o", "test"
    system "./test"
  end
end
