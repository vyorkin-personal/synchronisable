require 'ar_remote_synchronizer/config'

module ArRemoteSynchronizer
  class Import < ActiveRecord::Base
    scope :with_local_type, ->(type) { where(local_type: type.to_s) }
    scope :with_remote_id,  ->(remote_id) { where(remote_id: remote_id.to_s) }
    scope :with_remote_ids, ->(remote_ids) { where(remote_id: remote_ids.map(&:to_s)) }
    scope :with_local_id,   ->(local_id) { where(local_id: local_id) }
    scope :with_local_ids,  ->(local_ids) { where(local_id: local_ids) }

    validates :local_type, :inclusion => { :in => ->(o) { ArRemoteSynchronizer.models } }

    def self.find_by_remote_id(remote_id)
      with_remote_id(remote_id).first
    end

    def local_model
      local_type.constantize
    end

    def local_record
      local_model.where(id: local_id).first
    end

    def destroy_with_local_record
      ActiveRecord::Base.transaction do
        local_record.try :destroy
        destroy
      end
    end
  end
end
