local M = {}

local DEFAULT_SENTINEL = "default"

-- Optional per-provider model overrides (e.g. AgyProvider = "gemini-4-neon-high", DeepSeekProvider = "deepseek-reasoner").
local provider_models = {}

-- Direct OpenAI-compatible HTTP API providers (local or remote).
-- Omit `api_key_env` for local servers like llama.cpp / Ollama.
local api_providers_config = {
    LlamaProvider = {
        endpoint = "http://127.0.0.1:8080/v1",
        default_model = DEFAULT_SENTINEL,
        temperature = 0.6,
        max_tokens = 32768,
    },
    DeepSeekProvider = {
        endpoint = "https://api.deepseek.com/v1",
        api_key_env = "DEEPSEEK_API_KEY",
        default_model = "deepseek-flash",
        temperature = 0.6,
        max_tokens = 32768,
    },
}

local include_harpoon_context = true

local function normalize_path(path)
    if not path or path == "" then
        return ""
    end
    if not vim.startswith(path, "/") then
        path = vim.fs.joinpath(vim.uv.cwd(), path)
    end
    return vim.fs.normalize(path)
end

local function read_file_or_buffer(abs_path)
    local bufnr = vim.fn.bufnr(abs_path)
    if bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr) then
        return table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
    end
    if vim.fn.filereadable(abs_path) == 1 then
        local ok, lines = pcall(vim.fn.readfile, abs_path)
        if ok and lines then
            return table.concat(lines, "\n")
        end
    end
    return nil
end

local function collect_context_files(bufnr, include_harpoon)
    local current_path = normalize_path(vim.api.nvim_buf_get_name(bufnr))
    local current_content = ""
    if vim.api.nvim_buf_is_valid(bufnr) then
        current_content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
    end

    local harpoon_files = {}
    if include_harpoon then
        local ok, harpoon = pcall(require, "harpoon")
        if ok then
            local ok_list, list = pcall(function()
                return harpoon:list()
            end)
            if ok_list and list and list.items then
                local seen = {}
                if current_path ~= "" then
                    seen[current_path] = true
                end
                local len = list._length or #list.items
                for i = 1, len do
                    local item = list.items[i]
                    if item and type(item.value) == "string" and item.value ~= "" then
                        local abs_path = normalize_path(item.value)
                        if abs_path ~= "" and not seen[abs_path] then
                            seen[abs_path] = true
                            local content = read_file_or_buffer(abs_path)
                            if content then
                                table.insert(harpoon_files, {
                                    path = abs_path,
                                    content = content,
                                })
                            end
                        end
                    end
                end
            end
        end
    end

    return {
        current = {
            path = current_path ~= "" and current_path or "[No Name]",
            content = current_content,
        },
        harpoon = harpoon_files,
    }
end

local function format_context_blocks(ctx_files)
    local parts = {}
    for _, hf in ipairs(ctx_files.harpoon) do
        table.insert(parts, string.format('<HARPOON_FILE path="%s">\n%s\n</HARPOON_FILE>', hf.path, hf.content))
    end
    table.insert(
        parts,
        string.format('<CURRENT_FILE path="%s">\n%s\n</CURRENT_FILE>', ctx_files.current.path, ctx_files.current.content)
    )
    return table.concat(parts, "\n\n")
end

local function strip_code_fences(text)
    if not text then
        return ""
    end
    local trimmed = text:gsub("^%s*\r?\n", ""):gsub("\r?\n%s*$", "")
    local inner = trimmed:match "^```[^\n]*\r?\n(.*)\r?\n```$"
    if inner then
        return inner
    end
    return text
end

