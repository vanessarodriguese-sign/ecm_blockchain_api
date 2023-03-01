# ECM Blockchain API

Client library to connect and transact with your [ECM Blockchain network](https://www.ecmsecure.com) and Certificate Authorities.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ecm_blockchain_api'
```

And then execute:

    $ bundle install

Or install through a CLI with:

    $ gem install ecm_blockchain_api

## Usage
Configure the library by initializing it with your access token.

```ruby
ECMBlockchain.access_token = 'abc'
```

Or create a Rails initializer file `ecm_api.rb`

```ruby
# file: app/initializers/ecm_api.rb

require 'ecm_blockchain_api'

ECMBlockchain.access_token = ENV['ECM_ACCESS_TOKEN']
```

## Interact with your Certificate Authority

```ruby
# Register and enroll member
ECMBlockchain::Member.create(
  uuid: "user@org1.example.com",
  secret: "s3cr3t!",
  customAttributes: [
    {
      name: "verified",
      value: "true"
    }
  ]
)

# Retrieve a member by UUID
member = ECMBlockchain::Member.retrieve("user@org1.example.com")
member.custom_attributes

# Update a member
custom_attributes = [{ name: "verified", value: "false" }]
ECMBlockchain::Member.update(custom_attributes)

# Delete a member
ECMBlockchain::Member.delete("user@org1.example.com")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ecm_blockchain_api.
