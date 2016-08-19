class Zeromq40 < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "http://www.zeromq.org/"
  url "http://download.zeromq.org/zeromq-4.0.7.tar.gz"
  sha256 "e00b2967e074990d0538361cc79084a0a92892df2c6e7585da34e4c61ee47b03"

  bottle do
    cellar :any
    sha256 "a8276cede4c824f86f779408bb2c375e51e47dfdf14271eb451c56fb86456199" => :el_capitan
    sha256 "2870f7f4c2ae6f8c35eec102b8483ef377273983e90056b553efe6da34536f7e" => :yosemite
    sha256 "80771fd720a205b35d4a5629d234e7788a2fa396352af2969eaa27d31db57788" => :mavericks
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
