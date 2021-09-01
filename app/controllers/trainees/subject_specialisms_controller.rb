# frozen_string_literal: true

module Trainees
  class SubjectSpecialismsController < ApplicationController
    include PublishCourseNextPath

    before_action :authorize_trainee
    helper_method :position

    def edit
      @subject = course.subjects[position - 1].name
      @specialisms = calculate_subject_specialisms[:"course_subject_#{position_in_words}"]

      if @specialisms.count == 1
        SubjectSpecialismForm.new(trainee, position, params: { "course_subject_#{position_in_words}": @specialisms.first }).stash_or_save!
        redirect_to next_step_path
        return
      end

      @subject_specialism_form = SubjectSpecialismForm.new(trainee, position)
    end

    def update
      @subject_specialism_form = SubjectSpecialismForm.new(trainee, position, params: specialism_params)
      if @subject_specialism_form.stash_or_save!
        redirect_to next_step_path
      else
        @subject = course.subjects[position - 1].name
        @specialisms = calculate_subject_specialisms[:"course_subject_#{position_in_words}"]
        render :edit
      end
    end

  private

    def position
      params[:position].to_i
    end

    def position_in_words
      @_position_in_words ||= to_word(position)
    end
    helper_method :position_in_words

    def to_word(number)
      case number
      when 1
        "one"
      when 2
        "two"
      when 3
        "three"
      end
    end

    def authorize_trainee
      authorize(trainee)
    end

    def specialism_params
      return {} if params[:subject_specialism_form].blank?

      params
        .require(:subject_specialism_form)
        .permit(:"course_subject_#{position_in_words}", "course_subject_#{position_in_words}": [])
        .transform_values(&:first)
    end

    def next_step_path
      next_position = position + 1
      if calculate_subject_specialisms[:"course_subject_#{to_word(next_position)}"].present?
        edit_trainee_subject_specialism_path(trainee, next_position)
      else
        publish_course_next_path
      end
    end

    def course_code
      publish_course_details_form.course_code || trainee.course_code
    end

    def calculate_subject_specialisms
      @calculate_subject_specialisms ||= CalculateSubjectSpecialisms.call(subjects: course.subjects.map(&:name))
    end
  end
end
