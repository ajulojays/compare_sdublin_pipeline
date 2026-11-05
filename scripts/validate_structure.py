#!/usr/bin/env python3
"""Source, environment and metadata integrity checks for the publication branch."""
import pathlib, re, subprocess, sys

ROOT=pathlib.Path(__file__).resolve().parents[1]
stages={
"B1_Reads_QC":("accessionqc.sh","trimqc.sh","classifyreads.sh","filterreads.sh"),
"B2_Assembly_Typing":("assembly.sh","assembqc.sh","seqsero2.sh","sistr.sh","mlst.sh"),
"B3_Phylogenomics":("modeltest.sh","iqtree.sh"),
"B4_Pangenome":("prokka.sh","combineprokkasummary.sh","roary.sh"),
"B5_AMR_Virulence_Plasmids":("amrfinder.sh","abricate.sh"),
"B6_Comparative_Analyses":("plotmeta.R","readqc.R","assembqc.R","abricate.R","amrfinder.R","pangenome.R","anno.R","snp.R"),
}
failed=[]
def check(condition,what):
    if not condition: failed.append(what)

for directory,items in stages.items():
    for item in items:
        path=ROOT/"workflow"/directory/item
        check(path.is_file(),f"Missing analysis script: {path.relative_to(ROOT)}")
        if path.suffix==".sh" and path.is_file():
            p=subprocess.run(["bash","-n",str(path)],capture_output=True,text=True)
            check(p.returncode==0,f"Bash syntax: {path.relative_to(ROOT)}: {p.stderr.strip()}")
        if path.suffix==".R" and path.is_file():
            check('setwd("./R")' not in path.read_text(),f"Old R working directory: {item}")
for file in ("workflow/lib/common.sh","scripts/check_inputs.sh","scripts/make_publication_archive.sh"):
    p=ROOT/file
    check(p.is_file(),f"Missing support script: {file}")
    if p.exists():
        c=subprocess.run(["bash","-n",str(p)],capture_output=True,text=True)
        check(c.returncode==0,f"Syntax error: {file}: {c.stderr.strip()}")
for path in (ROOT/"workflow").rglob("*"):
    if path.suffix in (".sh",".R") and path.is_file():
        check("/your/path/here" not in path.read_text(),f"Unconfigured hard-coded path: {path}")
for path in (ROOT/"environments").glob("*.yaml"):
    contents=path.read_text()
    check(not re.search(r"^prefix:",contents,re.M),f"Machine-specific Conda prefix: {path.name}")
    check(not re.search(r"^name:\s*/",contents,re.M),f"Machine-specific Conda env name: {path.name}")
for path in ("data/meta/finalset_meta.tsv","data/phylo/distances.tab","data/phylo/iq.treefile","data/amrfinder/amrfinderentero.txt","data/abricate/vf-all_summary.txt"):
    check((ROOT/path).is_file(),f"Missing deposited study file: {path}")
manifest=ROOT/"docs/DATA_BLOB_MANIFEST.tsv"
check(manifest.is_file(),"Missing data-blob provenance manifest")
if manifest.exists():
    lines=[l for l in manifest.read_text().splitlines() if l and not l.startswith("#")]
    check(len(lines)-1>=350,"Unexpectedly incomplete data manifest")
    for line in lines[1:]:
        cols=line.split("\t")
        if len(cols)!=3: failed.append(f"Malformed manifest: {line}"); continue
        check((ROOT/cols[0]).is_file(),f"Missing archived data: {cols[0]}")
if failed:
    for item in failed: print("[FAIL]",item)
    sys.exit(1)
print("[PASS] 24 original analysis scripts indexed in six ordered workflow stages")
print("[PASS] Shell syntax, portable paths, environment descriptors and archived input presence")
print("[PASS] Archived data path manifest complete")
