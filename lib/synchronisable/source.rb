module Synchronisable
  # TODO: Massive refactoring needed

  # Synchronization source.
  class Source
    CHILD_ASSOCIATION_KEYS = %i(has_one has_many)
    PARENT_ASSOCIATION_KEYS = %i(belongs_to)

    attr_accessor :import_record
    attr_reader :parent_associations, :child_associations
    attr_reader :model, :remote_attrs, :remote_id,
                :local_attrs, :import_ids

    def initialize(model, parent, remote_attrs)
      @model, @parent, @synchronizer = model, parent, model.synchronizer
      @remote_attrs = remote_attrs.with_indifferent_access
    end

    # Prepares synchronization source:
    # `remote_id`, `local_attributes`, `import_record` and `associations`.
    #
    # Sets foreign key if current model is specified as `has_one` or `has_many`
    # association of parent model.
    #
    # @api private
    def prepare
      @remote_id = @synchronizer.extract_remote_id(@remote_attrs)
      @local_attrs = @synchronizer.map_attributes(@remote_attrs)

      @associations = @synchronizer.associations_for(@local_attrs)
      @parent_associations = @associations.select do |association|
        PARENT_ASSOCIATION_KEYS.include? association.macro
      end

      @child_associations = @associations.select do |association|
        CHILD_ASSOCIATION_KEYS.include? association.macro
      end

      @import_record = Import.find_by(
        :remote_id => @remote_id.to_s,
        :synchronisable_type => @model
      )

      remove_association_keys_from_local_attrs

      # TODO: This should be in Synchronisable::RecordWorker
      set_belongs_to_parent_foreign_key
    end

    def updatable?
      import_record.present? &&
      local_record.present?
    end

    def local_record
      @import_record.try(:synchronisable)
    end

    def dump_message
      %Q(
        remote id: '#{remote_id}',
        remote attributes: #{remote_attrs},
        local attributes: #{local_attrs}
      )
    end

    private

    def remove_association_keys_from_local_attrs
      @local_attrs.delete_if do |key, _|
        @associations.keys.any? { |a| a.key == key }
      end
    end

    def set_belongs_to_parent_foreign_key
      return unless @parent && parent_has_current_model_as_reflection?
      @local_attrs[parent_foreign_key_name] = @parent.local_record.id

    end

    def parent_foreign_key_name
      "#{parent_name}_id"
    end

    def parent_name
      @parent.model.table_name.singularize
    end

    def parent_has_current_model_as_reflection?
      @parent.model.reflections.values.any? do |reflection|
        reflection.plural_name == @model.table_name &&
        %i(has_one has_many).include?(reflection.macro)
      end
    end
  end
end
