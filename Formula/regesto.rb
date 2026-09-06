# Regesto — a knowledge base your agents consult, not a memory they carry.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "unknown" unless it reproduced that stamp exactly.
class Regesto < Formula
  desc "Knowledge base your coding agents consult before they act"
  homepage "https://github.com/prof18/regesto"
  version "0.4.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.4.1/regesto_v0.4.1_darwin_arm64.tar.gz"
      sha256 "b8aeb88642c51c9773c06f30853a38bb93300ca7b4bac95826a2f03b776865db"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.4.1/regesto_v0.4.1_darwin_amd64.tar.gz"
      sha256 "b2a62db379fec833bbc10b26ffc80baf241c4197e965931bc53327f856c3304e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.4.1/regesto_v0.4.1_linux_arm64.tar.gz"
      sha256 "a1f83718b7600c996d644f449876f617bb24180e36629289647e5c75e58b4d19"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.4.1/regesto_v0.4.1_linux_amd64.tar.gz"
      sha256 "56d8465593529186b110561de0c11b54e274ab5fa15b4226040e60e9f2ab706f"
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
