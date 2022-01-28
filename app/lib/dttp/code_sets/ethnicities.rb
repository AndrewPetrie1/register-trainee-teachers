# frozen_string_literal: true

module Dttp
  module CodeSets
    module Ethnicities
      WHITE = "white"
      SCOTTISH = "scottish"
      INFORMATION_REFUSED = "information_refused"
      INFORMATION_NOT_YET_SOUGHT = "information_not_yet_sought"

      NOT_PROVIDED_ETHNICITIES = [
        Diversities::NOT_PROVIDED,
        INFORMATION_REFUSED,
        INFORMATION_NOT_YET_SOUGHT,
      ].freeze

      WHITE_ETHNICITIES = [
        WHITE,
        SCOTTISH,
      ].freeze

      MAPPING = {
        ::Diversities::AFRICAN => { ethnic_minority: true, entity_id: "c00bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::ANOTHER_ASIAN_BACKGROUND => { ethnic_minority: true, entity_id: "cc0bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::ANOTHER_BLACK_BACKGROUND => { ethnic_minority: true, entity_id: "c20bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::ANOTHER_ETHNIC_BACKGROUND => { ethnic_minority: true, entity_id: "d80bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::ANOTHER_MIXED_BACKGROUND => { ethnic_minority: true, entity_id: "d40bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::ANOTHER_WHITE_BACKGROUND => { ethnic_minority: false, entity_id: "bc0bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::ARAB => { ethnic_minority: true, entity_id: "d60bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::ASIAN_AND_WHITE => { ethnic_minority: true, entity_id: "d20bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::BANGLADESHI => { ethnic_minority: true, entity_id: "c80bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::BLACK_AFRICAN_AND_WHITE => { ethnic_minority: true, entity_id: "d00bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::BLACK_CARIBBEAN_AND_WHITE => { ethnic_minority: true, entity_id: "ce0bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::CARIBBEAN => { ethnic_minority: true, entity_id: "be0bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::CHINESE => { ethnic_minority: true, entity_id: "ca0bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::INDIAN => { ethnic_minority: true, entity_id: "c40bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::IRISH => { ethnic_minority: false, entity_id: "b40bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::IRISH_TRAVELLER => { ethnic_minority: true, entity_id: "b80bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::NOT_PROVIDED => { ethnic_minority: false, entity_id: "da0bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::PAKISTANI => { ethnic_minority: true, entity_id: "c60bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::TRAVELLER_OR_GYPSY => { ethnic_minority: false, entity_id: "ba0bb892-2b9d-e711-80d9-005056ac45bb" },
        ::Diversities::WHITE_BRITISH => { ethnic_minority: false, entity_id: "b20bb892-2b9d-e711-80d9-005056ac45bb" },
      }.freeze

      INACTIVE_MAPPING = {
        WHITE => { entity_id: "b00bb892-2b9d-e711-80d9-005056ac45bb" },
        SCOTTISH => { entity_id: "b60bb892-2b9d-e711-80d9-005056ac45bb" },
        INFORMATION_REFUSED => { entity_id: "dc0bb892-2b9d-e711-80d9-005056ac45bb" },
        INFORMATION_NOT_YET_SOUGHT => { entity_id: "de0bb892-2b9d-e711-80d9-005056ac45bb" },
      }.freeze
    end
  end
end
