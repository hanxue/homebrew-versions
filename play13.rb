class Play13 < Formula
  desc "Play’s goal is to ease Java web applications development."
  homepage "https://www.playframework.com"
  url "https://downloads.typesafe.com/play/1.3.4/play-1.3.4.zip"
  sha256 "a97a4a70e48df578206fd6660e3f83aa1442d6f85b79429e7b6a7c08ac1fc8d1"

  bottle :unneeded

  conflicts_with "sox", :because => "Both install a `play` executable"
  conflicts_with "play14", :because => "Both install a `play` executable"
  conflicts_with "play22", :because => "Both install a `play` executable"

  def install
    rm_rf "python" # we don't need the bundled Python for windows
    rm Dir["*.bat"]
    libexec.install Dir["*"]
    chmod 0755, libexec/"play"
    bin.install_symlink libexec/"play"
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/play new #{testpath}/app") do |stdin, _, _|
      stdin.write "\n"
      stdin.close
    end
    %W[app conf lib public test].each do |d|
      File.directory? testpath/"app/#{d}"
    end
  end
end
