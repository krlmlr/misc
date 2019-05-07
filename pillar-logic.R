library(tibble)

repo <- rep(list(as.list(1:68)), 3)
tibble(repo)

library(pillar)
colonnade(tibble(repo))
pillar(repo)
pillar_shaft(repo)
str(pillar_shaft(repo))
