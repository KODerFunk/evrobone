require 'evrobone/version'

module Evrobone
  if defined?(Rails)
    class Engine < ::Rails::Engine
      # Rails -> use app/assets directory.
    end
  end
end
