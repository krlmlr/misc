library(tidyverse)

N <- 4
#COLS <- 50
COLS <- NULL

set.seed(20200109)

grad <- seq(0, 1, length.out = 256)
grad_r <- seq(0, 1, length.out = N)

colors_grid <-
  expand_grid(r = grad_r, g = grad, b = grad) %>%
  mutate(rgb = grDevices::rgb(r, g, b)) %>%
  rowid_to_column("id")

all <-
  tibble(color = colors(), hex = farver::encode_colour(farver::decode_colour(color))) %>%
  separate(color, into = c("name", "variant"), sep = "(?=[0-9]+)", remove = FALSE, extra = "merge", fill = "right") %>%
  filter(!grepl("grey", name)) %>%
  mutate(variant = coalesce(variant, "")) %>%
  group_by(name) %>%
  mutate(singleton = (n() == 1)) %>%
  ungroup() %>%
  filter(name != "gray", singleton | variant == "")

if (!is.null(COLS)) {
  all <-
    all %>%
    sample_n(COLS)
}

dist <- farver::compare_colour(farver::decode_colour(colors_grid$rgb), farver::decode_colour(all$hex), "rgb", method = "euclidean")
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
  facet_wrap(vars(r), ncol = 1)
