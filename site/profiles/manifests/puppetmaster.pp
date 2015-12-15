class profiles::puppetmaster {
  class{ 'hiera':
    hierarchy => [
      'nodes/%{::trusted.certname}',
      '%{environment}/%{calling_class}',
      '%{environment}',
      'common',
    ],
    hiera_yaml     => '/etc/puppetlabs/code/hiera.yaml',
    datadir        => '/etc/puppetlabs/code/environments/%{environment}/hieradata',
    datadir_manage => false,
    owner          => 'root',
    group          => 'root',
    master_service => 'puppetserver',
  }
  
  class{ 'motd':
    content => 'Vagrant Puppet Master',
  }
}
