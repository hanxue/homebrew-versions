class Spidermonkey45 < Formula
  desc "JavaScript-C Engine, version 45"
  homepage "https://developer.mozilla.org/en/SpiderMonkey"

  stable do
    url "https://people.mozilla.org/~sfink/mozjs-45.0.2.tar.bz2"
    sha256 "570530b1e551bf4a459d7cae875f33f99d5ef0c29ccc7742a1b6f588e5eadbee"
    # mozbuild installs symlinks in `make install`
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1296289
    patch :DATA
  end

  bottle do
    cellar :any
    sha256 "a6a556c6c8884df6e6d17bd8e9c20c6a441f4e337514f0a113226b3e2b22e539" => :sierra
    sha256 "5d2ec29fb24fdda4b53a6695388523b2c024da782c959155291578289fdd81fd" => :el_capitan
    sha256 "c0eb90b9749dc82000aec33073bdc860d000905324085e77a92c21a7c7a4e001" => :yosemite
  end

  revision 2

  depends_on "readline"
  depends_on "nspr"
  depends_on "icu4c"
  depends_on "pkg-config" => :build

  conflicts_with "narwhal", :because => "both install a js binary"

  def install
    mkdir "brew-build" do
      system "../js/src/configure", "--prefix=#{prefix}",
                                    "--enable-readline",
                                    "--with-system-nspr",
                                    "--with-system-icu",
                                    "--with-nspr-prefix=#{Formula["nspr"].opt_prefix}",
                                    "--enable-macos-target=#{MacOS.version}"

      # These need to be in separate steps.
      system "make"
      system "make", "install"

      # libmozglue.dylib is required for both the js shell and embedders
      # https://bugzilla.mozilla.org/show_bug.cgi?id=903764
      lib.install "mozglue/build/libmozglue.dylib"

      mv lib/"libjs_static.ajs", lib/"libjs_static.a"
    end
  end

  test do
    path = testpath/"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}/js #{path}").strip
  end
end
__END__
--- mozjs-45.0.2/python/mozbuild/mozbuild/backend/recursivemake.py.orig 2016-08-04 09:44:05.439784749 +0800
+++ mozjs-45.0.2/python/mozbuild/mozbuild/backend/recursivemake.py  2016-08-04 09:44:19.226451018 +0800
@@ -1306,7 +1306,7 @@
             for f in files:
                 if not isinstance(f, ObjDirPath):
                     dest = mozpath.join(reltarget, path, mozpath.basename(f))
-                    install_manifest.add_symlink(f.full_path, dest)
+                    install_manifest.add_copy(f.full_path, dest)
                 else:
                     backend_file.write('%s_FILES += %s\n' % (
                         target_var, self._pretty_path(f, backend_file)))
