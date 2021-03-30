# frozen_string_literal: true

FactoryBot.define do
  factory :consistency_check do
    trainee_id { 1 }
    contact_last_updated_at { "2021-03-25 16:04:59" }
    placement_assignment_last_updated_at { "2021-03-25 16:04:59" }
  end
end
