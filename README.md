# Tenacious

[![Build Status](https://travis-ci.org/emerald-rubies/tenacious.svg?branch=master)](https://travis-ci.org/emerald-rubies/tenacious)

A tenacious inventory system.

## Dependencies

- Ruby 2.4.1
- psql
- node
- yarn

## Setup

### First time setup

Simply run `bin/setup` after all dependencies have been met.

You can also run `bin/setup` to reset your instance.

### Running the Server

`bundle exec rails s` and `bin/webkpack-dev-server` in seperate terminal panes

### Running the Tests

`bin/rake` or `bundle exec rspec`

Travis also tests rubocop which is required for PR acceptance, you can run that with `bundle exec rubocop`.
