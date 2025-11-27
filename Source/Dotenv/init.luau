local fs = require("@lune/fs")
local process = require("@lune/process")

local Dotenv = {}

function Dotenv.parse(str: string): { [string?]: string? }
    str = str:gsub("\r", "")
    if str:sub(-1) ~= "\n" then
        str ..= "\n"
    end

    local env: { [string?]: string? } = {}

    local multiline = false
    local multilineKey = ""
    local multilineValue = ""

    for line in str:gmatch("([^\n]+)\n") do
        local key, value = line:match("(.+)=(.+)")

        if key and value then
            local firstChar = value:sub(1, 1)
            local lastChar = value:sub(#value, #value)

            if firstChar == '"' then
                if lastChar ~= '"' or #value == 1 then
                    multiline = true
                end
            end

            if not multiline then
                value = value:gsub('^"(.*)"$', "%1")
                value = value:gsub("^'(.*)'$", "%1")

                env[key] = value
            else
                value = value:gsub('^"(.*)', "%1")
                multilineKey = key
                multilineValue = value
            end
        elseif multiline then
            local lastChar = line:sub(#line, #line)
            local escapeChar = line:sub(#line - 1, #line - 1)

            if lastChar == '"' and escapeChar ~= "\\" then
                line = line:gsub('(.*)"$', "%1")
                multilineValue = multilineValue .. "\n" .. line

                env[multilineKey] = multilineValue

                multiline = false
                multilineKey = ""
                multilineValue = ""

                continue
            end

            multilineValue = multilineValue .. "\n" .. line
        end
    end

    return env
end

function Dotenv.load(overwrite: boolean?, path: string?)
    local target = path or ".env"

    local success, result = pcall(function()
        return fs.readFile(target)
    end)

    local file: string
    if success then
        file = result
    else
        error(`Dotenv.load failed to read file "{target}". {result}.`)
    end

    local env = Dotenv.parse(file)

    for key, value in env do
        if not process.env[key] or overwrite then
            process.env[key] = value
        end
    end
end

return Dotenv
