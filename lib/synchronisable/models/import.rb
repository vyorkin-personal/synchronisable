module Synchronisable
  class Import < ActiveRecord::Base
    belongs_to :synchronisable, polymorphic: true

    serialize :attrs, Hash

    scope :with_synchronisable_type, ->(type) { where(synchronisable_type: type) }
    scope :with_synchronisable_ids,  ->(ids)  { where(synchronisable_id: ids) }

    scope :with_remote_id,  ->(id)  { where(remote_id: id.to_s) }
    scope :with_remote_ids, ->(ids) { where(remote_id: ids.map(&:to_s)) }

    def self.find_by_remote_id(id)
      with_remote_id(id).first
    end

    def destroy_with_synchronisable
      ActiveRecord::Base.transaction do
        synchronisable.try :destroy
        destroy
      end
    end
  end
end
