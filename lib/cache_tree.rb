require 'md5'
require 'singleton'
require 'fileutils'
require 'isna'
require 'tree_node'

module CacheTree

  def self.use(node, report = proc {}, &block)
    CacheTree::Manager.instance.use(node, report, &block)
  end

  def self.node(object)
    CacheTree::Node.new(object)
  end

  class Manager

    include Singleton

    attr_accessor :configuration

    def initialize
      @current_link   = nil
      @configuration  = { :perform_caching => true }
    end

    def use(node, report, &block)
      return yield unless @configuration[:perform_caching]
      @node = node
      @node.map(:up) { |parent| parent.load! }
      return read if exists?
      report.call
      save(yield)
    end

    protected

    def exists?
      return false unless @configuration[:perform_caching]
      btree_key_files = @node.map(:up) { |node| node.btree_key }
      return false unless btree_key_files.all? { |btree_key| File.exists?(btree_key) }
      File.exists?(@node.cache_file)
    end

    def read
      File.read(@node.cache_file)
    end

    def save(data)
      @node.map(:up) { |node| node.save }
      FileUtils.mkdir_p(File.dirname(@node.cache_file))
      File.open(@node.cache_file, 'w+') { |file| file.write data }
      data
    end

  end

  class Node

    class << self
      attr_accessor :directory
    end

    SEPARATOR = '/'

    attr_accessor :name, :value, :stamp

    include Tree::Node

    def initialize(target)
      if target.is_a?(Hash)
        initialize_from_hash(target)
      else
        initialize_from_object(target)
      end
      @stamp = generate_stamp
    end

    def initialize_from_hash(hash)
      @name  = hash[:name]
      @value = hash[:value]
    end

    def initialize_from_object(target)
      @name  = target.class.name.gsub(/([A-Z])/) { "_#{$1}" }.gsub(/^./, '').downcase
      @value = target.id
    end

    def directory
      self.class.directory
    end

    def generate_stamp
      (Time.now.to_f * 1.0).to_s + '-' + Kernel.rand(1000000).to_s
    end

    # Path of the cache node
    def path
      "#{name}#{SEPARATOR}#{value}#{SEPARATOR}"
    end

    # Resolves final name for btree_key file.
    def btree_key
      directory + SEPARATOR + (map(:up) { |node| node.path } * '') + 'btree.key'
    end

    # Updates current node stamp from btree_key
    def load
      @stamp = eval(File.read(btree_key).to_s.inspect)
    end

    # Updates current node stamp from btree_key
    # ensuring the btree file is present reflecting node-data on memory.
    def load!
      File.exists?(btree_key) ? load : save
    end

    # Sums up all stamps and generates a checksum.
    def checksum
      MD5.hexdigest(map(:up) { |node| node.stamp } * '')
    end

    # Resolves final name for cache file.
    def cache_file
      directory + SEPARATOR + (map(:up) { |node| node.path } * '') + checksum + '.cache'
    end

    # Writes node stamp from to btree_key file
    def save
      FileUtils.mkdir_p File.dirname(btree_key)
      File.open(btree_key, 'w+') { |file| file.write stamp.inspect }
    end

    # Quickly expire a whole cache-tree or a single node.
    # Expiring a node in the middle will automatically expire all
    # children nodes. no need to expire each one individually.
    def expire
      @stamp = generate_stamp
      save
    end

    # Cleans up expired cache files for a specific node.
    #
    # You need to be specific the engine will not walk down the tree
    # for you to prevent iterating through large trees.
    #
    # @return [Array] of items that were deleted.
    def clean
      diagnose[:dead].each { |file| FileUtils.rm file }
    end

    # Runs an analysis on a given node and returns its status.
    #
    # @return [Hash] with detailed diagnosis of curret status for that
    # node's cache
    def diagnose
      map(:up) { |node| node.load! }
      file_alive             = cache_file
      base                   = File.basename(file_alive)
      dir                    = File.dirname(file_alive)
      diagnostic             = {}
      diagnostic[:alive]     = file_alive
      diagnostic[:dead]      = []
      Dir["#{dir}/*.cache"].each do |cached_file|
        next if File.basename(cached_file) == base
        diagnostic[:dead] << cached_file
      end
      diagnostic
    end

    # Prints out active cache in green, and expired files in red.
    def debug
      diagnostic = diagnose
      if File.exists?(diagnostic[:alive])
        puts diagnostic[:alive].to_ansi.green
      else
        puts diagnostic[:alive].to_ansi.yellow
      end
      diagnostic[:dead].each { |file| puts file.to_ansi.red }
      nil
    end

  end

end

