# Fork info
Fork contains a few fixes and tweaks.

## One-time Windows setup advice

- Enable Hanewin's **Edit > Preferences > Server > Set executable bit for all files**.
- Give your logged-in user write access to `exports` in the Hanewin installation directory.
- Allow that user to query, start, and stop the `NFSserver` service without elevation.
  The plugin restarts this service when updating exports.

## Configuration

Add these settings to the top-level configuration block in your project's
`Vagrantfile` or your user-wide `~/.vagrant.d/Vagrantfile`:

```ruby
Vagrant.configure("2") do |config|
  config.hanewin_nfs.installation_directory = "C:/Program Files/nfsd"
  config.hanewin_nfs.service_timeout_seconds = 30
end
```

## Installation

Install this fork from its built gem:

```powershell
vagrant plugin install '.\vagrant-hanewin-nfs-1.0.1.gem'
```

----

# Vagrant Hanewin NFS

Manage and adds support for NFS on windows.

## Supported Platforms

Only tested with Vagrant 1.5.0 or later

Supported guests:

  * Linux

## Installation

```
$ vagrant plugin install vagrant-hanewin-nfs
```

## Hanewin NFS

You need to install Hanewin NFS Server to use this plugin. Hanewin NFS is
shareware and can be evaluated for 30 days.D 

You can get it here:

http://www.hanewin.de/nfs-d.htm

## Thanks to

* @GM-Alex [vagrant-winnfsd](https://github.com/GM-Alex/vagrant-winnfsd) idea and basic structure of this plugin.
