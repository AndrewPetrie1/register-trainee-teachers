# frozen_string_literal: true

module Dttp
  module CodeSets
    module AgeRanges
      MAPPING = {
        AgeRange::THREE_TO_ELEVEN => { option: :main, entity_id: "efa15e61-8ec0-e611-80be-00155d010316" },
        AgeRange::FIVE_TO_ELEVEN => { option: :main, entity_id: "22215c74-8ec0-e611-80be-00155d010316" },
        AgeRange::ELEVEN_TO_SIXTEEN => { option: :main, entity_id: "feed86a2-8ec0-e611-80be-00155d010316" },
        AgeRange::ELEVEN_TO_EIGHTEEN => { option: :main, entity_id: "69e663ac-8ec0-e611-80be-00155d010316" }, # this is currently mapped to 11-19 in DTTP as there isn't an option for 11-18 yet.
        # These appear in 'other' dropdown:
        AgeRange::ZERO_TO_FIVE => { option: :additional, entity_id: "4660ff36-3c6d-e711-80d2-005056ac45bb" },
        AgeRange::TWO_TO_SEVEN => { option: :additional, entity_id: "b86eee51-8ec0-e611-80be-00155d010316" }, # currently mapped to 3-7 in DTTP
        AgeRange::TWO_TO_ELEVEN => { option: :additional, entity_id: "efa15e61-8ec0-e611-80be-00155d010316" }, # currently mapped to 3-11 in DTTP
        AgeRange::TWO_TO_NINETEEN => { option: :additional, entity_id: "69e663ac-8ec0-e611-80be-00155d010316" }, # currently mapped to 11-19 in DTTP
        AgeRange::THREE_TO_SEVEN => { option: :additional, entity_id: "b86eee51-8ec0-e611-80be-00155d010316" },
        AgeRange::THREE_TO_EIGHT => { option: :additional, entity_id: "49a9eb3f-5a9c-e711-80d9-005056ac45bb" },
        AgeRange::THREE_TO_NINE => { option: :additional, entity_id: "eea15e61-8ec0-e611-80be-00155d010316" },
        AgeRange::THREE_TO_SIXTEEN => { option: :additional, entity_id: "1a7ee9f5-569c-e711-80d9-005056ac45bb" }, # currently mapped to 7-16 in DTTP
        AgeRange::FOUR_TO_ELEVEN => { option: :additional, entity_id: "22215c74-8ec0-e611-80be-00155d010316" }, # currently mapped to 5-11 in DTTP
        AgeRange::FOUR_TO_NINETEEN => { option: :additional, entity_id: "69e663ac-8ec0-e611-80be-00155d010316" }, # currently mapped to 11-19 in DTTP
        AgeRange::FIVE_TO_NINE => { option: :additional, entity_id: "21215c74-8ec0-e611-80be-00155d010316" },
        AgeRange::FIVE_TO_FOURTEEN => { option: :additional, entity_id: "187ee9f5-569c-e711-80d9-005056ac45bb" },
        AgeRange::FIVE_TO_EIGHTEEN => { option: :additional, entity_id: "187ee9f5-569c-e711-80d9-005056ac45bb" }, # currently mapped to 5-14 in DTTP
        AgeRange::SEVEN_TO_ELEVEN => { option: :additional, entity_id: "fad38a88-8ec0-e611-80be-00155d010316" },
        AgeRange::SEVEN_TO_FOURTEEN => { option: :additional, entity_id: "fbd38a88-8ec0-e611-80be-00155d010316" },
        AgeRange::SEVEN_TO_SIXTEEN => { option: :additional, entity_id: "1a7ee9f5-569c-e711-80d9-005056ac45bb" },
        AgeRange::SEVEN_TO_EIGHTEEN => { option: :additional, entity_id: "1a7ee9f5-569c-e711-80d9-005056ac45bb" }, # currently mapped to 7-16 in DTTP
        AgeRange::NINE_TO_THIRTEEN => { option: :additional, entity_id: "7064d397-8ec0-e611-80be-00155d010316" }, # currently mapped to 9-14 in DTTP
        AgeRange::NINE_TO_FOURTEEN => { option: :additional, entity_id: "7064d397-8ec0-e611-80be-00155d010316" },
        AgeRange::NINE_TO_SIXTEEN => { option: :additional, entity_id: "1c7ee9f5-569c-e711-80d9-005056ac45bb" },
        AgeRange::ELEVEN_TO_NINETEEN => { option: :additional, entity_id: "69e663ac-8ec0-e611-80be-00155d010316" },
        AgeRange::THIRTEEN_TO_EIGHTEEN => { option: :additional, entity_id: "73a86fb7-8ec0-e611-80be-00155d010316" }, # currently mapped to 14-19 in DTTP
        AgeRange::FOURTEEN_TO_EIGHTEEN => { option: :additional, entity_id: "73a86fb7-8ec0-e611-80be-00155d010316" }, # currently mapped to 14-19 in DTTP
        AgeRange::FOURTEEN_TO_NINETEEN => { option: :additional, entity_id: "73a86fb7-8ec0-e611-80be-00155d010316" },
      }.freeze
    end
  end
end
