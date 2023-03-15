import pkg/gm_api/metadata

const userscriptHeader* = genMetadataBlock(
  name = "OhMyForm Analyze",
  author = "Thiago Navarro",
  match = [
    "*://forms.*.*/*",
    "*://form.*.*/*"
  ],
  # resource = [
  #   ("css", "https://cdnjs.cloudflare.com/ajax/libs/balloon-css/1.2.0/balloon.min.css")
  # ],
  version = "0.1.0",
  runAt = GmRunAt.docStart,
  downloadUrl = "https://git.ozzuu.com/thisago/ohMyForm_analyze/raw/branch/master/build/ohMyForm_analyze.js",
  description = "A userscript that creates a easy to use interface to analyze the submitted forms",
  homepageUrl = "https://git.ozzuu.com/thisago/ohMyForm_analyze",
)
