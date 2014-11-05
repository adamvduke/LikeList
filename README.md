# Like List

## Getting Started

1. This application relies on using Instagram as a third party provider for
authentication. As such, you will need to obtain an application key/secret pair
from [Instagram](http://instagram.com/developer/clients/register/)
1. Copy `config/application.example.yml` to `config/application.yml` and add
values for each key.
1. Run `bundle && rake db:migrate && rake` to install the application's
dependencies, create the database, and run the tests.

## Dependencies

1. ruby
1. redis
1. postgresql

## Running the site

1. `bundle exec rails s`

## Running sidekiq

1. `bundle exec sidekiq -q default -q low_priority`

## Credits

The template for this application was generated with the
[rails\_apps\_composer](https://github.com/RailsApps/rails_apps_composer) gem
provided by the [RailsApps Project](http://railsapps.github.com/).
