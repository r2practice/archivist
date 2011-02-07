module Archivist
  module ArchiveMethods
    def self.included(base)
      base.class_eval do
        extend ArchiveClassMethods
        protected :get_klass,:get_klass_name,:get_klass_instance_methods
      end
    end

    def method_missing(method,*args,&block)
      if get_klass_instance_methods.include?(method.to_s)
        instance = get_klass.new
        instance.id = self.id
        instance_attribute_names = instance.attribute_names
        attrs = self.attributes.select{|k,v| instance_attribute_names.include?(k.to_s)}
        instance.attributes= attrs,false
        instance.send(method,*args,&block)
      else
        super(method,*args,&block)
      end
    end

    def respond_to?(method)
      klass = get_klass
      if klass.instance_methods.include?(method.to_s)
        return true
      else
        super
      end
    end

    def get_klass
      @klass ||= Kernel.const_get(get_klass_name)
    end
    
    def get_klass_name
      @klass_name ||= self.class.to_s.split("::").first
    end

    def get_klass_instance_methods
      @klass_instance_methods ||= get_klass.instance_methods(false)
    end

    module ArchiveClassMethods;end
  end
end

