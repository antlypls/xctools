# XcTools

[![Code Climate](http://img.shields.io/codeclimate/github/antlypls/xctools.svg?style=flat)](https://codeclimate.com/github/antlypls/xctools)
[![Build Status](http://img.shields.io/travis/antlypls/xctools.svg?style=flat)](https://travis-ci.org/antlypls/xctools)

Collection of helpers for parsing Xcode CLI tools output.

This is an extract from [ognivo gem](https://github.com/antlypls/ognivo).
Originally code is based on a [shenzhen tool](https://github.com/nomad/shenzhen).

## Installation

Add this line to your application's Gemfile:

    gem 'xctools'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xctools

## Usage

    XcTools::Agvtool.marketing_version

    XcTools::XcodeBuild.info(workspace: 'Project.xcworkspace')

    XcTools::XcodeBuild.settings("-workspace \"Project.xcworkspace\"")

## Contributing

1. Fork it ( https://github.com/antlypls/xctools/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
