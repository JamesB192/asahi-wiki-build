# Unofficial Website Builds for Asahi Linux Wiki

This repository contains files that can be used to build a website for the
[Asahi Linux Wiki]'s content with [Hugo], and a [GitHub Actions workflow] that
periodically uses these files to build such a website.

[Asahi Linux Wiki]: https://github.com/AsahiLinux/docs/wiki
[Hugo]: https://gohugo.io/
[GitHub Actions workflow]: .github/workflows/hugo.yaml

## Benefits of Rebuilding the Wiki as a Website

A website built with Hugo is able to support easier-to-use search functionality
than GitHub wiki, where the official Asahi Linux Wiki is hosted, provided that
a Hugo theme with website search feature is used.  On such a website, users can
click on the search icon or search box on the webpage, type in their query, and
instantly get the results -- a typical flow of searching in an information
system.  On GitHub wiki, users still click on the search box and type in their
query, but they will first get the results from a code search rather than a
wiki search.  They must manually set the search scope to wikis to get their
desired results, which requires more interactions than the typical flow.

## Technical Difficulties Resolved by This Repository

The official Asahi Linux Wiki is hosted in a GitHub repository's wiki, which is
itself a Git repository with many Markdown files containing the wiki's content.
Because Hugo is capable of creating webpages from Markdown files as a static
site generator, using Hugo to build a website from the wiki's Markdown files
should be trivial.

However, Asahi Linux Wiki's Markdown files commonly use MediaWiki-style syntax
for internal links, which is not part of common Markdown syntax.  For instance,
these files may use `[[Home]]` as an equivalent for `[Home](Home)`, which is
supported by GitHub wiki but unrecognized by common Markdown parsers.  For this
reason, Hugo could not generate internal links that were created using this
syntax, which would severely degrade the generated website's browsing
experience.

The following files in this repository help resolve this issue:

- `download-files.sh`: Uses a `sed` command to convert any MediaWiki-style
  internal links in the Markdown files to standard Markdown-style links, e.g.
  `[[Home]]` to `[Home]({{< internal-link "Home" >}})`.

- `layouts/shortcodes/internal-link.html`: A [Hugo shortcode] that converts a
  page title to the page's URL on this website.  This is why
  `download-files.sh` uses `{{< internal-link "Home" >}}` as the link
  destination in its conversion.

With what these files do, Hugo is able to correctly parse the internal links in
the Markdown files and compute the links' destination URLs, hence the internal
links work properly on the generated website.

[Hugo shortcode]: https://gohugo.io/content-management/shortcodes/

## Website Build Instructions

1. [Install Hugo].

2. Change the working directory to this repository's root directory.

3. Run the `download-files.sh` script to download the sources files required
   for building the website:

   ```console
   $ ./download-files.sh
   ```

4. To start a local development server for previewing, run command `hugo
   server`.  By default, the website is accessible at <http://localhost:1313>.

5. To write the website's files to disk, run the following command:

   ```console
   $ hugo --baseURL <URL>
   ```

   The `--baseURL <URL>` option is necessary because this website's Hugo
   configuration does not set the `baseURL` option (which is intentional since
   this website may be hosted anywhere).  Please replace `<URL>` with the base
   URL where this website will be hosted.

   By default, the files will be available in the `public` directory under this
   repository's root directory.

6. To clean up the downloaded files before completely rebuilding this website,
   run the following command:

   ```console
   $ git clean -dffX
   ```

[Install Hugo]: https://gohugo.io/installation/
