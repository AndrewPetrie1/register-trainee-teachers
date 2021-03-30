# frozen_string_literal: true

require "rails_helper"

describe CreateOrUpdateConsistencyCheckJob do
  include ActiveJob::TestHelper
  let(:trainee) { create(:trainee) }
  let(:contact) { double({ updated_on: "2021-03-29 16:00:00.000000 +0100" }) }
  let(:placement_assignment) { double({ updated_at: "2021-03-29 16:00:00.000000 +0100" }) }

  subject { described_class.perform_now(trainee) }
  before do
    allow(Dttp::Contacts::Fetch).to receive(:call) { contact }
    allow(Dttp::PlacementAssignments::Fetch).to receive(:call) { placement_assignment }
  end

  describe "#perform" do
    context "when a consistency check does not exist" do
      it "it creates a new consistency check with relative fields" do
        expect { subject }.to change { ConsistencyCheck.count }.from(0).to(1)
      end
    end

    context "when a consistency check does exist" do
      let(:old_consistency_check) do
        create(:consistency_check,
               trainee_id: trainee.id,
               contact_last_updated_at: (Time.zone.now - 1.day),
               placement_assignment_last_updated_at: (Time.zone.now - 1.day))
      end

      it "it will not make duplicate checks" do
        subject
        expect { subject }.to_not(change { ConsistencyCheck.count })
      end

      it "it will update the check" do
        old_consistency_check
        subject
        expect(ConsistencyCheck.where(trainee_id: trainee.id).first.contact_last_updated_at).to eq contact.updated_on
        expect(ConsistencyCheck.where(trainee_id: trainee.id).first.placement_assignment_last_updated_at).to eq placement_assignment.updated_at
      end
    end
  end
end
