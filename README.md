# Knife::VM

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'knife-vm'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install knife-vm

## Usage

# server management

    knife vm server list
    knife vm server show NAME
    
    knife vm server create NAME
    knife vm server delete NAME
    knife vm server converge NAME
    knife vm server converge NAME
    
# chef_server management

    knife vm chef_server create
    knife vm chef_server delete
    knife vm configure

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
