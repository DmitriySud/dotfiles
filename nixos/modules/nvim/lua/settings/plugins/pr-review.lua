return require("pr_review").setup({
    mode = "review",
    wrap = true,
    sherpa = {
        root = vim.fn.expand("~/arcadia/junk/nodge/sherpa"),
    },
    additional_review_skills = {
        {
            name = "review-code-preferences",
            path = vim.fn.expand(
                "~/repos/ai/knowledge_base/code_preferences/review-code-preferences/SKILL.md"
            ),
        },
    },
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
