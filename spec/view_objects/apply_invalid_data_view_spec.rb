# frozen_string_literal: true

require "rails_helper"

describe ApplyInvalidDataView do
  let(:application) do
    instance_double(ApplyApplication, invalid_data: {
      "degrees" => { "BUpwce1Qe9RDM3A9AmgsmaNT" => { "subject" => "Master's Degree" } },
    }.to_json)
  end

  subject { described_class.new(application) }

  describe "#summary_content" do
    context "when there is only one invalid data" do
      it "returns the singular invalid answer summary" do
        expect(subject.summary_content).to eq(
          I18n.t("views.apply_invalid_data_view.invalid_answers_summary", count: 1),
        )
      end
    end

    context "when there are multiple invalid data" do
      let(:application) do
        instance_double(ApplyApplication, invalid_data: {
          "degrees" => { "BUpwce1Qe9RDM3A9AmgsmaNT" => { "subject" => "Master's Degree", "institution" => "University of Warwicks" } },
        }.to_json)
      end

      it "returns the pluralised invalid answer summary" do
        expected_text = I18n.t("views.apply_invalid_data_view.invalid_answers_summary", count: 2)

        expect(subject.summary_content).to eq(expected_text)
      end
    end
  end

  describe "#invalid_data?" do
    subject { described_class.new(application).invalid_data? }

    it { is_expected.to be_truthy }

    context "when there are no invalid data" do
      let(:application) do
        instance_double(ApplyApplication, invalid_data: {
          "degrees" => { "BUpwce1Qe9RDM3A9AmgsmaNT" => {} },
        })
      end

      it { is_expected.to be_falsey }
    end
  end

  describe "#summary_items_content" do
    it "returns the invalid answer summary items" do
      expected_markup = "<li><a class=\"govuk-notification-banner__link\" href=\"#degrees-subject-label\">Subject is not recognised</a></li>"
      expect(subject.summary_items_content).to include(expected_markup)
    end
  end
end
