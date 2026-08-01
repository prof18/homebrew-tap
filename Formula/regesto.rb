# Regesto — a knowledge base your agents consult, not a memory they carry.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "unknown" unless it reproduced that stamp exactly.
class Regesto < Formula
  desc "Knowledge base your coding agents consult before they act"
  homepage "https://github.com/prof18/regesto"
  version "0.2.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.2.1/regesto_v0.2.1_darwin_arm64.tar.gz"
      sha256 "7ea9dc0dd667ee6b2fce00b20f6a9cfecc18bdf47766ebc1efd18a63144fb5e3"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.2.1/regesto_v0.2.1_darwin_amd64.tar.gz"
      sha256 "5e421ebc8acc6f3e26ce4576d7f7f26240627befc4dfbf3af8644844cf2cf668"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/regesto/releases/download/v0.2.1/regesto_v0.2.1_linux_arm64.tar.gz"
      sha256 "8e9768fe6e358b4cb040164f265bcabda6cc76877aeacb64102ba2210c41d032"
    else
      url "https://github.com/prof18/regesto/releases/download/v0.2.1/regesto_v0.2.1_linux_amd64.tar.gz"
      sha256 "7a84a495e616d43d488408f3fd906085a9adebce2146dfd373c4a6dd2fc08e62"
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
