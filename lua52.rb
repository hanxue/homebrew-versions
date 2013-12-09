require 'formula'

class Lua52 < Formula
  homepage 'http://www.lua.org/'
  url 'http://www.lua.org/ftp/lua-5.2.3.tar.gz'
  sha1 '926b7907bc8d274e063d42804666b40a3f3c124c'

  fails_with :llvm do
    build 2326
    cause "Lua itself compiles with LLVM, but may fail when other software tries to link."
  end

  option 'completion', 'Enables advanced readline support'

  def patches
    if build.include? 'completion'
      'http://luajit.org/patches/lua-5.2.0-advanced_readline.patch'
    end
  end

  def install
    # Use our CC/CFLAGS to compile.
    inreplace 'src/Makefile' do |s|
      s.remove_make_var! 'CC'
      s.change_make_var! 'CFLAGS', "#{ENV.cflags} -DLUA_COMPAT_ALL $(SYSCFLAGS) $(MYCFLAGS)"
      s.change_make_var! 'MYLDFLAGS', ENV.ldflags
    end

    # Fix path in the config header
    inreplace 'src/luaconf.h', '/usr/local', HOMEBREW_PREFIX

    # this ensures that this symlinking for lua starts at lib/lua/5.2 and not
    # below that, thus making luarocks work
    (HOMEBREW_PREFIX/"lib/lua"/version.to_s.split('.')[0..1].join('.')).mkpath

    system "make", "macosx", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}"
    system "make", "install", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}"
  end
end
