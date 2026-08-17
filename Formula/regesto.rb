# Regesto — a knowledge base your agents consult, not a memory they carry.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "unknown" unless it reproduced that stamp exactly.
class Regesto < Formula
  desc "Knowledge base your coding agents consult before they act"
  homepage "https://github.com/prof18/regesto"
  version "0.3.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.3.0/regesto_v0.3.0_darwin_arm64.tar.gz"
      sha256 "c3cdf3a15b3aac13cf36841c30bb9048bcc7bfae49fb8fd4c88e64c761c8e555"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.3.0/regesto_v0.3.0_darwin_amd64.tar.gz"
      sha256 "d281ab8a74e558dbbad5191a98d12662aa342b828e2a54198f2ba8509e716507"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.3.0/regesto_v0.3.0_linux_arm64.tar.gz"
      sha256 "e9acd49393e3d4ab0851efe867c3c06c812f8f2069978170b19830b8cbe21644"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.3.0/regesto_v0.3.0_linux_amd64.tar.gz"
      sha256 "251e0cf280e1c1ff4b8fb79938322d2af05f59a29885c6550df5ceec07a9be2d"
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
