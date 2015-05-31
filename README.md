# AllSystems [![Gem Version](https://badge.fury.io/rb/all_systems.svg)](http://badge.fury.io/rb/all_systems)

**Simple Ruby usecases/interactors/service-object to encapsulate business logic**

### Well what is it?
The three terms above are all used at various times to describe the use of a dedicated object separate to the delivery mechanism (read ApplicationController) to coordinate the calls on several domain objects (such as user models). Service object is sometimes used to describe the encapsulation of an external service that you system uses. E.g. you might have a Stripe service object, so I do not use that term. Also usecase seams to make more sense on a non technical level, so the Login usecase is what the customer does. It is achieved using the Login interactor, the Ruby object. A good starting point is this [article](https://netguru.co/blog/service-objects-in-rails-will-help) as well as the further reading listed. This [article](http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/) helps explain there place in the landscape of objeccts beyond MVC  

### Overview
An interactor encapsulates a specific business interaction, often a user interaction, such as `LogIn` or `CreatePost`. The business logic is declared by defining a `go!` method. All possible outcomes are stated by defining a outcomes method. Each instance of the interactor executes the `go!` method once only to produce a single result. The result consists of an outcome and optional output. The outcome is a single :symbol to name the result. The output an array of zero or more values.

Results are reported within the `go!` method of the interactor.

```rb
Class WelcomeJohn < AllSystems::Interactor
  def options
    # Will always succeed
    [:success]
  end

  def go!
    new_user = {:name => 'John Smith'}
    report :success, new_user
  end
end

welcome = WelcomeJohn.new
welcome.result == [:success, new_user]
welcome.outcome == :success
welcome.output = [new_user]
```

The interactor outcome can then be used to decide response

```rb
welcome.on :success do |user|
  puts "Hello #{user[:name]}"
end
```

### why?

Such a simple class that a library is almost not needed. I have found its value not in reduced work when making my specific interactors but in reduced testing for those interactor. Don't need to test things like single execution and predicate methods on specific interactors

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'all_systems'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install all_systems

## Usage

### Example 1 *Flipping a coin*

```rb
Class FlipCoin < AllSystems::Interactor
  def outcomes
    [:heads, :tails]
  end

  def go!
    report_tails if [true, false].sample
    report_heads
  end
end

filp = FlipCoin.new

flip.result
# => [:heads]

filp.outcome
# => :heads

flip.output?
# => []

flip.heads?
# => true

flip.tails?
# => false

flip.other?
# raise UnknownMethodError

flip.heads do
  puts "Hooray"
end
```

Example 2

```rb
class Customer
  # One of several customer actions
  class PasswordReset < AllSystems::Interactor
    def initialize(context, id, params)
      @context = context
      @id = id
      @params = params
    end

    attr_reader :context, :id, :params

    def outcomes
      [:succeded, :account_unknown, :user_unknown, :not_permitted, :invalid_details]
    end

    def go!
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
class CustomerController
  def password_reset(id)
    reset = Customer::Password.new(self, id, request.POST['customer'])

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
  end
end
```
establish, deduce, ascertain, settle, evaluate

## Docs

**#go!** `interactor.go! => raise AbstractMethodError`

Abstract method that will always raise an error. Should be over written in for specific interactors

**#outcomes** `interactor.outcomes => []`

Should be over written in for specific interactors to return list of possible outcomes

**#name** `interactor.name => class_name`

Returns the name of the class or Anonymous if class not set to constant

**(private)#report** `interactor.report(outcome, *output) => terminate with result`

Use within the interactor to report that an outcome state has been reached with optional output. Terminates execution of go!

**#outcome** `interactor.outcome => symbol`

Returns the outcome of goning the interactor

**#outcome?(outcome)** `interactor.outcome?(outcome) => boolean`

Does the outcome match the predicate outcome.

**#output** `interactor.output => [*output]`

Returns an array of output from goning the interactor

**#on(:outcome)** `interactor.on(:outcome, &block) => block return value`

If the interactors out come was the same as given here then the output is yielded to the block, else no action.


**#&lt;outcome&gt;?** `interactor.<outcome>? => boolean`

Was the outcome equal to the method name, raises error if method name not one of possible outcomes

**#&lt;outcome&gt;** `interactor.<outcome> &block => block_return_value`

Yields output to block if outcome equal to method name, raises error if method name not one of possible outcomes

**#report_&lt;outcome&gt;** `interactor.report_<outcome>(*output) => terminate with result`

Use within the interactor to report that an outcome state has been reached with optional output. Terminates execution of go!

## Testing
I separate my tests on the interactor divison as much as possible. 

#### Testing the domain
These are often the nearest thing I have to integration tests. I find that making tests of the interactors that hit all parts of the domain, e.g. the database. Are much less cumbersome than trying to test all the domain logic from a web interface

```rb
context = OpenStruct.new(:current_user => admin_user, :logger => NullLogger.new)
# Don't need to do any fill in user[password_confirmation] noise just pass the imputs as the form would have coerced them.
form = OpenStruct.new(:password => new_password, :current_password => oldpassword)

interactor = ChangePassword.new(context, admin_user.id, form)
assert_equal :success, interactor.outcome
assert_equal [admin_user], interactor.output
# OR
assert_equal [:success, admin_user], interactor.result
```

There is no need to test any of the blocks arguments which is normally more complicated than testing a return value. This is the main reason I reuse this Gem, for the assurance that the calls have been separatly tested.

#### Testing the web application
This is simply the case of stubbing out the result from the usecase then testing the returned pages/json any way you want

```rb
ChangePassword.stub :new, DummyInteractor.new(:success, admin_user) do
  post '/change_password' # don't need any form parms 
end
assert_something last_response
```

To test the imput send whatever you like and then check that the form has the correct details
```rb
dummy_interactor = DummyInteractor.new(:success, admin_user)
ChangePassword.stub :new, DummyInteractor.new(:success, admin_user) do
  post '/change_password', {:user => {:password => new_password, :etc => etc}}
end
assert_something dummy_interactor.form
```

## Upcoming
8. actions on class passed to instance *possible to declare action before use*

## Contributing

1. Fork it ( https://github.com/[my-github-username]/usecase/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
