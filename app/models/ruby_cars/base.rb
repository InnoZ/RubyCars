module RubyCars
  class Base
    class << self
      def all
        Dir[Rails.root.join('app', 'models', 'ruby_cars', '*.rb')].each { |file| require file }
        Base.descendants
      end

      def name
        to_s.split(':').last.downcase
      end
    end
  end
end
