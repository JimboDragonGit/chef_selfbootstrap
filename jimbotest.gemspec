
# require_relative 'cookbooks/chef_workstation_initialize/libraries/jimbotest'
# ChefWorkstationInitialize::jimbotest.extend_helpers
# extend ChefWorkstationInitialize::jimbotest

module Jimbobob
  def self.get_all_files_from_folder(folder)
    Dir.new(folder).children.map do |child_path|
      folder_child = File.join(folder, child_path)
      Dir.exist?(folder_child) ? get_all_files_from_folder(folder_child) : ::Dir[::File.dirname(folder_child) + '/*.rb']
    end.flatten
  end
end

Gem::Specification.new do |s|
  s.name          = 'jimbotest'
  s.version       = '0.1.0'
  s.license       = 'MIT'
  s.authors       = ['Jimmy Provencher']
  s.email         = ['maintainers@localhost.local']
  s.homepage      = 'https://localhost.local/jimbotest'
  s.summary       = 'A auto chef bootstrapper and wrapper cookbook to deploy code'
  s.description   = 'Using Chef cookbook style and force any script using it to switch to chef even if it is not install. It will install it tho ;)'

  # all_files       = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  # s.files         = all_files.grep(%r!^(exe|lib|rubocop)/|^.rubocop.yml$!)
  code_folder = 'lib/'
  s.files = Jimbobob.get_all_files_from_folder(code_folder)
  s.require_paths = ['lib/']
  # s.executables   = all_files.grep(%r!^exe/!) { |f| File.basename(f) }
  # s.bindir        = 'exe'

  s.metadata      = {
    # 'source_code_uri' => '/home/git/jimbotest.git/',
    'bug_tracker_uri' => 'https://localhost.local/jimbotest/issues',
    'changelog_uri'   => 'https://localhost.local/jimbotest/releases',
    'homepage_uri'    => s.homepage,
  }

  s.rdoc_options     = ['--charset=UTF-8']
  s.extra_rdoc_files = %w(README.md LICENSE)

  # s.required_ruby_version     = '>= 2.5.0'
  # s.required_rubygems_version = '>= 2.7.0'

  # s.add_runtime_dependency('withlogger', '~> 0.1')

  # s.add_runtime_dependency('colorator',             '~> 1.0')
  # s.add_runtime_dependency('em-websocket',          '~> 0.5')
  # s.add_runtime_dependency('i18n',                  '~> 1.0')
  # s.add_runtime_dependency('jekyll-sass-converter', '>= 2.0', '< 4.0')
  # s.add_runtime_dependency('jekyll-watch',          '~> 2.0')
  # s.add_runtime_dependency('kramdown',              '~> 2.3', '>= 2.3.1')
  # s.add_runtime_dependency('kramdown-parser-gfm',   '~> 1.0')
  # s.add_runtime_dependency('liquid',                '~> 4.0')
  # s.add_runtime_dependency('mercenary',             '>= 0.3.6', '< 0.5')
  # s.add_runtime_dependency('pathutil',              '~> 0.9')
  # s.add_runtime_dependency('rouge',                 '>= 3.0', '< 5.0')
  # s.add_runtime_dependency('safe_yaml',             '~> 1.0')
  # s.add_runtime_dependency('terminal-table',        '>= 1.8', '< 4.0')
  # s.add_runtime_dependency('webrick',               '~> 1.7')
end
