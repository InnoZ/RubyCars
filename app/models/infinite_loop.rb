class InfiniteLoop
  def run
    i = 0
    loop do
      i += 1
      p "Run no.#{i}"
      begin
        puts ""
        RubyCars::Base.all.each do |subclass|
          subclass.new.run
        end
      rescue => e
        Rails.logger.error e.message
        e.backtrace.each { |line| Rails.logger.error line }
        next
      end
    end
  end
end
