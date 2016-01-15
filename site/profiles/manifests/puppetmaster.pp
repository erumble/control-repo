class profiles::puppetmaster {
  
  class { 'motd':
    content => "Vagrant Puppet Master\n",
  }

  package { 'puppetserver':
    ensure => latest,
  }

  augeas { 'puppetserver::jvm':
    lens    => 'Shellvars.lns',
    incl    => '/etc/sysconfig/puppetserver',
    changes => [
      "set JAVA_ARGS '\"-Xms512m -Xmx512m -XX:MaxPermSize=256m\"'",
    ],
    require => Package['puppetserver'],
    notify  => Service['puppetserver'],
  }

  file { '/etc/puppetlabs/puppet/puppet.conf':
    ensure  => file,
    source  => 'puppet:///modules/profiles/puppetmaster/puppet.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['puppetserver'],
    notify  => Service['puppetserver'],
  }

  service { 'puppetserver':
    ensure => running,
    enable => true,
  }

  file { ['/opt', '/opt/enc']:
    ensure => directory,
  }

  file { '/opt/enc/enc.rb':
    ensure  => file,
    source  => 'puppet:///modules/profiles/puppetmaster/cert_enc.rb',
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0755',
  }

  class { 'hiera':
    hierarchy => [
      "nodes/%{::trusted.certname}",
      "%{environment}/%{calling_class}",
      "%{environment}",
      "common",
    ],
    owner          => 'root',
    group          => 'root',
    datadir        => '/etc/puppetlabs/code/environments/%{environment}/hieradata',
    hiera_yaml     => '/etc/puppetlabs/code/hiera.yaml',
    datadir_manage => false,
    master_service => 'puppetserver',
  }

  class { 'r10k':
    remote   => 'https://github.com/erumble/control-repo.git',
    cachedir => '/opt/puppetlabs/puppet/cache/r10k',
  }

#  The resource declarations below demonstrate how to create a webhook for r10k

#  class { 'r10k::webhook::config':
#    use_mcollective => false,
#    enable_ssl      => false,
#    protected       => false,
#  }
#  class { 'r10k::webhook':
#    use_mcollective => false,
#    user            => 'root',
#    group           => 'root',
#    require         => Class['r10k::webhook::config'],
#  }

#  git_webhook { 'web_post_receive_webhook':
#    ensure       => present,
#    webhook_url  => '<webhook_url>',
#    token        => '<github_token>',
#    project_name => '<org/repo>',
#    server_url   => 'https://api.github.com',
#    provider     => 'github',
#  }

}
