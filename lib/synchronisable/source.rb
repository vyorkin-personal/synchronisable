module Synchronisable
  # TODO: Massive refactoring needed

  # Synchronization source.
  class Source
    CHILD_ASSOCIATION_KEYS = %i(has_one has_many)
    PARENT_ASSOCIATION_KEYS = %i(belongs_to)

    attr_accessor :import_record
    attr_reader :parent_associations, :child_associations
    attr_reader :model, :remote_attrs, :remote_id, :unique_id,
                :local_attrs, :import_ids, :parent, :includes, :data

    def initialize(model, parent, includes)
      @model, @parent, @synchronizer = model, parent, model.synchronizer
      @model_name = @model.to_s.demodulize.underscore.to_sym
      @includes = includes
    end

    # Prepares synchronization source:
    # `remote_id`, `local_attributes`, `import_record` and `associations`.
    #
    # @api private
    def prepare(data, remote_attrs)
      @data = @parent
        .try(:source).try(:data)
        .try(:merge, data) || data

      @remote_attrs = remote_attrs.with_indifferent_access

      @remote_id    = @synchronizer.extract_remote_id(@remote_attrs)
      @local_attrs  = @synchronizer.map_attributes(@remote_attrs)
      @unique_id    = @synchronizer.uid(@local_attrs)
      @associations = @synchronizer.associations_for(@local_attrs)

      @parent_associations = filter_associations(PARENT_ASSOCIATION_KEYS)
      @child_associations  = filter_associations(CHILD_ASSOCIATION_KEYS)

      @import_record = find_import

      remove_association_keys_from_local_attrs
    end

    def find_import
      (@unique_id.present? && find_import_by_unique_id) ||
        find_import_by_remote_id
    end

    def find_import_by_unique_id
      Import.find_by(
        unique_id: @unique_id.to_s,
        synchronisable_type: @model.to_s
      )
    end

    def find_import_by_remote_id
      Import.find_by(
        remote_id: @remote_id.to_s,
        synchronisable_type: @model.to_s
      )
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
        unique_id: '#{unique_id}',
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

    def filter_associations(kinds)
      @associations.select { |a| kinds.include? a.kind }
    end
  end
end
