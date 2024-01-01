# frozen_string_literal: true

require "stackprof"
require_relative "route_middleware/version"

module StackProf
  class RouteMiddleware
    def initialize(app, options = {})
      @app = app
      @options = options

      self.class.mode = options[:mode] || :cpu
      self.class.interval = options[:interval] || 1000
      self.class.raw = options[:raw] || false
      self.class.enabled = options[:enabled]
      options[:path] = "tmp/" if options[:path].to_s.empty?
      self.class.path = options[:path]
      self.class.metadata = options[:metadata] || {}
      self.class.route_calculator = options[:route_calculator]

      warn "StackProf::RouteMiddleware does not support save_every option. It regards save_every is 1." if options[:save_every] && options[:save_every] != 1
      warn "StackProf::RouteMiddleware does not support save_at_exit option." if options[:save_at_exit]
    end

    def call(env)
      enabled = self.class.enabled?(env)
      if enabled
        StackProf.start(
          mode: self.class.mode,
          interval: self.class.interval,
          raw: self.class.raw,
          metadata: self.class.metadata
        )
      end
      @app.call(env)
    ensure
      if enabled
        StackProf.stop
        self.class.save(env)
      end
    end

    class << self
      attr_accessor :enabled, :mode, :interval, :raw, :path, :metadata, :route_calculator

      def enabled?(env)
        if enabled.respond_to?(:call)
          enabled.call(env)
        else
          enabled
        end
      end

      def save(env)
        results = StackProf.results
        return unless results

        raise "Expected path to be directory" if path == path.chomp("/")

        route = route_calculator.call(env)
        return unless route

        filename = "stackprof-#{route.gsub(/\W/, "_")}-#{results[:mode]}-#{Process.pid}-#{Time.now.to_i}.dump"

        FileUtils.mkdir_p(path)
        File.binwrite(File.join(path, filename), Marshal.dump(results))
        filename
      end
    end
  end
end
