# typed: false
# frozen_string_literal: true

module Helpers
  def log_in(user)
    mock_valid_auth_hash(user)
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:auth0]
    visit auth_callback_path(code: 'vihipkGaumc5IVgs')
  end

  def click_action_button(title, action)
    element = find_all('div.title.h4').find { |e| e.text == title }
    raise "Could not find '#{action}' button within title '#{title}'" unless element

    node = element.to_capybara_node
    within(node) { find(".action.#{action}").click }
  end
end
