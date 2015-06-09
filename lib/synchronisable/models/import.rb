module Synchronisable
  class Import < ActiveRecord::Base
    belongs_to :synchronisable, polymorphic: true

    if Gem.loaded_specs['activerecord'].version < Gem::Version.create(4)
      attr_accessible :synchronisable_id, :synchronisable_type, :remote_id, :unique_id, :attrs
    end

    serialize :attrs, Hash

    scope :with_synchronisable_type, ->(type) { where(synchronisable_type: type) }
    scope :with_synchronisable_ids,  ->(ids)  { where(synchronisable_id: ids) }

    scope :with_remote_id,  ->(id)  { where(remote_id: id.to_s) }
    scope :with_remote_ids, ->(ids) { where(remote_id: ids.map(&:to_s)) }

    def destroy_with_synchronisable
      ActiveRecord::Base.transaction do
        synchronisable.try :destroy
        destroy
      end
    end
  end
end
