local options = {
    provider = "copilot",
    cursor_applying_provider = "copilot",
    behaviour = {
        enable_cursor_planning_mode = true,
    },
    system_prompt = function()
        local ok, mcphub = pcall(require, "mcphub")
        if not ok then
            return ""
        end
        local hub = mcphub.get_hub_instance()
        return hub and hub:get_active_servers_prompt() or ""
    end,
    custom_tools = function()
        local ok, mcp_avante = pcall(require, "mcphub.extensions.avante")
        if not ok then
            return {}
        end
        return {
            mcp_avante.mcp_tool(),
        }
    end,
}

return options
