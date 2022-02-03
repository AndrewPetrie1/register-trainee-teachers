# frozen_string_literal: true

module PageObjects
  module Users
    class UserRow < SitePrism::Section
      element :link, ".user-link"
    end

    class Index < PageObjects::Base
      set_url "/system-admin/users"
      sections :users, UserRow, ".user-row"
    end
  end
end
