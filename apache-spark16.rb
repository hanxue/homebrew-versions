class ApacheSpark16 < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org"
  url "http://d3kbcqa49mib13.cloudfront.net/spark-1.6.2-bin-hadoop2.6.tgz"
  version "1.6.2"
  sha256 "bddeccec0fb8ac9491cbb4e320467e9263bcc1caf9b45466164f8ae2d97de710"

  bottle :unneeded

  conflicts_with "apache-spark", :because => "Differing version of same formula"

  def install
    # Rename beeline to distinguish it from hive's beeline
    mv "bin/beeline", "bin/spark-beeline"

    rm_f Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/spark-shell <<<'sc.parallelize(1 to 1000).count()'"
  end
end
