# typed: true
# frozen_string_literal: true

module NoticeHelper
  def resource_created(resource)
    "#{resource.class.model_name.singular.humanize} was successfully created."
  end

  def resource_updated(resource)
    "#{resource.class.model_name.singular.humanize} was successfully updated."
  end

  def resource_destroyed(resource)
    "#{resource.class.model_name.singular.humanize} was successfully destroyed."
  end
end
