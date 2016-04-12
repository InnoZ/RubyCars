class Runner
  include RubyCarsLog

  def initialize(scraper)
    @scraper = scraper
  end

  def run
    log_start
    scrape
  ensure
    log_finish
  end

  private

  attr_reader :scraper

  def scrape
    scraper.run
  rescue => e
    rescue_message(e)
  end

  def rescue_message(e)
    RubyCarsLog.logger.error([
      common_log_args,
      "error=#{e.class}",
      "message=#{e.message}",
    ].join(' '))
  end

  def log_start
    @start_time = Time.now.to_f
    RubyCarsLog.logger.info "#{common_log_args} event=start"
  end

  def log_finish
    RubyCarsLog.logger.info [
      "#{common_log_args} event=finish",
      RubyCarsLog.duration_since(@start_time),
    ].join(' ')
  end

  def common_log_args
    "class=#{scraper.class}"
  end
end
