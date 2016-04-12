module RubyCarsLog
  def self.logger
    @logger ||= begin
      file = "#{Rails.root}/log/ruby_cars.log"

      Logger.new(file).tap do |logger|
        logger.formatter = proc do |severity, time, _progname, msg|
          "time=#{time.utc.iso8601} severity=#{severity} pid=#{Process.pid} #{msg}\n"
        end
      end
    end
  end

  def log_request(url)
    @_log_request_start = Time.now.to_f
    yield.tap do
      log :info, 'result=ok', url
    end
  rescue => e
    log :warn, "result=error error=#{e.class} message=\"#{e.message}\"", url
    raise
  end

  module_function

  def duration_since(start)
    "duration=#{((Time.now.to_f - start) * 1000).to_i}ms"
  end

  private

  def log(severity, message, url)
    RubyCarsLog.logger.public_send(severity, [
      "class=#{self.class}",
      'action=request',
      "url=#{url} #{message}",
      duration_since(@_log_request_start),
    ].join(' '))
  end
end
