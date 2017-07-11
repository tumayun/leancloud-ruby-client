# -*- encoding : utf-8 -*-
## ----------------------------------------------------------------------
##
## Ruby client for parse.com
## A quick library for playing with parse.com's REST API for object storage.
## See https://parse.com/docs/rest for full documentation on the API.
##
## ----------------------------------------------------------------------
require 'rubygems'
require 'bundler/setup'

require 'faraday'
require 'faraday_middleware'
require_relative 'faraday/better_retry'
require_relative 'faraday/extended_parse_json'
require_relative 'faraday/get_method_override'
require 'date'
require 'cgi'

cwd = Pathname(__FILE__).dirname
$:.unshift(cwd.to_s) unless $:.include?(cwd.to_s) || $:.include?(cwd.expand_path.to_s)

require_relative 'leancloud/object'
require_relative 'leancloud/query'
require_relative 'leancloud/datatypes'
require_relative 'leancloud/util'
require_relative 'leancloud/protocol'
require_relative 'leancloud/user'
require_relative "leancloud/installation"
require_relative 'leancloud/push'
require_relative 'leancloud/cloud'
require_relative 'leancloud/model'
require_relative 'leancloud/batch'
require_relative 'leancloud/scan'
require_relative 'leancloud/application'
