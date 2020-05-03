# typed: true
# frozen_string_literal: true

module ActiveAdmin
  module Views
    class CardComponent < ActiveAdmin::Component
      builder_method :card

      def row(content = nil, options = {}, &block)
        @row_content << build_row_content(content, options, &block)
      end

      def build(options = {}, &block)
        action        = options.delete(:action)
        card_class    = [options.delete(:class)&.split(' '), 'card-wrapper'].flatten.compact.join(' ')
        @card_wrapper = div options.merge(class: card_class)
        @row_content  = div class: 'main-col'
        @card_wrapper << @row_content
        if action.present?
          @action = div class: 'action-col'
          @action << build_card_action(action)
        end
        @card_wrapper << @action
      end

      def build_row_content(content = nil, **options, &block)
        div class: 'card-section' do
          div content, class: merge_css_classes(options[:class], 'card-row'),
                       style: merge_css_styles(options[:style]), &block
        end
      end

      def build_card_action(action)
        div class: 'card-action' do
          a '', href: action[:path] || '#', 'data-method': action[:method], class: action[:class], 'data-warning' => action[:warning]
        end
      end

      def merge_css_classes(*classes)
        merged = []
        classes.compact.each { |klass| merged << klass.split(' ') }
        merged.flatten.compact.join(' ')
      end

      alias merge_css_styles merge_css_classes
    end
  end
end
