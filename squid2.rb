require 'formula'

class Squid2 < Formula
  homepage 'http://www.squid-cache.org/'
  url 'http://www.squid-cache.org/Versions/v2/2.7/squid-2.7.STABLE9.tar.gz'
  version '2.7.9'
  sha1 '6d90fe06468b662b2eefd7ffeb47b9a78f0a871d'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
                          "--enable-ssl"
    system "make install"
  end
  
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
        <string>#{opt_prefix}/sbin/squid</string>
        <string>-N</string>
        <string>-d 1</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOS
  end
end
