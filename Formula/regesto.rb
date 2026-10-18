# Regesto — a knowledge base your agents consult, not a memory they carry.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "unknown" unless it reproduced that stamp exactly.
class Regesto < Formula
  desc "Knowledge base your coding agents consult before they act"
  homepage "https://github.com/prof18/regesto"
  version "0.8.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.8.1/regesto_v0.8.1_darwin_arm64.tar.gz"
      sha256 "7607566448d0ac4e0a13778c3326a2e905e5ba7974a145a135abe3fd9346d59d"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.8.1/regesto_v0.8.1_darwin_amd64.tar.gz"
      sha256 "9cec7b89dbfb096be1cec310e4c4bb25d8f8da7fd955ccdc2e1382ff50fd546f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.8.1/regesto_v0.8.1_linux_arm64.tar.gz"
      sha256 "595ec0928924c43cad5d3e8271c486d81bc068c898a5bea4b5137c4ca8971598"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.8.1/regesto_v0.8.1_linux_amd64.tar.gz"
      sha256 "32793c3f20b892f996cc8b4633edde9f7e04970bd1838b6662277a3220d7a76d"
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
