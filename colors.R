library(tidyverse)

N <- 16
COLS <- 50
#COLS <- NULL

set.seed(20200109)

grad <- seq(0, 1, length.out = N)

colors_grid <-
  expand_grid(r = grad, g = grad, b = grad) %>%
  mutate(rgb = grDevices::rgb(r, g, b)) %>%
  rowid_to_column("id")

all <-
  tibble(color = colors()) %>%
  filter(!grepl("^gr[ae]y", color))

if (!is.null(COLS)) {
  all <-
    all %>%
    sample_n(COLS)
}

dist <- farver::compare_colour(farver::decode_colour(colors_grid$rgb), farver::decode_colour(all$color), "rgb", method = "cmc")
dimnames(dist) <- list(id = colors_grid$id, color = all$color)

all_dists <-
  dist %>%
  as.table() %>%
  as_tibble(n = "dist") %>%
  mutate(id = as.integer(id))

min_dists <-
  all_dists %>%
  group_by(color) %>%
  filter(row_number(dist) == 1) %>%
  ungroup() %>%
  left_join(colors_grid, by = "id")

ggplot(colors_grid, aes(x = b, y = g)) +
  geom_tile(aes(fill = rgb)) +
  geom_point(data = min_dists) +
  ggrepel::geom_label_repel(aes(label = color), min_dists, alpha = 0.8) +
  scale_color_identity() +
  scale_fill_identity() +
  facet_wrap(vars(r))
