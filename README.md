# Dradis Tenable One Export Plugin

Exports Dradis issues into a CSV format designed for the Tenable One Open Connector.

## Features

- Fixed CSV schema for Tenable One ingestion
- Null-safe output
- Field-name fallbacks for common Dradis templates
- Static `Pentest` tag for downstream filtering
- ISO 8601 timestamps for export-derived date fields

## CSV Fields

The exporter produces the following columns:

- Asset Name
- Asset Last Observed At
- Finding First Seen
- Finding Name
- Finding Description
- Finding Generic Details
- Finding Solutions
- Finding Proof
- Finding State
- Severity
- Tags

## Field Mapping

| Tenable One CSV Field | Dradis Source |
|---|---|
| Asset Name | Dradis project name |
| Asset Last Observed At | Export timestamp |
| Finding First Seen | Export timestamp |
| Finding Name | Title, FindingName, Name |
| Finding Description | Description, FindingDescription, Details, Overview |
| Finding Generic Details | Risk and References joined |
| Finding Solutions | Remediation, Solution, Recommendation, Recommendations, Fix |
| Finding Proof | StepsToReproduce, Proof, Evidence, ReproductionSteps, Steps To Reproduce |
| Finding State | Static value: Active |
| Severity | Rating, Severity, RiskRating, Risk Rating |
| Tags | Static value: Pentest |

## Installation

Add the plugin to your `Gemfile.plugins`:

    gem 'dradis-tenable_one_export'

Then run:

    bundle install

Restart Dradis.

## Installation from a Local Path

For local testing:

    gem 'dradis-tenable_one_export', path: '/opt/dradis-tenable_one_export'

Then run:

    bundle install

Restart Dradis.

## Dradis Pro Notes

Before changing plugins in Dradis Pro, back up the plugin file:

    cp Gemfile.plugins Gemfile.plugins.bak

Install or update dependencies:

    bundle install --local
    bundle check

Restart Dradis Pro Puma:

    god restart dradispro-puma
    god status

Confirm the Puma socket exists:

    ls -la /opt/dradispro/dradispro/shared/sockets/

## Uninstall

Remove the plugin line from `Gemfile.plugins`.

Then run:

    bundle install --local
    bundle check

Restart Dradis Pro Puma:

    god restart dradispro-puma
    god status

## Tenable One Open Connector

After export, upload the generated CSV into the Tenable One Open Connector and map the CSV columns to the relevant Tenable fields.

The `Tags` column is populated with `Pentest` to help identify imported penetration test findings downstream.

## Version

Current version: `0.1.0`
