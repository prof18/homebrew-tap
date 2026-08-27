# Regesto — a knowledge base your agents consult, not a memory they carry.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "unknown" unless it reproduced that stamp exactly.
class Regesto < Formula
  desc "Knowledge base your coding agents consult before they act"
  homepage "https://github.com/prof18/regesto"
  version "0.3.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.3.1/regesto_v0.3.1_darwin_arm64.tar.gz"
      sha256 "b0ce0bf7b72defb102259dd0cc3dfe20ea3c39b6a4b676178a36911f5dfddd5d"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.3.1/regesto_v0.3.1_darwin_amd64.tar.gz"
      sha256 "2580f52e5b7ef5aefc447289de7ffdc107dbe8eb43ebd0857060a4c985118322"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.3.1/regesto_v0.3.1_linux_arm64.tar.gz"
      sha256 "69637a6e122fd0584fc6b3a5bad329ea1d9ee63620bd44dba2b0c60c96a639ce"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.3.1/regesto_v0.3.1_linux_amd64.tar.gz"
      sha256 "48ec2cfd6af64ca35bad3dd11868678d754898699c2bd0e9e5bb1cf056dcb3ef"
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
