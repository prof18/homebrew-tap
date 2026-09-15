# Regesto — a knowledge base your agents consult, not a memory they carry.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "unknown" unless it reproduced that stamp exactly.
class Regesto < Formula
  desc "Knowledge base your coding agents consult before they act"
  homepage "https://github.com/prof18/regesto"
  version "0.5.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.5.0/regesto_v0.5.0_darwin_arm64.tar.gz"
      sha256 "cc41426578d0d848e6c39a5cb23b059ab06be8d2a90ee6c22c511d85c94d45d4"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.5.0/regesto_v0.5.0_darwin_amd64.tar.gz"
      sha256 "c4f3f13cf8401477c56b6c9a36c7dca90b96e4e7a06eb7de6162c50d902561a2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.5.0/regesto_v0.5.0_linux_arm64.tar.gz"
      sha256 "572aead10d62f9ba8b2be6f5a8b8d03615d567e07d5c39ffd59a07c2e28fcaf1"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.5.0/regesto_v0.5.0_linux_amd64.tar.gz"
      sha256 "f0df8cfc8b9b58323fbc109ac5a1fb9784b69ff3f2de4463de8179f2cd1ff2a3"
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
