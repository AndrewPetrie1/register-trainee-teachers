# frozen_string_literal: true

require "rails_helper"

RSpec.describe Trainees::Filters::View do
  let(:selected_text) { "Selected filters" }
  let(:result) { render_inline described_class.new(filters) }

  context "when no filters are applied" do
    let(:filters) { nil }

    it "all of the checkboxes are unchecked" do
      expect(result.css("#record_type-assessment_only").attr("checked")).to eq(nil)
      expect(result.css("#record_type-provider_led").attr("checked")).to eq(nil)
    end

    it "does not show a 'Selected filters' dialogue" do
      expect(result.text).not_to include(selected_text)
    end
  end

  context "when a subject has been pre-selected" do
    let(:filters) { { subject: "Business studies" }.with_indifferent_access }

    it "retains the input" do
      selected_value = result.css('#subject option[@selected="selected"]').attr("value").value
      expect(selected_value).to eq("Business studies")
    end

    it "shows a 'Selected filters' dialogue" do
      expect(result.text).to include(selected_text)
    end
  end
end
