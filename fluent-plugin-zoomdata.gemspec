# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = "fluent-plugin-zoomdata"
  gem.version       = "0.0.1"
  gem.authors       = ["Jun Ohtani"]
  gem.email         = ["johtani@gmail.com"]
  gem.description   = %q{Fluentd output plugin to post json to zoomdata}
  gem.summary       = %q{see zoomdata http://www.zoomdata.com}
  gem.homepage      = "https://github.com/johtani/fluent-plugin-zoomdata"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "json"
  gem.add_development_dependency "fluentd"
  gem.add_development_dependency "webmock"
  gem.add_runtime_dependency "fluentd"

end
