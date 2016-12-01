require_relative '../../../kitchen/data/spec_helper'

describe 'solr/init.sls' do
  case os[:family]
  when 'debian'
    case os[:release]
    when '7.11'
      pkgs_installed = %w()
      main_config = '/etc/default/solr'
      solr_logfile = '/var/log/solr.log'
      service = 'solr'
    when '8.6'
      pkgs_installed = %w()
      main_config = '/etc/default/solr'
      solr_logfile = '/var/log/solr.log'
      service = 'solr'
    end
  when 'redhat'
    pkgs_installed = %w()
    main_config = '/etc/sysconfig/solr'
    service = 'solr'
  when 'arch'
    pkgs_installed = %w()
    main_config = '/usr/lib/systemd/system/solr.service'
    solr_logfile = '/var/log/solr.log'
    service = 'solr'
  when 'ubuntu'
    case os[:release]
    when '14.04'
      pkgs_installed = %w(default-jre)
      main_config = '/etc/default/solr'
      solr_logfile = '/var/log/solr.log'
      service = 'solr'
    when '16.04'
      pkgs_installed = %w()
      main_config = '/etc/default/solr'
      solr_logfile = '/var/log/solr.log'
      service = 'solr'
    end
  end

  pkgs_installed.each do |p|
    describe package(p) do
      it { should be_installed }
    end
  end

  describe service(service) do
    it { should be_running }
  end

  describe file(main_config) do
    it { should be_file }
    its(:content) { should_not match('# This file is managed by salt.') }
  end

  describe file(solr_logfile) do
    it { should be_file }
    its(:content) { should contain('INFO: Server startup in') }
  end
end
