require 'vagrant'

module VagrantPlugins
  module VagrantHanewinNfs
    # Host settings merged by Vagrant from the user and project Vagrantfiles.
    class Settings < Vagrant.plugin(2, :config)
      DEFAULT_INSTALLATION_DIRECTORY = 'C:/Program Files/nfsd'.freeze
      DEFAULT_SERVICE_TIMEOUT_SECONDS = 30

      attr_accessor :installation_directory, :service_timeout_seconds

      # Defer defaults until merging finishes so project omissions retain user settings.
      def initialize
        @installation_directory = UNSET_VALUE
        @service_timeout_seconds = UNSET_VALUE
      end

      # Supply defaults only for values the user has not explicitly configured.
      def finalize!
        @installation_directory = DEFAULT_INSTALLATION_DIRECTORY if @installation_directory == UNSET_VALUE
        @service_timeout_seconds = DEFAULT_SERVICE_TIMEOUT_SECONDS if @service_timeout_seconds == UNSET_VALUE
      end

      # Report configuration errors through Vagrant's normal validation output.
      def validate(machine)
        errors = _detected_errors
        unless @installation_directory.is_a?(String) && !@installation_directory.strip.empty? &&
            !@installation_directory.match(/["\r\n\x00]/)
          errors << 'installation_directory must be a nonempty path without quotes or line breaks'
        end
        unless (@service_timeout_seconds.is_a?(Integer) || @service_timeout_seconds.is_a?(Float)) &&
            @service_timeout_seconds.finite? && @service_timeout_seconds > 0
          errors << 'service_timeout_seconds must be a positive, finite number'
        end
        {'hanewin_nfs' => errors}
      end
    end
  end
end
