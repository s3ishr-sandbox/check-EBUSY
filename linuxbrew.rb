#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'pathname'

# import from Linuxbrew
#   https://github.com/Linuxbrew/linuxbrew/blob/master/Library/Homebrew/extend/pathname.rb
class Pathname
  def atomic_write(content)
    require "tempfile"
    tf = Tempfile.new(basename.to_s, dirname)
    begin
      tf.binmode
      tf.write(content)

      begin
        old_stat = stat
      rescue Errno::ENOENT
        old_stat = default_stat
      end

      uid = Process.uid
      gid = Process.groups.delete(old_stat.gid) { Process.gid }

      begin
        tf.chown(uid, gid)
        tf.chmod(old_stat.mode)
      rescue Errno::EPERM
      end

      File.rename(tf.path, self)
    ensure
      tf.close!
    end
  end

  def default_stat
    sentinel = parent.join(".brew.#{Process.pid}.#{rand(Time.now.to_i)}")
    sentinel.open("w") {}
    sentinel.stat
  ensure
    sentinel.unlink
  end
end

p = Pathname.new 'linuxbrew.txt'
p.atomic_write 'Test String'
