#!/usr/bin/env ruby

# Streaming events now receive parameters directly from EventStreamParser:
# Block receives: |type, data, id, reconnection_time|
# - type: Event type (e.g., 'messages/partial', 'updates', 'values', 'error')
# - data: Parsed JSON data or raw string
# - id: Event ID (optional)
# - reconnection_time: SSE reconnection time (optional)

require 'langgraph_platform'

# Parse command line arguments
if ARGV.empty?
  puts <<~USAGE
    Usage: ruby streaming_example.rb <stream_mode> [content]

    Arguments:
      stream_mode  - Required: The streaming mode to use
      content      - Optional: Custom message content

    Available stream modes:
      values    - Complete conversation state (default behavior)
      messages  - Content streaming (best for real-time display)
      updates   - Step-by-step execution updates
      multiple  - Combined updates + messages
      tools     - Tool execution with updates mode
      all       - Run all examples (original behavior)

    Examples:
      ruby streaming_example.rb messages
      ruby streaming_example.rb updates "Tell me about Ruby programming"
      ruby streaming_example.rb values "What is machine learning?"
      ruby streaming_example.rb tools "Search for recent AI developments"
  USAGE
  exit 1
end

stream_mode_arg = ARGV[0].downcase
content_arg = ARGV[1] || 'Hello, how are you?'

# Initialize the client
client = LanggraphPlatform::Client.new(
  api_key: 'fake-api-key',
  base_url: 'http://127.0.0.1:2024'
)

def print_with_flush(text)
  print text
  STDOUT.flush
end

def simulate_typing_effect(text, delay: 0.05)
  text.each_char do |char|
    print_with_flush(char)
    sleep(delay)
  end
  puts
end

def run_messages_example(client, thread, content)
  puts "\n" + ('=' * 60)
  puts '🚀 MESSAGES MODE - CONTENT STREAMING'
  puts '=' * 60
  puts 'Demonstrating real-time content streaming:'
  puts "📝 Query: #{content}"
  puts '-' * 50

  last_content_length = 0 # Track how much we've already printed

  client.runs.stream(
    thread.thread_id,
    assistant_id: 'chat',
    input: { messages: [{ role: 'user',
                          content: content }] },
    stream_mode: 'messages'
  ) do |type, data, _id, _reconnection_time|
    case type
    when 'messages/partial'
      # The data is an array with cumulative content
      if data.is_a?(Array) && !data.empty?
        message = data.first
        if message.is_a?(Hash) && message['content']
          current_content = message['content']
          # Only print the new part since last update
          if current_content.length > last_content_length
            new_content = current_content[last_content_length..-1]
            print_with_flush(new_content)
            last_content_length = current_content.length
          end
        end
      end
    when 'messages/complete'
      puts "\n✅ Message complete"
      last_content_length = 0 # Reset for next message
    when 'error'
      puts "\n❌ Error: #{data}"
    else
      # Silently ignore other event types for clean output
    end
  end
  puts "\n💡 This is the best mode for real-time content display!"
end

def run_updates_example(client, thread, content)
  puts "\n" + ('=' * 60)
  puts '🔄 UPDATES MODE - EXECUTION PROGRESS'
  puts '=' * 60
  puts 'Demonstrating step-by-step execution updates:'
  puts "📝 Query: #{content}"
  puts '-' * 50

  client.runs.stream(
    thread.thread_id,
    assistant_id: 'chat',
    input: { messages: [{ role: 'user',
                          content: content }] },
    stream_mode: 'updates'
  ) do |type, data, _id, _reconnection_time|
    case type
    when 'updates'
      if data.is_a?(Hash)
        data.each do |node_name, node_data|
          puts "🔄 Node '#{node_name}' executed"
          next unless node_data.is_a?(Hash) && node_data['messages']

          messages = node_data['messages']
          next unless messages.is_a?(Array) && !messages.empty?

          last_message = messages.last
          puts "   💬 Response: #{last_message['content']}" if last_message.is_a?(Hash) && last_message['content']
        end
      elsif data.is_a?(Array) && !data.empty?
        # Handle case where updates data is also wrapped in array
        message = data.first
        puts "🔄 Update: #{message['content']}" if message.is_a?(Hash) && message['content']
      end
    when 'error'
      puts "❌ Error: #{data}"
    end
  end
  puts "\n💡 This mode shows you exactly when each part of the graph executes!"
