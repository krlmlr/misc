library(tidyverse)

dta <- tribble(
  ~date,       ~class,
  "1997-04-23",  "data.frame",
  "1997-04-23",  "ts",
  "1999-07-09",  "tseries",
  "2004-02-20",  "zoo",
  "2006-04-15",  "data.table",
  "2008-01-05",  "xts",
  "2008-09-10",  "tis",
  "2008-10-23",  "timeSeries",
  "2016-03-23",  "tibble",
  "2017-09-07",  "tibbletime",
  "2018-01-09",  "tsibble"
) %>%
  transmute(Event = class, Event_Dates = as.Date(date))

ggplot(dta, aes(x = Event_Dates)) +
  geom_segment(aes(xend = Event_Dates, y = 1, yend = 9), color = "gray") +
  ggrepel::geom_text_repel(aes(label = Event, y = 10)) +
  geom_text(data = data.frame(x = as.Date("2019-07-12"), y = 0.1), aes(x, y, label = "tsbox")) +
  coord_polar() +
  geom_segment(data = data.frame(x = as.Date("1993-08-12")), aes(x = x, xend = x, y = 1, yend = 12), linetype = 2, size = 0.2) +
  theme_void()
