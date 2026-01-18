--[[

DotenvTest

Tests for the Dotenv parser module.

--]]

local Dotenv = require("@dotenvluau")

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
end
