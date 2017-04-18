# word to RNA to DNA
word <- commandArgs(TRUE)
capital <- toupper(gsub(" +|\t|\r|'", "", word)) # trims whitespace
codons <- c("GCU", "GCC", "GCA", "GCG", "CGU", "CGC", "CGA", "CGG", "AGA", "AGG", "AAU", "AAC", "GAU", "GAC", "UGU", "UGC", "CAA", "CAG", "GAA", "GAG", "GGU", "GGC", "GGA", "GGG", "CAU", "CAC", "AUU", "AUC", "AUA", "UUA", "UUG", "CUU", "CUC", "CUA", "CUG", "AAA", "AAG", "AUG", "UUU", "UUC", "CCU", "CCC", "CCA", "CCG", "UCU", "UCC", "UCA", "UCG", "AGU", "AGC", "ACU", "ACC", "ACA", "ACG", "UGG", "UAU", "UAC", "GUU", "GUC", "GUA", "GUG", "UAA", "UGA", "UAG")
names(codons) <- c(rep("A", 4), rep("R", 6), rep("N", 2),rep("D", 2), rep("C", 2), rep("Q", 2), rep("E", 2),rep("G", 4), rep("H", 2), rep("I", 3), rep("L", 6),rep("K", 2), "M", rep("F", 2), rep("P", 4), rep("S", 6),rep("T", 4), "W", rep("Y", 2), rep("V", 4), rep("*", 3))
capital <- unlist(strsplit(capital,""))
RNA <- codons[capital]
RNA <- unname(RNA)
RNA <- unlist(strsplit(RNA,""))
DNA <- RNA; DNA2 <- RNA
DNA2[which(RNA == "U")] <- "T" # the complementary DNA strand
DNA[which(DNA == "C")] <- "X"
DNA[which(DNA == "G")] <- "C"
DNA[which(DNA == "X")] <- "G"
DNA[which(DNA == "A")] <- "T"
DNA[which(DNA == "U")] <- "A"
DNA[is.na(DNA)] <- "???"; DNA2[is.na(DNA2)] <- "???"
DNA <- paste(DNA,collapse=""); DNA2 <- paste(DNA2,collapse="")
cat("DNA:\n3' -> ",DNA, " -> 5'\n5' <- ", DNA2, " <- 3'\n", sep = "")
