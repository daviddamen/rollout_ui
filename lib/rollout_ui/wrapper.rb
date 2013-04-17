module RolloutUi
  class Wrapper
    class NoRolloutInstance < StandardError; end
    class NoUserFetcherInstance < StandardError; end

    attr_reader :rollout

    def initialize(rollout = nil, user_fetcher = nil)
      @rollout = rollout || RolloutUi.rollout
      raise NoRolloutInstance unless @rollout

      @user_fetcher = user_fetcher || RolloutUi.user_fetcher
      raise NoUserFetcherInstance unless @user_fetcher
    end

    def groups
      @rollout.instance_variable_get("@groups").keys
    end

    def features
      features = @rollout.features
      features ? features.uniq.sort : []
    end

    def fetch(uid_prefix)
      @user_fetcher.fetch(uid_prefix)
    end
  end
end