end

def run_values_example(client, thread, content)
  puts "\n" + ('=' * 60)
  puts '📊 VALUES MODE - COMPLETE STATE'
  puts '=' * 60
  puts 'Demonstrating complete conversation state (your original experience):'
  puts "📝 Query: #{content}"
  puts '-' * 50

  client.runs.stream(
    thread.thread_id,
    assistant_id: 'chat',
    input: { messages: [{ role: 'user',
                          content: content }] },
    stream_mode: 'values'
  ) do |type, data, _id, _reconnection_time|
    puts "📨 Event Type: #{type}"
    case type
    when 'values'
      puts '   📊 Contains: Complete conversation state'

      # Handle both direct hash and array-wrapped data
      messages = if data.is_a?(Hash) && data['messages']
                   data['messages']
                 elsif data.is_a?(Array) && !data.empty? && data.first.is_a?(Hash)
                   # Handle array-wrapped format
                   [data.first]
                 else
                   []
                 end

      puts "   🔢 Message count: #{messages.length}"
      if messages.last&.is_a?(Hash)
        last_content = messages.last['content']
        puts "   💬 Latest response: #{last_content}" if last_content
      end
    when 'error'
      puts '   ❌ Contains: Error information'
      puts "   📝 Details: #{data}"
    when 'end'
      puts '   🏁 Stream finished'
    else
      puts "   ❓ Unknown event type with data: #{data&.class}"
    end
    puts
  end
  puts "\n💡 This is your original experience - complete state delivered at once!"
end

def run_multiple_example(client, thread, content)
  puts "\n" + ('=' * 60)
  puts '📊 MULTIPLE MODES - UPDATES + MESSAGES'
  puts '=' * 60
  puts 'Combining updates + messages for full visibility:'
  puts "📝 Query: #{content}"
  puts '-' * 50

  last_content_length = 0 # Track content for streaming

  client.runs.stream(
    thread.thread_id,
    assistant_id: 'chat',
    input: { messages: [{ role: 'user',
                          content: content }] },
    stream_mode: %w[updates messages]
  ) do |type, data, _id, _reconnection_time|
    case type
    when 'updates'
      puts "\n🔄 Graph Update: Processing..."
    when 'messages/partial'
      # Handle the array-wrapped data structure
      if data.is_a?(Array) && !data.empty?
        message = data.first
        if message.is_a?(Hash) && message['content']
          current_content = message['content']
          # Only print the new part since last update
          if current_content.length > last_content_length
            if last_content_length == 0
              print_with_flush('💬 ') # Only print prefix for first chunk
            end
            new_content = current_content[last_content_length..-1]
            print_with_flush(new_content)
            last_content_length = current_content.length
          end
        end
      end
    when 'messages/complete'
      puts "\n✅ Response complete"
      last_content_length = 0 # Reset for next message
    when 'error'
      puts "\n❌ Error: #{data}"
    end
  end
  puts "\n💡 Multiple modes give you both execution progress AND content streaming!"
end

