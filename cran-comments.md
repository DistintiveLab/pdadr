## Resubmission

This is a resubmission. Versions 0.1.0 and 0.1.1 were not accepted; on
both the CRAN team flagged a possibly invalid file ROADMAP.md (again on
0.1.1).

Root cause identified and fixed in this version (0.1.2): README.md, which
is shipped in the tarball, contained a relative markdown link to
ROADMAP.md, an internal development roadmap that is excluded from the
tarball via `.Rbuildignore`. The link therefore pointed to a file not
included in the package. The link has been removed from README.md, and
the reference to the roadmap file has also been removed from NEWS.md.

As before, we verified the contents of the built tarball: its top level
contains only DESCRIPTION, NAMESPACE, NEWS.md and README.md; no
development files are included anywhere in the archive. ROADMAP.md
remains excluded via `.Rbuildignore` and, additionally, is listed in
`.gitignore`. The package version has been bumped at each submission
(0.1.1, then 0.1.2) following the CRAN submission policy.

The fix from 0.1.1 is retained: `get_pdad()` raises the download timeout
to at least 600 seconds (restored on exit) before calling
`download.file()`, as the microdata ZIP files are ~6 MB.

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
