# Regesto — a knowledge base your agents consult, not a memory they carry.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "unknown" unless it reproduced that stamp exactly.
class Regesto < Formula
  desc "Knowledge base your coding agents consult before they act"
  homepage "https://github.com/prof18/regesto"
  version "0.4.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.4.0/regesto_v0.4.0_darwin_arm64.tar.gz"
      sha256 "615c5eb9df17ba2aff0476a56c07be998d3ef0f91a07ef7222030abdc1d729ad"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.4.0/regesto_v0.4.0_darwin_amd64.tar.gz"
      sha256 "b891fa6f8c01843f3a9c67a9b33eb3cdd8e2a5bd5ff518ce2d1073aedab120fc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.4.0/regesto_v0.4.0_linux_arm64.tar.gz"
      sha256 "739fb36eceed48687d7ad2c1a63fb530287dc9aac0ef70fd381f0db6e39ab1ab"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.4.0/regesto_v0.4.0_linux_amd64.tar.gz"
      sha256 "8c50609191d3d95487f8e2dc894611c281bf9927024d9cef3bd79f7d19d817b4"
    end
  end

  def install
    bin.install "regesto"
  end

  def caveats
    <<~EOS
      Create a knowledge base, then wire it into your agents:

        regesto init --dir ~/regesto-kb --examples
        ~/regesto-kb/bin/regesto-install

      After upgrading regesto itself, refresh the files it wrote into your
      instance:

        regesto upgrade
    EOS
  end

  test do
    # Tags carry the "v"; Homebrew's `version` does not.
    assert_match "regesto v#{version}", shell_output("#{bin}/regesto version")

    # The binary's real job is scaffolding a working instance, so the test
    # does that rather than only checking that it runs.
    system bin/"regesto", "init", "--dir", testpath/"kb", "--machine", "test"
    assert_predicate testpath/"kb/bin/regesto-search", :exist?
    assert_predicate testpath/"kb/SCHEMA.md", :exist?
  end
end
