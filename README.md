# Aliyun

The Aliyun ECS API Client for Ruby 是调用 [阿里云 ECS服务](http://help.aliyun.com/view/11108189_13730407.html) 的 Ruby客户端类库.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aliyun-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aliyun-api

## Usage

首先，需要在代码中引入类库:

```
require 'aliyun'
```

### 配置aliyun的access_key

#### 1. 全局配置

```
options = {
           :access_key_id => "xxxxxx", 
           :access_key_secret => "yyyyyy" 
           }
Aliyun.config options
ecs = Aliyun::ECS.new
```

#### 2. 直接配置ECS客户端

```
options = {
           :access_key_id => "xxxxxx", 
           :access_key_secret => "yyyyyy" 
           }
ecs = Aliyun::ECS.new options
```

#### 3. 环境变量

如果环境变量里`ALIYUN_ACCESS_KEY_ID`和`ALIYUN_ACCESS_KEY_SECRET`初始化了密钥，那么可以直接初始化ecs：

```
ecs = Aliyun::ECS.new
```

### 调用ECS

这样, 你就可以根据 [阿里云弹性计算服务API参考手册](http://help.aliyun.com/view/11108189_13730407.html)初始化业务参数（除Action参数之外）为一个hash对象，并且将其作为参数传给Action方法（Action参数）, action方法需要将阿里云手册中的Action名按ruby方式命名, 如：阿里云手册中的Action名`StartInstance`对应到这里的方法名为`start_instance`。

(1) 例如查询可用地域列表，其Action参数为DescribeRegions，而没有其他参数，代码如下

```
ecs.describe_regions {}
# 输出如下：
{"Regions"=>{"Region"=>[{"LocalName"=>"深圳", "RegionId"=>"cn-shenzhen"}, {"LocalName"=>"青岛", "RegionId"=>"cn-qingdao"}, {"LocalName"=>"北京", "RegionId"=>"cn-beijing"}, {"LocalName"=>"香港", "RegionId"=>"cn-hongkong"}, {"LocalName"=>"杭州", "RegionId"=>"cn-hangzhou"}]}, "RequestId"=>"abcdefg"}
```

(2) 再比如查询可用镜像，代码如下

```
parameters = {:RegionId => "cn-beijing", :PageNumber => 2, :RageSize => 20}
service.describe_images parameters
```


## Contributing

1. Fork it ( https://github.com/qjpcpu/aliyun-api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
