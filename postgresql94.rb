class Postgresql94 < Formula
  desc "Object-relational database system"
  homepage "http://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v9.4.9/postgresql-9.4.9.tar.bz2"
  sha256 "c120a62e90214c20d9160da3ca3fbaec97d5f1656f1dd033f60e7297b7a1e1c9"

  bottle do
    rebuild 1
    sha256 "16ed0f6837096cac0fab926ac36ca88461f12d640be0dcaf7482c0b907852aa8" => :el_capitan
    sha256 "b48ac1cc7ea1c123800873ef5b79ce5be2d15b602f6afad0e71a83fad68fae18" => :yosemite
    sha256 "89e575a4f2d805a1b7c2b9c44eac6087059cfd28dcf667aa0c4c2262e34d3c3f" => :mavericks
  end

  option "32-bit"
  option "without-perl", "Build without Perl support"
  option "without-tcl", "Build without Tcl support"
  option "with-dtrace", "Build with DTrace support"

  depends_on "openssl"
  depends_on "readline"
  depends_on "libxml2" if MacOS.version <= :leopard # Leopard libxml is too old
  depends_on python: :optional

  fails_with :clang do
    build 211
    cause "Miscompilation resulting in segfault on queries"
  end

  conflicts_with "postgres-xc",
    because: "postgresql and postgres-xc install the same binaries."
  conflicts_with "postgresql",
    because: "Differing versions of the same formula."

  patch :DATA

  def install
    ENV.libxml2 if MacOS.version >= :snow_leopard

    ENV.prepend "LDFLAGS", "-L#{Formula["openssl"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl"].opt_include} -I#{Formula["readline"].opt_include}"

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --datadir=#{share}/#{name}
      --docdir=#{doc}
      --enable-thread-safety
      --with-bonjour
      --with-gssapi
      --with-ldap
      --with-openssl
      --with-pam
      --with-libxml
      --with-libxslt
    ]

    args << "--with-python" if build.with? "python"
    args << "--with-perl" if build.with? "perl"

    # The CLT is required to build tcl support on 10.7 and 10.8 because tclConfig.sh is not part of the SDK
    if build.with?("tcl") && (MacOS.version >= :mavericks || MacOS::CLT.installed?)
      args << "--with-tcl"

      if File.exist?("#{MacOS.sdk_path}/usr/lib/tclConfig.sh")
        args << "--with-tclconfig=#{MacOS.sdk_path}/usr/lib"
      end
    end

    args << "--enable-dtrace" if build.with? "dtrace"
    args << "--with-uuid=e2fs"

    if build.build_32_bit?
      ENV.append ["CFLAGS", "LDFLAGS"], "-arch #{Hardware::CPU.arch_32_bit}"
    end

    system "./configure", *args
    system "make", "install-world"
  end

  def post_install
    (var/"log").mkpath
    (var/"postgres").mkpath
    unless File.exist? "#{var}/postgres/PG_VERSION"
      system "#{bin}/initdb", "#{var}/postgres"
    end
  end

  def caveats
    s = <<-EOS.undent
    If builds of PostgreSQL 9 are failing and you have version 8.x installed,
    you may need to remove the previous version first. See:
      https://github.com/Homebrew/homebrew/issues/issue/2510

    To migrate existing data from a previous major version (pre-9.3) of PostgreSQL, see:
      http://www.postgresql.org/docs/9.3/static/upgrading.html
    EOS

    if MacOS.prefer_64_bit?
      s << <<-EOS.undent
      \nWhen installing the postgres gem, including ARCHFLAGS is recommended:
        ARCHFLAGS="-arch x86_64" gem install pg

      To install gems without sudo, see the Homebrew documentation:
      https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Gems,-Eggs-and-Perl-Modules.md
      EOS
    end

    s
  end

  plist_options manual: "postgres -D #{HOMEBREW_PREFIX}/var/postgres"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/postgres</string>
        <string>-D</string>
        <string>#{var}/postgres</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/postgres.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/initdb", testpath/"test"
  end
end


__END__
--- a/contrib/uuid-ossp/uuid-ossp.c	2012-07-30 18:34:53.000000000 -0700
+++ b/contrib/uuid-ossp/uuid-ossp.c	2012-07-30 18:35:03.000000000 -0700
@@ -9,6 +9,8 @@
  *-------------------------------------------------------------------------
  */

+#define _XOPEN_SOURCE
+
 #include "postgres.h"
 #include "fmgr.h"
 #include "utils/builtins.h"
