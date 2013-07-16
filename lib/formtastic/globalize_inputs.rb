module Formtastic
  class FormBuilder
    def globalize_inputs(options={}, &proc)
      index = options[:child_index] || "#{self.object.class.to_s}-#{self.object.object_id}"
      linker = ActiveSupport::SafeBuffer.new
      fields = ActiveSupport::SafeBuffer.new
      available_locales = options[:available_locales] || I18n.available_locales
      available_locales.each do |locale|
        linker << self.template.content_tag(:li,
                                            self.template.content_tag(:a,
                                                                      ::I18n.t("translation.#{locale}"),
                                                                      :href => "#lang-#{locale}-#{index}"
                                                                     )
                                           )
        fields << self.template.content_tag(:div,
                                            self.semantic_fields_for(:translations, self.object.translation_for(locale), &proc),
                                            :id => "lang-#{locale}-#{index}"
                                           )
      end

      linker = self.template.content_tag(:ul, linker, :class => "language-selection")

      self.template.content_tag(:div, linker + fields, :class => "language-tabs-#{index}") + self.template.content_tag(:script, "$('.language-tabs-#{index}').tabs();".html_safe, :type => "text/javascript")
    end
  end
end
