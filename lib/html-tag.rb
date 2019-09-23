unless ''.respond_to?(:blank?)
  require 'fast_blank'
end

require_relative './html-tag/base'
require_relative './html-tag/adapter'