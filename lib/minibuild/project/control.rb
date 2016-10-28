# frozen_string_literal: true
require 'ice_nine'
require 'ice_nine/core_ext/object'
module Minibuild
  module Project
    # Control of docker image building and docker container execution
    # Is stored couple of shell commands to run in image/container context
    # Is 2 queue and custom watcher
    # :setup queue - executes then builds base docker image to build apps
    # it can install .deb packages. setup rvm, nodejs. everithing what you
    # need in builder image
    # :build - executes then container build app. Naturaly is a build commands
    # it can be: gulp build, compile some language or maybe run tests.
    # :watch - watch files in code repo and executes queue of commands if
    # files changed.
    # e.g if package.json updated - runs npm install, or budle install
    # on changes in Gemfile. Normaly it useless to run npm install every build
    class Control
      def initialize
        @setup = Queue.new
        @build = Queue.new
        @watch = {}
        yield self
        deep_freeze
      end

      def setup
        yield @setup
      end

      def build
        yield @build
      end

      def watch(key)
        @watch[key] ||= Queue.new
        yield @watch[key]
      end

      def empty?(queue, key = nil)
        q = instance_variable_get("@#{queue}")
        q.is_a?(Hash) ? q[key].empty? : q.empty?
      end

      def pop(queue, key = nil)
        q = instance_variable_get("@#{queue}")
        q.is_a?(Hash) ? q[key].pop : q.pop
      end
    end
  end
end
