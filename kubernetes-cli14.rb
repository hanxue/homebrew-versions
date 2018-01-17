class KubernetesCli14 < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.4.7.tar.gz"
  sha256 "2f5d4c5071109935386c550899ae85f338ee3a9d58cb1908d2d975d8a9c5baa9"

  bottle do
    cellar :any_skip_relocation
    sha256 "08b4eb3a37a78df4ff80ee01da5273e9a252f162f5241c98bf137846bb55e858" => :sierra
    sha256 "57b844472dbeae8b7c6853197e6a886e4ebd6bdb3449854dc292e348f2cbfeb1" => :el_capitan
    sha256 "788d21907e3f7f3c82b2aa4db74d6a794e878d7f37a589d95c135a643a2b59fa" => :yosemite
  end

  depends_on "go" => :build

  conflicts_with "kubernetes-cli", :because => "Differing versions of the same formula"

  def install
    # Patch needed to avoid vendor dependency on github.com/jteeuwen/go-bindata
    # Build will otherwise fail with missing dep
    # Raised in https://github.com/kubernetes/kubernetes/issues/34067
    # Fix merged into 1.5 branch; patch may be removed when that goes GA
    rm "./test/e2e/framework/gobindata_util.go"

    # Race condition still exists in OSX Yosemite
    # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
    ENV.deparallelize { system "make", "generated_files" }
    system "make", "kubectl", "GOFLAGS=-v"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    bin.install "_output/local/bin/darwin/#{arch}/kubectl"

    output = Utils.popen_read("#{bin}/kubectl completion bash")
    (bash_completion/"kubectl").write output
  end

  test do
    output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", output
  end
end
