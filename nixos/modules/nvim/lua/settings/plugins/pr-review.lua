return require("pr_review").setup({
    mode = "review",
    wrap = true,
    -- Bind a task with PRReviewCodexUse before its writable <leader>pe appears.
    mappings = {
        open = "<leader>po",
        files = "<leader>pf",
        lines = "<leader>pl",
        codex_ask_line = "<leader>pq",
        codex_threads = "<leader>pQ",
        codex_edit = "<leader>pe",
    },
})
