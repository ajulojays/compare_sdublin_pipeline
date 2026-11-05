# Verify, rather than silently install, the dependencies used by the original R scripts.
packages <- c("tidyverse", "tidylog", "readxl", "ggpubr", "gt",
              "vegan", "pairwiseAdonis", "pagoo", "ape", "chorddiag", "maps")
missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly=TRUE)]
if (length(missing)) {
  cat("[MISSING] R packages:", paste(missing, collapse=", "), "\n")
  quit(status=1)
}
cat("[PASS] Original downstream R package imports are available.\n")
