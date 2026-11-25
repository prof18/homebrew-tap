# Regesto — a knowledge base your agents consult, not a memory they carry.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "unknown" unless it reproduced that stamp exactly.
class Regesto < Formula
  desc "Knowledge base your coding agents consult before they act"
  homepage "https://github.com/prof18/regesto"
  version "0.8.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.8.2/regesto_v0.8.2_darwin_arm64.tar.gz"
      sha256 "e61b2fee9c547386235d81361c2de2416209b2d1f6c048db520947b0e081676b"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.8.2/regesto_v0.8.2_darwin_amd64.tar.gz"
      sha256 "0b11377113f263a118178912313993072c03d77e9c867f06a351978eca1fce69"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.8.2/regesto_v0.8.2_linux_arm64.tar.gz"
      sha256 "397ce71a3d182496fc30be82687c4ec24e825e92cde784f9e9429423f1f82d98"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.8.2/regesto_v0.8.2_linux_amd64.tar.gz"
      sha256 "1e334861c52e55b5ecb56e06e0f2c193266b38bb19554fa95f8f89edea2cbc50"
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
