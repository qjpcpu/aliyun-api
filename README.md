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
parameters = {:RegionId => "cn-beijing", :PageNumber => 2, :PageSize => 20}
service.describe_images parameters
# or use parameters in rubyway
parameters = {:region_id => "cn-beijing", :page_number => 2, :page_size => 20}
```

## ECS API列表(aliyun ecs api版本: 20140526)

### 实例相关接口
#### 创建实例create_instance
参数列表
* region_id,地域,required
* zone_id,子区域,optional
* image_id,镜像,required
* instance_type, required
* security_group_id, required
* instance_name, optional
* description, optional
* 略

example: `ecs.create_instance :region_id=>'cn-hangzhou',:image_id=>'img_identifier',:instance_type=>'t2.small',:security_group_id=>'sg_id'`

#### 启动实例start_instance
参数列表
* instance_id,实例id,required

example: `ecs.start_instance :instance_id=>'AYxxx'`

#### 停止实例stop_instance
参数列表
* instance_id,实例id,required
* force_stop,重启机器时是否强制关机，默认为false, optional

example: `ecs.stop_instance :instance_id=>'AYxxx'`

#### 重启实例reboot_instance
参数列表
* instance_id,实例id,required
* force_stop,重启机器时是否强制关机，默认为false, optional

example: `ecs.reboot_instance :instance_id=>'AYxxx'`

#### 修改实例属性modify_instance_attribute
参数列表
* instance_id,实例id,required
* instance_name,optional
* description, optional
* password, optional
* host_name, optional

example: `ecs.modify_instance_attribute :instance_id=>'AYxxx',:instance_name=>'new-name'`

#### 查询实例列表describe_instance_status
参数列表
* region_id,地域id,required
* zone_id,子区域,optional
* page_number, optional
* page_size, optional

example: `ecs.describe_instance_status :region_id=>'cn-hangzhou'`

#### 查询实例信息describe_instance_attribute
参数列表
* instance_id,实例id,required

example: `ecs.describe_instance_attribute :instance_id=>'AYxxx'`

## Contributing

1. Fork it ( https://github.com/qjpcpu/aliyun-api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
