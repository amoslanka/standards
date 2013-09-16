# 
# Configures controllers and helpers to offer a "force?" method useful in applying and checking
# for forced values, typically via a get parameter named "force".
# 
# To use as a helper method in both controller and views, simply include in your controller:
# 
# class SomeController < ActionController::Base
#   include Standards::Force
#   ...
# end
# 
module Standards
  module Force
    extend ActiveSupport::Concern

    included do 
      helper_method :force?
    end

    def force? *keys
      _value_in_param_list? :force, *keys
    end

    private

    def _value_in_param_list? name, *keys
      return false unless params.has_key?(name)
      options = keys.extract_options!
      keys = keys.collect{ |key| key.to_s.split(/\W*,\W*/) if key.present? }.flatten.compact.collect(&:downcase)
      q_keys = Array(params[name]).collect{ |key| key.to_s.split(/\W*,\W*/) if key.present? }.flatten.compact.collect(&:downcase)
      (q_keys & keys).any?
    end

  end
end