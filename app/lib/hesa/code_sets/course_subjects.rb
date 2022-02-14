# frozen_string_literal: true

module Hesa
  module CodeSets
    module CourseSubjects
      # https://www.hesa.ac.uk/collection/c21053/xml/c21053/c21053codelists.xsd
      # https://www.hesa.ac.uk/collection/c21053/e/sbjca
      MAPPING = {
        "101117" => ::CourseSubjects::ANCIENT_HEBREW,
        "100343" => ::CourseSubjects::APPLIED_BIOLOGY,
        "101038" => ::CourseSubjects::APPLIED_CHEMISTRY,
        "100358" => ::CourseSubjects::APPLIED_COMPUTING,
        "101060" => ::CourseSubjects::APPLIED_PHYSICS,
        "101192" => ::CourseSubjects::ARABIC_LANGUAGES,
        "100346" => ::CourseSubjects::BIOLOGY,
        "100078" => ::CourseSubjects::BUSINESS_MANAGEMENT,
        "100079" => ::CourseSubjects::BUSINESS_STUDIES,
        "100417" => ::CourseSubjects::CHEMISTRY,
        "100456" => ::CourseSubjects::CHILD_DEVELOPMENT,
        "101165" => ::CourseSubjects::CHINESE_LANGUAGES,
        "101126" => ::CourseSubjects::CLASSICAL_GREEK_STUDIES,
        "100300" => ::CourseSubjects::CLASSICAL_STUDIES,
        "100366" => ::CourseSubjects::COMPUTER_SCIENCE,
        "100150" => ::CourseSubjects::CONSTRUCTION_AND_THE_BUILT_ENVIRONMENT,
        "101361" => ::CourseSubjects::ART_AND_DESIGN,
        "100068" => ::CourseSubjects::DANCE,
        "100048" => ::CourseSubjects::DESIGN,
        "100069" => ::CourseSubjects::DRAMA,
        "100510" => ::CourseSubjects::EARLY_YEARS_TEACHING,
        "100450" => ::CourseSubjects::ECONOMICS,
        "100320" => ::CourseSubjects::ENGLISH_STUDIES,
        "100381" => ::CourseSubjects::ENVIRONMENTAL_SCIENCES,
        "101017" => ::CourseSubjects::FOOD_AND_BEVERAGE_STUDIES,
        "100321" => ::CourseSubjects::FRENCH_LANGUAGE,
        "100184" => ::CourseSubjects::GENERAL_OR_INTEGRATED_ENGINEERING,
        "100390" => ::CourseSubjects::GENERAL_SCIENCES,
        "100409" => ::CourseSubjects::GEOGRAPHY,
        "100323" => ::CourseSubjects::GERMAN_LANGUAGE,
        "100061" => ::CourseSubjects::GRAPHIC_DESIGN,
        "101373" => ::CourseSubjects::HAIR_AND_BEAUTY_SCIENCES,
        "100476" => ::CourseSubjects::HEALTH_AND_SOCIAL_CARE,
        "100473" => ::CourseSubjects::HEALTH_STUDIES,
        "101410" => ::CourseSubjects::HISTORICAL_LINGUISTICS,
        "100302" => ::CourseSubjects::HISTORY,
        "100891" => ::CourseSubjects::HOSPITALITY,
        "100372" => ::CourseSubjects::INFORMATION_TECHNOLOGY,
        "100326" => ::CourseSubjects::ITALIAN_LANGUAGE,
        "101420" => ::CourseSubjects::LATIN_LANGUAGE,
        "100485" => ::CourseSubjects::LAW,
        "100202" => ::CourseSubjects::MANUFACTURING_ENGINEERING,
        "100225" => ::CourseSubjects::MATERIALS_SCIENCE,
        "100403" => ::CourseSubjects::MATHEMATICS,
        "100444" => ::CourseSubjects::MEDIA_AND_COMMUNICATION_STUDIES,
        "100329" => ::CourseSubjects::MODERN_LANGUAGES,
        "100642" => ::CourseSubjects::MUSIC_EDUCATION_AND_TEACHING,
        "100071" => ::CourseSubjects::PERFORMING_ARTS,
        "100337" => ::CourseSubjects::PHILOSOPHY,
        "100425" => ::CourseSubjects::PHYSICS,
        "101142" => ::CourseSubjects::PORTUGUESE_LANGUAGE,
        "100511" => ::CourseSubjects::PRIMARY_TEACHING,
        "100050" => ::CourseSubjects::PRODUCT_DESIGN,
        "100209" => ::CourseSubjects::PRODUCTION_AND_MANUFACTURING_ENGINEERING,
        "100497" => ::CourseSubjects::PSYCHOLOGY,
        "100091" => ::CourseSubjects::PUBLIC_SERVICES,
        "100893" => ::CourseSubjects::RECREATION_AND_LEISURE_STUDIES,
        "100339" => ::CourseSubjects::RELIGIOUS_STUDIES,
        "100092" => ::CourseSubjects::RETAIL_MANAGEMENT,
        "100330" => ::CourseSubjects::RUSSIAN_LANGUAGES,
        "100471" => ::CourseSubjects::SOCIAL_SCIENCES,
        "100332" => ::CourseSubjects::SPANISH_LANGUAGE,
        "101085" => ::CourseSubjects::SPECIALIST_TEACHING_PRIMARY_WITH_MATHEMETICS,
        "100433" => ::CourseSubjects::SPORT_AND_EXERCISE_SCIENCES,
        "100097" => ::CourseSubjects::SPORTS_MANAGEMENT,
        "100406" => ::CourseSubjects::STATISTICS,
        "100214" => ::CourseSubjects::TEXTILES_TECHNOLOGY,
        "100101" => ::CourseSubjects::TRAVEL_AND_TOURISM,
        "100610" => ::CourseSubjects::UK_GOVERNMENT_PARLIAMENTARY_STUDIES,
        "100333" => ::CourseSubjects::WELSH_LANGUAGE,
      }.freeze
    end
  end
end
