# frozen_string_literal: true

require 'csv'
require 'time'

module Dradis::Plugins::TenableOneExport
  class Exporter < Dradis::Plugins::Export::Base
    HEADERS = [
      'Asset Name',
      'Asset Last Observed At',
      'Finding First Seen',
      'Finding Name',
      'Finding Description',
      'Finding Generic Details',
      'Finding Solutions',
      'Finding Proof',
      'Finding State',
      'Severity',
      'Tags'
    ].freeze

    DEFAULT_TAGS = ['Pentest'].freeze

    FIELD_MAPPINGS = {
      finding_name: ['Title', 'FindingName', 'Name'],
      finding_description: ['Description', 'FindingDescription', 'Details', 'Overview'],
      risk: ['Risk', 'Impact', 'BusinessImpact'],
      references: ['References', 'Reference', 'Links'],
      finding_solutions: ['Remediation', 'Solution', 'Recommendation', 'Recommendations', 'Fix'],
      finding_proof: ['StepsToReproduce', 'Proof', 'Evidence', 'ReproductionSteps', 'Steps To Reproduce'],
      severity: ['Rating', 'Severity', 'RiskRating', 'Risk Rating']
    }.freeze

    def export(_args = {})
      issues = content_service.all_issues

      return "The project didn't contain any issues" if issues.empty?

      export_timestamp = Time.now.utc.iso8601
      asset_name = clean_value(project.name)

      ::CSV.generate do |csv|
        csv << HEADERS

        issues.each do |issue|
          fields = normalise_fields(issue.fields)

          csv << [
            asset_name,
            export_timestamp,
            export_timestamp,
            mapped_value(fields, :finding_name),
            mapped_value(fields, :finding_description),
            generic_details(fields),
            mapped_value(fields, :finding_solutions),
            mapped_value(fields, :finding_proof),
            'Active',
            mapped_value(fields, :severity),
            DEFAULT_TAGS.join(',')
          ]
        end
      end
    end

    private

    def normalise_fields(fields)
      fields.each_with_object({}) do |(key, value), normalised|
        normalised[normalise_key(key)] = clean_value(value)
      end
    end

    def mapped_value(fields, mapping_key)
      FIELD_MAPPINGS.fetch(mapping_key).each do |candidate|
        value = fields[normalise_key(candidate)]
        return value unless value.empty?
      end

      ''
    end

    def generic_details(fields)
      risk = mapped_value(fields, :risk)
      references = mapped_value(fields, :references)

      sections = []
      sections << "Risk:\n\n#{risk}" unless risk.empty?
      sections << "References:\n\n#{references}" unless references.empty?

      sections.join("\n\n")
    end

    def normalise_key(key)
      key.to_s.downcase.gsub(/[^a-z0-9]/, '')
    end

    def clean_value(value)
      value.to_s.gsub(/\r\n?/, "\n").strip
    end
  end
end
