local options = {
    -- provider = "deepseek",
    -- cursor_applying_provider = "deepseek",
    providers = {
        deepseek = {
            __inherited_from = "openai",
            endpoint = "https://api.deepseek.com/v1",
            model = "deepseek-v4-flash",
            api_key_name = "AVANTE_DEEPSEEK_API_KEY",
            always_echo_reasoning = true,
        },
    },
    behaviour = {
        enable_cursor_planning_mode = true,
    },
}

return options
