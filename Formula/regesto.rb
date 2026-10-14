# Regesto — a knowledge base your agents consult, not a memory they carry.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "unknown" unless it reproduced that stamp exactly.
class Regesto < Formula
  desc "Knowledge base your coding agents consult before they act"
  homepage "https://github.com/prof18/regesto"
  version "0.7.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.7.1/regesto_v0.7.1_darwin_arm64.tar.gz"
      sha256 "05f2d8ab3af23ee2b39f47ee7d2bcbd389c5c5082c6d768e4d21d7be779ffa56"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.7.1/regesto_v0.7.1_darwin_amd64.tar.gz"
      sha256 "b641b93dc2dd1dda564852131fc187b14b6ff359e425ad4c6969941efe19c6a5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.7.1/regesto_v0.7.1_linux_arm64.tar.gz"
      sha256 "d396ae7d92cda0c531b0252d24efade31e2b42896982aba472e650d6e1477e6a"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.7.1/regesto_v0.7.1_linux_amd64.tar.gz"
      sha256 "41579c117e1e6dfdf6c789b05f9b4890a9e2dbb58a48feacbadbe4e90a827dbf"
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