local function build_api_visual_messages(context, include_harpoon)
    local visual_data = context:visual_data()
    local range = visual_data.range
    local ctx_files = collect_context_files(visual_data.buffer, include_harpoon)

    local sr, sc = range.start:to_vim()
    local er, ec = range.end_:to_vim()
    local selection_text = range:to_text()
    local instruction = context.user_prompt or ""

    local system_prompt = table.concat({
        "You are an expert code editor.",
        "Replace ONLY the code inside <SELECTION_CONTENT> according to <USER_INSTRUCTION>.",
        "Use <CURRENT_FILE> and any <HARPOON_FILE> blocks strictly as read-only context.",
        "Output ONLY the raw replacement code for the selected region.",
        "Do NOT wrap the output in markdown code fences, do NOT add explanations, and do NOT include unchanged surrounding lines.",
        "Preserve the exact indentation style and level expected at <SELECTION_LOCATION>.",
    }, " ")

    local user_parts = {
        format_context_blocks(ctx_files),
        string.format(
            "<SELECTION_LOCATION>\n%s: lines %d-%d (cols %d-%d)\n</SELECTION_LOCATION>",
            ctx_files.current.path,
            sr + 1,
            er + 1,
            sc + 1,
            ec + 1
        ),
        string.format("<SELECTION_CONTENT>\n%s\n</SELECTION_CONTENT>", selection_text),
        string.format("<USER_INSTRUCTION>\n%s\n</USER_INSTRUCTION>", instruction),
    }

    return {
        { role = "system", content = system_prompt },
        { role = "user",   content = table.concat(user_parts, "\n\n") },
    }
end

local function make_api_provider(BaseProvider, name, cfg)
    local ApiProvider = setmetatable({}, { __index = BaseProvider })
    local endpoint = cfg.endpoint:gsub("/+$", "")

    -- Stub required by 99.extensions.pickers.is_selectable_provider
    function ApiProvider._build_command()
        return {}
    end

    function ApiProvider._get_provider_name()
        return name
    end

    function ApiProvider._get_default_model()
        return provider_models[name] or cfg.default_model or DEFAULT_SENTINEL
    end

    function ApiProvider.fetch_models(callback)
        local cmd = { "curl", "-sS", "--max-time", "5" }
        if cfg.api_key_env then
            local key = os.getenv(cfg.api_key_env)
            if not key or key == "" then
                callback(nil, string.format("%s is not set", cfg.api_key_env))
                return
            end
            vim.list_extend(cmd, { "-H", "Authorization: Bearer " .. key })
        end
        table.insert(cmd, endpoint .. "/models")

        vim.system(cmd, { text = true }, function(obj)
            vim.schedule(function()
                if obj.code ~= 0 then
                    callback(nil, string.format("Failed to fetch models from %s (%s)", name, endpoint))
                    return
                end
                local ok, decoded = pcall(vim.json.decode, obj.stdout or "")
                if not ok or type(decoded) ~= "table" or type(decoded.data) ~= "table" then
                    callback(nil, string.format("Invalid /models response from %s", name))
                    return
                end
                local models = {}
                if not cfg.api_key_env then
                    table.insert(models, DEFAULT_SENTINEL)
                end
                local ids = {}
                for _, m in ipairs(decoded.data) do
                    if type(m) == "table" and type(m.id) == "string" and m.id ~= "" then
                        table.insert(ids, m.id)
                    end
                end
                table.sort(ids)
                vim.list_extend(models, ids)
                callback(models, nil)
            end)
        end)
    end

    function ApiProvider:make_request(query, context, observer)
        observer.on_start()

        local api_key = nil
        if cfg.api_key_env then
            api_key = os.getenv(cfg.api_key_env)
            if not api_key or api_key == "" then
                local msg = string.format("%s: environment variable %s is not set", name, cfg.api_key_env)
                vim.notify("99: " .. msg, vim.log.levels.ERROR)
                observer.on_complete("failed", msg)
                return
            end
        end

        local messages
        if context.operation == "visual" then
            messages = build_api_visual_messages(context, include_harpoon_context)
        else
            messages = {
                { role = "user", content = query },
            }
        end

        local body = {
            messages = messages,
            stream = false,
            temperature = cfg.temperature or 0.2,
            max_tokens = cfg.max_tokens or 8192,
        }

        local model = context.model
        if model and model ~= "" and model ~= DEFAULT_SENTINEL then
            body.model = model
        elseif cfg.default_model and cfg.default_model ~= "" and cfg.default_model ~= DEFAULT_SENTINEL then
            body.model = cfg.default_model
        end

        local payload_path = vim.fn.tempname() .. ".json"
        local encoded = vim.json.encode(body)
        local f, open_err = io.open(payload_path, "w")
        if not f then
            observer.on_complete("failed", "Failed to write request payload: " .. tostring(open_err))
            return
        end
        f:write(encoded)
        f:close()

        local cmd = {
            "curl",
            "-sS",
            "--max-time",
            tostring(cfg.timeout or 120),
            "-X",
            "POST",
            endpoint .. "/chat/completions",
            "-H",
            "Content-Type: application/json",
            "-H",
            "Accept: application/json",
            "--data-binary",
            "@" .. payload_path,
        }
        if api_key then
            vim.list_extend(cmd, { "-H", "Authorization: Bearer " .. api_key })
        end

        local proc = vim.system(
            cmd,
            { text = true },
            vim.schedule_wrap(function(obj)
                pcall(os.remove, payload_path)

                if context:is_cancelled() then
                    observer.on_complete("cancelled", "")
                    return
                end

                if obj.code ~= 0 then
                    local err = string.format("%s request failed (curl exit %d): %s", name, obj.code, obj.stderr or "")
                    vim.notify("99: " .. err, vim.log.levels.ERROR)
                    observer.on_complete("failed", err)
                    return
                end

                local ok_json, decoded = pcall(vim.json.decode, obj.stdout or "")
                if not ok_json or type(decoded) ~= "table" then
                    local err = string.format("%s returned invalid JSON: %s", name, (obj.stdout or ""):sub(1, 200))
                    vim.notify("99: " .. err, vim.log.levels.ERROR)
                    observer.on_complete("failed", err)
                    return
                end

                if decoded.error then
                    local err_msg = type(decoded.error) == "table" and
                        (decoded.error.message or vim.inspect(decoded.error))
                        or tostring(decoded.error)
                    vim.notify(string.format("99 (%s): %s", name, err_msg), vim.log.levels.ERROR)
                    observer.on_complete("failed", err_msg)
                    return
                end

                local choice = type(decoded.choices) == "table" and decoded.choices[1] or nil
                local content = choice and type(choice.message) == "table" and choice.message.content or nil
                if type(content) ~= "string" or vim.trim(content) == "" then
                    local err = string.format("%s returned an empty response", name)
                    vim.notify("99: " .. err, vim.log.levels.ERROR)
                    observer.on_complete("failed", err)
                    return
                end

                local code = strip_code_fences(content)
                observer.on_complete("success", code)
            end)
        )

        context:_set_process(proc)
    end

    return ApiProvider
