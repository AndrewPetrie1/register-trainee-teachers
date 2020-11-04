module Trainees
  module Confirmation
    module Diversity
      class View < GovukComponent::Base
        include SanitizeHelper

        attr_accessor :trainee

        def initialize(trainee:)
          @trainee = trainee
        end

        def diversity_information_rows
          rows = [
            {
              key: "Diversity information",
              value: I18n.t("components.confirmation.diversity.diversity_disclosure.#{trainee.diversity_disclosure}"),
              action: govuk_link_to('Change<span class="govuk-visually-hidden"> diversity information</span>'.html_safe,
                                    edit_trainee_diversity_disclosure_path(trainee.id)),
            },
          ]

          if trainee.diversity_disclosure == "diversity_disclosed"
            rows << {
              key: "Ethnicity",
              value: ethnic_group_content,
              action: govuk_link_to('Change<span class="govuk-visually-hidden"> ethnicity</span>'.html_safe,
                                    edit_trainee_diversity_ethnic_group_path(trainee.id)),
            }

            rows << {
              key: "Disability",
              value: tag.p(disability_selection, class: "govuk-body") + selected_disability_options,
              action: govuk_link_to('Change<span class="govuk-visually-hidden"> disability</span>'.html_safe,
                                    edit_trainee_diversity_disability_disclosure_path(trainee.id)),
            }
          end
          rows
        end

        def ethnic_group_content
          value = I18n.t("components.confirmation.diversity.ethnic_groups.#{trainee.ethnic_group}")

          if trainee.ethnic_background.present? && trainee.ethnic_background != Diversities::NOT_PROVIDED_VALUE
            value += " (#{trainee.ethnic_background})"
          end
          value
        end

        def disability_selection
          if trainee.disabled?
            "They shared that they’re disabled"
          elsif trainee.not_disabled?
            "They shared that they’re not disabled"
          else
            "Not provided"
          end
        end

        def selected_disability_options
          return "" if trainee.disabilities.blank?

          disabilities = trainee.disabilities.map { |disability| disability.name.titleize }

          selected = tag.p("Disabilities shared:", class: "govuk-body")

          selected + sanitize(tag.ul(class: "govuk-list govuk-list--bullet") do
            disabilities.each do |disability|
              concat tag.li(disability)
            end
          end)
        end
      end
    end
  end
end
