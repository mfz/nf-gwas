# Attempt to get nf-gwas running on AllOfUS research platform

This is an attempt to get nf-gwas running on the AllOfUS research platform.
I am only interested in obtaining the regenie GWAS results, not in creating Manhattan plots etc.

This is the first time I am dealing with nextflow and/or the Google Cloud Platform.
So there are likely better ways ...

The Dockerfile is modified to include the Google Cloud SDK and bgenix, which is used to split the bgen files.

Nextflow stages input files (for example .bgen) by copying them to the working directory.
Even if only a small slice is needed, the whole file gets copied. To avoid this, `splitbgen.nf` can be used to split the bgen files into chunks beforehand.

Similarly, `splitancestry.nf` can be used to split the input PLINK files by ancestry.
`splitancestry.nf` also sets FID to IID in the .fam files, to agree with the .bgen sample files. 

Some modifications were made to the nf-gwas pipeline to restrict functionality to only run regenie, and to try to avoid copying too many files.

The AllOfUS specific configuration is in `conf/aou.conf`. The Google cloud profile can be found in `~/.nextflow/config` on the AllOfUS research platform. It provides the `gls` profile. The `spot` profile to enable running on spot instances was added to `nextflow.config`. 

Steps:

- create ancestry file with columns FID, IID, ancestry and run `splitancestry.nf` workflow vv(this workflow has to be run outside of nf-gwas directory) using profile `gls`

- run `splitbgen.nf` workflow using profile `gls`

- configure `conf/aou` with phenotype and covariates

- run `main.nf` workflow using profiles `gls` and `spot`




# Excerpts from original README.md


**nf-gwas** is a Nextflow pipeline to run biobank-scale genome-wide association studies (GWAS) analysis. The pipeline automatically performs numerous pre- and post-processing steps, integrates regression modeling from the REGENIE package and currently supports single-variant, gene-based and interaction testing. All modules are structured in sub-workflows which allows to extend the pipeline to other methods and tools in future. nf-gwas includes an extensive reporting functionality that allows to inspect thousands of phenotypes and navigate interactive Manhattan plots directly in the web browser. 

## Citation

Please cite [our paper](https://academic.oup.com/nargab/article/6/1/lqae015/7602818) if you use nf-gwas:

> Schönherr S*, Schachtl-Riess JF*, Di Maio S*, Filosi M, Mark M, Lamina C, Fuchsberger C, Kronenberg F, Forer L. 
> Performing highly parallelized and reproducible GWAS analysis on biobank-scale data. 
> NAR Genom Bioinform. 2024 Feb 7;6(1):lqae015. doi: 10.1093/nargab/lqae015. PMID: 38327871; PMCID: PMC10849172.


## License

nf-gwas is MIT Licensed and was developed at the [Institute of Genetic Epidemiology](https://genepi.i-med.ac.at/), Medical University of Innsbruck, Austria.

## Contact

- [Sebastian Schönherr](mailto:sebastian.schoenherr@i-med.ac.at)
- [Lukas Forer](mailto:lukas.forer@i-med.ac.at)
- [Johanna Schachtl-Riess](mailto:johanna.schachtl-riess@i-med.ac.at)
- [Silvia Di Maio](mailto:silvia.di-maio@i-med.ac.at)
