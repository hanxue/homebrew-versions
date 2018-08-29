class Litetree < Formula
  desc "SQLite with Branches"
  homepage "https://github.com/aergoio/litetree"
  url "https://github.com/aergoio/litetree/archive/master.tar.gz"
  version "1.0.0"
  sha256 "f8f5bbf5c9626021ec809fdc6f16a4c07052936614d92184f46854f8faa3c319"
  head "https://github.com/aergoio/litetree.git"

  depends_on "readline" => :recommended
  depends_on "icu4c" => :optional

  def install
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_COLUMN_METADATA=1"
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
    ENV.append "CPPFLAGS", "-DSQLITE_MAX_VARIABLE_NUMBER=250000"

    inreplace "makefile" do |s|
      s.gsub! "cp $(SHORT).h $(INCPATH)", "cp $(SHORT).h $(INCPATH)/"
      s.gsub! "cp $(SSHELL) $(EXEPATH)", "cp $(SSHELL) $(EXEPATH)/"
    end
    mkdir "#{include}"
    mkdir "#{bin}"
    system "make"
    system "make", "install", "prefix=#{HOMEBREW_PREFIX}/Cellar/#{name}/1.0.0"
  end

  test do
    path = testpath/"school.sql"
    path.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    EOS

    names = shell_output("#{bin}/sqlite3 < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