end

local function make_agy_provider(BaseProvider)
    local AgyProvider = setmetatable({}, { __index = BaseProvider })

    function AgyProvider._build_command(_, query, context)
        local cmd = { "agy", "--mode", "accept-edits" }
        if context.model and context.model ~= "" and context.model ~= DEFAULT_SENTINEL then
            vim.list_extend(cmd, { "--model", context.model })
        end
        vim.list_extend(cmd, { "-p", query })
        return cmd
    end

    function AgyProvider._get_provider_name()
        return "AgyProvider"
    end

    function AgyProvider._get_default_model()
        return provider_models.AgyProvider or DEFAULT_SENTINEL
    end

    function AgyProvider.fetch_models(callback)
        vim.system({ "agy", "models" }, { text = true }, function(obj)
            vim.schedule(function()
                if obj.code ~= 0 then
                    callback(nil, "Failed to fetch models from agy")
                    return
                end
                local models = { DEFAULT_SENTINEL }
                for _, line in ipairs(vim.split(obj.stdout, "\n", { trimempty = true })) do
                    local id = line:match "^([^\t]+)\t"
                    if id and id ~= "" then
                        table.insert(models, id)
                    end
                end
                callback(models, nil)
            end)
        end)
    end

    return AgyProvider
end

local function make_pi_provider(BaseProvider)
    local PiProvider = setmetatable({}, { __index = BaseProvider })

    function PiProvider._build_command(_, query, context)
        local cmd = { "pi", "-p" }
        if context.model and context.model ~= "" and context.model ~= DEFAULT_SENTINEL then
            vim.list_extend(cmd, { "--model", context.model })
        end
        table.insert(cmd, query)
        return cmd
    end

    function PiProvider._get_provider_name()
        return "PiProvider"
    end

    function PiProvider._get_default_model()
        return provider_models.PiProvider or DEFAULT_SENTINEL
    end

    function PiProvider.fetch_models(callback)
        if vim.fn.executable "pi" ~= 1 then
            callback(nil, "pi is not installed in PATH")
            return
        end
        vim.system({ "pi", "--list-models" }, { text = true }, function(obj)
            vim.schedule(function()
                if obj.code ~= 0 then
                    callback(nil, "Failed to fetch models from pi")
                    return
                end
                local models = { DEFAULT_SENTINEL }
                vim.list_extend(models, vim.split(obj.stdout, "\n", { trimempty = true }))
                callback(models, nil)
            end)
        end)
    end

    return PiProvider
