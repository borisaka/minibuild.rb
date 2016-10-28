require 'minibuild/version'
require 'dry-configurable'
require 'git'

module Minibuild
  extend Dry::Configurable
  setting :projects_dir, 'projects'
end
