# frozen_string_literal: true

require 'spec_helper_acceptance'

# Only the host provider is tested: openvox-agent doesn't ship the mailalias type
# (puppetlabs-mailalias_core) and metadata.json doesn't depend on it
describe 'host augeas provider' do
  before(:all) do
    shell("printf '127.0.0.1 localhost\\n' > /tmp/hosts_test")
  end

  context 'with ensure => present' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          host { 'example':
            ensure       => present,
            ip           => '192.168.1.1',
            host_aliases => ['foo-a', 'foo-b'],
            comment      => 'test',
            target       => '/tmp/hosts_test',
            provider     => augeas,
          }
        PUPPET
      end
    end

    describe file('/tmp/hosts_test') do
      its(:content) { is_expected.to match(%r{^127\.0\.0\.1\s+localhost$}) }
      its(:content) { is_expected.to match(%r{^192\.168\.1\.1\s+example\s+foo-a\s+foo-b\s+# test$}) }
    end
  end

  context 'with ensure => absent' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          host { 'example':
            ensure   => absent,
            target   => '/tmp/hosts_test',
            provider => augeas,
          }
        PUPPET
      end
    end

    describe file('/tmp/hosts_test') do
      its(:content) { is_expected.not_to match(%r{example}) }
      its(:content) { is_expected.to match(%r{^127\.0\.0\.1\s+localhost$}) }
    end
  end
end
