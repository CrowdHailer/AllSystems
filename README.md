# Usecase

Simple abstract usecases, with complete freedom on final state.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'usecase'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install usecase

## Usage

Example

```rb
Class FlipCoin < Usecase::Interactor
  def initialize(context)
    @context = context,
  end

  attr_reader :context

  def available_outcomes
    [:heads, :tails]
  end

  def run!
    report_tails if rand 2
    send_admin_report
    report_heads if rand 2
  end

  def send_admin_report
    context.admin_mailer.flipped_heads
  end
end

filp = FlipCoin.new(self)

filp.outcome
# => :heads

flip.results
# => []

flip.heads?
# => true

flip.consequence
# => [:heads]

flip.on_heads do
  puts "Hooray"
end
```

establish, deduce, ascertain, settle, evaluate

## Contributing

1. Fork it ( https://github.com/[my-github-username]/usecase/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
