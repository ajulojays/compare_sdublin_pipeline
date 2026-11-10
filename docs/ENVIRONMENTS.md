# Scientific environment requirements

`environments/` contains the original Conda YAML exports used in the S. Dublin study. Package and build pins are retained, while source-machine `prefix:` declarations have been removed; `prokka_env` and `roary_env` now have portable environment names.

To attempt a reconstruction on Linux:

```bash
conda env create -f environments/bioinfo.yaml
conda env create -f environments/unicycler.yaml
conda env create -f environments/seqsero2.yaml
# Continue for the analysis-specific environments needed in docs/SCRIPT_INDEX.md
```

The upstream YAML exports include historical exact build strings, some older channels, and platform-specific packages. Their existence is provenance, **not a guarantee that current Conda repositories can solve them unchanged**. If a YAML is unsatisfiable, preserve it and record a separate resolved environment file and full tool versions instead of silently relaxing analysis versions.

For downstream R, verify installed packages with `Rscript scripts/check_r_packages.R`. This checks `tidyverse`, `tidylog`, `readxl`, `ggpubr`, `gt`, `vegan`, `pairwiseAdonis`, `pagoo`, `ape`, `chorddiag`, and `maps`. It does not install anything or substitute packages.
