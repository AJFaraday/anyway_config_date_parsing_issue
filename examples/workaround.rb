require_relative "../config/configs/workaround_config"

=begin

  workaround.yml includes !!str declaration to force Psych to read the value as a string

    date_string: !!str

  Then in the config file, it's coerced back to a date

    coerce_types date_string: :date

  ---

  This is presented as a valid workaround which doesn't involve monkey patching
  or modifying the library, but I don't like it. It feels clumsy coercing a date
  into a string and then back into a date, and it's not easy to understand why
  the !!str declaration is in the file unless you've investigated this issue in depth.

=end

puts WorkaroundConfig.new.date_string.inspect
