# frozen_string_literal: true
require 'ice_nine'
require 'ice_nine/core_ext/object'
module Minibuild
  module Project
    # Simple git repository class
    # initialized with full url to repo
    # @todo URL validation
    # @todo forbid git:// protocol (insecureness)
    # @!attribute [r] url
    #   @return [String] full url to git repository. given at constructor
    class GitRepository
      attr_reader :url
      # @param url [String] repository url
      def initialize(url)
        @url = url
      end
    end

    # Github repository class
    # @!attribute [w] repo
    #   accepts repository github short link e.g. my-company/my-repo
    #   @return [String] @repo
    # @!attribute [w] token
    #   github personal access token
    #   see {https://github.com/blog/1509-personal-api-tokens}
    #   @param [String] token
    #   @return [String] @token
    # @!attribute [w] host
    #   defaults to `github.com`
    #   @return [String] @host
    #   for github enterprise users
    class GithubRepository
      GITHUB_TRANSPORTS = %i(https ssh).freeze

      attr_writer :repo, :token, :host
      # Error wrong transport protocol
      class WrongGithubTransport < StandardError
        def message
          "only #{GITHUB_TRANSPORTS} allowed for now"
        end
      end

      # @yieldparam [GithubRepository] self to user set attributes manualy
      # @note freeze self after initialization
      # @example
      #   GithubRepository.new do |repo|
      #     r.transport = :https
      #     r.token = ACCESS_TOKEN
      #     r.repo = 'my-company/my-repo'
      #   end
      def initialize
        @transport = :https
        @host = 'github.com'
        yield self
        deep_freeze
      end

      # @param [String] transport must be one of GITHUB_TRANSPORTS
      # @return [String] @transport
      # @raise [WrongGithubTransport] if transport not allowed
      def transport=(transport)
        raise WrongGithubTransport \
          unless GITHUB_TRANSPORTS.include?(transport.to_sym)
        @transport = transport
      end

      # @return [String]
      #   full url to github
      # @example
      #   # SSH
      #   repo = GitRepository.new do |r|
      #     r.transport = :ssh
      #     r.repo = 'my-org/my-repo'
      #   end
      #   repo.url
      #   => git@github.com:my-org/my-repo # :ssh
      # @example
      #   # HTTPS with access_token
      #   repo = GitRepository.new do |r|
      #     r.transport = :https
      #     r.token = ACCESS_TOKEN
      #     r.repo = 'my-org/my-repo'
      #   end
      #   repo.url
      #   => https://ACCESS_TOKEN@github.com/my-org/my-repo.git
      # @example
      #   # Just HTTPS
      #   repo = GitRepository.new do |r|
      #     r.transport = :https
      #     r.repo = 'my-org/my-repo'
      #   end
      #   repo.url
      #   => https://github.com/my-org/my-repo.git
      def url
        if @transport == :ssh
          "git@#{@host}:#{@repo}.git"
        elsif @token
          "https://#{@token}@#{@host}/#{@repo}.git"
        else
          "https://#{@host}/#{@repo}.git"
        end
      end
    end
  end
end
