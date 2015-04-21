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
    @context = context
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

# output?
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

Example 2

```rb
class Customer
  # One of several customer actions
  class PasswordReset < Usecase::Interactor
    def initialize(context, id, params)
      @context = context
      @id = id
      @params = params
    end

    attr_reader :context, :id, :params

    def available_outcomes
      [:succeded, :account_unknown, :user_unknown, :not_permitted, :invalid_details]
    end

    def run!
      report_account_unknown id, unless account
      report_user_unknown if authority.guest?
      report_not_permitted unless authority == account || authority.admin?
      report_invalid_details form unless form.valid?
      account.password = form.password
      account.save
      send_email
      report_succeeded account
    end

    def send_email
      context.customer_mailer.password_reset
    end

    def form
      @form ||= Form.new params
    end

    def account
      @account ||= Customers[id]
    end

    def authority
      @authority ||= context.current_user
    end

  end
end

# use in controller

  reset = Customer::Password.new(self, 1, request.POST['customer'])

  reset.succeeded do |customer| # 204: No Content
    flash['success'] = 'Password update successful'
    redirect customer_page(customer), 204
  end

  reset.unknown_account do |id| # 404: Not found
    flash['error'] = "account: #{id} not found"
    redirect customers_page, 404
  end

  reset.unknow_user do # 401: Unauthenticated
    flash['error'] = 'Login required'
    redirect login_page, 401
  end

  reset.not_permitted do # 403: Forbidden
    flash['error'] = 'Not authorized'
    redirect customer_page, 403
  end

  reset.invalid_details do |form| # 400: bad request
    status = 400
    render :new, :locals => {:form => form}
  end
```
establish, deduce, ascertain, settle, evaluate

## Upcoming
1. Generalize callback and query methods
2. `report_outcome` as method
3. Error for unknown callback *maybe declaring callbacks not necessary*
4. Error for reporting unknown outcome *maybe declaring callbacks not necessary*
7. inheritance of available callbacks *maybe declaring callbacks not necessary*
8. actions on class passed to instance *possible to declare action before use*

## Contributing

1. Fork it ( https://github.com/[my-github-username]/usecase/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
