require "aliyun/version"
require "aliyun/aliyun_error"
require "aliyun/ecs"
require 'singleton'

module Aliyun
    class Config
        include Singleton
        attr_accessor :request_parameters, :access_key_id, :access_key_secret, :endpoint_url, :request_method
        def initialize()
            self.request_parameters={
                :Format=>"JSON",
                :Version=>"2014-05-26", 
                :SignatureMethod=>"HMAC-SHA1", 
                :SignatureVersion=>"1.0"
            }
            self.request_method = 'GET'
            self.endpoint_url = 'https://ecs.aliyuncs.com/'
            self.access_key_id = ENV['ALIYUN_ACCESS_KEY_ID']
            self.access_key_secret = ENV['ALIYUN_ACCESS_KEY_SECRET']
        end
    end
    def self.[](key)
        Config.instance.send key if Config.instance.respond_to? key
    end
    def self.[]=(key,value)
        key="#{key}="
        Config.instance.send key,value if Config.instance.respond_to? key
    end
    def self.config(cfg)
        cfg.each do |k,v|
            self[k]=v
        end
    end
end
