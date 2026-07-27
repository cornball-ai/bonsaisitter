library(bonsaisitter)

# Node type names differ per grammar, so every language needs its own proof that
# the walk actually matches something. An empty extraction is indistinguishable
# from a clean audit at the call site, which is exactly how cpp went unnoticed.

if (requireNamespace("treesitter.r", quietly = TRUE)) {
  # -- R --
  got <- literals_and_calls("f(1L, 2.5) + g(3)", "r")
  expect_equal(got$literals, c("1L", "2.5", "3"))
  expect_equal(got$calls, c("f", "g"))

  # -- audit_translation reports drift in both directions --
  res <- audit_translation("clamp(x, 1e-10); y * 8", "pmax(x, 1e-10); y * 9")
  expect_equal(res$literals_missing, "8")
  expect_equal(res$literals_extra, "9")

  # -- normalize collapses 4, 4L and 4.0 --
  clean <- audit_translation("f(4L)", "f(4.0)")
  expect_equal(length(clean$literals_missing), 0L)
  expect_equal(length(clean$literals_extra), 0L)
  raw <- audit_translation("f(4L)", "f(4.0)", normalize = FALSE)
  expect_equal(raw$literals_missing, "4L")
}

if (requireNamespace("treesitter.python", quietly = TRUE)) {
  # -- Python --
  got <- literals_and_calls("f(1, 2.5) + g(3)", "python")
  expect_equal(got$literals, c("1", "2.5", "3"))
  expect_equal(got$calls, c("f", "g"))
}

if (requireNamespace("treesitter.cpp", quietly = TRUE)) {
  # -- C++ uses number_literal / call_expression, not R's names --
  got <- literals_and_calls("int f() { return g(1, 2.5); }", "cpp")
  expect_equal(got$literals, c("1", "2.5"))
  expect_equal(got$calls, "g")
}

if (requireNamespace("treesitter.rust", quietly = TRUE)) {
  # -- Rust: integer_literal / float_literal --
  got <- literals_and_calls("fn f() -> f64 { g(1, 2.5) }", "rust")
  expect_equal(got$literals, c("1", "2.5"))
  expect_equal(got$calls, "g")
}

if (requireNamespace("treesitter.javascript", quietly = TRUE)) {
  # -- JavaScript folds every numeric literal into one node type --
  got <- literals_and_calls("function f() { return g(1, 2.5); }", "javascript")
  expect_equal(got$literals, c("1", "2.5"))
  expect_equal(got$calls, "g")
}

if (requireNamespace("treesitter.go", quietly = TRUE)) {
  # -- Go splits ints and floats into separate node types --
  code <- "package main\n\nfunc f() float64 { return g(1, 2.5) }\n"
  got <- literals_and_calls(code, "go")
  expect_equal(got$literals, c("1", "2.5"))
  expect_equal(got$calls, "g")

  # -- cross-language audit: R reference against a Go port --
  res <- audit_translation("g(1, 2.5)", code, lang = c("r", "go"))
  expect_equal(length(res$literals_missing), 0L)
  expect_equal(length(res$literals_extra), 0L)
}

# -- unknown languages are rejected by match.arg, not silently empty --
expect_error(literals_and_calls("x <- 1", "fortran"))
