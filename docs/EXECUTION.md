# Execution guide

## Scope

This repository preserves the original S. Dublin computational methods and moves the command-line scripts into ordered stages. Run all commands at the repository root on Linux; upstream large-scale computations are intended for a workstation or HPC cluster.

## Configuration

```bash
cp config/paths.example.env config/paths.env
# Edit paths.env for database, adapter and software resources.
source config/paths.env
bash scripts/check_inputs.sh
python3 scripts/validate_structure.py
```

Conda specifications under `environments/` are derived from historical environment exports. They contain tightly pinned package/build combinations, and some may not solve on every present-day platform. Preserve the historic files for provenance; document a resolved environment before manuscript-scale reruns.

After installing the required environment, use `conda run -n <env> bash workflow/<stage>/<script>.sh` to run a stage; the scripts should not activate Conda themselves.

## Core process and stage handoffs

1. `B1_Reads_QC/accessionqc.sh`: `work/0.0-raw/acclist.txt` → paired FASTQ and raw QC
2. `B1_Reads_QC/trimqc.sh`: raw paired reads → `work/1.0-trimmed`
3. `B1_Reads_QC/classifyreads.sh`: trimmed paired reads → `work/2.0-kraken2`
4. `B1_Reads_QC/filterreads.sh`: Kraken2 report/output and trimmed reads → `work/2.1-k2filteredentero`
5. `B2_Assembly_Typing/assembly.sh` and `assembqc.sh`: filtered reads → draft assemblies and CheckM/QUAST reports
6. `B2_Assembly_Typing/seqsero2.sh`, `sistr.sh`, `mlst.sh`: assembled genomes → serotyping and MLST
7. `B4_Pangenome/prokka.sh`, `combineprokkasummary.sh`, `roary.sh`: assemblies → Prokka annotations and Roary alignment
8. `B5_AMR_Virulence_Plasmids/amrfinder.sh`, `abricate.sh`: annotated assemblies → AMR/PlasmidFinder results
9. `B3_Phylogenomics/modeltest.sh`, `iqtree.sh`: Roary core alignment → nucleotide model search and ML tree
10. `B6_Comparative_Analyses/*.R`: already deposited metadata and stage output tables → manuscript analyses

The exact script names and detailed file purposes are linked from [SCRIPT_INDEX.md](SCRIPT_INDEX.md).

## Direct R analysis

```bash
export SDUBLIN_ROOT="$PWD"
Rscript scripts/check_r_packages.R
bash scripts/run_r_analysis.sh plotmeta
bash scripts/run_r_analysis.sh abricate
bash scripts/run_r_analysis.sh amrfinder
bash scripts/run_r_analysis.sh snp
```

For `pangenome.R`, first place the missing combined Roary files from Zenodo at the locations documented in [DATA_REQUIREMENTS.md](DATA_REQUIREMENTS.md). The original R scripts retain their statistical and plotting logic. External finishing of the original figures in iTOL and Flourish remains a separate provenance step and is not implied by R execution.

## Rerun interpretation

These scripts preserve the original publication computations. Environment resolution, external-data retrieval, source-stage execution and comparison against manuscript tables are independent requirements; the repository must not claim a verified full end-to-end rerun until those checks are completed.
