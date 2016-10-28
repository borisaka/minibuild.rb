# frozen_string_literal: true
require 'test_helper'
require 'minibuild/project/control'
class ControlTest < Minitest::Test
  include Minibuild::Project
  def setup
    @control = Control.new do |ctl|
      ctl.setup do |sh|
        sh << 'npm install -g bower'
        sh << 'npm install -g gulp'
      end

      ctl.build do |sh|
        sh << 'gulp biuld'
        sh << 'gulp cleanup'
        sh << 'gulp make'
      end

      ctl.watch('package.json') do |sh|
        sh << 'npm install'
        sh << 'node-gyp rebuild'
      end

      ctl.watch('bower.json') do |sh|
        sh << 'bower install'
      end
    end
  end

  def test_setup_queue
    setup_tasks = []
    setup_tasks << @control.pop(:setup) until @control.empty?(:setup)
    assert_equal setup_tasks, ['npm install -g bower', 'npm install -g gulp']
  end

  def test_build_queue
    build_tasks = []
    build_tasks << @control.pop(:build) until @control.empty?(:build)
    assert_equal build_tasks, ['gulp biuld', 'gulp cleanup', 'gulp make']
  end

  def test_watch_queues
    watch_npm = []
    watch_bower = []
    until @control.empty?(:watch, 'package.json')
      watch_npm << @control.pop(:watch, 'package.json')
    end
    until @control.empty?(:watch, 'bower.json')
      watch_bower << @control.pop(:watch, 'bower.json')
    end
    assert_equal watch_npm, ['npm install', 'node-gyp rebuild']
    assert_equal watch_bower, ['bower install']
  end
end
