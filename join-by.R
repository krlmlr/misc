library(tidyverse)
library(dbplyr)

tbl1 <- memdb_frame(a = 1:3, b = 4:2)
tbl2 <- memdb_frame(c = 1:3, b = 2:0)

tbl12 <- left_join(tbl1, tbl2, sql_on = "TBL_LEFT.b < TBL_RIGHT.c")
tbl12 %>% sql_render()
tbl12

full_join(tbl1, tbl2, by = character()) %>%
  filter(sql("TBL_LEFT.b < TBL_RIGHT.c")) %>%
  sql_render()
