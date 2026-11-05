# Input data and external dependencies

The original deposited study tables are retained in `data/`, including:

- `data/meta/finalset_meta.tsv` — final study metadata
- `data/phylo/distances.tab` and `data/phylo/iq.treefile` — SNP distance matrix and phylogeny
- `data/amrfinder/amrfinderentero.txt` — AMRFinderPlus calls
- `data/abricate/` — archived plasmid and virulence summaries
- `data/assembqc/` and `data/readqc/` — QC and typing summaries
- `data/pangenome/raw/` — deposited source-specific presence/absence tables
- `data/pangenome/subsets/` — 100 resampling tables for each source class
- `data/functionalanno/` — gene lists and COG reference files

`workflow/B6_Comparative_Analyses/pangenome.R` additionally reads the **combined** Roary `gene_presence_absence.csv` and `gene_presence_absence.Rtab` from `data/pangenome/raw/`. Those combined files are not included in this Git repository. The study README points to [Zenodo record 15652582](https://zenodo.org/records/15652582) for full presence/absence matrices. Verify the deposited filenames before copying them into that directory; do not substitute the three source-specific CSVs.

The original study also links `combinedkreports.xlsx` from [the same record](https://zenodo.org/records/15652582); this file is not in the repository.

The read-level Bash workflow requires the original SRA accession list (`work/0.0-raw/acclist.txt` unless configured otherwise), a suitable Kraken2 Standard database, adapter FASTAs, KrakenTools, CheckM database, and required scientific executables. `data/meta/finalset_meta.tsv` is a study metadata table; it must **not** be blindly treated as the SRA download manifest.

The recorded source workflows rely on external inputs, some of which are large or must be retrieved from the original public study deposits. `scripts/check_inputs.sh` reports these prerequisites before computation.
