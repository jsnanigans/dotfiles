-- set up backwards compatibility
require('utils.version').setup_backwards_compat()

-- set options
require 'config.options'

-- set auto commands
require 'config.autocmds'

-- setup mini dependency manager and plugins
require 'config.mini'

-- setup up package manager, load plugins and configs
require 'config.lazy'

-- require 'config.jdtls'
