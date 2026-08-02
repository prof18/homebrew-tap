# Regesto — a knowledge base your agents consult, not a memory they carry.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "unknown" unless it reproduced that stamp exactly.
class Regesto < Formula
  desc "Knowledge base your coding agents consult before they act"
  homepage "https://github.com/prof18/regesto"
  version "0.2.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.2.2/regesto_v0.2.2_darwin_arm64.tar.gz"
      sha256 "eeba28f25dc4d794161edd1593643509095223917f27807ca3ebc7d0ca71df90"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.2.2/regesto_v0.2.2_darwin_amd64.tar.gz"
      sha256 "51a2d39494ff3e74e2b8345a110d88279d7413100393d5a3dbf4b4f87fd6127d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.2.2/regesto_v0.2.2_linux_arm64.tar.gz"
      sha256 "33b9fac1ede159fa71e2b15803d283aa5d742f7fc33a485112dc55a3f2f05bd8"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.2.2/regesto_v0.2.2_linux_amd64.tar.gz"
      sha256 "3bbeb7d8f486352c4e87845bba51f8fd681dff450c974bfea9af558416be7d02"
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