def run_tools_example(client, thread, content)
  puts "\n" + ('=' * 60)
  puts '🛠️ TOOLS MODE - WATCHING TOOL EXECUTION'
  puts '=' * 60
  puts 'Watch the AI use tools in real-time:'
  puts "📝 Query: #{content}"
  puts '-' * 50

  client.runs.stream(
    thread.thread_id,
    assistant_id: 'chat',
    input: { messages: [{ role: 'user',
                          content: content }] },
    stream_mode: 'updates'
  ) do |type, data, _id, _reconnection_time|
    case type
    when 'updates'
      if data.is_a?(Hash)
        data.each do |node_name, node_data|
          next unless node_data.is_a?(Hash) && node_data['messages']

          messages = node_data['messages']
          next unless messages.is_a?(Array) && !messages.empty?

          last_message = messages.last
          next unless last_message.is_a?(Hash)

          case last_message['type']
          when 'ai'
            if last_message['tool_calls'] && !last_message['tool_calls'].empty?
              puts '🔧 AI is calling tools...'
              last_message['tool_calls'].each do |tool_call|
                if tool_call.is_a?(Hash) && tool_call['function']
                  function_name = tool_call['function']['name']
                  puts "   └── Using tool: #{function_name}"
                end
              end
            elsif last_message['content'] && !last_message['content'].empty?
              puts "💬 AI Response: #{last_message['content']}"
            end
          when 'tool'
            puts "⚙️  Tool completed: #{last_message['name']}"
          when 'human'
            puts "👤 User: #{last_message['content']}"
          end
        end
      elsif data.is_a?(Array) && !data.empty?
        # Handle array-wrapped data structure
        message = data.first
        if message.is_a?(Hash)
          case message['type']
          when 'ai'
            if message['tool_calls'] && !message['tool_calls'].empty?
              puts '🔧 AI is calling tools...'
              message['tool_calls'].each do |tool_call|
                if tool_call.is_a?(Hash) && tool_call['function']
                  function_name = tool_call['function']['name']
                  puts "   └── Using tool: #{function_name}"
                end
              end
            elsif message['content'] && !message['content'].empty?
              puts "💬 AI Response: #{message['content']}"
            end
          when 'tool'
            puts "⚙️  Tool completed: #{message['name']}"
          when 'human'
            puts "👤 User: #{message['content']}"
          end
        end
      end
    when 'error'
      puts "❌ Error: #{data}"
    end
  end
  puts "\n💡 This mode is perfect for monitoring tool usage and execution flow!"
end

begin
  # Create a thread
  puts "\nCreating thread..."
  thread = client.threads.create(
    metadata: { user_id: 'streaming_user', type: "steaming_#{stream_mode_arg}_example" }
  )
  puts "Created thread: #{thread.thread_id}"

  # Run the appropriate example based on command line argument
  case stream_mode_arg
  when 'messages'
    run_messages_example(client, thread, content_arg)
  when 'updates'
    run_updates_example(client, thread, content_arg)
  when 'values'
    run_values_example(client, thread, content_arg)
  when 'multiple'
    run_multiple_example(client, thread, content_arg)
  when 'tools'
    run_tools_example(client, thread, content_arg)
  when 'all'
    puts "\n🎯 Running all streaming examples with: '#{content_arg}'"
    run_messages_example(client, thread, content_arg)
    run_updates_example(client, thread, content_arg)
    run_values_example(client, thread, content_arg)
    run_multiple_example(client, thread, content_arg)
    run_tools_example(client, thread, content_arg)
  else
    puts "❌ Unknown stream mode: #{stream_mode_arg}"
    puts 'Valid modes: values, messages, updates, multiple, tools, all'
    exit 1
  end

  # Final summary for the specific mode
  puts "\n" + ('=' * 60)
  puts "🎯 SUMMARY FOR #{stream_mode_arg.upcase} MODE"
  puts '=' * 60
rescue LanggraphPlatform::Errors::UnauthorizedError => e
  puts "Authentication error: #{e.message}"
  puts 'Please set your API key using the LANGGRAPH_API_KEY environment variable'
rescue LanggraphPlatform::Errors::APIError => e
  puts "API error: #{e.message}"
rescue StandardError => e
  puts "Unexpected error: #{e.message}"
  puts e.backtrace.join("\n")
end
