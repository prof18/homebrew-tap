# claudup — one Claude Code Remote Control bridge per project, kept running by launchd.
#
# Binaries come from the release archives rather than being built here: the
# version is stamped at link time, and a formula that compiled from source
# would report "dev" unless it reproduced that stamp exactly.
#
# macOS only: claudup drives launchd.
class Claudup < Formula
  desc "Keep one Claude Code Remote Control bridge running per project"
  homepage "https://github.com/prof18/claudup"
  version "0.1.0"
  license "MIT"

  depends_on :macos

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prof18/claudup/releases/download/v0.1.0/claudup_v0.1.0_darwin_arm64.tar.gz"
      sha256 "95de069204bae6b6a13f6323b3185ad3e2208ce655bb3bf60c0e03d48881e703"
    else
      url "https://github.com/prof18/claudup/releases/download/v0.1.0/claudup_v0.1.0_darwin_amd64.tar.gz"
      sha256 "9052a19749b2544fdbb829898920c9bd9a79f80dde6cb822e25d38ae0a0f5e7e"
    end
  end

  def install
    bin.install "claudup"
    pkgshare.install "hermes-plugin"
  end

  def caveats
    <<~EOS
      Write a starter config, edit it, then start the always-on bridges:

        claudup init
        claudup up

      LaunchAgents run #{HOMEBREW_PREFIX}/bin/claudup, so they keep working across
      upgrades. Running bridges keep the old binary until `claudup restart <name>`.

      Optional /rc Telegram command for Hermes:

        ln -s #{opt_pkgshare}/hermes-plugin/claudup-rc ~/.hermes/plugins/claudup-rc
    EOS
  end

  test do
    assert_equal "claudup v#{version}", shell_output("#{bin}/claudup version").strip

    ENV["CLAUDUP_CONFIG"] = (testpath/"claudup.toml").to_s
    assert_match "wrote", shell_output("#{bin}/claudup init")
    assert_match "alert_command = []", (testpath/"claudup.toml").read
  end
end
