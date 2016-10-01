class LibmongoclientLegacy < Formula
  homepage "https://www.mongodb.org"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/legacy-1.1.2.tar.gz"
  sha256 "8c52cae798086c3e9d0e6fe488c3378601db858cc71944b6b83440d8b00298f4"

  head "https://github.com/mongodb/mongo-cxx-driver.git", :branch => "legacy"

  bottle do
    sha256 "9639189d02dd9c71704effdfefa3696f3a95076cc1c91c628940b6ebbe645ccd" => :sierra
    sha256 "d4beb45e68470497281cddb9ab8f99a74bd91a0fc925d047b968a9db8c0f71c3" => :el_capitan
    sha256 "f080e21c4c7482d045e30cbd60c190bda7fad3805481c7b8f4f09465718b23e3" => :yosemite
  end

  option :cxx11

  depends_on "scons" => :build

  if build.cxx11?
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  conflicts_with "libmongoclient", :because => "libmongoclient contains 26compat branch"

  def install
    ENV.cxx11 if build.cxx11?

    boost = Formula["boost"].opt_prefix

    args = [
      "--prefix=#{prefix}",
      "-j#{ENV.make_jobs}",
      "--cc=#{ENV.cc}",
      "--cxx=#{ENV.cxx}",
      "--extrapath=#{boost}",
      "--sharedclient",
      # --osx-version-min is required to override --osx-version-min=10.6 added
      # by SConstruct which causes "invalid deployment target for -stdlib=libc++"
      # when using libc++
      "--osx-version-min=#{MacOS.version}",
      "install",
    ]

    args << "--libc++" if MacOS.version >= :mavericks

    scons *args
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <mongo/client/dbclient.h>

      int main() {
          mongo::DBClientConnection c;
          mongo::client::initialize();
          return 0;
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-lmongoclient",
           "-L#{Formula["boost"].opt_lib}", "-lboost_system",
           testpath/"test.cpp", "-o", testpath/"test"
    system "./test"
  end
end
