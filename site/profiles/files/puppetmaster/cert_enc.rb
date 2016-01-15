#!/opt/puppetlabs/puppet/bin/ruby

require 'yaml'
require 'openssl'

raw = File.read "/etc/puppetlabs/puppet/ssl/ca/signed/#{ARGV[0]}.pem"
certificate = OpenSSL::X509::Certificate.new raw

result = {}

certificate.extensions.each do |ext|
  if ext.oid == '1.3.6.1.4.1.34380.1.1.12' # pp_environment
    result['environment'] = ext.value.gsub(/\W/, '')
  elsif ext.oid == '1.3.6.1.4.1.34380.1.1.13' # pp_role
    result['classes'] = ["roles::#{ext.value.gsub(/\W/, '')}"]
  end
end

puts result.to_yaml

