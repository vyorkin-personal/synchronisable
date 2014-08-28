[![Build Status](https://travis-ci.org/vyorkin/synchronisable.png?branch=master)](https://travis-ci.org/vyorkin/synchronisable)
[![Code Climate](https://codeclimate.com/github/vyorkin/synchronisable.png)](https://codeclimate.com/github/vyorkin/synchronisable)
[![Inline docs](http://inch-ci.org/github/vyorkin/synchronisable.png)](http://inch-ci.org/github/vyorkin/synchronisable)
[![Coverage Status](https://coveralls.io/repos/vyorkin/synchronisable/badge.png)](https://coveralls.io/r/vyorkin/synchronisable)
[![Gem Version](http://stillmaintained.com/vyorkin/synchronisable.png)](http://stillmaintained.com/vyorkin/synchronisable)
[![Dependency Status](https://gemnasium.com/vyorkin/synchronisable.svg)](https://gemnasium.com/vyorkin/synchronisable)

# Synchronisable

### :construction: this README & docs are work in progress :construction:

## Overview

Provides base fuctionality for active record models synchronization
with external resources. The remote source could be anything you like:
apis, services, site that you gonna parse and steal some data from it.

## Resources

* [Rubygems](https://rubygems.org/gems/synchronisable)
* [API](http://rdoc.info/github/vyorkin/synchronisable/master/frames)
* [Bugs](https://github.com/vyorkin/synchronisable/issues)
* [Development](https://travis-ci.org/vyorkin/synchronisable)

## Installation

Add this line to your application's Gemfile:

    gem 'synchronisable'

And then execute:

    $ bundle

Optionally, if you are using rails to run an initializer generator:

    $ rails g synchronisable:install

## Rationale

Sometimes we need to sync our domain models (or some part of them)
with some kind of remote source. Its great if you can consume a well-done RESTful api
that is pretty close to you local domain models.
But unfortunately the remote data source could be just anything.

Actually this gem was made to consume data coming from a site parser :crying_cat_face:

Examples of the usage patterns are shown below.
You can find more by looking at the [dummy app](https://github.com/vyorkin/synchronisable/tree/master/spec/dummy/app)
[models](https://github.com/vyorkin/synchronisable/tree/master/spec/dummy/app/models) and
[synchronizers](https://github.com/vyorkin/synchronisable/tree/master/spec/dummy/app/synchronizers).

## Features

* Attribute mapping, `unique_id`
* Associations sync + `:includes` option to specify (restrict)
  an association tree to be synchronized
* `before` and `after` callbacks to hook into sync process
* ???

## Configuration

For rails users there is a well-documented initializer.
Just run `rails g synchronisable:install` and you'll be fine.

Non-rails users can do so by using provided
`ActiveSupport::Configurable` interface. So here is the default settings:

```ruby
Synchronisable.configure do |config|
  # Logging configuration
  #
  # Default logger fallbacks to `Rails.logger` if available, otherwise
  # `STDOUT` will be used for output.
  #
  config.logging = {
    :logger   => defined?(Rails) ? Rails.logger : Logger.new(STDOUT)
    :verbose  => true,
    :colorize => true
  }

  # If you want to restrict synchronized models.
  # By default it will try to sync all models that have
  # a `synchronisable` dsl instruction.
  #
  config.models = %w(Foo Bar)
end
```

## Usage

Imagine a situation when you have to periodically get data from
some remote source and store it locally.
Basically the task is to create local records if they don't exist
and update their attributes otherwise.

### Gateways

Thing that provides an access to an external system or resource
is called [gateway](http://martinfowler.com/eaaCatalog/gateway.html).
You can take a look at the base [gateway](https://github.com/vyorkin/synchronisable/blob/master/lib/synchronisable/gateway.rb)
class to get a clue what does it mean in terms of this gem
(btw fetching data from a remote source is not a purpose of this gem).

The main idea is that gateway implementation class has only 2 methods:

* `fetch(params = {})` – returns an array of hashes, each hash contains
   an attributes that should be (somehow) mapped over your target model.
* `find(params)` – returns a single hash with remote attributes.
  `params` here is only to have a choice between representing a single
   or a composite identity.

### Models and synchronizers

The first step is to declare that your active record model is synchronizable.
You can do so by using corresponding `synchronisable` dsl instruction,
that optionally takes a synchonizer class to be used.
You should only specify it when the name can't be figured out
by the following convention: `ModelSynchronizer`.
So for example here we have a Tournament that has many Stages:

```ruby
class Tournament < ActiveRecord::Base
  has_many :stages

  synchronisable
end

class Stage < ActiveRecord::Base
  belongs_to :tournament

  synchronisable
end
```

Lets define synchronizers:

```ruby
class TournamentSynchronizer < Synchronisable::Synchronizer
  has_many :stages

  remote_id :tour_id
  unique_id { |attrs| attrs[:name] }

  mappings(
    :eman       => :name,
    :eman_trohs => :short_name,
    :gninnigeb  => :beginning,
    :gnidge     => :ending,
    :tnerruc_si => :is_current
  )

  only :name, :beginning, :ending

  gateway TournamentGateway
end

class StageSynchronizer < Synchronisable::Synchronizer
  has_many :matches

  remote_id :stage_id

  mappings(
    :tour_id   => :tournament_id,
    :gninnigeb => :beginning,
    :gnidge    => :ending,
    :eman      => :name,
    :rebmun    => :number
  )

  except :ignored_1, :ignored_2

  gateway StageGateway

  before_sync do |source|
    source.local_attrs[:name] != 'ignored'
  end
end
```

### Gateways vs `fetch` & `find` in synchronizers

TDOO: Blah blah blah... Need to describe the difference & use cases.

### Blah blah

### Blah blah

```ruby
class TournamentSynchronizer < Synchronisable::Synchronizer
  mappings(
    :t => :title,
    :c => :content
  )

  remote_id :p_id

  # Local attributes to ignore.
  # These will not be set on your local record.
  except :ignored_attr1, :ignored_attr42

  # Declares that we want to sync comments after syncing this model.
  # The resulting hash with remote attributes should contain `comment_ids`
  has_many :comments

  # Method that will be used to fetch all of the remote entities
  fetch do
    # Somehow get and return an array of hashes with remote entity attibutes
    [
      { t: 'first', c: 'i am the first post' },
      { t: 'second', c: 'content of the second post'  }
    ]
  end

  # This method should return only one hash for the given id
  find do |id|
    # return a hash with with remote entity attributes
    # ...
  end

  #
  before_record_sync do |source|
    # return false if you want to skip syncing of this particular record
    # ...
  end

  after_record_sync do |source|
    # ...
  end

  before_association_sync do |source, remote_id, association|
    # ...
  end

  after_association_sync do |source, remote_id, association|
    # ...
  end

  before_sync do |source|
    # ...
    # return false if you want to skip syncing of this particular record
  end

  after_sync do |source|
    # ...
  end
end



class MyCommentSynchronizer < Synchronisable::Synchronizer
  remote_id :c_id

  mappings(
    :a => :author,
    :t => :body
  )

  only :author, :body

  fetch do
    # ...
  end

  find do |id|
    # ...
  end

end
```

To start synchronization

```ruby
Post.sync
```
P.S.: Better readme & wiki is coming! ^__^

## Support

<a href='https://www.codersclan.net/task/yorkinv' target='_blank'><img src='https://www.codersclan.net/button/yorkinv' alt='expert-button' width='205' height='64' style='width: 205px; height: 64px;'></a>
