# frozen_string_literal: true

require "rails_helper"

module ApplyApplications
  describe TraineeDataForm, type: :model do
    subject { described_class.new(trainee) }

    describe "validations" do
      context "when one or more of the forms is invalid" do
        let(:trainee) { create(:trainee, :with_apply_application) }

        before do
          subject.valid?
        end

        it "returns the entire form as invalid" do
          expect(subject.progress).to eq false
          expect(subject.errors).not_to be_empty
        end
      end

      context "when all of the forms are valid" do
        let(:trainee) { create(:trainee, :with_apply_application, :completed) }

        it "returns the entire form as invalid" do
          expect(subject.progress).to eq true
          expect(subject.errors).to be_empty
        end
      end
    end
  end
end
