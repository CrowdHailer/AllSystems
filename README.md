# Usecase

**Simple usecases/interactors, main interactor class currently only 45 lines.**

### Overview
An interactor encapsulates a specific buisness interaction, often a user interaction, such as `LogIn` or `CreatePost`. Each interactor runs once only to produce a single result that consists of an outcome and output. The outcome is a single :symbol and the output an optional array of values. The result can be decomposed into outcome and output as follows.

```rb
outcome, *output = result
```

Results are reported within the `run!` method of the interactor.

```rb
def run!
  new_user = {:name => 'John Smith'}
  report :success, new_user
end

# result = [:success, new_user]
# outcome = :success
# output = [new_user]
```

The interactor can then be used to set responses to the results

```rb
create_user.on :success do |user|
  puts "Hello #{user[:name]}"
end
```

### Question 1: What should the predicate method be called?
a) was?
```rb
create_user.was? :success
# => true
```
seams a bit odd to try and force the english as any outcome can be reported
```rb
create_user.was? :email_taken
```
b) outcome?
less nice in some cases
```rb
create_user.outcome? :success
# => true
```
but never sounds silly
```rb
create_user.outcome? :email_taken
```
c) outcome name
```rb
create_user.success?
# => true
```
Shortest solution but requires responding false to unknwn methods and not with a no method error, unless the interactor has a defined set of outcomes
```rb
create_user.email_taken?
# => true
create_user.emai_taken? #probably want this to throw error
# => false
```

### why?

Such a simple class that a library is almost not needed. I have found its value not in reduced work when making my specific interactors but in reduced testing for those interactor. Don't need to test things like single execution and predicate methods on specific interactors

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
  def available_outcomes
    [:heads, :tails]
  end

  def run!
    report_tails if [true, false].sample
    report_heads
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
