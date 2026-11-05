#!/usr/bin/env python3
"""Verify that the archived study data have the exact original Git blob identities."""
import csv
import pathlib
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
manifest = ROOT / "docs/DATA_BLOB_MANIFEST.tsv"
total = 0
with manifest.open(encoding="utf-8", newline="") as handle:
    records = (line for line in handle if not line.startswith("#"))
    for row in csv.DictReader(records, delimiter="\t"):
        path = ROOT / row["path"]
        if not path.is_file():
            sys.exit(f"[FAIL] Data file missing: {row['path']}")
        if path.stat().st_size != int(row["size_bytes"]):
            sys.exit(f"[FAIL] Data file size changed: {row['path']}")
        actual = subprocess.check_output(["git", "hash-object", str(path)], cwd=ROOT, text=True).strip()
        if actual != row["git_blob_sha1"]:
            sys.exit(f"[FAIL] Data file content changed: {row['path']}")
        total += 1
print(f"[PASS] {total} original study data files match the source Git blobs exactly.")
