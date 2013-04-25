require 'json'

class Fluent::ZoomdataOutput < Fluent::Output
  Fluent::Plugin.register_output('zoomdata', self)

  def initialize
    super
    require 'net/http'
    require 'uri'
  end


  # Endpoint URL ex. localhost.local:port/api/
  config_param :endpoint_url, :string, :default => 'https://localhost/zoomdata-web/service/upload'

  config_param :sourcename, :string, :default => nil

  config_param :ssl, :bool, :default => false
  config_param :verify_ssl, :bool, :default => false

  config_param :username, :string, :default => ''
  config_param :password, :string, :default => ''

  def configure(conf)
    super
  end

  def start
    super
  end

  def shutdown
    super
  end

  def format_url(tag)
    if @sourcename
      @endpoint_url + URI.escape('?source='+@sourcename)
    else
      @endpoint_url + URI.escape('?source='+tag)
    end
  end

  def post(tag, time, record)
    url = format_url(tag)
    res = nil
    begin
      uri = URI.parse(url)
      req = Net::HTTP::Post.new(url)
      req.basic_auth(@username, @password)
      req['Content-Type'] = 'application/json'
      req.body = JSON.dump(record)
      http = Net::HTTP.new(uri.host, uri.port)
      if @ssl
        http.use_ssl = true
        unless @verify_ssl
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end
      res = http.start {|http| http.request(req)}
    rescue IOError, EOFError, SystemCallError
      # server didn't respond
      $log.warn "Net::HTTP.post_form raises exception: #{$!.class}, '#{$!.message}'"
    end
    unless res and res.is_a?(Net::HTTPSuccess)
      $log.warn "failed to post to zoomdata: #{url}, json: #{record}, code: #{res && res.code}"
    end

  end

  def emit(tag, es, chain)
    es.each do |time, record|
      post(tag, time, record)
    end
    chain.next
  end

end