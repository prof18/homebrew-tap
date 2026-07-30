# Regesto — a knowledge base your agents consult, not a memory they carry.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "unknown" unless it reproduced that stamp exactly.
class Regesto < Formula
  desc "Knowledge base your coding agents consult before they act"
  homepage "https://github.com/prof18/regesto"
  version "0.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.1.1/regesto_v0.1.1_darwin_arm64.tar.gz"
      sha256 "d9a88596bcb4e96af45ac311ac40639a781cfcb5139dd96ae5785426bbcee102"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.1.1/regesto_v0.1.1_darwin_amd64.tar.gz"
      sha256 "b12c4b053b239bc8652eb54ceaade4b7e8e06d813ad7df275708a16e2f94444e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.1.1/regesto_v0.1.1_linux_arm64.tar.gz"
      sha256 "b74ca2ccceebeb8211de597f4b9dd068a2eb6b0dd6c10b02138d30a888e8f7f1"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.1.1/regesto_v0.1.1_linux_amd64.tar.gz"
      sha256 "630d9bed277c3fbe4346eb5ab11d95e74933d74dbf9815c5484a8773a62281de"
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
