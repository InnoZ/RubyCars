class InfiniteLoop
  # rubocop:disable MethodLength
  def run
    i = 0
    loop do
      i += 1
      start = Time.now
      begin
        RubyCars::Base.all.each do |subclass|
          Runner.new(subclass.new).run
        end
      rescue => e
        RubyCarsLog.logger.warn "result=error error=#{e.class} message=\"#{e.message}\""
        next
      end
      finish = Time.now
      diff = finish - start
      puts "Run no.#{i} took #{diff} seconds"
    end
  end
end
