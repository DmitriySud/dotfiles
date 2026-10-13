local min_preview_width = 120
local preview_fraction = 0.6

require('telescope').setup {
    defaults = {
        border = false,
        layout_strategy = 'flex',
        layout_config = {
            -- No outer margins; leave Neovim's command/status/tab lines available.
            width = { padding = 0 },
            height = { padding = 0 },
            flex = {
                -- Telescope calls side-by-side panes "horizontal" and stacked panes "vertical".
                flip_columns = math.ceil(min_preview_width / preview_fraction),
                flip_lines = 0,
            },
            horizontal = {
                preview_width = preview_fraction,
                preview_cutoff = 0,
            },
            vertical = {
                preview_height = preview_fraction,
                preview_cutoff = 0,
            },
        },
    },
}
