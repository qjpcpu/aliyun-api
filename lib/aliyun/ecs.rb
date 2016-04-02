require 'time'
require 'securerandom'
require 'uri'
require 'rest_client'
require 'base64'
require 'openssl'
require 'json'


module Aliyun
    class ECS
        def initialize(options={})
            Aliyun[:access_key_id] = options[:access_key_id] || Aliyun[:access_key_id] || ENV['ALIYUN_ACCESS_KEY_ID']
            Aliyun[:access_key_secret] = options[:access_key_secret] || Aliyun[:access_key_secret] || ENV['ALIYUN_ACCESS_KEY_SECRET']
            Aliyun[:endpoint_url] ||= options[:endpoint_url]
        end
        
        def method_missing(method_name, *args,&block)
            super if  /[A-Z]/ =~ method_name.to_s
            method_name = method_name.to_s.split('_').map{|w| w.capitalize }.join('').gsub '_',''
            proxy_to_aliyun(method_name, args[0],&block) 
        end
        
        private
        def proxy_to_aliyun(method_name, params,&block)
            params = build_request_parameters method_name, params
            block.call params if block
            begin
                res = RestClient.send Aliyun[:request_method].downcase, Aliyun[:endpoint_url], {:params => params,:verify_ssl => OpenSSL::SSL::VERIFY_PEER }
                return JSON.parse res.body if res.code == 200
            rescue RestClient::Exception => rcex
                raise AliyunError.new "response error: #{rcex.to_s}\nresponse detail: #{rcex.http_body}\nrequest parameters: #{params.reject{|k,v| k==:AccessKeyId}}"
            rescue =>e
                raise AliyunError.new e.to_s
            end
        end
        
        def build_request_parameters(method_name, params={})
            params = Aliyun[:request_parameters].merge(params||{})
            params.keys.each do |k|
                if /[A-Z]/ !~ k.to_s
                    key=k.to_s.split('_').map{|w| w.capitalize }.join('').gsub('_','').to_sym
                    params[key] = params.delete k
                end
            end
            params.merge!({
                              :AccessKeyId => Aliyun[:access_key_id],
                              :Action => method_name.to_s,
                              :SignatureNonce => SecureRandom.uuid,
                              :TimeStamp => Time.now.utc.iso8601
                          })
            params[:Signature] = compute_signature params
            params
        end
        
        def compute_signature(params)
            params = params.inject({}){|memo,(k,v)| memo[k.to_sym]=v;memo}
            sorted_keys = params.keys.sort
            canonicalized_query_string = ""
            sorted_keys.each do |key|
                canonicalized_query_string << '&'
                canonicalized_query_string << percent_encode(key.to_s)
                canonicalized_query_string << '='
                canonicalized_query_string << percent_encode(params[key])
            end
            length = canonicalized_query_string.length
            string_to_sign = Aliyun[:request_method] + '&' + percent_encode('/') + '&' + percent_encode(canonicalized_query_string[1,length])
            calculate_signature Aliyun[:access_key_secret]+"&", string_to_sign
        end
        
        def calculate_signature key, string_to_sign
            Base64.strict_encode64 OpenSSL::HMAC.digest('sha1',key, string_to_sign)
        end
        
        def percent_encode value
            value = URI.encode_www_form_component(value).gsub(/\+/,'%20').gsub(/\*/,'%2A').gsub(/%7E/,'~')
        end
        
    end
end
