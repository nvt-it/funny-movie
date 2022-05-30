# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def create
    if resource_class.find_by(email: sign_in_params['email']).present?
      super
      
      return
    end

    build_resource(sign_in_params)

    resource.save
    yield resource if block_given?

    unless resource.persisted?
      clean_up_passwords resource
      set_minimum_password_length
      redirect_to root_path, alert: resource.errors.full_messages.first

      return
    end

    if resource.active_for_authentication?
      set_flash_message! :notice, :signed_up
      sign_in(resource_name, resource)
      respond_with resource, location: '/'

      return
    end

    set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
    expire_data_after_sign_in!
    respond_with resource, location: '/'
  end

  private

  def build_resource(hash = {})
    self.resource = resource_class.new_with_session(hash, session)
  end
end
