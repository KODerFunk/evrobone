# Evrobone

[![Gem Version](https://badge.fury.io/rb/evrobone.svg)](http://badge.fury.io/rb/evrobone)

Light-weight client-side framework based on Backbone.js for Ruby on Rails Front-end

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'evrobone'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install evrobone

## Usage

Coming soon...

### `Evrobone.AppClass` и организация приложения

### `Evrobone.AppMixins.ViewsManagement` и `Evrobone.View`

### `Evrobone.AppMixins.CustomElementBinding` и `/initializers`

### `Evrobone.AppMixins.WindowNavigation` и совместимость с Turbolinks

### `Evrobone.AppMixins.WindowRefresh`

### LiveReload plugin for Ruby on Rails

Для более удобного использования LiveReload в Ruby on Rails проекте, можно подключить плагин, добавив в `config/initializers/assets.rb`:
```ruby
Rails.application.config.assets.precompile += %w( evrobone/lib/livereload-plugin-rails.js ) if Rails.env.development?
```
и подключить скрипт в лэйауте:
```haml
- if Rails.env.development?
  = javascript_include_tag 'evrobone/lib/livereload-plugin-rails'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/KODerFunk/evrobone.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
