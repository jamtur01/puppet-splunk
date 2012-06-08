require 'puppet'
require 'yaml'
require 'rubygems'
require 'json'
require 'rest-client'
require 'uri'

unless Puppet.version >= '2.6.5'
  fail "This report processor requires Puppet version 2.6.5 or later"
end

Puppet::Reports.register_report(:splunk) do

  configfile = File.join([File.dirname(Puppet.settings[:config]), "splunk.yaml"])
  raise(Puppet::ParseError, "Splunk report config file #{configfile} not readable") unless File.exist?(configfile)
  CONFIG = YAML.load_file(configfile)
  API_ENDPOINT = 'services/receivers/simple'

  desc <<-DESC
  Send notification of reports to Splunk.
  DESC

  def process
    output = []
    self.logs.each do |log|
      output << log
    end

    @host = self.host
    @failed = true unless self.status != 'failed'
    @start_time = self.logs.first.time
    @elapsed_time = metrics["time"]["total"]

    #send_metrics(self.metrics)
    send_event(output)
  end

  def send_metrics(metrics)
    metadata = {
      :sourcetype => 'json_puppet-metrics',
      :source => 'puppet',
      :host => @host,
      :index => CONFIG[:index]
    }

    metrics.each { |metric,data|
      data.values.each { |val|
        name = "Puppet #{val[1]} #{metric}"
        if metric == 'time'
          unit = 'Seconds'
        else
          unit = 'Count'
        end
        value = val[2]
        puts name,unit,value
      }
    }
    splunk_post(event, metadata)
  end

  def send_event(output)
    metadata = {
          :sourcetype => 'json',
          :source => 'puppet',
          :host => @host,
          :index => CONFIG[:index]
    }

    event = {
      :failed => @failed,
      :start_time => @start_time,
      :end_time => Time.now,
      :elapsed_time => @elapsed_time,
      :exception => output}.to_json

    splunk_post(event, metadata)
  end

  def splunk_post(event, metadata)
    api_params = metadata.collect{ |k,v| [k, v].join('=') }.join('&')
    url_params = URI.escape(api_params)
    endpoint_path = [API_ENDPOINT, url_params].join('?')

    request = RestClient::Resource.new(
      CONFIG[:splunk_url], :user => CONFIG[:user], :password => CONFIG[:password]
    )

    request[endpoint_path].post(event)
  end
end
