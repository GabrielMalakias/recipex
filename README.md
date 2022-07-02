# Recipex

## Overview

This app display recipes by retrieving them from Contentful and storing them in the registry

![Home](images/home.jpg)
![Details](images/details.jpg)

## Installing

First install elixir, this project uses 1.13.4, there are many ways to do that for more details check some options like:

- https://asdf-vm.com/
- https://github.com/taylor/kiex

After installing elixir you can install the dependencies by running `./scripts/setup`
To make sure everything was installed correctly and the app works, please run `./scripts/start`
In case you would like to run using docker the application can be started by running `docker-compose up -d`
Otherwise you can simply run `./scripts/start`

If you have added code please make sure you run `mix credo` before pushing it to Github :)

### How it works

There is a Genserver named worker that given the interval configured. It can be configured in the following way:
```elixir
config :recipex, cache_expiration: :timer.seconds(30)
```

As the worker requests it, it saves all the results returned by this api into the registry making it available once someone requests it. As soon as the application starts it tries to retrieve the list of recipes.

### Considerations/Limitations

I tried to write as much tests as possible for the important parts, neglecting a bit the controller/view tests. If I had more time I could certainly add it.

The idea behind using the `Registry` as cache comes from my experience with Redis + Ruby, luckily it works out of the box with elixir

I could have improved a bit more the Mapper to avoid some loops but as everything is handled in background I though it wouldnt make that much of a difference for now.

I did not spend time trying to improve the views, so they look quite ugly