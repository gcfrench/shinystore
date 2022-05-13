species_images <- tibble::tribble(
  ~species, ~id, ~author,
  "Chinstrap", "ZZyK8GjFJ4Q", "rocinante_11",
  "Gentoo", "LAQ2QfYTpTY", "tamwarnerminton",
  "Adelie", "9k9tNQTwMEA", "dylanshaw"
)

usethis::use_data(species_images, overwrite = TRUE)
