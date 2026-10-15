# Regesto — a knowledge base your agents consult, not a memory they carry.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "unknown" unless it reproduced that stamp exactly.
class Regesto < Formula
  desc "Knowledge base your coding agents consult before they act"
  homepage "https://github.com/prof18/regesto"
  version "0.8.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.8.0/regesto_v0.8.0_darwin_arm64.tar.gz"
      sha256 "2956a196fcee596de89d8432dbff195a20abfe4a8f917c5b779646c6b43619c0"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.8.0/regesto_v0.8.0_darwin_amd64.tar.gz"
      sha256 "3ace4531027b0350c3510f7d3e3b286ab7fff8f43328574ec01de42fbf81740a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.8.0/regesto_v0.8.0_linux_arm64.tar.gz"
      sha256 "072ada68bfdc5e4f158db7a400c20e63caaae731ae117ab234f6cb5ba6fc000d"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.8.0/regesto_v0.8.0_linux_amd64.tar.gz"
      sha256 "62d03ac646953de2245efee6fae26b91cab5b450112c95c2a3e0e577dc1a7993"
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
