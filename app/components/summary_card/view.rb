# frozen_string_literal: true

class SummaryCard::View < ViewComponent::Base
  include ViewComponent::Slotable

  renders_one :header_actions


  def initialize(trainee:, title:, heading_level: 2, rows:, id_token: nil)
    @trainee = trainee
    @title = title
    @heading_level = heading_level
    @rows = rows
    @id_token = id_token
  end

  def rows
    @rows.map do |row|
      row.tap do |r|
        r.delete(:action) if prevent_action?
      end
    end
  end

private

  attr_accessor :trainee, :title, :heading_level

  def prevent_action?
    trainee.recommended_for_award? || trainee.awarded? || trainee.withdrawn?
  end

  def row_title(key)
    return key.parameterize if id_token.nil?

    "#{id_token}-#{key.parameterize}"
  end
end
