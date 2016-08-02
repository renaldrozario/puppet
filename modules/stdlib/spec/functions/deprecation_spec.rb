require 'spec_helper'

if ENV["FUTURE_PARSER"] == 'yes'
  describe 'deprecation' do
    pending 'teach rspec-puppet to load future-only functions under 3.7.5' do
      it { is_expected.not_to eq(nil) }
    end
  end
end

if Puppet.version.to_f >= 4.0
  describe 'deprecation' do
    before(:each) {
      # this is to reset the strict variable to default
      Puppet.settings[:strict] = :warning
    }

    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params().and_raise_error(ArgumentError) }

    it 'should display a single warning' do
      Puppet.expects(:warning).with(includes('heelo'))
      is_expected.to run.with_params('key', 'heelo')
    end

    it 'should display a single warning, despite multiple calls' do
      Puppet.expects(:warning).with(includes('heelo')).once
      is_expected.to run.with_params('key', 'heelo')
      is_expected.to run.with_params('key', 'heelo')
    end

    it 'should fail twice with message, with multiple calls. when strict= :error' do
      Puppet.settings[:strict] = :error
      Puppet.expects(:warning).with(includes('heelo')).never
      is_expected.to run.with_params('key', 'heelo').and_raise_error(RuntimeError, /deprecation. key. heelo/)
      is_expected.to run.with_params('key', 'heelo').and_raise_error(RuntimeError, /deprecation. key. heelo/)
    end

    it 'should display nothing, despite multiple calls. strict= :off' do
      Puppet.settings[:strict] = :off
      Puppet.expects(:warning).with(includes('heelo')).never
      is_expected.to run.with_params('key', 'heelo')
      is_expected.to run.with_params('key', 'heelo')
    end

    after(:all) {
      # this is to reset the strict variable to default
      Puppet.settings[:strict] = :warning
    }
  end
end
