--[[

DotenvTest

Tests for the Dotenv parser module.

--]]

local fs = require("@lune/fs")
local process = require("@lune/process")

local Dotenv = require("@dotenvluau")

local function createTempDir(): string
    local tempDir = `.test-temp-{os.clock()}-{math.random(1000, 9999)}`
    fs.writeDir(tempDir)
    return tempDir
end

local function cleanupTempDir(tempDir: string)
    if fs.isDir(tempDir) then
        fs.removeDir(tempDir)
    end
end

return function()
    describe("parse", function()
        it("should parse simple key-value pairs", function()
            local result = Dotenv.parse("FOO=bar\n")
            expect(result.FOO).to.equal("bar")
        end)

        it("should parse multiple key-value pairs", function()
            local result = Dotenv.parse("FOO=bar\nBAZ=qux\n")
            expect(result.FOO).to.equal("bar")
            expect(result.BAZ).to.equal("qux")
        end)

        it("should handle double-quoted values", function()
            local result = Dotenv.parse('FOO="bar baz"\n')
            expect(result.FOO).to.equal("bar baz")
        end)

        it("should handle single-quoted values", function()
            local result = Dotenv.parse("FOO='bar baz'\n")
            expect(result.FOO).to.equal("bar baz")
        end)

        it("should handle multiline values", function()
            local result = Dotenv.parse('FOO="line1\nline2"\n')
            expect(result.FOO).to.equal("line1\nline2")
        end)

        it("should handle values with equals signs", function()
            local result = Dotenv.parse("FOO=bar=baz\n")
            expect(result.FOO).to.equal("bar=baz")
        end)

        it("should handle empty input", function()
            local result = Dotenv.parse("")
            expect(next(result)).to.equal(nil)
        end)

        it("should handle input without trailing newline", function()
            local result = Dotenv.parse("FOO=bar")
            expect(result.FOO).to.equal("bar")
        end)

        it("should handle carriage returns", function()
            local result = Dotenv.parse("FOO=bar\r\nBAZ=qux\r\n")
            expect(result.FOO).to.equal("bar")
            expect(result.BAZ).to.equal("qux")
        end)
    end)

    describe("load", function()
        it("should load environment variables from file", function()
            local tempDir = createTempDir()

            local success, err = pcall(function()
                fs.writeFile(`{tempDir}/.env`, "TEST_VAR_A=hello\nTEST_VAR_B=world\n")

                Dotenv.load(`{tempDir}/.env`)

                expect(process.env.TEST_VAR_A).to.equal("hello")
                expect(process.env.TEST_VAR_B).to.equal("world")
            end)

            cleanupTempDir(tempDir)

            if not success then
                error(err)
            end
        end)

        it("should load from custom path", function()
            local tempDir = createTempDir()

            local success, err = pcall(function()
                fs.writeFile(`{tempDir}/.env.local`, "CUSTOM_VAR=custom_value\n")

                Dotenv.load(`{tempDir}/.env.local`)

                expect(process.env.CUSTOM_VAR).to.equal("custom_value")
            end)

            cleanupTempDir(tempDir)

            if not success then
                error(err)
            end
        end)

        it("should overwrite existing environment variables", function()
            local tempDir = createTempDir()

            local success, err = pcall(function()
                process.env.OVERWRITE_TEST = "original"
                fs.writeFile(`{tempDir}/.env`, "OVERWRITE_TEST=overwritten\n")

                Dotenv.load(`{tempDir}/.env`)

                expect(process.env.OVERWRITE_TEST).to.equal("overwritten")
            end)

            cleanupTempDir(tempDir)

            if not success then
                error(err)
            end
        end)

        it("should handle multiline values from file", function()
            local tempDir = createTempDir()

            local success, err = pcall(function()
                fs.writeFile(`{tempDir}/.env`, 'MULTILINE_VAR="line1\nline2\nline3"\n')

                Dotenv.load(`{tempDir}/.env`)

                expect(process.env.MULTILINE_VAR).to.equal("line1\nline2\nline3")
            end)

            cleanupTempDir(tempDir)

            if not success then
                error(err)
            end
        end)

        it("should error when file does not exist", function()
            expect(function()
                Dotenv.load("/nonexistent/path/.env")
            end).to.throw()
        end)
    end)
end
