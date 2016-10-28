# frozen_string_literal: true
module Minibuild
  module Project
    class Project
      def initialize
        @declared_env = :global
        yield self
      end

      def setup
        @commands_for = :setup
        yield
      end

      def watch(pattern)
        raise 'Cannot watch nil' if pattern.nil?
        @commands_for = :watch
        @watcher = pattern
        yield
        @commands_for = nil
        @watcher = nil
      end

      def build
        @commands_for = :build
        yield
        @commands_for = nil
      end

      def export
        @dir_mode = :export
        yield
        @dir_mode = nil
      end

      def shared
        @dir_mode = :shared
        yield
        @dir_mode = nil
      end

      def env(env_name)
        @declared_env = env_name
        yield
        @declared_env = :global
      end

      def repo
      end
    end
  end
end
