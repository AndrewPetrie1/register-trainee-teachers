# frozen_string_literal: true

class TraineeForm
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations::Callbacks

  attr_accessor :trainee, :user, :params, :store, :fields

  delegate :id, :persisted?, to: :trainee

  after_validation :track_validation_error, if: -> { user.present? && errors.any? }

  def initialize(trainee, params: {}, user: nil, store: FormStore)
    @user = user
    @trainee = trainee
    @params = params
    @store = store
    @fields = compute_fields
    assign_attributes(fields)
  end

  def stash_or_save!
    save_strategy = trainee.draft? ? :save! : :stash
    public_send(save_strategy)
  end

  def save!
    if valid?
      trainee.assign_attributes(fields.except(*fields_to_ignore_before_stash_or_save))
      trainee.save!
      clear_stash
    else
      false
    end
  end

  def stash
    valid? && store.set(id, form_store_key, fields.except(*fields_to_ignore_before_stash_or_save))
  end

  def course_start_date_attribute_name
    "#{course_date_attribute_name_prefix}_start_date".to_sym
  end

  def course_end_date_attribute_name
    "#{course_date_attribute_name_prefix}_end_date".to_sym
  end

  def missing_fields
    return [] if valid?

    [errors.attribute_names]
  end

private

  def course_date_attribute_name_prefix
    itt_route? ? :itt : :course
  end

  def itt_route?
    trainee.itt_route?
  end

  def compute_fields
    raise NotImplementedError
  end

  def fields_to_ignore_before_stash_or_save
    []
  end

  def new_attributes
    fields_from_store.merge(params).symbolize_keys
  end

  def track_validation_error
    return unless Settings.track_validation_errors

    ValidationError.create!(form_object: self.class.name, user: user, details: validation_error_details.to_h)
  end

  def validation_error_details
    errors.messages.map do |field, messages|
      [field, { messages: messages, value: public_send(field) }]
    end
  end

  def clear_stash
    store.set(id, form_store_key, nil)
  end

  def fields_from_store
    store.get(id, form_store_key).presence || {}
  end

  def form_store_key
    self.class.name.underscore.chomp("_form").split("/").last.to_sym
  end
end
