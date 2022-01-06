# frozen_string_literal: true

require "rails_helper"

module Trainees
  describe CreateFromDttp do
    include SeedHelper

    let(:api_trainee) { create(:api_trainee) }
    let(:provider) { create(:provider) }
    let(:dttp_trainee) { create(:dttp_trainee, :with_placement_assignment, api_trainee_hash: api_trainee) }

    subject(:create_trainee_from_dttp) { described_class.call(dttp_trainee: dttp_trainee) }

    context "when provider does not exist" do
      it "does not create a trainee" do
        expect {
          create_trainee_from_dttp
        }.not_to change(Trainee, :count)
      end
    end

    context "when dttp_trainee is already imported" do
      let(:dttp_trainee) { create(:dttp_trainee, :with_provider, :with_placement_assignment, state: :imported) }

      it "does not create a trainee" do
        expect {
          create_trainee_from_dttp
        }.not_to change(Trainee, :count)
      end
    end

    context "when placement assignment does not exist" do
      let(:dttp_trainee) { create(:dttp_trainee) }

      it "does not create a trainee" do
        expect {
          create_trainee_from_dttp
        }.not_to change(Trainee, :count)
      end
    end

    context "when the trainee is merged" do
      let(:api_trainee) { create(:api_trainee, merged: true) }
      let(:dttp_trainee) { create(:dttp_trainee, :with_placement_assignment, :with_provider, api_trainee_hash: api_trainee) }

      it "does not create a trainee" do
        expect {
          create_trainee_from_dttp
        }.not_to change(Trainee, :count)
      end
    end

    context "when the trainee is hpitt" do
      let(:dttp_trainee) { create(:dttp_trainee, :with_provider, :with_hpitt_placement_assignment) }

      it "marks the application as non importable" do
        expect {
          create_trainee_from_dttp
        }.to change(Trainee, :count).by(0)
        .and change(dttp_trainee, :state).to("non_importable_hpitt")
      end
    end

    context "when a provider exists" do
      let(:dttp_trainee) { create(:dttp_trainee, :with_placement_assignment, :with_provider, api_trainee_hash: api_trainee) }

      it "creates a trainee" do
        expect {
          create_trainee_from_dttp
        }.to change(Trainee, :count).by(1)
      end

      it "marks the dttp_trainee as imported" do
        expect {
          create_trainee_from_dttp
        }.to change(dttp_trainee, :state).to("imported")
      end

      it "creates a trainee with the dttp_trainee attributes" do
        create_trainee_from_dttp
        trainee = Trainee.last
        expect(trainee.created_from_dttp).to be true
        expect(trainee.first_names).to eq(api_trainee["firstname"])
        expect(trainee.last_name).to eq(api_trainee["lastname"])
        expect(trainee.locale_code).to eq("uk")
        expect(trainee.address_line_one).to eq(api_trainee["address1_line1"])
        expect(trainee.address_line_two).to eq(api_trainee["address1_line2"])
        expect(trainee.town_city).to eq(api_trainee["address1_line3"])
        expect(trainee.postcode).to eq(api_trainee["address1_postalcode"])
        expect(trainee.email).to eq(api_trainee["emailaddress1"])
        expect(trainee.date_of_birth).to eq(Date.parse(api_trainee["birthdate"]))
        expect(trainee.gender).to eq("male")
        expect(trainee.trainee_id).to eq(api_trainee["dfe_traineeid"])
        expect(trainee.nationalities).to be_empty
        expect(trainee.trn).to eq(api_trainee["dfe_trn"].to_s)
        expect(trainee.training_initiative).to eq("now_teach")
        expect(trainee.hesa_id).to eq(api_trainee["dfe_husid"])
      end

      context "when the country is something other than England and has a non-uk postcode" do
        let(:api_trainee) { create(:api_trainee, address1_postalcode: nil, address1_country: "France") }

        it "sets the locale to non_uk" do
          create_trainee_from_dttp
          expect(Trainee.last.locale_code).to eq("non_uk")
        end
      end

      context "when neither address line one or postcode is present" do
        let(:api_trainee) { create(:api_trainee, address1_line1: nil, address1_postalcode: nil) }

        before do
          create_trainee_from_dttp
        end

        it "does not set the local to UK" do
          expect(Trainee.last.locale_code).to be nil
        end

        context "but the country is set to England" do
          let(:api_trainee) do
            create(:api_trainee, address1_line1: nil, address1_postalcode: nil, address1_country: "England")
          end

          it "sets the local to UK" do
            expect(Trainee.last.locale_code).to eq("uk")
          end
        end
      end

      context "when the trainee is on future_teaching_scholars" do
        let(:placement_assignment) do
          create(:dttp_placement_assignment,
                 provider_dttp_id: provider.dttp_id,
                 response: create(:api_placement_assignment,
                                  :with_future_teaching_scholars_initiative))
        end

        let(:dttp_trainee) { create(:dttp_trainee, placement_assignments: [placement_assignment], provider_dttp_id: provider.dttp_id) }

        it "creates a trainee with school_direct_salaried route" do
          create_trainee_from_dttp
          trainee = Trainee.last
          expect(trainee.training_route).to eq(TRAINING_ROUTE_ENUMS[:school_direct_salaried])
          expect(trainee.training_initiative).to eq("future_teaching_scholars")
        end
      end

      context "when the trainee is on an early_years route" do
        let(:dttp_trainee) { create(:dttp_trainee, :with_provider, :with_early_years_route) }

        it "sets the course subject one to early years and age range zero to five" do
          create_trainee_from_dttp
          trainee = Trainee.last
          expect(trainee.course_subject_one).to eq(CourseSubjects::EARLY_YEARS_TEACHING)
          expect(trainee.course_age_range).to eq(AgeRange::ZERO_TO_FIVE)
        end

        context "when the trainee has a grant" do
          let(:placement_assignment) do
            create(:dttp_placement_assignment,
                   provider_dttp_id: provider.dttp_id,
                   response: create(:api_placement_assignment,
                                    :with_early_years_salaried_bursary))
          end

          let(:dttp_trainee) { create(:dttp_trainee, placement_assignments: [placement_assignment], provider_dttp_id: provider.dttp_id) }

          let(:funding_method) { create(:funding_method, training_route: :early_years_salaried, funding_type: FUNDING_TYPE_ENUMS[:grant]) }
          let(:specialism) { create(:subject_specialism, subject_name: CourseSubjects::EARLY_YEARS_TEACHING) }

          before do
            create(:funding_method_subject, funding_method: funding_method, allocation_subject: specialism.allocation_subject)
          end

          it "sets funding" do
            create_trainee_from_dttp
            trainee = Trainee.last
            expect(trainee.applying_for_grant).to eq(true)
          end
        end
      end

      context "when the trainee is not on any initiative" do
        let(:placement_assignment) do
          create(:dttp_placement_assignment,
                 provider_dttp_id: provider.dttp_id,
                 response: create(:api_placement_assignment,
                                  _dfe_initiative1id_value: nil))
        end

        let(:dttp_trainee) { create(:dttp_trainee, placement_assignments: [placement_assignment], provider_dttp_id: provider.dttp_id) }

        it "creates a trainee with no training_initiative" do
          create_trainee_from_dttp
          trainee = Trainee.last
          expect(trainee.training_initiative).to eq(ROUTE_INITIATIVES_ENUMS[:no_initiative])
        end
      end

      context "when the trainee is provider_led_postgrad" do
        let(:placement_assignment) do
          create(:dttp_placement_assignment,
                 provider_dttp_id: provider.dttp_id,
                 response: create(:api_placement_assignment,
                                  :with_provider_led_undergrad,
                                  dfe_courselevel: Dttp::Params::PlacementAssignment::COURSE_LEVEL_PG))
        end

        let(:dttp_trainee) { create(:dttp_trainee, placement_assignments: [placement_assignment], provider_dttp_id: provider.dttp_id) }

        it "creates a trainee with provider_led_postgrad route" do
          create_trainee_from_dttp
          trainee = Trainee.last
          expect(trainee.training_route).to eq(TRAINING_ROUTE_ENUMS[:provider_led_postgrad])
        end
      end

      context "when the trainee is provider_led_undergrad" do
        let(:placement_assignment) do
          create(:dttp_placement_assignment,
                 provider_dttp_id: provider.dttp_id,
                 response: create(:api_placement_assignment,
                                  :with_provider_led_undergrad,
                                  dfe_courselevel: Dttp::Params::PlacementAssignment::COURSE_LEVEL_UG))
        end

        let(:dttp_trainee) { create(:dttp_trainee, placement_assignments: [placement_assignment], provider_dttp_id: provider.dttp_id) }

        it "creates a trainee with provider_led_undergrad route" do
          create_trainee_from_dttp
          trainee = Trainee.last
          expect(trainee.training_route).to eq(TRAINING_ROUTE_ENUMS[:provider_led_undergrad])
        end
      end

      context "when the trainee is in a submitted_for_trn state" do
        let(:placement_assignment) do
          create(:dttp_placement_assignment,
                 provider_dttp_id: provider.dttp_id,
                 response: create(:api_placement_assignment,
                                  _dfe_traineestatusid_value: "275af972-9e1b-e711-80c7-0050568902d3"))
        end

        let(:dttp_trainee) { create(:dttp_trainee, placement_assignments: [placement_assignment], provider_dttp_id: provider.dttp_id) }

        before do
          allow(Dttp::RetrieveTrnJob).to receive(:perform_with_default_delay)
        end

        it "enqueues Dttp::RetrieveTrnJob job" do
          create_trainee_from_dttp
          expect(Dttp::RetrieveTrnJob).to have_received(:perform_with_default_delay).with(Trainee.last)
        end
      end

      context "when the trainee is in a recommended_for_award state" do
        let(:placement_assignment) do
          create(:dttp_placement_assignment,
                 provider_dttp_id: provider.dttp_id,
                 response: create(:api_placement_assignment,
                                  _dfe_traineestatusid_value: "1f5af972-9e1b-e711-80c7-0050568902d3"))
        end

        let(:dttp_trainee) { create(:dttp_trainee, placement_assignments: [placement_assignment], provider_dttp_id: provider.dttp_id) }

        before do
          allow(Dttp::RetrieveAwardJob).to receive(:perform_with_default_delay)
        end

        it "enqueues Dttp::RetrieveAwardJob job" do
          create_trainee_from_dttp
          expect(Dttp::RetrieveAwardJob).to have_received(:perform_with_default_delay).with(Trainee.last)
        end
      end

      context "when the trainee has an invalid TRN" do
        let(:api_trainee) { create(:api_trainee, dfe_trn: "999999999") }

        it "does not save the TRN" do
          create_trainee_from_dttp
          trainee = Trainee.last
          expect(trainee.trn).to be nil
        end
      end

      context "with primary subjects" do
        let(:placement_assignment) do
          create(:dttp_placement_assignment,
                 provider_dttp_id: provider.dttp_id,
                 response: create(:api_placement_assignment,
                                  _dfe_ittsubject1id_value: "8ca12838-b3cf-e911-a860-000d3ab1da01"))
        end

        let(:dttp_trainee) { create(:dttp_trainee, placement_assignments: [placement_assignment], provider_dttp_id: provider.dttp_id) }

        it "sets the course education phase" do
          create_trainee_from_dttp
          trainee = Trainee.last
          expect(trainee.course_education_phase).to eq("primary")
          expect(trainee.course_subject_one).to eq(CourseSubjects::SPECIALIST_TEACHING_PRIMARY_WITH_MATHEMETICS)
        end
      end

      context "with multiple placement_assignments" do
        let(:placement_assignment_one) do
          create(:dttp_placement_assignment,
                 :with_academic_year_twenty_twenty_one,
                 provider_dttp_id: provider.dttp_id,
                 response: create(:api_placement_assignment,
                                  _dfe_ittsubject1id_value: Dttp::CodeSets::CourseSubjects::MODERN_LANGUAGES_DTTP_ID))
        end

        let(:placement_assignment_two) do
          create(:dttp_placement_assignment,
                 :with_academic_year_twenty_one_twenty_two,
                 provider_dttp_id: provider.dttp_id,
                 response: create(:api_placement_assignment,
                                  _dfe_ittsubject1id_value: Dttp::CodeSets::CourseSubjects::MODERN_LANGUAGES_DTTP_ID))
        end

        let(:dttp_trainee) { create(:dttp_trainee, provider: provider, placement_assignments: [placement_assignment_one, placement_assignment_two]) }

        before { dttp_trainee.reload }

        it "sets the course details from the latest placement assignment" do
          create_trainee_from_dttp
          trainee = Trainee.last
          expect(trainee.course_subject_one).to eq(CourseSubjects::MODERN_LANGUAGES)
          expect(trainee.commencement_date).to eq(placement_assignment_two.response["dfe_commencementdate"].to_date)
        end

        it "sets the trainee submitted_for_trn_at date from the first placement assignment" do
          create_trainee_from_dttp
          trainee = Trainee.last
          expect(trainee.submitted_for_trn_at).to eq(placement_assignment_one.response["dfe_trnassessmentdate"].to_date)
        end
      end

      context "with funding information available" do
        let(:api_placement_assignment) do
          create(:dttp_placement_assignment, provider_dttp_id: provider.dttp_id, response: create(:api_placement_assignment, :with_provider_led_bursary))
        end
        let(:dttp_trainee) { create(:dttp_trainee, provider: provider, placement_assignments: [api_placement_assignment]) }

        context "when bursary is NO_BURSARY_AWARDED" do
          let(:api_placement_assignment) do
            create(:dttp_placement_assignment, provider_dttp_id: provider.dttp_id, response: create(:api_placement_assignment, :with_no_bursary_awarded))
          end

          let(:funding_method) { create(:funding_method, training_route: :pg_teaching_apprenticeship, funding_type: FUNDING_TYPE_ENUMS[:scholarship]) }
          let(:specialism) { create(:subject_specialism, subject_name: CourseSubjects::MODERN_LANGUAGES) }

          before do
            create(:funding_method_subject, funding_method: funding_method, allocation_subject: specialism.allocation_subject)
          end

          it "sets bursary to false" do
            create_trainee_from_dttp
            trainee = Trainee.last
            expect(trainee.applying_for_bursary).to eq(false)
          end
        end

        context "when scholarship" do
          let(:api_placement_assignment) do
            create(:dttp_placement_assignment, provider_dttp_id: provider.dttp_id, response: create(:api_placement_assignment, :with_scholarship))
          end
          let(:funding_method) { create(:funding_method, training_route: :provider_led_postgrad, funding_type: FUNDING_TYPE_ENUMS[:scholarship]) }
          let(:specialism) { create(:subject_specialism, subject_name: CourseSubjects::MODERN_LANGUAGES) }

          before do
            create(:funding_method_subject, funding_method: funding_method, allocation_subject: specialism.allocation_subject)
          end

          it "sets scholarship" do
            create_trainee_from_dttp
            trainee = Trainee.last
            expect(trainee.applying_for_scholarship).to eq(true)
          end
        end

        context "when bursary" do
          let(:funding_method) { create(:funding_method, training_route: :provider_led_postgrad, funding_type: FUNDING_TYPE_ENUMS[:bursary]) }
          let(:specialism) { create(:subject_specialism, subject_name: CourseSubjects::MODERN_LANGUAGES) }

          before do
            create(:funding_method_subject, funding_method: funding_method, allocation_subject: specialism.allocation_subject)
          end

          it "sets funding" do
            create_trainee_from_dttp
            trainee = Trainee.last
            expect(trainee.applying_for_bursary).to eq(true)
          end
        end

        context "when multiple funding methods are available" do
          let(:bursary_funding_method) { create(:funding_method, training_route: :provider_led_postgrad, funding_type: FUNDING_TYPE_ENUMS[:bursary]) }
          let(:scholarship_funding_method) { create(:funding_method, training_route: :provider_led_postgrad, funding_type: FUNDING_TYPE_ENUMS[:scholarship]) }
          let(:specialism) { create(:subject_specialism, subject_name: CourseSubjects::MODERN_LANGUAGES) }

          before do
            create(:funding_method_subject, funding_method: bursary_funding_method, allocation_subject: specialism.allocation_subject)
            create(:funding_method_subject, funding_method: scholarship_funding_method, allocation_subject: specialism.allocation_subject)
          end

          it "sets the correct funding" do
            create_trainee_from_dttp
            trainee = Trainee.last
            expect(trainee.applying_for_grant).to eq(nil)
            expect(trainee.applying_for_bursary).to eq(true)
            expect(trainee.applying_for_scholarship).to eq(nil)
          end
        end

        context "when funding method does not exist" do
          it "marks the application as non importable" do
            expect {
              create_trainee_from_dttp
            }.to change(Trainee, :count).by(0)
            .and change(dttp_trainee, :state).to("non_importable_missing_funding")
          end
        end
      end

      context "with tiered bursary funding" do
        let(:api_placement_assignment) do
          create(:dttp_placement_assignment, provider_dttp_id: provider.dttp_id, response: create(:api_placement_assignment, :with_tiered_bursary))
        end
        let(:dttp_trainee) { create(:dttp_trainee, provider: provider, placement_assignments: [api_placement_assignment]) }

        it "sets bursary tier" do
          create_trainee_from_dttp
          trainee = Trainee.last
          expect(trainee.applying_for_bursary).to eq(true)
          expect(trainee.bursary_tier).to eq(BURSARY_TIER_ENUMS[:tier_two])
        end
      end

      context "when nationalities exist" do
        before do
          generate_seed_nationalities
        end

        it "adds the trainee's nationality" do
          create_trainee_from_dttp
          trainee = Trainee.last
          expect(trainee.nationalities.map(&:name)).to match_array(["british"])
        end
      end

      context "when date of birth is blank" do
        let(:api_trainee) { create(:api_trainee, birthdate: "") }

        it "does not set date_of_birth" do
          create_trainee_from_dttp
          trainee = Trainee.last
          expect(trainee.date_of_birth).to be_nil
        end
      end

      context "when gender is other" do
        let(:api_trainee) { create(:api_trainee, gendercode: "389040000") }

        it "maps gender to not provided" do
          create_trainee_from_dttp
          trainee = Trainee.last
          expect(trainee.gender).to eq("gender_not_provided")
        end
      end

      context "when trainee_id is NOTPROVIDED" do
        let(:api_trainee) { create(:api_trainee, dfe_traineeid: "NOTPROVIDED") }

        it "sets the trainee id to blank" do
          create_trainee_from_dttp
          trainee = Trainee.last
          expect(trainee.trainee_id).to be_nil
        end
      end

      context "when trainee already exists" do
        before { create(:trainee, dttp_id: dttp_trainee.dttp_id) }

        it "marks the application as a duplicate" do
          expect {
            create_trainee_from_dttp
          }.to change(Trainee, :count).by(0)
          .and change(dttp_trainee, :state).to("non_importable_duplicate")
        end
      end
    end

    context "when training route is missing" do
      let(:api_placement_assignment) { create(:dttp_placement_assignment, provider_dttp_id: provider.dttp_id, response: create(:api_placement_assignment, _dfe_routeid_value: nil)) }
      let(:dttp_trainee) { create(:dttp_trainee, provider: provider, placement_assignments: [api_placement_assignment]) }

      it "marks the application as non importable" do
        expect {
          create_trainee_from_dttp
        }.to change(Trainee, :count).by(0)
        .and change(dttp_trainee, :state).to("non_importable_missing_route")
      end
    end

    context "when training state is not mapped" do
      let(:api_placement_assignment) { create(:dttp_placement_assignment, provider_dttp_id: provider.dttp_id, response: create(:api_placement_assignment, _dfe_traineestatusid_value: nil)) }
      let(:dttp_trainee) { create(:dttp_trainee, provider: provider, placement_assignments: [api_placement_assignment]) }

      it "marks the application as non importable" do
        expect {
          create_trainee_from_dttp
        }.to change(Trainee, :count).by(0)
        .and change(dttp_trainee, :state).to("non_importable_missing_state")
      end
    end

    context "when placement assignments are from multiple providers" do
      let(:dttp_trainee) { create(:dttp_trainee, :with_provider, placement_assignments: create_list(:dttp_placement_assignment, 2)) }

      it "marks the application as non importable" do
        expect {
          create_trainee_from_dttp
        }.to change(Trainee, :count).by(0)
        .and change(dttp_trainee, :state).to("non_importable_multi_provider")
      end
    end

    context "when placement assignments are having different courses" do
      let(:dttp_trainee) {
        create(:dttp_trainee,
               placement_assignments: create_list(:dttp_placement_assignment,
                                                  2,
                                                  provider_dttp_id: provider.dttp_id),
               provider_dttp_id: provider.dttp_id)
      }

      it "marks the application as non importable" do
        expect {
          create_trainee_from_dttp
        }.to change(Trainee, :count).by(0)
        .and change(dttp_trainee, :state).to("non_importable_multi_course")
      end
    end

    context "when training_initiative is EBACC" do
      let(:api_placement_assignment) { create(:dttp_placement_assignment, provider_dttp_id: provider.dttp_id, response: create(:api_placement_assignment, _dfe_initiative1id_value: Dttp::CodeSets::TrainingInitiatives::EBACC)) }
      let(:dttp_trainee) { create(:dttp_trainee, provider: provider, placement_assignments: [api_placement_assignment]) }

      before do
        create_trainee_from_dttp
      end

      it "sets ebaac to true" do
        expect(Trainee.last.ebacc).to be true
      end

      it "sets no initiative" do
        expect(Trainee.last.training_initiative).to eq(ROUTE_INITIATIVES_ENUMS[:no_initiative])
      end
    end

    context "when training_initiative is not mapped" do
      let(:api_placement_assignment) { create(:dttp_placement_assignment, provider_dttp_id: provider.dttp_id, response: create(:api_placement_assignment, _dfe_initiative1id_value: SecureRandom.uuid)) }
      let(:dttp_trainee) { create(:dttp_trainee, provider: provider, placement_assignments: [api_placement_assignment]) }

      it "marks the application as non importable" do
        expect {
          create_trainee_from_dttp
        }.to change(Trainee, :count).by(0)
        .and change(dttp_trainee, :state).to("non_importable_missing_initiative")
      end
    end
  end
end
