#!/usr/bin/env -S lune run

--[[

RunTests

Executes all test suites and exits with appropriate status code.

--]]

local Testable = require("@devpackages/Testable")
local process = require("@lune/process")

local TESTS = {
    { Name = "DotenvTest", Func = require("@tests/DotenvTest.spec") },
}

local function runTests()
    local _, passed = Testable.run(TESTS)
    process.exit(if passed then 0 else 1)
end

runTests()
