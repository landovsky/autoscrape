# typed: true
# frozen_string_literal: true

module TranslationsHelper
  # Returns an array of the possible key/i18n values for the enum
  # Example usage:
  # enum_options_for_select(User, :approval_state)
  def enum_options_for_select(class_name, enum)
    class_name.send(enum.to_s.pluralize).map do |key, _|
      [enum_i18n(class_name, enum, key), key]
    end
  end

  # Returns the i18n version the models current enum key
  # Example usage:
  # enum_l(user, :approval_state)
  def enum_l(model, enum)
    enum_i18n(model.class, enum, model.send(enum))
  end

  # Returns the i18n string for the enum key
  # Example usage:
  # enum_i18n(User, :approval_state, :unprocessed)
  def enum_i18n(class_name, enum, key)
    I18n.t("activerecord.enums.#{class_name.model_name.i18n_key}.#{enum.to_s.pluralize}.#{key}")
  end

  class << self
    def model_error(model, field, reason)
      I18n.t(reason, scope: [:activerecord, :errors, :messages, model.model_name.i18n_key, field])
    end

    def api_error(field, reason, fallback: nil)
      I18n.t("api.errors.#{field}.#{reason}", default: fallback)
    end
  end
end
