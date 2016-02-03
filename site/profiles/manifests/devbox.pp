class profiles::devbox {
  include rbenv
  rbenv::plugin { 'sstephenson/ruby-build': }
  rbenv::build { '2.1.7':
    global => true,
  }
}

