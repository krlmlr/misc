library(tidyverse)

all_colors <-
  tibble(color = colors(), hex = farver::encode_colour(farver::decode_colour(color))) %>%
  separate(color, into = c("name", "variant"), sep = "(?=[0-9]+)", remove = FALSE, extra = "merge", fill = "right") %>%
  filter(!grepl("grey", name)) %>%
  mutate(variant = coalesce(variant, "")) %>%
  group_by(name) %>%
  mutate(singleton = (n() == 1)) %>%
  ungroup() %>%
  arrange(!singleton, as.numeric(paste0("0", variant))) %>%
  mutate(dupe = duplicated(hex))

dupes <-
  all_colors %>%
  group_by(hex) %>%
  mutate(color_unique = color[!dupe]) %>%
  ungroup() %>%
  filter(dupe)

# Many dupes are same as variant == "1"
# Only few "interesting" dupes
dupes %>%
  filter(name != color_unique | variant != "1")

# 57 singletons
singletons <-
  all_colors %>%
  filter(singleton)

# 78 ramps with 5 colors each, and gray
all_colors %>%
  filter(!singleton) %>%
  count(name) %>%
  count(n)

all_colors %>%
  filter(name != "gray", singleton | variant == "1")

# Increasing number in "variant" gives a darker color
# variant == "" is often somewhere inbetween, or a dupe of "1"
all_colors %>%
  filter(!singleton) %>%
  filter(name != "gray") %>%
  ggplot(aes(x = variant, y = name, fill = hex)) +
  geom_tile() +
  scale_fill_identity()

# All colors with variant have a variant without number
all_colors %>%
  group_by(name) %>%
  summarize(has_empty = any(variant == "")) %>%
  ungroup() %>%
  count(has_empty)
