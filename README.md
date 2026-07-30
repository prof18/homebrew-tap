# prof18/homebrew-tap

Homebrew formulae for my tools.

```bash
brew install prof18/tap/regesto
```

## regesto

A knowledge base your coding agents consult before they act — plain markdown, one claim per
file, nothing ever deleted. [github.com/prof18/regesto](https://github.com/prof18/regesto)

The formula ships the release binaries rather than building from source: regesto stamps its
version at link time, and a build from an extracted source archive has no git metadata to
stamp, so it would report `unknown`.

## How this stays current

[`.github/workflows/update-regesto.yml`](.github/workflows/update-regesto.yml) checks for a
new release every six hours and rewrites the formula from that release's own
`checksums.txt`. It writes only to this repository, using the token GitHub issues for the
run — there is no stored credential anywhere, in either direction.

Nothing is pushed until the rewritten formula has been parsed as Ruby, every archive URL has
answered 200, and `brew install` plus `brew test` have both succeeded on the runner. A tap
that lags a release is a nuisance; a tap that serves a formula which does not install is a
real problem.

To pick up a release immediately, run the workflow by hand from the Actions tab.
