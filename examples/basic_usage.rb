#!/usr/bin/env ruby

require 'langgraph_platform'

# Initialize the client
client = LanggraphPlatform::Client.new(
  api_key: 'fake-api-key',
  base_url: 'http://127.0.0.1:2024'
)

begin
  # Create an assistant
  puts "\nCreating assistant..."
  assistant = client.assistants.create(
    graph_id: 'chat',
    name: 'Example Chat Assistant',
    description: 'A basic chat assistant for demonstration',
    metadata: {
      created_by: 'basic_usage_example',
      version: '1.0'
    }
  )
  puts "Created assistant: #{assistant.assistant_id}"
  puts "Assistant name: #{assistant.name}"
  puts "Assistant description: #{assistant.description}"

  # Create a thread
  puts "\nCreating thread..."
  thread = client.threads.create(
    metadata: { user_id: 'user123', session: 'example' }
  )
  puts "Created thread: #{thread.thread_id}"

  # Create a run using the created assistant
  puts "\nCreating run..."
  run = client.runs.create(
    thread.thread_id,
    assistant_id: assistant.assistant_id,
    input: { message: 'Hello, world!' }
  )
  puts "Created run: #{run.run_id}"
  puts "Initial run status: #{run.status}"

  # Monitor run status until completion or timeout
  puts "\nMonitoring run status..."
  start_time = Time.now
  timeout = 60 # seconds

  while run.status != 'success' && run.status != 'error' && run.status != 'interrupted'
    elapsed = Time.now - start_time
    if elapsed > timeout
      puts "Timeout reached (#{timeout}s). Run status: #{run.status}"
      break
    end

    sleep(1) # Wait 1 second before checking again
    run = client.runs.find(thread.thread_id, run.run_id)
    puts "Run status: #{run.status} (elapsed: #{elapsed.round(1)}s)"
  end

  puts "Final run status: #{run.status}"

  # Get detailed thread state
  puts "\nReading thread state..."
  state = client.threads.state(thread.thread_id)
  puts "Thread state values: #{state.values}"
  puts "Thread state checkpoint: #{state.checkpoint}"
  puts "Thread state metadata: #{state.metadata}"
  puts "Thread state next actions: #{state.next}"
  puts "Thread state created at: #{state.created_at}"

  # List runs for the thread
  puts "\nListing runs for thread..."
  runs = client.runs.list(thread.thread_id)
  puts "Found #{runs.length} runs"
  runs.each do |r|
    puts "  Run #{r.run_id}: #{r.status}"
  end

  # Clean up - delete the assistant
  puts "\nCleaning up..."
  client.assistants.delete(assistant.assistant_id)
  puts "Deleted assistant: #{assistant.assistant_id}"
rescue LanggraphPlatform::Errors::UnauthorizedError => e
  puts "Authentication error: #{e.message}"
  puts 'Please set your API key using the LANGGRAPH_API_KEY environment variable'
rescue LanggraphPlatform::Errors::APIError => e
  puts "API error: #{e.message}"
rescue StandardError => e
  puts "Unexpected error: #{e.message}"
  puts e.backtrace.join("\n")
end
