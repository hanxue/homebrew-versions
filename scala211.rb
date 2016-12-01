class Scala211 < Formula
  desc "Scala programming language"
  homepage "http://www.scala-lang.org/"
  url "http://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.tgz"
  sha256 "87fc86a19d9725edb5fd9866c5ee9424cdb2cd86b767f1bb7d47313e8e391ace"

  keg_only "Conflicts with scala in main repository."

  option "with-docs", "Also install library documentation"

  resource "docs" do
    url "http://www.scala-lang.org/files/archive/scala-docs-2.11.8.zip"
    sha256 "73bd44375ebffd5f401950a11d78addc52f8164c30d8528d26c82c1f819cfc16"
  end

  resource "completion" do
    url "https://raw.github.com/scala/scala-dist/27bc0c25145a83691e3678c7dda602e765e13413/completion.d/2.9.1/scala"
    sha256 "95aeba51165ce2c0e36e9bf006f2904a90031470ab8d10b456e7611413d7d3fd"
  end

  def install
    rm_f Dir["bin/*.bat"]
    doc.install Dir["doc/*"]
    man1.install Dir["man/man1/*"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
    bash_completion.install resource("completion")
    doc.install resource("docs") if build.with? "docs"

    # Set up an IntelliJ compatible symlink farm in "idea"
    idea = prefix/"idea"
    idea.install_symlink libexec/"src", libexec/"lib"
    (idea/"doc/scala-devel-docs").install_symlink doc => "api"
  end

  def caveats; <<-EOS.undent
    To use with IntelliJ, set the Scala home to:
      #{opt_prefix}/idea
    EOS
  end

  test do
    file = testpath/"hello.scala"
    file.write <<-EOS.undent
      object Computer {
        def main(args: Array[String]) {
          println(2 + 2)
        }
      }
    EOS
    output = `'#{bin}/scala' #{file}`
    assert_equal "4", output.strip
    assert $?.success?
  end
end
