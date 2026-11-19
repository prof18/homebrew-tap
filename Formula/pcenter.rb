# pcenter — the Microsoft Store (Partner Center) from the command line.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "unknown" unless it reproduced that stamp exactly.
#
# macOS and Linux only — Homebrew has no Windows channel, so Windows consumers
# take the release's .zip by pinned URL and verify it against checksums.txt.
class Pcenter < Formula
  desc "Command-line tool for the Microsoft Store (Partner Center)"
  homepage "https://github.com/prof18/pcenter-cli"
  version "0.0.5"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/pcenter-cli/releases/download/v0.0.5/pcenter_v0.0.5_darwin_arm64.tar.gz"
      sha256 "3aee63f56f47138caa88f62b1c2fb3ed3872c283fd9c47ecd1186a3e4f200c13"
    else
      url "https://github.com/prof18/pcenter-cli/releases/download/v0.0.5/pcenter_v0.0.5_darwin_amd64.tar.gz"
      sha256 "9f37ef6a9dd1c15a06459e0d3cad7f9dbc59eba1a556408b60a1db172924145e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/pcenter-cli/releases/download/v0.0.5/pcenter_v0.0.5_linux_arm64.tar.gz"
      sha256 "f084d86ab9af751e1ee70c123a15c3e97ff22a76bd6abba928c8d40f0aae148c"
    else
      url "https://github.com/prof18/pcenter-cli/releases/download/v0.0.5/pcenter_v0.0.5_linux_amd64.tar.gz"
      sha256 "a68561a3c05452f2d6291d532084cfaae09289ef535156510a4931d2bc695b5a"
    end
  end

  def install
    bin.install "pcenter"
  end

  def caveats
    <<~EOS
      Store your Partner Center credentials, then prove the whole setup works:

        pcenter auth login
        pcenter auth doctor

      In CI, set MS_STORE_TENANT_ID / MS_STORE_CLIENT_ID / MS_STORE_CLIENT_SECRET
      / MS_STORE_APP_ID from your secrets instead. They take precedence over the
      credentials file and leave nothing on the runner.
    EOS
  end

  test do
    # Tags carry the "v"; Homebrew's `version` does not. Output is JSON here
    # because stdout is a pipe, which is the TTY-aware default every CI job and
    # agent gets — so this asserts that behaviour as well as the stamp.
    assert_match "\"version\":\"v#{version}\"", shell_output("#{bin}/pcenter version")

    # Credentials the binary will never get to use: both commands below are
    # rejected before the first request is built. They exist so that credential
    # resolution, which runs first, is not what fails. The endpoints point at a
    # closed port, so anything that did try to reach the network would fail
    # here rather than talk to the real Store.
    ENV["MS_STORE_APP_ID"] = "000000000000"
    ENV["MS_STORE_CLIENT_ID"] = "ci"
    ENV["MS_STORE_CLIENT_SECRET"] = "ci"
    ENV["MS_STORE_TENANT_ID"] = "ci"
    ENV["PCENTER_API_BASE"] = "http://127.0.0.1:9"
    ENV["PCENTER_LOGIN_BASE"] = "http://127.0.0.1:9"

    # `listing push` refuses to guess: exactly one mode flag, or it is a usage
    # error. Exit 2 is the "fix your invocation" code.
    mode = shell_output("#{bin}/pcenter listing push --dir #{testpath} --dry-run --yes 2>&1", 2)
    assert_match "exactly one of", mode

    # The identity guard: a directory with no store.json is not a metadata
    # directory for any app, and that is decided locally, before any request.
    guard = shell_output("#{bin}/pcenter listing push --dir #{testpath} --dry-run 2>&1", 1)
    assert_match "store.json", guard
  end
end
