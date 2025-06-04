require "middleman-core"
require "tailwindcss-ruby"
require_relative "tailwind/version"

module Middleman
  module Tailwind
    class Error < StandardError; end

    class Main < Middleman::Extension
      option :config_path, nil, "Custom tailwind.config.js file path"
      option :css_path, nil, "Tailwind source css file path"
      option :destination_path, "source/stylesheets/tailwind.css", "Destination path for tailwind css"
      option :latency, 0.25, "Latency between refreshes when watching"
      option :disable_background_execution, false, "Don't run the command in a separate background thread"
      option :ignore_exit_code, false, "Ignore exit code for restart or stop of a command"

      def initialize(app, options_hash = {}, &block)
        super
        @gem_dir = File.expand_path "../..", __dir__
        @project_dir = Dir.pwd
        @config_path = options.config_path
        @css_path = options.css_path
        @destination_path = options.destination_path
        @current_thread = nil

        return if app.mode?(:config)

        require 'thread'
        require 'fileutils'

        # Ensure destination directory exists
        destination_dir = File.dirname(destination)
        ::FileUtils.mkdir_p(destination_dir)

        # Setup file watcher for the destination directory
        @watcher = app.files.watch :source,
                                   path: destination_dir,
                                   latency: options[:latency],
                                   frontmatter: false

        app.reload(&method(:reload!))
      end

      def application_css
        return File.join(@project_dir, @css_path) if @css_path
        File.join(@gem_dir, "tailwind/application.tailwind.css")
      end

      def destination
        File.join(@project_dir, @destination_path)
      end

      def config_file
        return File.join(@project_dir, @config_path) if @config_path
        File.join(@gem_dir, "tailwind/tailwind.config.js")
      end

      def build_command
        cmd_parts = []
        cmd_parts << "./bin/tailwindcss"
        cmd_parts << "-c #{config_file}" if File.exist?(config_file)
        cmd_parts << "-i #{application_css}"
        cmd_parts << "-o #{destination}"
        cmd_parts << "--minify" if app.build?

        cmd_parts.join(" ")
      end

      def after_configuration
        return if app.mode?(:server)

        logger.info "Building Tailwind CSS..."
        build_css(false)
        @watcher.poll_once! if @watcher
      end

      def ready
        return unless app.mode?(:server)

        logger.info "Building Tailwind CSS..."
        if options[:disable_background_execution]
          build_css(false)
          @watcher.poll_once! if @watcher
        else
          build_css(true)
        end
      end

      def reload!
        if @current_thread
          logger.info "== Stopping Tailwind CSS watch process"
          @current_thread.kill if @current_thread.alive?
          @current_thread = nil
        end
      end

      private

      def build_css(watch_mode = false)
        cmd = build_command
        cmd += " -w" if watch_mode

        logger.info "== Executing: `#{cmd}`"

        if watch_mode && !options[:disable_background_execution]
          @current_thread = Thread.new do
            run_command_with_output(cmd)
          end
        else
          run_command_with_output(cmd)
        end
      rescue => e
        logger.error "== Tailwind CSS: Command failed with message: #{e.message}"
        exit(1) unless options[:ignore_exit_code]
      end

      def run_command_with_output(cmd)
        IO.popen(cmd, 'r') do |io|
          while line = io.gets
            output = line.chomp
            logger.info "== Tailwind CSS: #{output}" unless output.empty?
          end
        end

        exit_status = $?.exitstatus
        if !options[:ignore_exit_code] && exit_status != 0
          logger.error "== Tailwind CSS: Command failed with exit status #{exit_status}"
          exit(1)
        end
      rescue Errno::ENOENT => e
        logger.error "== Tailwind CSS: Command not found. Make sure ./bin/tailwindcss exists and is executable"
        logger.error "== Tailwind CSS: #{e.message}"
        exit(1) unless options[:ignore_exit_code]
      end

      def logger
        app.logger
      end
    end
  end
end

::Middleman::Extensions.register(:tailwind, Middleman::Tailwind::Main)
