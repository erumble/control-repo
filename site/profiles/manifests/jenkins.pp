class profiles::jenkins {
  include jenkins

  jenkins::plugin { 'git':
    version => '2.4.1',
  }

  
}

