# frozen_string_literal: true

module Trainees
  class PublishCourseDetailsController < ApplicationController
    before_action :authorize_trainee

    def edit
      @courses = Course.take(10)
      @publish_course_details = PublishCourseDetailsForm.new(trainee)
    end

    def update
      @publish_course_details = PublishCourseDetailsForm.new(trainee, course_params)

      result = @publish_course_details.stash
      unless result
        @courses ||= Course.take(10)
        render :edit
        return
      end

      if course_params[:code] == PublishCourseDetailsForm::NOT_LISTED
        redirect_to edit_trainee_course_details_path
      else
        redirect_to edit_trainee_confirm_publish_course_path(id: helpers.stashed_code(@trainee), trainee_id: @trainee.slug)
      end
    end

  private

    def course_params
      params.fetch(:publish_course_details_form, {}).permit(:code)
    end

    def trainee
      @trainee ||= Trainee.from_param(params[:trainee_id])
    end

    def authorize_trainee
      authorize(trainee)
    end
  end
end
