# Regesto — a knowledge base your agents consult, not a memory they carry.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "unknown" unless it reproduced that stamp exactly.
class Regesto < Formula
  desc "Knowledge base your coding agents consult before they act"
  homepage "https://github.com/prof18/regesto"
  version "0.4.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.4.2/regesto_v0.4.2_darwin_arm64.tar.gz"
      sha256 "e101d4f11cabe000001ec846bdcd7a04d756a2b7dd98e2c6404923c60f6b25e7"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.4.2/regesto_v0.4.2_darwin_amd64.tar.gz"
      sha256 "e2f239efe72a457bb9d80bca28b7662f3e0fb2127135dae7dd297f3cced178b6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.4.2/regesto_v0.4.2_linux_arm64.tar.gz"
      sha256 "365bb13de4825316dc6d62338467a23ae7bf6d21a3c6952423fd3c6c34e4991e"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.4.2/regesto_v0.4.2_linux_amd64.tar.gz"
      sha256 "6830a1d33d87f439f908fd97e21f40d5fd467a6ab0b5f55015b97c2c8c833561"
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
