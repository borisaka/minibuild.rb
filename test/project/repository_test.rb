# frozen_string_literal: true
require 'test_helper'
require 'minibuild/project/repository'
class RepositoryTest < Minitest::Test
  include Minibuild::Project
  def setup
    @repo_url = 'git@github.com:borisaka/repo_4_minibuild.git'
    @git_repo = GitRepository.new(@repo_url)
    @github_repo = GithubRepository.new do |r|
      r.transport = :https
      r.token = '12345'
      r.repo = 'borisaka/repo_4_minibuild'
    end
    @gh_with_token = 'https://12345@github.com/borisaka/repo_4_minibuild.git'
    @gh_https = 'https://github.com/borisaka/repo_4_minibuild.git'
    @gh_ssh = @repo_url
  end

  def test_git_url
    assert_equal @git_repo.url, @repo_url
  end

  def test_gh_https_with_token
    assert_equal @github_repo.url, @gh_with_token
  end

  def test_gh_https
    github_repo = GithubRepository.new do |r|
      r.transport = :https
      r.repo = 'borisaka/repo_4_minibuild'
    end
    assert_equal github_repo.url, @gh_https
  end

  def test_gh_ssh
    github_repo = GithubRepository.new do |r|
      r.transport = :ssh
      r.repo = 'borisaka/repo_4_minibuild'
    end
    assert_equal github_repo.url, @gh_ssh
  end

  def test_gh_wrong_transport
    assert_raises(GithubRepository::WrongGithubTransport) do
      GithubRepository.new { |r| r.transport = :git }
    end
  end
end
