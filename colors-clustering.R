library(tidyverse)

N <- 16

METHOD <- "cie2000"

set.seed(20200109)

all <-
  tibble(color = colors(), rgb = farver::decode_colour(color), hex = farver::encode_colour(rgb)) %>%
  mutate(r = rgb[, 1], g = rgb[, 2], b = rgb[, 3]) %>%
  separate(color, into = c("name", "variant"), sep = "(?=[0-9]+)", remove = FALSE, extra = "merge", fill = "right") %>%
  filter(!grepl("grey", name)) %>%
  mutate(variant = coalesce(variant, "")) %>%
  group_by(name) %>%
  mutate(singleton = (n() == 1)) %>%
  ungroup() %>%
  filter(name != "gray", singleton | variant == "")

# Needs https://github.com/thomasp85/farver/pulls/21 for Euclidean:
dist <- farver::compare_colour(farver::decode_colour(all$hex), farver::decode_colour(all$hex), from_space = "rgb", method = METHOD)

agnes <- cluster::agnes(dist, diss = TRUE)
dend <- as.dendrogram(agnes)

while (length(dend) < N) {
  lengths <- map_int(dend, ~ length(unlist(.)))
  dend <- dend[order(-lengths)]
  dend <- c(dend[[1]], dend[-1])
}

cluster <-
  map(dend, unlist) %>%
  enframe("cluster") %>%
  unnest(value) %>%
  arrange(value) %>%
  pull(cluster)

all_clustered <-
  all %>%
  mutate(cluster = !!cluster) %>%
  group_by(cluster) %>%
  mutate(mean_r = mean(r), sd_r = sd(r)) %>%
  ungroup() %>%
  arrange(mean_r) %>%
  mutate(facet = forcats::fct_inorder(paste0("cluster: ", cluster, ", r: ", round(mean_r)))) %>%
  mutate(
    is_light = as.vector(diff(t(
      farver::compare_colour(farver::decode_colour(hex), farver::decode_colour(c("black", "white")), from_space = "rgb", method = METHOD)
    ))) < 0
  ) %>%
  mutate(hex_bg = c("black", "white")[if_else(is_light, 1, 2)])

all_clustered %>%
  group_by(facet) %>%
  summarize_at(vars(r, g, b), ~ diff(range(.))) %>%
  pivot_longer(-facet) %>%
  arrange(value) %>%
  filter(!duplicated(facet)) %>%
  count(name)


all_grid <-
  all_clustered %>%
  group_by(facet) %>%
  summarize_at(vars(r, g, b), list(min = min, max = max, mean = ~ round(mean(.)), extent = ~ diff(range(.)), grid = ~ list(seq.int(min(.), max(.))))) %>%
  mutate(grid = map2(g_grid, b_grid, ~ expand_grid(g = .x, b = .y))) %>%
  select(facet, r = r_mean, grid) %>%
  unnest(grid) %>%
  mutate(hex = rgb(r, g, b, maxColorValue = 255))

#+ r plot, fig.width = 16, fig.height = 9, fig.retina = TRUE
ggplot(mapping = aes(x = g, y = b)) +
  geom_tile(aes(fill = hex), data = all_grid) +
  geom_point(data = all_clustered) +
  ggrepel::geom_label_repel(aes(label = color, color = hex, fill = hex_bg), data = all_clustered, alpha = 0.8) +
  #geom_label(aes(label = color, color = hex, fill = hex_bg), data = all_clustered, alpha = 0.8) +
  scale_fill_identity() +
  facet_wrap(vars(facet), scale = "free") +
  scale_color_identity() +
  theme_minimal() +
  theme(axis.text = element_blank())
