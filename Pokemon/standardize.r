library(dplyr)

input <- "~/Downloads/pokemon-combat/pokemon.csv"
output <- "~/projects/pokedata/" # must end with a "/"

#####################################################################
#' @param categorical a vector of categorical values that have levels
#' @return 1-of-(C-1) effects-coding style list of vectors
numerify_categorical <- function(categorical){
  uniq <- unique(categorical[!is.na(categorical)]) # remove NA's for the love of god
  categorical <- factor(categorical, levels = uniq) 
  sorter <- lapply(uniq, function(x) {
    rtn <- integer(length(uniq))
    rtn[x] <- 1
    if(as.numeric(x) == length(rtn))
      rep(-1, length(rtn))
    else
      rtn
  })
  names(sorter) <- uniq
  return(unname(sorter[categorical]))
}

#####################################################################
#' @param binary_data a vector of values that can be coerced to boolean
#' @return a vector of -1 and 1's
binarize_categorical <- function(binary_data)
  sapply(as.logical(binary_data), function(x) if(x) 1 else -1)

#####################################################################
#' @param x the index within the metadata list of the list to be stored
#' @return None
store_metadata <- function(x) 
  write.csv(
    t(as.data.frame(metalists[[x]])), 
    paste0(output, names(metalists[x]),".csv"),
    row.names = FALSE, na = "")
    
#####################################################################
#' @param list the main list to store
#' @param metalists columns from the main list that need to be stored as separate data.frames
#' @return None
store <- function(list, metalists){
  write.csv(list, paste0(output,"main.csv"), row.names = FALSE)
  invisible(lapply(1:length(metalists), store_metadata))
}
         
#####################################################################

# normalizing data
pokemon <- read.csv(input, na.strings=c("",NA))
pn <- pokemon %>% 
  rename(ID = X.,
         Type1 = Type.1,
         Type2 = Type.2,
         Sp.Atk = Sp..Atk,
         Sp.Def = Sp..Def,
         Gen = Generation) %>%
  mutate(Power = pmax(Attack, Sp.Atk)) %>% # Judge by their best offensive stat
  mutate(HP = as.numeric(scale(HP)), # normalize all numerics
         Attack = as.numeric(scale(Attack)), # assuming that the stats are normally distributed... qqnorm looks okay, so w/e
         Defense = as.numeric(scale(Defense)),
         Sp.Atk = as.numeric(scale(Sp.Atk)),
         Sp.Def = as.numeric(scale(Sp.Def)),
         Speed = as.numeric(scale(Speed)),
         Power = as.numeric(scale(Power))) %>%
  mutate(Type1 = numerify_categorical(Type1), # take care of categorical variables
         Type2 = numerify_categorical(Type2),
         Gen = numerify_categorical(Gen),
         Legendary = binarize_categorical(Legendary)) %>% # convert binary to numeric
  mutate(Type2 = lapply(Type2, function(x) if(!is.null(x)) x else NA)) # turn NULLs into NA

# determine which lists need to be separately stored
lists <- pn[which(!sapply(pn, class) == "list")]
metalists <- pn[which(sapply(pn, class) == "list")]
store(lists, metalists)
