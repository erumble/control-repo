class profiles::pe_aio_server {

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
    master_service => 'pe-puppetserver',
  }

}
