# README

Create the new rail project :
```
rails new dailylog
```

Generate your data model, `scaffold` will create everything (MVC)
```
bin/rails generate scaffold event EventType:string{100} date:date
bin/rails db:migrate
```

if you wand to land on events page add this to _config/routes.rb_
```
root "events#index"
```

To run the server :
```
bin/rails server
```
That's it you can now play with the events, if you want to go further continue reading :)

# Additionnal features

## Install Tailwindcss and make a beautiful UI :
[Tailwindcss](https://tailwindcss.com/docs/guides/ruby-on-rails)

Add this to your Gemfile:
```
gem "tailwindcss-rails"
```
then run:
```
bundle install
bin/rails tailwindcss:install
```
You can test that everything works by uncommenting the content of _app/assets/stylesheets_
and add the new class (btn-primary) to a button for example in _app/views/events/index.html.erb_:
```
<%= button_to "New event", new_event_path, class:"btn-primary" %>
```

Once you installe tailwindcss you need to change the way you run the server because it will use `foreman` to monitor
changes in the code and in the css for tailwindcss to rebuild, so now the command to run the server is:
```
bin/dev
```


## Install Chartkick and make pretty graphs
[Chartkick](https://chartkick.com/)

To be able to use chartkick add this to your gemfile:
```
gem "chartkick"
gem "groupdate"
```
then run `bundle install`

add this to _config/importmap.rb_:
```
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"
```
and this to _app/javascript/application.js_:
```
import "chartkick";
import "Chart.bundle";
```
You can test that everything works you can add this line inside `<div id="events">`:
```
  <%= line_chart @events.group_by_day(:date).count %>
```

## Install Devise to log in and restrict access depending on which user is connected
[Devise](https://github.com/heartcombo/devise)

### Signup and login
Add this to the Gemfile:
```
gem "devise"
```
then run `bundle install`

then install everything in your project needed for authentication with:
```
bin/rails generate devise:install
bin/rails generate devise User
```

Ensure you have defined root_url to *something* in your _config/routes.rb_ for example:
```
root "events#index"
```
Ensure you have flash messages in _app/views/layouts/application.html.erb_.
That will allow devise to open the log in page. For example in the body:
```
<p class="notice"><%= notice %></p>
<p class="alert"><%= alert %></p>
```

### Associate events to a specific user
If you want your events to be associated with users run:
```
bin/rails g migration add_user_to_event user:references
```

Then you need to add this to your user model _app/models/user.rb_:
```
has_many :events
```

For you events to be associated with a specific user (the one logged in) you need to change this different lines
Add this at the begining (after the other before_action):
```
before_action :authenticate_user!
```
___
change: (that will only list the current user events)
```
  def index
    @events = Event.all
  end
```
to:
```
  # GET /events or /events.json
  def index
    @events = current_user.events
  end
```
___
change: (that will associate the events to the user at creation)
```
  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
```
to:
```
  # POST /events or /events.json
  def create
    @event = current_user.events.new(event_params)
```
___
change: (that will handle the other function like edit and show to work only if the user own the event)
```
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end
```
to:
```
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = current_user.events.find(params[:id])
    end
```