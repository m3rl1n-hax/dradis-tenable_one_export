require_relative 'gem_version'

module Dradis
  module Plugins
    module TenableOneExport
      # Returns the version of the currently loaded Tenable One exporter as a
      # <tt>Gem::Version</tt>.
      def self.version
        gem_version
      end
    end
  end
end
