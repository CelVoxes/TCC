# scrape them ALL!
library(hypeR)
library(parallel)

geneset.names <- available$Geneset

results <- mclapply( seq_along(geneset.names), function(x){ 
    message(sprintf("Downloading (%d/%d): %s", x, length(geneset.names), geneset.names[x]))
    gs <- enrichr_gsets(geneset.names[x]) 
    return(gs$genesets)
}), )

all.genesets <- lapply(seq_along(geneset.names), function(x){ 
    message(sprintf("Downloading (%d/%d): %s", x, length(geneset.names), geneset.names[x]))
    gs <- enrichr_gsets(geneset.names[x]) 
    return(gs$genesets)
})

discard.bucket <- 
    c(  "Azimuth_Cell_Types_2021", "BioCarta_2013", "BioCarta_2015", "ChEA_2013", "ChEA_2015", "ChEA_2016", "Chromosome_Location",
        "Chromosome_Location_hg19", "COVID-19_Related_Gene_Sets", "ENCODE_Histone_Modifications_2013", "ENCODE_TF_ChIP-seq_2014",
        "Enrichr_Libraries_Most_Popular_Genes","Enrichr_Submissions_TF-Gene_Coocurrence", "GO_Biological_Process_2013",                       
        "GO_Biological_Process_2015", "GO_Biological_Process_2017", "GO_Biological_Process_2017b", 
        "GO_Biological_Process_2018", "GO_Biological_Process_2021", "GO_Cellular_Component_2013", "GO_Cellular_Component_2015",
        "GO_Cellular_Component_2017", "GO_Cellular_Component_2017b", "GO_Cellular_Component_2018", "GO_Cellular_Component_2021",
        "GO_Molecular_Function_2013", "GO_Molecular_Function_2015", "GO_Molecular_Function_2017","GO_Molecular_Function_2017b", 
        "GO_Molecular_Function_2018", "GO_Molecular_Function_2021", 
        "GWAS_Catalog_2019","HDSigDB_Mouse_2021", 
        "KEA_2013", 
        "KEGG_2013", "KEGG_2015", "KEGG_2016", "KEGG_2019_Human", "KEGG_2019_Mouse", 
        "MGI_Mammalian_Phenotype_Level_4", "MGI_Mammalian_Phenotype_Level_4_2019",
        "MGI_Mammalian_Phenotype_2013", "MGI_Mammalian_Phenotype_2017", 
        "Reactome_2013", "Reactome_2015", "Reactome_2016",  
        "SynGO_2022",  
        "WikiPathway_2021_Human", "WikiPathways_2013", "WikiPathways_2015", "WikiPathways_2016", 
        "WikiPathways_2019_Human", "WikiPathways_2019_Mouse")
               
filtered.geneset.names <- setdiff(geneset.names, discard.bucket)
filtered.genesets <- all.genesets[filtered.geneset.names]

#save(filtered.genesets, "db/filtered.genesets.Rda")

filtered.genesets.flatten <- unlist(filtered.genesets, recursive = FALSE)

# get pathways with more than 5 genes
idx <- sapply(filtered.genesets.flatten, length) >= 5

filtered.genesets.flatten <- filtered.genesets.flatten[idx]
length(filtered.genesets.flatten)

tmp = filtered.genesets.flatten
gmt = sapply(names(tmp), function(x){ paste0(x, "\t\t", paste(tmp[[x]], collapse = "\t"))})

write.table(gmt, 'filtered.genesets.gmt', sep = "\t", row.names = FALSE,
                col.names = FALSE, quote = FALSE)