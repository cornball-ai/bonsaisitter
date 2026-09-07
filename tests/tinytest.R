if (requireNamespace("tinytest", quietly = TRUE)) {
  # Keep every transitive tools::R_user_dir() write inside the check's temp
  # area, so nothing lands under ~/.cache, ~/.config or ~/.local/share.
  Sys.setenv(R_USER_CACHE_DIR = tempfile("bonsaisitter_cache_"),
             R_USER_DATA_DIR = tempfile("bonsaisitter_data_"),
             R_USER_CONFIG_DIR = tempfile("bonsaisitter_config_"))
  tinytest::test_package("bonsaisitter")
}
