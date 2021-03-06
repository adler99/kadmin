# Rails dependencies
require 'bootstrap-sass'
require 'sass-rails'
require 'jquery-rails'
require 'select2-rails'

module Kadmin
  class Engine < ::Rails::Engine
    isolate_namespace Kadmin

    initializer 'kadmin.install', after: :finisher_hook do
      Kadmin.logger = Rails.logger
    end
  end
end
