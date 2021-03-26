# frozen_string_literal: true

require "rails_helper"

feature "edit disability disclosure", type: :feature do
  background do
    given_i_am_authenticated
    given_a_trainee_exists(disability_disclosure: nil)
    given_i_visited_the_review_draft_page
    and_i_am_on_the_disability_disclosure_page
  end

  scenario "choosing to disclose a disability" do
    and_i_choose_to_disclose
    and_i_submit_the_form
    then_i_am_redirected_to_the_disabilities_page
    and_the_disability_disclosure_is_updated
  end

  scenario "choosing not to disclose a disability" do
    and_i_choose_not_to_disclose
    and_i_submit_the_form
    and_confirm_my_details
    then_i_am_redirected_to_the_review_draft_page
    and_the_disability_disclosure_is_updated
  end

  scenario "submitting with no option selected" do
    and_i_submit_the_form
    then_i_see_error_messages
  end

private

  def and_i_am_on_the_disability_disclosure_page
    disability_disclosure_page.load(id: trainee.slug)
  end

  def and_i_choose_to_disclose
    disability_disclosure_page.disabled.choose
  end

  def and_i_choose_not_to_disclose
    disability_disclosure_page.public_send(%w[disability_not_provided no_disability].sample).choose
  end

  def and_i_submit_the_form
    disability_disclosure_page.submit_button.click
  end

  def and_confirm_my_details
    expect(diversities_confirm_page).to be_displayed(id: trainee.slug)
    diversities_confirm_page.submit_button.click
  end

  def then_i_am_redirected_to_the_disabilities_page
    expect(disabilities_page).to be_displayed(id: trainee.slug)
  end

  def and_the_disability_disclosure_is_updated
    expect(trainee.reload.disability_disclosure).to be_truthy
  end

  def then_i_see_error_messages
    expect(disabilities_page).to have_content(
      I18n.t("activemodel.errors.models.diversities/disability_disclosure_form.attributes.disability_disclosure.blank"),
    )
  end
end
