# Regesto — a knowledge base your agents consult, not a memory they carry.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "unknown" unless it reproduced that stamp exactly.
class Regesto < Formula
  desc "Knowledge base your coding agents consult before they act"
  homepage "https://github.com/prof18/regesto"
  version "0.8.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.8.3/regesto_v0.8.3_darwin_arm64.tar.gz"
      sha256 "e725e30cbf0c5d8fa286702658f577bf03506411390a90a8614b4cb3e16a79d5"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.8.3/regesto_v0.8.3_darwin_amd64.tar.gz"
      sha256 "d3cb3f974864a7b93eb6e0173e5c922d60d277306ef72c1f6627ab9619875980"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.8.3/regesto_v0.8.3_linux_arm64.tar.gz"
      sha256 "0ad3c3faf76d02c8e7e4e45c35d8091d69c51db799697b71507e13a6a18a8505"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.8.3/regesto_v0.8.3_linux_amd64.tar.gz"
      sha256 "7435cfed6d1f02bec5ed10fc4a216362eae2cda17e5407ba4f6a6f98c9305366"
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
