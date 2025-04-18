require("luacov") -- start coverage
require("plenary.test_harness").run() -- run all specs
vim.cmd("q")
