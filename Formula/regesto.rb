# Regesto — a knowledge base your agents consult, not a memory they carry.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "unknown" unless it reproduced that stamp exactly.
class Regesto < Formula
  desc "Knowledge base your coding agents consult before they act"
  homepage "https://github.com/prof18/regesto"
  version "0.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.6.0/regesto_v0.6.0_darwin_arm64.tar.gz"
      sha256 "35b05a0c11558b364d893170e998db588e12a0c5f0ff47ffb5d75e4f3d57579b"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.6.0/regesto_v0.6.0_darwin_amd64.tar.gz"
      sha256 "ca0b3def272392415b5c3ffbb908d5e5fad6a85f397ebeb6ef45a3f3b25f5f5e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.6.0/regesto_v0.6.0_linux_arm64.tar.gz"
      sha256 "191a6c1d5e7cb361d9cab4648843142b9d90e5df6d857e3e25e6b3bd1b134a46"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.6.0/regesto_v0.6.0_linux_amd64.tar.gz"
      sha256 "2014bf0820bb78eb3f5f23e054be571fcf1ed5f3f96a2bc381b9f67daf1aac81"
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
