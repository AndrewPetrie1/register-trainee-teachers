# frozen_string_literal: true

module CourseFormHelpers
  def clear_bursary_information
    trainee.progress.funding = false

    trainee.assign_attributes({
      applying_for_bursary: nil,
      applying_for_scholarship: nil,
    })
  end

  def course_subjects_changed?
    trainee.course_subject_one_changed? || trainee.course_subject_two_changed? || trainee.course_subject_three_changed?
  end
end
