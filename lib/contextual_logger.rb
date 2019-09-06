class ContextualLogger
  LEVELS = %w(debug info warn error fatal unknown)

  TRACE_IGNORE_REGEXPS = [
    /^#{__FILE__}/,
    %r{/lib/ruby/}
  ]

  attr_reader :logger

  def initialize(logger, opts = {})
    @logger = logger
    @opts = opts
  end

  def push_context(context)
    context_stack.push context
    clear_context_cache
  end

  def pop_context
    context_stack.pop
    clear_context_cache
  end

  def push_tags(*tags)
    tags_stack.push tags.flatten
    clear_tags_cache
  end

  alias_method :push_tag, :push_tags

  def pop_tags
    tags_stack.pop
    clear_tags_cache
  end

  def with_context(context, &_block)
    tags = context.delete(:tags)
    push_tags tags if tags
    push_context context
    begin
      yield
    ensure
      pop_context
      pop_tags if tags
    end
  end

  def context
    thread_data[:context_cache] ||= context_stack.inject({}, :merge)
  end

  def tags
    thread_data[:tags_cache] ||= tags_stack.inject([], :concat).uniq
  end

  LEVELS.each do |name|
    class_eval <<-EOS, __FILE__, __LINE__
      def #{name}?; @logger.#{name}?; end
      def #{name}(*args, &block); log_at_level(:#{name}, *args, &block); end
    EOS
  end

  def level
    @logger.level
  end

  def level=(level)
    @logger.level = level
  end

  def trace?
    @opts[:trace] == true
  end

  def formatter
    @logger.formatter
  end

  def formatter=(formatter)
    @logger.formatter = formatter
  end

  private

  def clear_context_cache
    thread_data[:context_cache] = nil
  end

  def clear_tags_cache
    thread_data[:tags_cache] = nil
  end

  def tags_cache
    thread_data[:tags_cache]
  end

  def thread_data
    Thread.current[thread_data_key] ||= {}
  end

  def thread_data_key
    @thread_data_key ||= "logger_context_#{object_id}"
  end

  def tags_stack
    thread_data[:tags_stack] ||= []
  end

  def context_stack
    thread_data[:context_stack] ||= []
  end

  def log_at_level(level, *args, &block)
    data = context.merge(tags: tags)
    data.merge!(caller: trace_caller) if trace?
    @logger.__send__(level, *[data] + args, &block)
  end

  def trace_caller
    trace_caller = caller.find do |line|
      !trace_ignore_regexps.any? {|regexp| line =~ regexp}
    end
    if trace_caller && @opts[:trace_strip_regexp]
      trace_caller.gsub! @opts[:trace_strip_regexp], ''
    end
    trace_caller
  end

  def trace_ignore_regexps
    @trace_ignore_regexps ||= TRACE_IGNORE_REGEXPS +
                              Array(@opts[:trace_ignore])
  end
end
