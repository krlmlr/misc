con <- e360::e360_db_analysis()

library(tidyverse)

copy_to(con, tibble(a = 1:3, b = blob::blob(raw(1)))) %>% collect()
copy_to(con, tibble(a = 1:3, b = blob::blob(raw(1)), c = blob::blob(raw(1)))) %>% collect()
copy_to(con, tibble(a = 1:3, b = blob::blob(raw(1)), c = 1)) %>% collect()
