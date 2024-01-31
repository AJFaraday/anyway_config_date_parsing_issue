# Date parsing issue with AnywayConfig and Ruby 3.3.0

## Background

I'm in the process of updating a Rails project which uses AnywayConfig extensively to Ruby 3.3.0.
I found this error on initialising a `*Config` class where there was a date value
in the related `*.yml` file.

```
Tried to load unspecified class: Date (Psych::DisallowedClass)
```

It turns out this was before creating the instance of the class, inside AnywayConfig's YAML loader:

```
from /Users/ajfaraday/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/anyway_config-2.3.0/lib/anyway/loaders/yaml.rb:58:in `parse_yml'
```

This seems to be a well documented issue with Psych, where they have presented the option to explicitly
include additional classes to parse from YML in their load methods (e.g. `YAML.load`, `YAML.load_file` and `YAML.safe_load`).

There was, however no convenient way to implement this fix for Anyway, because the load call is buried in the 
YAML loader; `lib/anyway/loaders/yaml.rb`

This repo includes three ruby files demonstrating the issue and how I believe it can be addressed:

* `examples/reproduce_error.rb`
  * This is just a minimal reproduction of the error I'm seeing after the update to ruby 3.3.0
  * config/test.yml contains a date-type value, and the error occurs on `TestConfig.new`
* `examples/fix_with_monkey_patch.rb`
  * This is a possible way to address the issue with a change to the AnywayConfig gem.
  * It solves the issue simply by adding a constant on the `Anyway` module with allowed classes then passing these to the `load` and `load_file` calls.
  * Implementation details might change, but this should allow AnywayConfig to support dates in the same way as previous versions.
* `examples/workaround.rb`
  * This is a workaround which avoids modifying the library.
  * Essentially, the YAML coerces the date value into a string, and the Config class coerces it back into a date.