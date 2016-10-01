class Tomcat7 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-7/v7.0.72/bin/apache-tomcat-7.0.72.tar.gz"
  sha256 "779c7bba49a9ed3cafc47a87c8f331d2068f2545105fdd1c1076e0357ebda5db"

  bottle :unneeded

  conflicts_with "tomcat", :because => "Differing versions of same formula"

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-7/v7.0.72/bin/apache-tomcat-7.0.72-fulldocs.tar.gz"
    version "7.0.72"
    sha256 "bea99925baa6ac0e940a231655b125f0f1ccdc43c9150ebc3984e8fbf7305975"
  end

  # Keep log folders
  skip_clean "libexec"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/catalina.sh" => "catalina"

    (share/"fulldocs").install resource("fulldocs") if build.with? "fulldocs"
  end
end
