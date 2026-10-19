require 'vagrant-hanewin-nfs'
require 'vagrant-hanewin-nfs/windows_service'

module VagrantPlugins
  module VagrantHanewinNfs
    module Cap
      class NFS
        # Keep export writes and cleanup on the same configured host file.
        def self.nfs_config_file_path(env = nil)
          VagrantHanewinNfs.get_nfs_dir(env).join('exports')
        end

        def self.logger
          Log4r::Logger.new("vagrant::hosts::windows::nfs")
        end

        def self.service_name
          "NFSserver"
        end

        def self.nfs_export(env, ui, id, ips, folders)
          # Get some values we need before we do anything

          output = ""

          folders.each do |folder, opts|
            if opts[:nfs] = true
              # Build config
              ips.each do |ip|
                # Hanewin requires quotes around export paths containing spaces.
                output += "\"%s\" -mapall:1000:1000 %s ##VAGRANT#%s#\n" % [opts[:hostpath].gsub('/', '\\'),ip,id]
              end

              # Rewrite path for mount
              drive=opts[:hostpath][0].downcase
              opts[:hostpath] = "/#{drive}/#{opts[:hostpath][3..-1]}"

            end

            # Remove entries with id
            nfs_cleanup(id, env)

            # Append to config
            logger.info("Write nfs exports")
            open(nfs_config_file_path(env), 'a') do |f|
              f.write output
              f.flush
              f.close
            end

            # restart nfs
            logger.info("Restart nfs")
            nfs_apply_command = env.host.capability(:nfs_apply_command)
          end
        end

        def self.nfs_installed(env)
          true
        end

        def self.nfs_cleanup(id, env = nil)
          return if !File.exist?(nfs_config_file_path(env))

          #id_re = Regexp.escape(id.to_s)

          output = ""

          # read per line
          open(nfs_config_file_path(env), 'r').each do |line|
            match = line.scan(/##VAGRANT#([^#]*)#/)
            if match.length > 0
              next if match[0][0] == id.to_s
            end
            output += line
          end

          # write to file
          open(nfs_config_file_path(env), 'w') do |f|
            f.write output
            f.flush
            f.close
          end
        end

        def self.nfs_prune(environment, ui, valid_ids)
          # TODO Implement me
        end

        # Construct each service operation from this environment's final settings.
        def self.nfs_apply_command(env)
          service = WindowsService.new('NFSserver', VagrantHanewinNfs.settings(env).service_timeout_seconds)
          service.restart
        end

        def self.nfs_check_command(env)
          service = WindowsService.new('NFSserver', VagrantHanewinNfs.settings(env).service_timeout_seconds)
          service.status
        end

        def self.nfs_start_command(env)
          service = WindowsService.new('NFSserver', VagrantHanewinNfs.settings(env).service_timeout_seconds)
          service.start
        end
      end
    end
  end
end
