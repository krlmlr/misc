library(rlang)

eval_tidy_quo <- function(expr, data = NULL, env = caller_env()) {
  eval_tidy(enquo(expr), data = data, env = env)
}

b <- 5
a <- sym("b")

# This is not tidy evaluation, a is unquoted eagerly?
eval_tidy({{a}})
eval_tidy(a)
eval_tidy({{a}}, data = list(b = 3))
eval_tidy(a, data = list(b = 3))

# Tidy evaluation without mustache:
eval_tidy_quo(a)

# Not picking up b from .GlobalEnv here
try(eval_tidy_quo({{a}}))

# ...but works with the data mask
eval_tidy_quo({{a}}, data = list(b = 3))

# A quosure works
a <- quo(b)
eval_tidy_quo({{a}})

# Mustache implements quote-unquote in a function:
quoting_fun <- function(expr) {
  eval_tidy_quo({{expr}})
}

quoting_fun(a)
quoting_fun({{a}})
