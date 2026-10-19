# Build a distributable from project files, excluding local repository metadata.
# The historical gemspec scans hidden files too, so apply a package allowlist here
# before building the gem. Run from any directory with ruby path/to/build-gem.rb.
require 'rubygems/package'

Dir.chdir(File.expand_path('..', __dir__)) do
  specification = Gem::Specification.load('vagrant-hanewin-nfs.gemspec')
  abort 'Could not load gem specification' unless specification
  specification.files = Dir['lib/**/*', 'locales/**/*', 'spec/**/*', 'scripts/build-gem.rb',
                            'README.md', 'LICENSE', 'CHANGELOG',
                            'Gemfile', 'Rakefile', '*.gemspec', '.gitignore'].select { |path| File.file?(path) }
  Gem::Package.build(specification)
end
