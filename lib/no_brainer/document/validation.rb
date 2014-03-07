module NoBrainer::Document::Validation
  extend ActiveSupport::Concern
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  included do
    # We don't want before_validation returning false to halt the chain.
    define_callbacks :validation, :skip_after_callbacks_if_terminated => true, :scope => [:kind, :name],
                     :terminator => NoBrainer::Document::Callbacks.terminator
  end

  def valid?(context=nil)
    super(context || (new_record? ? :create : :update))
  end

  module ClassMethods
    def _field(attr, options={})
      super
      validates(attr, { :presence => true }) if options[:required]
      validates(attr, options[:validates]) if options[:validates]
    end
  end
end
