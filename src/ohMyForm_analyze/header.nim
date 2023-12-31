import pkg/gm_api/metadata

const userscriptHeader* = genMetadataBlock(
  name = "OhMyForm Analyze",
  author = "Thiago Navarro",
  match = [
    "*://forms.*.*/*",
    "*://form.*.*/*"
  ],
  version = "1.2.2",
  runAt = GmRunAt.docStart,
  downloadUrl = "https://git.ozzuu.com/thisago/ohMyForm_analyze/raw/branch/master/build/ohMyForm_analyze.user.js",
  description = "A userscript that creates a easy to use interface to analyze the submitted forms",
  homepageUrl = "https://git.ozzuu.com/thisago/ohMyForm_analyze",
)
