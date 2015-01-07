require "aliyun/version"
require "aliyun/aliyun_error"
require "aliyun/ecs"
require 'singleton'

module Aliyun
    class Config
        include Singleton
        attr_accessor :request_parameters, :access_key_id, :access_key_secret, :endpoint_url, :request_method
        def initialize
            self.request_parameters={
                :Format=>"JSON",
                :Version=>"2014-05-26", 
                :SignatureMethod=>"HMAC-SHA1", 
                :SignatureVersion=>"1.0"
            }
            self.request_method = 'GET'
            self.endpoint_url= 'https://ecs.aliyuncs.com/'
        end
    end
    def self.config
        Config.instance
    end
end