end

local function configure_opencode_provider(OpenCodeProvider)
    local orig_build = OpenCodeProvider._build_command
    local orig_fetch = OpenCodeProvider.fetch_models

    function OpenCodeProvider._get_default_model()
        return provider_models.OpenCodeProvider or DEFAULT_SENTINEL
    end

    function OpenCodeProvider._build_command(self, query, context)
        if not context.model or context.model == "" or context.model == DEFAULT_SENTINEL then
            return { "opencode", "run", "--agent", "build", query }
        end
        return orig_build(self, query, context)
    end

    function OpenCodeProvider.fetch_models(callback)
        orig_fetch(function(models, err)
            if err or not models then
                callback(models, err)
                return
            end
            local list = { DEFAULT_SENTINEL }
            vim.list_extend(list, models)
            callback(list, nil)
        end)
    end
end

local function wrap_cli_base_provider(BaseProvider)
    if BaseProvider._wrapped_for_harpoon_context then
        return
    end
    BaseProvider._wrapped_for_harpoon_context = true

    local orig_make_request = BaseProvider.make_request
    function BaseProvider:make_request(query, context, observer)
        if context.operation == "visual" then
            local ok, visual_data = pcall(context.visual_data, context)
            if ok and visual_data and visual_data.buffer then
                local ctx_files = collect_context_files(visual_data.buffer, include_harpoon_context)
                local header = format_context_blocks(ctx_files)
                query = header .. "\n\n" .. query
            end
        end
        return orig_make_request(self, query, context, observer)
    end
end

local function validate_configured_models(_99, providers)
    for name, configured in pairs(provider_models) do
        local provider = providers[name]
        if provider and configured and configured ~= "" and configured ~= DEFAULT_SENTINEL then
            provider.fetch_models(function(models, err)
                if err or not models then
                    return
                end
                if not vim.tbl_contains(models, configured) then
                    vim.notify(
                        string.format("99: Model '%s' not found for %s, falling back to default", configured, name),
                        vim.log.levels.WARN
                    )
                    provider_models[name] = nil
                    if _99.get_provider() == provider then
                        local fallback = provider._get_default_model and provider._get_default_model() or
                            DEFAULT_SENTINEL
                        _99.set_model(fallback)
                    end
                end
            end)
        end
    end
end

function M.visual(with_harpoon)
    include_harpoon_context = with_harpoon ~= false
    return require("99").visual()
end

function M.select_provider()
    local pickers = require "99.extensions.pickers"
    local info = pickers.get_providers()
    vim.ui.select(info.names, {
        prompt = "99: Select Provider (current: " .. info.current .. ")",
    }, function(choice)
        if choice then
            pickers.on_provider_selected(choice, info.lookup)
        end
    end)
end

function M.select_model()
    local pickers = require "99.extensions.pickers"
    pickers.get_models(nil, function(models, current)
        vim.ui.select(models, {
            prompt = "99: Select Model (current: " .. current .. ")",
        }, function(choice)
            if choice then
                pickers.on_model_selected(choice)
            end
        end)
    end)
end

function M.setup()
    local _99 = require "99"
    local BaseProvider = _99.Providers.BaseProvider

    wrap_cli_base_provider(BaseProvider)

    local AgyProvider = make_agy_provider(BaseProvider)
    local PiProvider = make_pi_provider(BaseProvider)
    configure_opencode_provider(_99.Providers.OpenCodeProvider)

    _99.Providers.AgyProvider = AgyProvider
    _99.Providers.PiProvider = PiProvider

    for name, cfg in pairs(api_providers_config) do
        _99.Providers[name] = make_api_provider(BaseProvider, name, cfg)
    end

    _99.setup {
        provider = AgyProvider,
        md_files = { "AGENTS.md" },
    }

    validate_configured_models(_99, _99.Providers)
end

M._strip_code_fences = strip_code_fences
M._collect_context_files = collect_context_files

return M
