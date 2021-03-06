join_rows <- function(x_key, y_key, type = c("inner", "left", "right", "full")) {
  type <- arg_match(type)

  # Find matching rows in y for each row in x
  y_split <- vec_group_loc(y_key)
  matches <- vec_match(x_key, y_split$key)
  y_loc <- y_split$loc[matches]

  if (type == "left" || type == "full") {
    y_loc <- map(y_loc, function(x) if (is.null(x)) NA_integer_ else x)
  }

  x_loc <- seq_len(vec_size(x_key))

  # flatten index list
  x_loc <- rep(x_loc, lengths(y_loc))
  y_loc <- vec_c(!!!y_loc, .ptype = integer())

  if (type == "right" || type == "full") {
    miss_x <- !vec_in(y_key, x_key)
    y_extra <- seq_len(vec_size(y_key))[miss_x]
  } else {
    y_extra <- integer()
  }

  list(x = x_loc, y = y_loc, y_extra = y_extra)
}
