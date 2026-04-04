# Changelog

## 0.1.5
- Remove .luaurc from Wally package to fix transitive dependency resolution
- Bump dependencies and update submodules

## 0.1.4
- Standardized test runner with code coverage
- Included .luaurc in Wally package
- Updated tooling: lune 0.10.4-horse.13.0, luau-lsp 1.63.0-horse.1.4, rojo 7.7.0-rc.1-horse.0.6
- Added branch name validation to CI
- Fixed .luaurc lune typedef version

## 0.1.3
- Synced project configuration with luau-package-template
- Updated luau-lsp to horsenuggets fork 1.63.0-horse.1.0
- Updated lune to 0.10.4-horse.10.0
- Removed branch name validation from CI
- Removed Roblox globals from .luaurc

## 0.1.2
- Added runtime typechecking to parse and load functions using t library

## 0.1.1
- Added Wally publishing to release workflow

## 0.1.0
- Added CI workflows for PRs to main and release branches
- Added test filtering by name to RunTests script
- Added comprehensive tests for Dotenv.load with temp directory isolation
- Added t dependency for runtime typechecking
- Added Testable dev-dependency for testing framework
- Fixed parser to correctly handle values containing equals signs
- Simplified Dotenv.load to always overwrite environment variables
- Synced project structure with luau-package-template
- Expanded README with installation and usage documentation

## 0.0.2
- Initial public release

## 0.0.1
- Initial release
