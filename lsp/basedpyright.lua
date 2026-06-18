local function get_python_project_settings()
    local settings = {}
    local root = vim.uv.cwd() -- Use current working directory as a starting point
    local path = root .. "/pyproject.toml"

    if vim.fn.filereadable(path) == 1 then
        local lines = vim.fn.readfile(path)
        local in_section = false
        for _, line in ipairs(lines) do
            if line:match "%[tool%.pyright%]" or line:match "%[tool%.basedpyright%]" then
                in_section = true
            elseif line:match "%[" then
                in_section = false
            elseif in_section then
                local k, v = line:match "^%s*([%w%-_]+)%s*=%s*\"?([%w%.%-%/]+)\"?"
                if k and v then
                    settings[k] = v
                end
            end
        end
    end
    return settings
end

local project_settings = get_python_project_settings()

return {
    settings = {
        basedpyright = {
            analysis = vim.tbl_deep_extend("force", {
                typeCheckingMode = "standard",
                reportMissingTypeStubs = false,
            }, project_settings),
        },
        python = {
            analysis = vim.tbl_deep_extend("force", {
                typeCheckingMode = "standard",
                reportMissingTypeStubs = false,
            }, project_settings),
        },
    },
}
