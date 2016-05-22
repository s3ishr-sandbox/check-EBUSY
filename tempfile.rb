#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'tempfile'

tf = Tempfile.new('tempfile.test', './')
File.rename(tf.path, 'tempfile.dst')
