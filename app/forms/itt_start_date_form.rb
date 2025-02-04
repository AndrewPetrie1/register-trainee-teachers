# frozen_string_literal: true

class IttStartDateForm < MultiDateForm
private

  def date_field
    @date_field ||= :course_start_date
  end

  def date_valid
    if date_string.nil?
      errors.add(:date_string, :blank)
    elsif date_string == "other" && [day, month, year].all?(&:blank?)
      errors.add(:date, :blank)
    elsif year.to_i > next_year
      errors.add(:date, :future)
    elsif !date.is_a?(Date)
      errors.add(:date, :invalid)
    elsif date < 10.years.ago
      errors.add(:date, :too_old)
    end
  end

  def next_year
    Time.zone.now.year.next
  end
end
