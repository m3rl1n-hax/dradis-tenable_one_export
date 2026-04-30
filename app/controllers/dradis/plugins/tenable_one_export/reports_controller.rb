module Dradis
  module Plugins
    module TenableOneExport
      class ReportsController < Dradis::Plugins::Export::BaseController
        skip_before_action :validate_template

        def create
          exporter = Dradis::Plugins::TenableOneExport::Exporter.new(export_params)
          csv = exporter.export

          send_data csv,
            disposition: 'inline',
            filename: "#{current_project.name.parameterize(separator: '_')}_Findings_#{Time.now.utc.strftime('%d%m%Y')}.csv",
            type: 'text/csv'
        end
      end
    end
  end
end
