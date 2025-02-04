# frozen_string_literal: true

module FundingHelper
  def training_initiative_options(trainee)
    TRAINING_ROUTE_INITIATIVES[trainee.training_route].sort
  end

  def funding_options(trainee)
    cannot_start_funding?(trainee) ? :funding_inactive : :funding_active
  end

  def format_currency(amount)
    number_to_currency(
      amount,
      unit: "£",
      locale: :en,
      strip_insignificant_zeros: true,
    )
  end

private

  def cannot_start_funding?(trainee)
    funding_manager = FundingManager.new(trainee)
    funding_manager.funding_available? &&
      trainee.course_subject_one.blank?
  end
end
