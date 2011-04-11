ERROR_ERROR_LIB_DIR = File.expand_path('../', __FILE__)
ERROR_ERROR_ROOT_DIR = File.expand_path('../../..', __FILE__)

module Palmade
  module ErrorError
    autoload :Error, File.join(ERROR_ERROR_LIB_DIR, 'error_error/error')
  end
end
