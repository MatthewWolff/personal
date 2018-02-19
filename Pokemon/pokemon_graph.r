library(dplyr)
library(ggplot2)

battles <- read.csv("~/Downloads/pokemon-combat/combats.csv")
tests <- read.csv("~/Downloads/pokemon-combat/tests.csv")
pokemon <- read.csv("~/Downloads/pokemon-combat/pokemon.csv", na.strings=c("",NA))

# set up coloring
types <- unique(pokemon$Type.1)
types2 <- unique(pokemon$Type.2)
colors <- c("chartreuse4","firebrick2","deepskyblue1","chartreuse2","black","darkorchid2","yellow","salmon4","palevioletred1","tomato4","purple","saddlebrown","snow2","paleturquoise1","red","gray13","darkgray","lightslateblue")

## Graphing poke-data
poke_graph <- pokemon %>%
  gather(key=tmp, value=Type, Type.1, Type.2) %>%
  select(-c(tmp)) %>% # toss out whether primary or secondary
  rename(ID = X.,
         Sp.Atk = Sp..Atk,
         Sp.Def = Sp..Def,
         Gen = Generation) %>%
  mutate(Power = pmax(Attack, Sp.Atk)) %>% # Judge by their best offensive stat
  mutate(Type = factor(Type, levels = types, ordered = TRUE)) %>% # refactor for coloring
  mutate(Legendary = as.logical(Legendary)) %>% # convert to real booleans
  filter(!is.na(Type)) # remove duplicates that don't have a secondary type

ggplot(data=poke_graph, mapping = aes(Type, Power, fill=Type)) + 
  geom_boxplot(outlier.alpha = 0.5) + 
  facet_wrap(~ Legendary, 
             labeller = as_labeller(c("FALSE" = "Non-Legendary", "TRUE" = "Legendary"))) +
  ggtitle("Comparing Offensive Ability of Pokemon by Type and Legendary Status") + 
  labs(y="Offensive Ability") +
  scale_fill_manual(values=colors) +
  guides(fill=FALSE) + # remove legend for fill
  coord_polar()
