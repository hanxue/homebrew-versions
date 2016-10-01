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
    sha256 "1384c6984ae99dd31cbb95dabdb18beac959528346e87304c5cd5256796808f2" => :sierra
    sha256 "dd4e395f959a85004e851822336f9c338cbf9a2e1910af00e1e3f6b981ee6bba" => :el_capitan
    sha256 "bcf55ed89f3b0f30fb6412833f69d15b3f15567e177e188668d934a9efd6185c" => :yosemite
  end

  revision 1

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
