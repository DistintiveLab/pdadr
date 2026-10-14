## Resubmission

This is a resubmission of version 0.1.0, which was not accepted. In reply
to the feedback about a possibly invalid file ROADMAP.md:

-   ROADMAP.md is an internal development roadmap. It is excluded from
    the built tarball by `.Rbuildignore` (entry `^ROADMAP\.md$`, present
    since the 0.1.0 submission). We verified the contents of the
    previously submitted tarball pdadr_0.1.0.tar.gz: its top level
    contains only DESCRIPTION, NAMESPACE, NEWS.md and README.md, and no
    ROADMAP.md (or other development files) is included anywhere in the
    archive. The file also cannot cause "additional issues" on the CRAN
    results page, as the package has not been published yet.
-   As an extra precaution, ROADMAP.md was also added to `.gitignore`
    and the package version was bumped to 0.1.1.

Additionally, following the CRAN policy for submissions: downloads of
more than a few MB now use a sufficiently large timeout. `get_pdad()`
raises the download timeout to at least 600 seconds (restored on exit)
before calling `download.file()`, as the microdata ZIP files are ~6 MB.

## Test environments

-   local: Ubuntu 24.04, R 4.5.3 (release), pt_BR.UTF-8 locale
-   GitHub Actions: ubuntu-latest (release, oldrel-1, devel),
    windows-latest (release), macos-latest (release)
    https://github.com/DistintiveLab/pdadr/actions

## R CMD check results

R CMD check --as-cran (with _R_CHECK_DONTTEST_EXAMPLES_=true) was run
locally on the built tarball with R 4.5.3 (release); R-devel is covered
by the GitHub Actions matrix above.

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
