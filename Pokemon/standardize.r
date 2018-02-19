library(dplyr)

pokemon <- read.csv("~/Downloads/pokemon-combat/pokemon.csv", na.strings=c("",NA))
## Prepare data 
# helpers
numerify_categorical <- function(categorical){
  uniq <- unique(categorical)
  categorical <- factor(categorical, levels = uniq, ordered = TRUE) # ordered for deterministic behavior
  sorter <- lapply(uniq, function(x) {
    if(is.na(x))
      return(NULL)
    rtn <- integer(length(uniq)); 
    rtn[x] <- 1; 
    if(as.numeric(x) == length(rtn))
      rep(-1, length(rtn))
    else
      rtn
  })
  names(sorter) <- uniq
  return(sorter[categorical])
}
binarize_categorical <- function(binary_data){
  return(sapply(as.logical(binary_data), function(x) if(x) 1 else -1))
}

# normalizing data
pd <- pokemon %>% 
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
  mutate(Type2 = lapply(pd$Type2, function(x) if(!is.null(x)) x else NA)) # turn NULLs into NA
