module Synchronisable
  class AttributeMapper
    class << self
      def map(source, mappings, options = {})
        new(mappings, options).map(source)
      end
    end

    def initialize(mappings, options = {})
      @mappings = mappings
      @keep = options[:keep] || []
      @only, @except = options[:only], options[:except]
    end

    def map(source)
      result = source.dup

      apply_mappings(result) if @mappings.present?
      apply_only(result)     if @only.present?
      apply_except(result)   if @except.present?

      result
    end

    private

    def apply_mappings(source)
      source.transform_keys! { |key| @mappings[key] || key }
    end

    def apply_only(source)
      source.keep_if { |key| @only.include?(key) || @keep.include?(key) }
    end

    def apply_except(source)
      source.delete_if { |key| key.nil? || @except.include?(key) }
    end
  end
end
