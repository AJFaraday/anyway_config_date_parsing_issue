require_relative "../config/configs/test_config"
require "time"

=begin

  This monkey-patched version represents what I believe would be an appropriate fix
  for this issue within the AnywayConfig library. Here's how it works:

  The most minimal reproduction of this issue (without Anyway) looks like this:

    YAML.load("1988-08-03")

  The Psych library allows users to work around this by passing permitted classes directly
  to the `load` call, or similar calls such as `load_file` or `safe_load`

    YAML.load("1988-08-03", permitted_classes: [Date])

  Note: This is additive, and does not prevent existing permitted classes.

  ---

  The solution I've suggested here is to set a global piece of config for allowed classes,
  and modify the YAML loader to pass this to the `load` and `load_file` calls.

=end

# Add a global setting which can be modified to include any required classes
Anyway::PERMITTED_CLASSES = [Date]

class Anyway::Loaders::YAML < Anyway::Loaders::Base
  def parse_yml(path)
    return {} unless File.file?(path)
    require "yaml" unless defined?(::YAML)

    # Pass Anyway::PERMITTED_CLASSES to all uses of `load` or `load_file`
    begin
      if defined?(ERB)
        ::YAML.load(ERB.new(File.read(path)).result, aliases: true, permitted_classes: Anyway::PERMITTED_CLASSES) || {}
      else
        ::YAML.load_file(path, aliases: true, permitted_classes: Anyway::PERMITTED_CLASSES) || {}
      end
    rescue ArgumentError
      if defined?(ERB)
        ::YAML.load(ERB.new(File.read(path)).result, permitted_classes: Anyway::PERMITTED_CLASSES) || {}
      else
        ::YAML.load_file(path, permitted_classes: Anyway::PERMITTED_CLASSES) || {}
      end
    end
  end

  alias_method :load_base_yml, :parse_yml
  alias_method :load_local_yml, :parse_yml
end

puts TestConfig.new.date_value.inspect
