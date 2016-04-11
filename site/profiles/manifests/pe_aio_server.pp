class profiles::pe_aio_server {

  class { 'puppet::server':
    java_Xms        => '512m',
    java_Xmx        => '512m',
    ca              => true,
    autosign        => true,
    service_name    => 'pe-puppetserver',
    manage_packages => false,
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

}
