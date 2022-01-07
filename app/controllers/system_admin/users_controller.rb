# frozen_string_literal: true

module SystemAdmin
  class UsersController < ApplicationController
    def new
      @user = authorize(provider.users.build)
    end

    def create
      @user = authorize(provider.users.build(permitted_attributes(User)))
      if @user.save
        ProviderUser.find_or_create_by!(provider: provider, user: @user)
        redirect_to(provider_path(provider), flash: { success: t(".success") })
      else
        render(:new)
      end
    end

    def edit
      user
      @provider = user.primary_provider
    end

    def update
      user
      @provider = user.primary_provider
      if user.update(permitted_attributes(@user))
        redirect_to(provider_path(provider), flash: { success: t(".success") })
      else
        render(:edit)
      end
    end

    def delete
      user
      @provider = user.primary_provider
    end

    def destroy
      user.discard
      @provider = user.primary_provider
      redirect_to(provider_path(@provider))
    end

  private

    def provider
      @provider ||= Provider.find(params[:provider_id])
    end

    def user
      @user ||= authorize(User.find(params[:id]))
    end
  end
end
