# Regesto — a knowledge base your agents consult, not a memory they carry.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "unknown" unless it reproduced that stamp exactly.
class Regesto < Formula
  desc "Knowledge base your coding agents consult before they act"
  homepage "https://github.com/prof18/regesto"
  version "0.2.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.2.3/regesto_v0.2.3_darwin_arm64.tar.gz"
      sha256 "0b4db0c0eb415193860f7527d1ab022aba0aef793f54e6289cec41a4669d3ef8"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.2.3/regesto_v0.2.3_darwin_amd64.tar.gz"
      sha256 "431d6528db2cbe46bcd929eb482bca77463740c6171c86dd3f1ae663e6e73958"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.2.3/regesto_v0.2.3_linux_arm64.tar.gz"
      sha256 "118455dcf43de2c7470464d71cae67d764285c735f8998b42f1490d51be5736b"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.2.3/regesto_v0.2.3_linux_amd64.tar.gz"
      sha256 "3ec9db63018e178d33bdb334f376c9bf25ba7c95bc3f27736df4c14f9379ac12"
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
