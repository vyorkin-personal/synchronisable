require 'active_support/configurable'

require 'ar_remote_synchronizer/version'
require 'ar_remote_synchronizer/models/import'

module ArRemoteSynchronizer
  include ActiveSupport::Configurable

  config_accessor :models
end
