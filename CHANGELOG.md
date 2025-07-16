# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2024-01-01

### Added
- Initial release of the LangGraph Platform Ruby SDK
- Complete API client implementation for LangGraph Platform
- Support for all major resources:
  - Assistants (create, read, update, delete, search)
  - Threads (create, read, update, delete, state management)
  - Runs (create, stream, wait, list, cancel)
  - Crons (create, read, update, delete, enable/disable)
  - Store (get, put, delete, list, batch operations)
  - MCP (tools, resources, prompts, logging)
- Server-Sent Events (SSE) streaming support
- Comprehensive error handling with specific error classes
- Request validation and parameter sanitization
- Retry mechanism with exponential backoff
- Configuration management with environment variable support
- Full test suite with RSpec, VCR, and WebMock
- Documentation with YARD
- Usage examples for basic, streaming, and advanced workflows
- Ruby 2.7+ compatibility
- Thread-safe operations
- Zeitwerk autoloading

### Dependencies
- faraday (~> 2.0) - HTTP client
- faraday-net_http (~> 3.0) - HTTP adapter
- multi_json (~> 1.15) - JSON parsing
- zeitwerk (~> 2.6) - Code loading

### Development Dependencies
- rspec (~> 3.12) - Testing framework
- vcr (~> 6.0) - HTTP interaction recording
- webmock (~> 3.18) - HTTP request stubbing
- rubocop (~> 1.50) - Code linting
- yard (~> 0.9) - Documentation generation
- pry (~> 0.14) - Debugging 