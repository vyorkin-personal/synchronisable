[![Build Status](https://travis-ci.org/vyorkin/synchronisable.png?branch=master)](https://travis-ci.org/vyorkin/synchronisable)
[![Code Climate](https://codeclimate.com/github/vyorkin/synchronisable.png)](https://codeclimate.com/github/vyorkin/synchronisable)
[![Coverage Status](https://coveralls.io/repos/vyorkin/synchronisable/badge.png)](https://coveralls.io/r/vyorkin/synchronisable)
[![Gem Version](http://stillmaintained.com/vyorkin/synchronisable.png)](http://stillmaintained.com/vyorkin/synchronisable)
[![Dependency Status](https://gemnasium.com/vyorkin/synchronisable.svg)](https://gemnasium.com/vyorkin/synchronisable)

# Synchronisable

Provides base fuctionality (models, DSL) for AR synchronization
with external resources (apis, services etc).

## Overview

## Installation

Add this line to your application's Gemfile:

    gem 'synchronisable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install synchronisable

## Usage

For examples we'll be using a well-known domain with posts & comments

```ruby
class Post < ActiveRecord::Base
  has_many :comments

  synchronizable
end

class Comment < ActiveRecord::Base
  belongs_to :post

  synchronizable MyCommentSynchronizer
end
```

As you can see above the first step is to declare your models to be
synchronizable. You can do so by using corresponding dsl instruction,
that optionally takes a synchonizer class to be used. Actually,
the only reason to specify it its when it has a name, that can't be figured out
by the following convention: `ModelSynchronizer`.

After that you should define your model synchronizers

```ruby
class PostSynchronizer < Synchronisable::Synchronizer
  remote_id :p_id

  mappings(
    :t => :title,
    :c => :content
  )

  except :ignored_attr1, :ignored_attr42

  has_many :comments

  fetch do
    # return array of hashes with
    # remote entity attributes
  end

  find do |id|
    # return a hash with
    # with remote entity attributes
  end

  # Hooks/callbacks

  before_record_sync do |source|
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
  end

  after_sync do |source|
    # ...
  end
end

class MyCommentSynchronizer < Synchronizable::Synchronizer
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

```ruby
```

P.S.: i promise i'll finish this later, soon, this week, promise!

## Support

<a href='https://www.codersclan.net/task/yorkinv' target='_blank'><img src='https://www.codersclan.net/button/yorkinv' alt='expert-button' width='205' height='64' style='width: 205px; height: 64px;'></a>
