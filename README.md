# JSONAPI

A Ruby library to access Bukkit server over JSONAPI plugin.

## Usage

```ruby
require 'jsonapi'
client = JSONAPI.new(HOST, PORT, USER, PASSWORD, SALT)
```

### Use standard API

```ruby
#kickPlayer
puts client.standard('kickPlayer', ['k5342', 'You are kicked from the server.'])

#getBukkitVersion
puts client.standard('getBukkitVersion', [])

#You can write like this:
puts client.standard('getBukkitVersion')
```

If successfully, you can see this results:

```json
{"result":"success","source":"kickPlayer","success":null}
{"result":"success","source":"getBukkitVersion","success":"1.7.2-R0.3-SNAPSHOT"}
{"result":"success","source":"getBukkitVersion","success":"1.7.2-R0.3-SNAPSHOT"}
```

### Use multiple API

```ruby
puts client.multiple_instant(['getBukkitVersion','kickPlayer'], [[], ['k5342', 'You are kicked from the server.']])
```

But code above is awkward to use.

```ruby
req = JSONAPI::MultipleRequest.new
req.add('getBukkitVersion')
req.add('kickPlayer', ['k5342', 'You are kicked!'])

puts client.multiple(req) #call api
```

```json
{"result":"success","source":["getBukkitVersion","kickPlayer"],"success":[{"result":"success","source":"getBukkitVersion","success":"1.7.2-R0.3-SNAPSHOT"},{"result":"success","success":null ,"source":"kickPlayer"}]}
```

### Use stream API

```ruby
client.stream('console') do |response|
  puts response
end
```

```json
{"result":"success","source":"console","tag":null,"success":{"time":1393679649,"line":"2014-03-01 22:14:09 [INFO] [JSONAPI] [API Call] 127.0.0.1: method=kickPlayer?args=[\"k5342\",\"\"]\n"}}
{"result":"success","source":"console","tag":null,"success":{"time":1393679649,"line":"2014-03-01 22:14:09 [INFO] onPlayerKick - before:§ek5342 left the game.\n"}}
```

