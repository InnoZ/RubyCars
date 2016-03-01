class InfiniteLoop
  def run
    loop do
      begin
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
