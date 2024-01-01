# StackProf::RouteMiddleware

Yet another `StackProf::Middleware` which saves dump files by each application route.

## Usage

### Sinatra

Sample configuration:

```ruby
use StackProf::RouteMiddleware,
    enabled: true,
    mode: :wall,
    interval: 1000,
    raw: true,
    route_calculator: proc { |env| env['sinatra.route'] }
```

Results in:

```bash
$ ls -alh tmp/
$ ls -alh tmp  | head
total 24632
drwxr-xr-x@ 2261 sangenya  staff    71K  1  1 22:48 .
drwxr-xr-x    16 sangenya  staff   512B  1  1 22:57 ..
-rw-r--r--     1 sangenya  staff   109B  1  1 22:48 stackprof-GET__api_chair__id-wall-97768-1704116922.dump
-rw-r--r--     1 sangenya  staff   109B  1  1 22:48 stackprof-GET__api_chair__id-wall-97768-1704116923.dump
-rw-r--r--     1 sangenya  staff   109B  1  1 22:48 stackprof-GET__api_chair__id-wall-97768-1704116924.dump
...
-rw-r--r--     1 sangenya  staff   109B  1  1 22:48 stackprof-POST__api_estate_req_doc__id-wall-97783-1704116920.dump
-rw-r--r--     1 sangenya  staff   109B  1  1 22:48 stackprof-POST__api_estate_req_doc__id-wall-97783-1704116921.dump
-rw-r--r--     1 sangenya  staff   109B  1  1 22:48 stackprof-POST__api_estate_req_doc__id-wall-97783-1704116922.dump
-rw-r--r--     1 sangenya  staff   109B  1  1 22:48 stackprof-POST__api_estate_req_doc__id-wall-97783-1704116923.dump
```

So you can analyze a specific route:

```bash
$ bundle exec stackprof tmp/stackprof-GET__api_estate_low_priced-wall-* --limit 5
==================================
  Mode: wall(1000)
  Samples: 85 (1.16% miss rate)
  GC: 2 (2.35%)
==================================
     TOTAL    (pct)     SAMPLES    (pct)     FRAME
        71  (83.5%)          71  (83.5%)     Mysql2::Client#_query
         4   (4.7%)           3   (3.5%)     JSON::Ext::Generator::GeneratorMethods::Hash#to_json
         3   (3.5%)           3   (3.5%)     Mysql2::Result#each
         2   (2.4%)           1   (1.2%)     App#camelize_keys_for_estate
        82  (96.5%)           1   (1.2%)     Sinatra::Base#route!
```

### Ruby on Rails

Sample configuration:

```ruby
use StackProf::RouteMiddleware,
    enabled: true,
    mode: :wall,
    interval: 1000,
    raw: true,
    route_calculator:  proc { |env| "#{env['REQUEST_METHOD']}_#{env['action_dispatch.route_uri_pattern']}" }
```

Results in:

```bash
$ ls -alh tmp/stackprof-*
-rw-r--r--  1 sangenya  staff   109B  1  1 23:36 tmp/stackprof-GET_-wall-3323-1704119802.dump
-rw-r--r--  1 sangenya  staff   207K  1  1 23:36 tmp/stackprof-GET__users___format_-wall-3323-1704119801.dump
-rw-r--r--  1 sangenya  staff    43K  1  1 23:36 tmp/stackprof-GET__users___format_-wall-3323-1704119805.dump
-rw-r--r--  1 sangenya  staff    41K  1  1 23:36 tmp/stackprof-GET__users___format_-wall-3323-1704119812.dump
-rw-r--r--  1 sangenya  staff    54K  1  1 23:36 tmp/stackprof-GET__users__id___format_-wall-3323-1704119804.dump
-rw-r--r--  1 sangenya  staff    41K  1  1 23:36 tmp/stackprof-GET__users__id___format_-wall-3323-1704119807.dump
-rw-r--r--  1 sangenya  staff    39K  1  1 23:36 tmp/stackprof-GET__users__id___format_-wall-3323-1704119810.dump
-rw-r--r--  1 sangenya  staff    51K  1  1 23:36 tmp/stackprof-GET__users__id_edit___format_-wall-3323-1704119809.dump
-rw-r--r--  1 sangenya  staff    59K  1  1 23:36 tmp/stackprof-GET__users_new___format_-wall-3323-1704119806.dump
-rw-r--r--  1 sangenya  staff    40K  1  1 23:36 tmp/stackprof-PATCH__users__id___format_-wall-3323-1704119810.dump
-rw-r--r--  1 sangenya  staff    53K  1  1 23:36 tmp/stackprof-POST__users___format_-wall-3323-1704119807.dump
```

## Installation

Add this line to your Gemfile:

```ruby
gem 'stackprof-route_middleware'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/genya0407/stackprof-route_middleware.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
