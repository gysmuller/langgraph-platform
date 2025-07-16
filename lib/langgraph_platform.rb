# frozen_string_literal: true

require 'http'
require 'multi_json'
require 'ostruct'
require 'time'
require 'zeitwerk'
require 'event_stream_parser'

Zeitwerk::Loader.for_gem.setup

module LanggraphPlatform
  class Error < StandardError; end
end
