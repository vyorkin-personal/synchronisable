[![Build Status](https://travis-ci.org/vyorkin/synchronisable.png?branch=master)](https://travis-ci.org/vyorkin/synchronisable)
[![Code Climate](https://codeclimate.com/github/vyorkin/synchronisable.png)](https://codeclimate.com/github/vyorkin/synchronisable)
[![Inline docs](http://inch-ci.org/github/vyorkin/synchronisable.png)](http://inch-ci.org/github/vyorkin/synchronisable)
[![Coverage Status](https://coveralls.io/repos/vyorkin/synchronisable/badge.png)](https://coveralls.io/r/vyorkin/synchronisable)
[![Gem Version](http://stillmaintained.com/vyorkin/synchronisable.png)](http://stillmaintained.com/vyorkin/synchronisable)
[![Dependency Status](https://gemnasium.com/vyorkin/synchronisable.svg)](https://gemnasium.com/vyorkin/synchronisable)

# Synchronisable

## Overview

Provides base fuctionality for active record models synchronization
with external resources. The remote source could be anything you like:
apis, services, site that you gonna parse and steal some data from it.

## Installation

Add this line to your application's Gemfile:

    gem 'synchronisable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install synchronisable

Then to run a generator:

    $ rails g synchronisable:install

## Usage

The first step is to declare that your active record model is synchronisable:
You can do so by using corresponding dsl instruction,
that optionally takes a synchonizer class to be used:

```ruby
class Post < ActiveRecord::Base
  has_many :comments

  synchronisable
end

class Comment < ActiveRecord::Base
  belongs_to :post

  synchronisable MyCommentSynchronizer
end
```

Actually, the only reason to specify it its when it has a name, that can't be figured out
by the following convention: `ModelSynchronizer`.

After that you should define your model synchronizers:

```ruby
class PostSynchronizer < Synchronisable::Synchronizer
  # Here is how you can define mappings from remote attributes to your local
  mappings(
    :t => :title,
    :c => :content
  )

  # The remote id (won't be mapped)
  remote_id :p_id

  # Local attributes to ignore.
  # These will not be set on your model.
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
