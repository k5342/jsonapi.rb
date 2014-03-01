require 'digest/sha2'
require 'json'
require 'uri'
require 'net/http'

class JSONAPI
  
  def initialize(host, port, user, password, salt)
    @host     = host
    @port     = port
    @user     = user
    @password = password
    @salt     = salt
  end
  
  class MultipleRequest
    
    attr_reader :methods, :args
    
    def initialize
      @methods = []
      @args    = []
    end
    
    def add(method, args = [])
      @methods << method
      @args    << args
    end
    
  end
  
  def standard(method, args = [])
    get('/api/call', method: method, args: args.to_json, key: compute_key(method))
  end
  
  def multiple_instant(methods, args)
    methods = methods.to_json
    get('/api/call-multiple', method: methods, args: args.to_json, key:compute_key(methods))
  end
  
  def multiple(multiple)
    methods = multiple.methods.to_json
    args    = multiple.args.to_json
    get('/api/call-multiple', method: methods, args: args, key: compute_key(methods))
  end
  
  def stream(source, &blk)
    call_api('/api/subscribe', source: source, key: compute_key(source)) do |response|
      response.read_body(&blk)
    end
  end
  
  private
  def compute_key(str)
    Digest::SHA256.hexdigest("#{@user}#{str}#{@password}#{@salt}")
  end
  
  def get(path, args)
    args.delete(:args) if args[:args] == ''
    call_api(path, args) do |response|
      return response.read_body
    end
  end
  
  def call_api(path, args, &blk)
    path_with_params = path + '?' + 
      args.map{|key, value| "#{key}=#{CGI.escape(value)}"}.join('&')
    
    path_with_params.gsub!('+', '%20')
    
    Net::HTTP.start(@host, @port) do |http|
      request = Net::HTTP::Get.new(path_with_params)
      
      #JSONAPI doesn't send HTTP header 'Transfer-Encoding: chunked'
      http.read_timeout = 60*60*24*7
      
      http.request(request, &blk)
    end
  end
  
end
