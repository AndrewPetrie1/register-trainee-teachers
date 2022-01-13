# frozen_string_literal: true

class ProviderPolicy
  attr_reader :user, :scope

  def initialize(user, scope)
    @user = user
    @scope = scope
  end

  def resolve
    scope
  end

  def show?
    user.system_admin?
  end

  alias_method :create?, :show?
  alias_method :new?, :show?
  alias_method :index?, :show?
  alias_method :edit?, :show?
  alias_method :update?, :show?
  alias_method :destroy?, :show?
  alias_method :delete?, :show?
end
