# dotenv-luau

A dotenv parser implemented in Luau.

## Installation

Add to your `wally.toml`:

```toml
[dependencies]
Dotenv = "horsenuggets/dotenv-luau@0.1.0"
```

Then run:

```sh
wally install
```

## Usage

### Parsing a string

```luau
local Dotenv = require("@packages/Dotenv")

local env = Dotenv.parse([[
DATABASE_URL=postgres://localhost:5432/mydb
API_KEY="my-secret-key"
DEBUG=true
]])

print(env.DATABASE_URL) -- postgres://localhost:5432/mydb
print(env.API_KEY)      -- my-secret-key
print(env.DEBUG)        -- true
```

### Loading from a file (Lune only)

```luau
local Dotenv = require("@packages/Dotenv")

-- Load from .env file and set environment variables
Dotenv.load()

-- Load from a custom path
Dotenv.load(".env.local")
```

## Features

- Parses standard `.env` file format
- Supports double-quoted and single-quoted values
- Supports multiline values with double quotes
- Handles values containing `=` characters
- Normalizes line endings (CRLF to LF)
- `Dotenv.load()` function for Lune to read files and set `process.env`

## API

### `Dotenv.parse(str: string): { [string]: string }`

Parses a dotenv-formatted string and returns a table of key-value pairs.

### `Dotenv.load(path: string?)`

Reads a `.env` file and sets the values in `process.env`. Only available when running in Lune.

- `path` - Path to the env file (default: `".env"`)
