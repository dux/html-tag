require 'fast_blank'

module ApplicationHelper
end

class Object
  def rr data
    ap ['- start', data, '- end']
  end
end

require './lib/html-tag'

# basic config
RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :json, CustomFormatterClass
end
