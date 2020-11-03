module PageObjects
  module Trainees
    class New < PageObjects::Base
      set_url "/trainees/new"

      element :page_heading, ".govuk-heading-xl"

      element :assessment_only, "#trainee-record-type-assessment-only-field"
      element :other, "#trainee-record-type-other-field"
      element :trainee_id_input, "#trainee-trainee-id-field"

      element :continue_button, 'input.govuk-button[type="submit"]'
    end
  end
end
