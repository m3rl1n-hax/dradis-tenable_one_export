module Dradis::Plugins::TenableOneExport
  class Engine < ::Rails::Engine
    isolate_namespace Dradis::Plugins::TenableOneExport

    include Dradis::Plugins::Base
    provides :export
    description 'Exports all issues mapped to Tenable One Open Connector fields. Author: James Wyatt 2026'

    initializer 'dradis-tenable_one_export.inflections' do |app|
      ActiveSupport::Inflector.inflections do |inflect|
        inflect.acronym('CSV')
      end
    end

    initializer 'dradis-tenable_one_export.mount_engine' do
      Rails.application.routes.append do
        mount Dradis::Plugins::TenableOneExport::Engine => '/', as: :tenable_one_export
      end
    end
  end
end
