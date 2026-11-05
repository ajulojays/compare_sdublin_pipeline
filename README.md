# Genomic evolution of *Salmonella* Dublin in U.S. cattle and humans

Reproducible analysis code and deposited study inputs for the published comparative-genomics investigation.

**Publication:** [Kenney et al., *Applied and Environmental Microbiology*](https://doi.org/10.1128/aem.00689-25)  
**Original study repository:** [sophiakenney/compare_sdublin](https://github.com/sophiakenney/compare_sdublin)  
**Supplementary data:** [Zenodo record 15652582](https://zenodo.org/records/15652582)  
**Workflow script-by-script guide:** [docs/SCRIPT_INDEX.md](docs/SCRIPT_INDEX.md)

## Layout

```text
workflow/
  B1_Reads_QC/                  SRA download, trimming, Kraken2, read extraction
  B2_Assembly_Typing/           Unicycler, CheckM/QUAST, SeqSero2, SISTR, MLST
  B3_Phylogenomics/             ModelTest-NG, IQ-TREE
  B4_Pangenome/                 Prokka, Roary and annotation summaries
  B5_AMR_Virulence_Plasmids/    AMRFinderPlus and ABRicate
  B6_Comparative_Analyses/      Eight R scripts for figures and tables
data/                            Preserved study tables, metadata, tree and matrices
environments/                    Original Conda environment specifications
config/                          Local path configuration template
scripts/                         Execution, dataset checks and archive tools
docs/                            Script index, provenance and release procedure
```

Original scientific script **filenames are retained**. Data are reorganized without changing their recorded values. All analyses are run from the repository root unless stated otherwise.

## Reproduce the analyses

```bash
git clone https://github.com/ajulojays/compare_sdublin_pipeline.git
cd compare_sdublin_pipeline
# On the restructuring branch until a publication release is approved:
git switch publication-restructure
cp config/paths.example.env config/paths.env
bash scripts/check_inputs.sh
python3 scripts/validate_structure.py
# Optional full-data integrity verification (reads all deposited files):
python3 scripts/verify_data_provenance.py
```

The deposited matrices and metadata support the downstream R analyses. Install the R packages identified at the top of each R script, then run an analysis (from the repository root):

```bash
Rscript scripts/check_r_packages.R
bash scripts/run_r_analysis.sh plotmeta
bash scripts/run_r_analysis.sh amrfinder
```

The full pangenome `gene_presence_absence.csv` and `.Rtab` required by `pangenome.R`, and the `combinedkreports.xlsx` file used by the study, are available separately through the linked Zenodo record. Place them under the directories specified in [docs/DATA_REQUIREMENTS.md](docs/DATA_REQUIREMENTS.md).

For read-level reconstruction, supply an accession list, configure the Kraken2 database and program dependencies, and execute the commands in [docs/EXECUTION.md](docs/EXECUTION.md). A full-read reconstruction requires substantial HPC resources; the deposited downstream inputs can be inspected independently.

## Script guide

| Stage | Files | Purpose |
| --- | --- | --- |
| B1 | [`workflow/B1_Reads_QC/`](workflow/B1_Reads_QC) | Obtain and quality-filter reads; Kraken2 classification and Enterobacteriaceae extraction |
| B2 | [`workflow/B2_Assembly_Typing/`](workflow/B2_Assembly_Typing) | Assemble, evaluate, serotype and sequence-type genomes |
| B3 | [`workflow/B3_Phylogenomics/`](workflow/B3_Phylogenomics) | Fit nucleotide substitution model and infer core-gene tree |
| B4 | [`workflow/B4_Pangenome/`](workflow/B4_Pangenome) | Annotate assemblies and generate Roary pangenome/core alignment |
| B5 | [`workflow/B5_AMR_Virulence_Plasmids/`](workflow/B5_AMR_Virulence_Plasmids) | Detect AMR elements and plasmid replicons |
| B6 | [`workflow/B6_Comparative_Analyses/`](workflow/B6_Comparative_Analyses) | Publication figures, genomic comparisons and tables |

**Every individual script and its expected handoff** is identified in [docs/SCRIPT_INDEX.md](docs/SCRIPT_INDEX.md). The repository intentionally distinguishes upstream processed tables from outputs that require external reads or additional deposited files.

## Citation, attribution and archive

Cite the [original study](https://doi.org/10.1128/aem.00689-25) and the upstream source repository when reusing the analytical methods. This reorganized copy retains upstream attribution and must not be represented as a new independent study. [Provenance](docs/PROVENANCE.md) records what changed.

[Release and preservation instructions](docs/ARCHIVE_RELEASE.md) explain how to freeze a commit, create a checksum-verified source archive, and deposit the approved publication version. **This branch is a preparation version, not yet a validated immutable publication release.**
