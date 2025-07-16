# LangGraph Platform Ruby SDK

An unoffical Ruby SDK for interacting with the [LangGraph Platform API](https://langchain-ai.github.io/langgraph/cloud/reference/api/api_ref.html). This gem provides a Ruby-idiomatic interface for managing assistants, threads, runs, crons, store operations, and Model Context Protocol (MCP) interactions.

## Current Status

This is a work in progress. The SDK is not yet complete and fully tested.

## Roadmap

- [x] Assistants
- [x] Threads
- [x] Runs
- [ ] Crons
- [ ] Store Operations
- [ ] Model Context Protocol (MCP)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'langgraph-platform'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install langgraph-platform
```

## Quick Start

```ruby
require 'langgraph_platform'

# Initialize the client
client = LanggraphPlatform::Client.new(
  api_key: 'your-api-key-here',
  base_url: 'https://api.langchain.com' # For local development, use http://127.0.0.1:2024
)

# Create an assistant
assistant = client.assistants.create(
  graph_id: 'my-graph',
  name: 'My Assistant',
  config: { recursion_limit: 10 }
)

# Create a thread
thread = client.threads.create(
  metadata: { user_id: 'user123' }
)

# Run the assistant
run = client.runs.create(
  thread.thread_id,
  assistant_id: assistant.assistant_id,
  input: { message: 'Hello, world!' }
)

puts "Run status: #{run.status}"
```

## Configuration

### Environment Variables

The SDK can be configured using environment variables:

- `LANGGRAPH_API_KEY`: Your LangGraph Platform API key (use fake-api-key for local development)
- `LANGGRAPH_BASE_URL`: Custom base URL (defaults to `https://api.langchain.com`)

### Client Configuration

```ruby
client = LanggraphPlatform::Client.new(
  api_key: 'your-api-key',
  base_url: 'https://custom-api.example.com',
  timeout: 30,
  retries: 3
)

# Or configure after initialization
client.configure do |config|
  config.timeout = 60
  config.retries = 5
end
```

## Features

### Assistants

```ruby
# Create an assistant
assistant = client.assistants.create(
  graph_id: 'my-graph',
  name: 'My Assistant',
  config: { recursion_limit: 10 },
  metadata: { version: '1.0' }
)

# Find an assistant
assistant = client.assistants.find('assistant-id')

# Search assistants
assistants = client.assistants.search(
  metadata: { version: '1.0' },
  limit: 10
)

# Update an assistant
client.assistants.update('assistant-id', name: 'Updated Name')

# Delete an assistant
client.assistants.delete('assistant-id')
```

### Threads

```ruby
# Create a thread
thread = client.threads.create(
  metadata: { user_id: 'user123' }
)

# Get thread state
state = client.threads.state(thread.thread_id)

# Update thread state
client.threads.update_state(
  thread.thread_id,
  values: { key: 'value' }
)

# Get thread history
history = client.threads.history(thread.thread_id, limit: 10)

# Search threads
threads = client.threads.search(
  status: 'idle',
  limit: 10
)
```

### Runs

```ruby
# Create a run
run = client.runs.create(
  thread.thread_id,
  assistant_id: assistant.assistant_id,
  input: { message: 'Hello!' }
)

# Create a run with webhook
run = client.runs.create(
  thread.thread_id,
  assistant_id: assistant.assistant_id,
  input: { message: 'Hello!' },
  webhook: 'https://your-app.com/webhooks/langgraph'
)

# Stream a run
client.runs.stream(
  thread.thread_id,
  assistant_id: assistant.assistant_id,
  input: { message: 'Hello!' }
) do |type, data, id, reconnection_time|
  puts "Event: #{type}, Data: #{data}"
end

# Stream a run with webhook
client.runs.stream(
  thread.thread_id,
  assistant_id: assistant.assistant_id,
  input: { message: 'Hello!' },
  webhook: 'https://your-app.com/webhooks/langgraph'
) do |type, data, id, reconnection_time|
  puts "Event: #{type}, Data: #{data}"
end

# Wait for a run to complete
result = client.runs.wait(
  thread.thread_id,
  assistant_id: assistant.assistant_id,
  input: { message: 'Hello!' }
)

# Wait for a run with webhook
result = client.runs.wait(
  thread.thread_id,
  assistant_id: assistant.assistant_id,
  input: { message: 'Hello!' },
  webhook: 'https://your-app.com/webhooks/langgraph'
)

# List runs
runs = client.runs.list(thread.thread_id)

# Cancel a run
client.runs.cancel(thread.thread_id, run.run_id)
```

### Crons

**Under development and untested.**

```ruby
# Create a cron job
cron = client.crons.create(
  assistant_id: assistant.assistant_id,
  schedule: '0 */6 * * *', # Every 6 hours
  payload: { task: 'periodic_task' }
)

# List cron jobs
crons = client.crons.list(assistant_id: assistant.assistant_id)

# Enable/disable cron jobs
client.crons.enable(cron.cron_id)
client.crons.disable(cron.cron_id)
```

### Store Operations

**Under development and untested.**

```ruby
# Store data
client.store.put('namespace', 'key', { data: 'value' })

# Retrieve data
item = client.store.get('namespace', 'key')

# List items in namespace
items = client.store.list('namespace', prefix: 'user_')

# Delete data
client.store.delete('namespace', 'key')

# Batch operations
client.store.batch_put([
  { namespace: 'ns1', key: 'key1', value: 'value1' },
  { namespace: 'ns1', key: 'key2', value: 'value2' }
])
```

### Model Context Protocol (MCP)

**Under development and untested.**

```ruby
# List available tools
tools = client.mcp.list_tools

# Call a tool
result = client.mcp.call_tool(
  'tool_name',
  arguments: { param: 'value' }
)

# List resources
resources = client.mcp.list_resources

# Read a resource
content = client.mcp.read_resource('resource://example')

# Work with prompts
prompts = client.mcp.list_prompts
result = client.mcp.complete_prompt('prompt_name', arguments: {})
```

## Webhooks

The SDK supports webhooks that are called after LangGraph API calls complete. Webhooks can be used with any run creation method:

```ruby
# Thread-based runs with webhooks
run = client.runs.create(
  thread.thread_id,
  assistant_id: assistant.assistant_id,
  input: { message: 'Process this data' },
  webhook: 'https://your-app.com/webhooks/langgraph'
)

# Stateless runs with webhooks
client.runs.create_stateless(
  assistant_id: assistant.assistant_id,
  input: { message: 'Process this data' },
  webhook: 'https://your-app.com/webhooks/langgraph'
)

# Streaming runs with webhooks
client.runs.stream(
  thread.thread_id,
  assistant_id: assistant.assistant_id,
  input: { message: 'Process this data' },
  webhook: 'https://your-app.com/webhooks/langgraph'
) do |type, data, id, reconnection_time|
  # Handle streaming events
end
```

**Webhook Requirements:**
- Must be a valid URI (up to 65,536 characters)
- Should handle HTTP POST requests from LangGraph Platform
- Called after the API call completes

## Streaming

The SDK supports Server-Sent Events (SSE) streaming for real-time responses. Streaming blocks receive four parameters directly from the SSE parser:

- `type`: Event type (e.g., 'messages/partial', 'updates', 'values', 'error')
- `data`: Parsed JSON data or raw string content
- `id`: Event ID (optional)
- `reconnection_time`: SSE reconnection time in milliseconds (optional)

```ruby
client.runs.stream(
  thread.thread_id,
  assistant_id: assistant.assistant_id,
  input: { message: 'Tell me a story' }
) do |type, data, id, reconnection_time|
  case type
  when 'data'
    puts "Data: #{data}"
  when 'message'
    puts "Message: #{data}"
  when 'error'
    puts "Error: #{data}"
  when 'end'
    puts "Stream ended"
  end
end
```

## Error Handling

The SDK provides specific error classes for different API errors:

```ruby
begin
  assistant = client.assistants.find('nonexistent-id')
rescue LanggraphPlatform::Errors::NotFoundError => e
  puts "Assistant not found: #{e.message}"
rescue LanggraphPlatform::Errors::UnauthorizedError => e
  puts "Authentication failed: #{e.message}"
rescue LanggraphPlatform::Errors::APIError => e
  puts "API error: #{e.message}"
end
```

Available error classes:
- `LanggraphPlatform::Errors::APIError` - Base error class
- `LanggraphPlatform::Errors::BadRequestError` - 400 errors
- `LanggraphPlatform::Errors::UnauthorizedError` - 401 errors
- `LanggraphPlatform::Errors::NotFoundError` - 404 errors
- `LanggraphPlatform::Errors::ConflictError` - 409 errors
- `LanggraphPlatform::Errors::ValidationError` - 422 errors
- `LanggraphPlatform::Errors::ServerError` - 500+ errors

## Examples

Check out the `examples/` directory for more comprehensive examples:

- `examples/basic_usage.rb` - Basic CRUD operations
- `examples/streaming_example.rb` - Streaming functionality

## Development

To run the tests:

```bash
$ bundle exec rspec
```

To run RuboCop:

```bash
$ bundle exec rubocop
```

## Acknowledgments

- Thanks to the LangGraph team for their work on the SDKs and for providing the API reference.
- Thanks to the Shopify team for [event_stream_parser gem](https://github.com/shopify/event_stream_parser).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gysmuller/langgraph-platform.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes. 