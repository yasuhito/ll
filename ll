#!/usr/bin/env ruby
$real_path = File.symlink?( __FILE__ ) ? File.readlink( __FILE__ ) : __FILE__
$LOAD_PATH << File.join( File.dirname( $real_path ), "lib" )


require "fileutils"
require "ll"


def lock
  load "./script/lock"
end


def unlock
  load "./script/unlock"
end


def show
  load "./script/show"
end


def version
  puts <<-EOL
ll, version #{ LL::VERSION::STRING }
Copyright (C) 2010 Yasuhito TAKAMIYA
  EOL
end


def method_for command
  case command
  when "lock"
    return :lock
  when "unlock"
    return :unlock
  when "show"
    return :show
  when "version", "-v", "--version"
    return :version
  when "help", "-h", "--help", "/?", "-?"
    return :help
  else
    return nil
  end
end


def help
  command = ARGV.shift

  ARGV.clear << "--help"
  if command.nil?
    puts <<-EOL
usage: ll <COMMAND> [OPTIONS ...] [ARGS ...]

Lucie lock, version #{ LL::VERSION::STRING }
Type 'll help <COMMAND>' for help on a specific command.
Type 'll --version' to see the version number.

Available commands:
  lock   - acquire a lock
  unlock - release a lock
  show   - show current locks
EOL
  elsif method_for( command )
    self.__send__ method_for( command )
  else
    STDERR.puts "Type 'll help' for usage."
    exit -1
  end
end


command = ARGV.shift
if method_for( command )
  FileUtils.cd File.dirname( $real_path ) do
    self.__send__ method_for( command )
  end
elsif command.nil?
  STDERR.puts "Type 'll --help' for usage."
  exit -1
else
  STDERR.puts "Unknown command: '#{ command }'"
  STDERR.puts "Type 'll --help' for usage."
  exit -1
end


### Local variables:
### mode: Ruby
### coding: utf-8
### indent-tabs-mode: nil
### End:
