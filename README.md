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

然后利用自己阿里云账号下的access_key初始化ECS对象。如果没有access_key，可以通过[阿里云用户中心](https://i.aliyun.com/access_key/)申请access_key。

```
options = {
           :access_key_id => "xxxxxx", 
           :access_key_secret => "yyyyyy" 
           }
ecs = Aliyun::ECS.new options
```

这样, 你就可以根据 [阿里云弹性计算服务API参考手册](http://help.aliyun.com/view/11108189_13730407.html)初始化业务参数（除Action参数之外）为一个hash对象，并且将其作为参数传给Action方法（Action参数）。

```
parameters = {:parameter_name => parameter_value}
ecs.action parameters
```

(1) 例如查询可用地域列表，其Action参数为DescribeRegions，而没有其他参数，代码如下

```
ecs.describe_regions {}
```

(2) 再比如查询可用镜像，代码如下

```
parameters = {:RegionId => "cn-beijing", :PageNumber => 2, :RageSize => 20}
service.describe_images parameters
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/aliyun-api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
