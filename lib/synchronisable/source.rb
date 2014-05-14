module Synchronisable
  # Synchronization source.
  class Source
    attr_accessor :import_record
    attr_reader :model, :remote_attrs,
                :remote_id, :local_attrs, :associations

    def initialize(model, parent, remote_attrs)
      @model, @parent, @synchronizer = model, parent, model.synchronizer
      @remote_attrs = remote_attrs.with_indifferent_access
    end

    # Extracts the `remote_id` from remote attributes, maps remote attirubtes
    # to local attributes and tries to find import record for given model
    # by extracted remote id.
    #
    # @api private
    def build
      @remote_id = @synchronizer.extract_remote_id(@remote_attrs)
      @local_attrs = @synchronizer.map_attributes(@remote_attrs)
      @associations = @synchronizer.associations_for(@local_attrs)

      @local_attrs.delete_if do |key, _|
        @associations.keys.any? { |a| a.key == key }
      end

      @import_record = Import.find_by(
        :remote_id => @remote_id,
        :synchronisable_type => @model
      )

      set_parent_attribute
    end

    def updatable?
      @import_record.present? && local_record.present?
    end

    def local_record
      @import_record.try(:synchronisable)
    end

    def dump_message
      %Q(
        remote_id: #{remote_id},
        remote attributes: #{remote_attrs},
        local attributes: #{local_attrs}
      )
    end

    private

    def set_parent_attribute
      return unless @parent
      name = parent_attribute_name
      @local_attrs[name] = @parent.local_record.id if name
    end

    def parent_attribute_name
      return nil unless parent_has_model_as_reflection?
      parent_name = @parent.model.table_name.singularize
      "#{parent_name}_id"
    end

    def parent_has_model_as_reflection?
      @parent.model.reflections.values.any? do |reflection|
        reflection.plural_name == @model.table_name &&
        [:has_one, :has_many].include?(reflection.macro)
      end
    end
  end
end
