require_relative "../config/configs/test_config"

=begin
  There is an error when Psych is reading a yml file with a date value,
  this occurs on initialising an AnywayConfig class, on parsing the file.

  /Users/ajfaraday/.asdf/installs/ruby/3.1.2/lib/ruby/3.1.0/psych/class_loader.rb:99:in `find': Tried to load unspecified class: Date (Psych::DisallowedClass)
  ...
  from /Users/ajfaraday/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/anyway_config-2.3.0/lib/anyway/loaders/yaml.rb:58:in `parse_yml'
  ...
	from /Users/ajfaraday/work/anyway_config_date_parsing_issue/examples/reproduce_error.rb:16:in `new'

  Note: Only discovered after updating to ruby 3.3.0
=end

TestConfig.new
