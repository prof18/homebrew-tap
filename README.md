# prof18/homebrew-tap

Homebrew formulae for my tools.

```bash
brew install prof18/tap/regesto
brew install prof18/tap/pcenter
```

## regesto

A knowledge base your coding agents consult before they act — plain markdown, one claim per
file, nothing ever deleted. [github.com/prof18/regesto](https://github.com/prof18/regesto)

The formula ships the release binaries rather than building from source: regesto stamps its
version at link time, and a build from an extracted source archive has no git metadata to
stamp, so it would report `unknown`.

## pcenter

The Microsoft Store (Partner Center) from the command line — publish an MSIX, manage your
listing and screenshots from files in your repo, read reviews, and rescue a submission or
rollout that has got stuck. [github.com/prof18/pcenter-cli](https://github.com/prof18/pcenter-cli)

Release binaries here too, and for the same reason.

macOS and Linux only: Homebrew has no Windows channel. Windows CI takes the release's
`.zip` by pinned URL and verifies it against `checksums.txt` — see
[the CI guide](https://github.com/prof18/pcenter-cli/blob/main/docs/CI.md).

## How this stays current

One workflow per tool — [`update-regesto.yml`](.github/workflows/update-regesto.yml) and
[`update-pcenter.yml`](.github/workflows/update-pcenter.yml) — each checking weekly for a new
release and rewriting its formula from that release's own `checksums.txt`. They write only to
this repository, using the token GitHub issues for the run — there is no stored credential
anywhere, in either direction.

Nothing is pushed until the rewritten formula has been parsed as Ruby, every archive URL has
answered 200, and `brew install` plus `brew test` have both succeeded on the runner. A tap
that lags a release is a nuisance; a tap that serves a formula which does not install is a
real problem.

**After cutting a release, run the workflow by hand** from the Actions tab rather than
waiting for Monday. Two things make that the habit worth having: the lag is up to a week,
and GitHub disables scheduled workflows in repositories with no activity for 60 days — which
this one will reach, since the updater's own commits do not count as activity. The manual
run always works regardless.
