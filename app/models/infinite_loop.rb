class InfiniteLoop
  def run
    i = 0
    loop do
      i += 1
      start = Time.now
      begin
        RubyCars::Base.all.each do |subclass|
          subclass.new.run
        end
      rescue => e
        Rails.logger.error e.message
        e.backtrace.each { |line| Rails.logger.error line }
        next
      end
      finish = Time.now
      diff = finish - start
      puts "Run no.#{i} took #{diff} seconds"
    end
  end
end
