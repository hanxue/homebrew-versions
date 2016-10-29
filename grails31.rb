class Grails31 < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v3.1.12/grails-3.1.12.zip"
  sha256 "65521d62aa553b5af8ead8722b96be6f69a6d3117b52cea272a9c482ddff4b89"

  bottle :unneeded

  conflicts_with "grails", :because => "Differing versions of the same formula"

  def install
    rm_f Dir["bin/*.bat", "bin/cygrails", "*.bat"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    The GRAILS_HOME directory is:
      #{opt_libexec}
    EOS
  end

  test do
    assert_match "Grails Version: #{version}", shell_output("#{bin}/grails -v")
  end
end
