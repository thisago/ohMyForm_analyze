import pkg/gm_api/metadata

const userscriptHeader* = genMetadataBlock(
  name = "OhMyForm Analyze",
  author = "Thiago Navarro",
  match = [
    "*://forms.*.com/admin/forms/*/submissions"
  ],
  version = "0.1.0",
  runAt = GmRunAt.docStart,
  downloadUrl = "https://git.ozzuu.com/thisago/ohMyForm_analyze/raw/branch/master/build/ohMyForm_analyze.js",
  description = "A userscript that creates a easy to use interface to analyze the submitted forms",
  homepageUrl = "https://git.ozzuu.com/thisago/ohMyForm_analyze",
)
