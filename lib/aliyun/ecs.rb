require 'time'
require 'securerandom'
require 'uri'
require 'rest_client'
require 'base64'
require 'hmac-sha1'
require 'json'

module Aliyun
    class ECS
        def initialize(options={})
            Aliyun.config.access_key_id ||= options[:access_key_id]
            Aliyun.config.access_key_secret ||= options[:access_key_secret]
            Aliyun.config.endpoint_url ||= options[:endpoint_url]
        end
        
        def method_missing(method_name, *args)
            proxy_to_aliyun(method_name, args[0])
        end
        
        private
        def proxy_to_aliyun(method_name, params)
            params = build_request_parameters method_name, params
            res = RestClient.get Aliyun.config.endpoint_url, {:params => params, :verify_mode => OpenSSL::SSL::VERIFY_NONE }
            case res.code
            when 200
                JSON.parse res.body
            else
                raise AliyunError.new "response error code: #{res.code} and details #{res.body}"
            end
        end
        
        def build_request_parameters(method_name, params)
            params = Aliyun.config.request_parameters.merge params
            params.merge!({
                :AccessKeyId => Aliyun.config.access_key_id,
                :Action => method_name.to_s,
                :SignatureNonce => SecureRandom.uuid
            })
            params[:Signature] = compute_signature params
            params
        end
        
        def compute_signature(params)
            sorted_keys = params.keys.sort
            canonicalized_query_string = ""
            sorted_keys.each do |key|
                canonicalized_query_string << '&'
                canonicalized_query_string << percent_encode(key.to_s)
                canonicalized_query_string << '='
                canonicalized_query_string << percent_encode(params[key])
            end
            length = canonicalized_query_string.length
            string_to_sign = Aliyun.config.request_method + '&' + percent_encode('/') + '&' + percent_encode(canonicalized_query_string[1,length])
            calculate_signature access_key_secret+"&", string_to_sign
        end
        
        def calculate_signature key, string_to_sign
            hmac = HMAC::SHA1.new(key)
            hmac.update(string_to_sign)
            signature = Base64.encode64(hmac.digest).gsub("\n", '')
            signature
        end
        
        def percent_encode value
            value = URI.encode_www_form_component(value).gsub(/\+/,'%20').gsub(/\*/,'%2A').gsub(/%7E/,'~')
        end
        
    end
end
