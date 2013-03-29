module RolloutUi
  class UsersController < RolloutUi::ApplicationController
    before_filter :wrapper, :only => [:index]

    def index
      prefix = params['data']['q']

      users = @wrapper.fetch(prefix)
      users ||= {}

      { q: prefix, results: users}.to_json
    end

    private

      def wrapper
        @wrapper = RolloutUi::Wrapper.new
      end
  end
end
