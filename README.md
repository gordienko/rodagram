# Installation

Requires `ruby 2.7.0` to be installed and `PostgreSQL Server 10+`

```
$ bundle install

$ rake db:create
$ rake db:migrate
$ rake db:seed

```

# Running

```
$ bundle exec foreman start