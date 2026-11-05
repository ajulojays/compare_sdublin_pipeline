# Frozen publication archive

A publication archive must identify one immutable source revision, retain its provenance, and make integrity checks possible. Merely maintaining a GitHub branch is **not** permanent archiving.

## Freeze gate

Before publication:

1. Confirm upstream reuse/redistribution rights and the attribution statement in [PROVENANCE.md](PROVENANCE.md).
2. Resolve external input locations and install reproducible software environments.
3. Perform a clean machine/HPC rerun of required analyses and reconcile output figures/tables with the original article.
4. Record any observed software-version differences and note analyses performed with external services.
5. Merge the validated preparation branch into the intended publication branch.

## Create the tagged archive

After the approved code is on the publication branch:

```bash
git status --short
git tag -a v1.0.0 -m "S. Dublin publication workflow v1.0.0"
git push origin v1.0.0
bash scripts/make_publication_archive.sh v1.0.0
```

The script requires a clean worktree and an existing tag at the checked-out commit. It creates `dist/compare_sdublin_pipeline-v1.0.0.tar.gz` and its `.sha256` integrity record using `git archive`, which includes tracked source/data but excludes local scratch outputs.

Publish an official **GitHub Release** for `v1.0.0` and attach the archive and checksum. For preservation independent of mutable GitHub hosting, deposit the approved release in a long-term repository such as Zenodo or an institutional archive with versioned metadata and a persistent identifier. The original paper's [Zenodo record](https://zenodo.org/records/15652582) is for its deposited data; do not claim it is the DOI of this reorganized code release.

Archive status on this branch: **prepared, not frozen or independently deposited**.
