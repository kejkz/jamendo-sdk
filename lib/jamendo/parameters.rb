# Define Jamendo search parameters
require 'ostruct'
module Jamendo
  class Parameters < OpenStruct
    def initialize(parameters={})
      if parameters.kind_of? Hash
        parameters.each do |name, value|
          instance_variable_set("@#{name.to_sym}", value.to_s)
          self.class.send(:attr_accessor, "#{name}")
        end
      elsif parameters.kind_of? Array
        parameters.each do | name | 
          instance_variable_set("@#{name.to_sym}", '')
          self.class.send(:attr_accessor, "#{name}")
        end
      end
      super()
    end
  
    # Convers parameters to hash
    def to_hash
      Hash[instance_variables.map { |var| [var[1..-1].to_sym, instance_variable_get(var)]}]
    end
      
    # Method that validates all key values from this class against parameters that they can use
    # This method is convenient to clear all values values that are not needed in Jamendo requests
    # !!!Still does not work!!!
    def validate!(call_name)
      params = self.methods
      params.select { | method | call_name.include?(call_name) }
    end

    # Display your object as a nice list of parameters
    def to_s
      self.methods.each { |m| puts self.m }
    end
    
    # def method_missing(m, *args)
#       self.define_singleton_method(m.to_sym) {"args[0])"}
#       self.class.send(:attr_accessor, "#{m.to_sym}")
#       super()
#     end
  end
end