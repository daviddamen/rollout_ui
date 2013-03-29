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
      rollout.instance_variable_get("@groups").keys
    end

    def add_feature(feature)
      redis.sadd(:features, feature)
    end

    def features
      features = redis.smembers(:features)
      features ? features.sort : []
    end

    def redis
      rollout.instance_variable_get("@redis")
    end

    def fetch(uid_prefix)
      @user_fetcher.fetch(uid_prefix)
    end
  end
end
