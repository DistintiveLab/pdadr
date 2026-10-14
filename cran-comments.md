## Test environments

-   local: Ubuntu 24.04, R 4.5.3 (release), pt_BR.UTF-8 locale
-   GitHub Actions: ubuntu-latest (release, oldrel-1, devel),
    windows-latest (release), macos-latest (release)
    https://github.com/DistintiveLab/pdadr/actions

## R CMD check results

R CMD check --as-cran was run locally on the built tarball with R 4.5.3
(release); R-devel is covered by the GitHub Actions matrix above.

0 errors, 0 warnings, 1 note:

-   New submission (first submission of this package).

## Additional notes

-   The package ships only survey metadata (the variable/code dictionary,
    ~150 KB). The microdata themselves (~6 MB per database) are downloaded
    on demand from the official IPE/DF URLs and cached locally via
    tools::R_user_dir(). No examples, tests or vignettes access the
    network: examples that require the microdata are marked \dontrun and
    the vignette chunks are not evaluated.

-   Package documentation, the vignette and user-facing messages are in
    Brazilian Portuguese (Language: pt-BR declared in DESCRIPTION), as the
    package targets users of a Brazilian official survey; the DESCRIPTION
    metadata is in English.
