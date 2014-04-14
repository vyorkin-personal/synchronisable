module Synchronizable
  class Import < ActiveRecord::Base
    belongs_to :synchronizable, polymorphic: true

    serialize :attrs, Hash

    scope :with_synchronizable_type, ->(type) { where(synchronizable_type: type) }
    scope :with_synchronizable_ids,  ->(ids)  { where(synchronizable_id: ids) }

    scope :with_remote_id,  ->(id)  { where(remote_id: id.to_s) }
    scope :with_remote_ids, ->(ids) { where(remote_id: ids.map(&:to_s)) }

    def self.find_by_remote_id(id)
      with_remote_id(id).first
    end

    def destroy_with_synchronizable
      ActiveRecord::Base.transaction do
        synchronizable.try :destroy
        destroy
      end
    end
  end
end
