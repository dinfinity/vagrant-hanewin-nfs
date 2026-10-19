require 'pathname'

module VagrantPlugins
  module VagrantHanewinNfs
    require 'vagrant-hanewin-nfs/version'
    require 'vagrant-hanewin-nfs/plugin'
    require 'vagrant-hanewin-nfs/settings'

    def self.source_root
      @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end

    # Host capabilities use the environment's merged user/project configuration.
    # A fresh default object keeps legacy helper calls independent of other projects.
    def self.settings(environment = nil)
      return environment.vagrantfile.config.hanewin_nfs if environment

      Settings.new.tap { |configuration| configuration.finalize! }
    end

    # Resolve the server directory without modifying installed gem files.
    def self.get_nfs_dir(environment = nil)
      Pathname.new(settings(environment).installation_directory)
    end

    def self.get_nfs_path(file, environment = nil)
      get_nfs_dir(environment).join(file)
    end
  end
end
