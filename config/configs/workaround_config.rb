require "anyway_config"
require "time"

class WorkaroundConfig < Anyway::Config
  attr_config :date_string
  coerce_types date_string: :date
end
