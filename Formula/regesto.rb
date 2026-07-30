# Regesto — a knowledge base your agents consult, not a memory they carry.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "unknown" unless it reproduced that stamp exactly.
class Regesto < Formula
  desc "Knowledge base your coding agents consult before they act"
  homepage "https://github.com/prof18/regesto"
  version "0.2.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.2.0/regesto_v0.2.0_darwin_arm64.tar.gz"
      sha256 "e30e5992fcb1cd8b757c58260ad3bc7e4a1f03bef61644aee93aa17be995909b"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.2.0/regesto_v0.2.0_darwin_amd64.tar.gz"
      sha256 "2a58d6db37d3feff2f640070b06b545666e2f0ead830216084509e826ebb18c3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.2.0/regesto_v0.2.0_linux_arm64.tar.gz"
      sha256 "7aef4fed2deb598d78e8a8d7c54dcf6dce98b1335d7828882fe49ab486195547"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.2.0/regesto_v0.2.0_linux_amd64.tar.gz"
      sha256 "f0fa1a5e93f587f8acafe57163c969f8d5fa7d231e37ae208e40677e9b2867fc"
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
