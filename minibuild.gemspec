lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minibuild/version'

Gem::Specification.new do |spec|
  spec.name          = 'minibuild'
  spec.version       = Minibuild::VERSION
  spec.authors       = ['Boris Kraportov']
  spec.email         = ['boris.kraportov@gmail.com']

  spec.summary       = 'Build inside docker'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/borisaka/minibuild.rb'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  runtime_dependencies = %w(
    git ~>1.3.0
    docker-api ~>1.32.1
    dry-configurable ~>0.3.0
    ice_nine ~>0.11.2
  )

  dev_dependencies = %w(
    bundler ~>1.13
    rake ~>10.0
    minitest ~>5.0
    yard ~>0.9.5
    pry ~>0.10.4
    pry-rescue ~>1.4.4
    pry-stack_explorer ~>0.4.9
    pry-state ~>0.1.7
    pry-byebug ~>3.4.0
  )

  runtime_dependencies.each_slice(2) do |gem, version|
    spec.add_runtime_dependency gem, version
  end

  dev_dependencies.each_slice(2) do |gem, version|
    spec.add_development_dependency gem, version
  end
  # spec.add_development_dependency 'bundler', '~> 1.13'
  # spec.add_development_dependency 'rake', '~> 10.0'
  # spec.add_development_dependency 'minitest', '~> 5.0'
end
