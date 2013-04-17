module RolloutUi
  class Feature
    User = Struct.new(:id)

    attr_reader :name

    def initialize(name)
      @wrapper = Wrapper.new
      @name = name
    end

    def percentage
      rollout.get(name).percentage
    end

    def groups
      rollout.get(name).groups
    end

    def user_ids
      rollout.get(name).users
    end

    def percentage=(percentage)
      rollout.activate_percentage(name, percentage)
    end

    def groups=(groups)
      self.groups.each { |group| rollout.deactivate_group(name, group) unless groups.include? group }
      groups.each { |group| rollout.activate_group(name, group) }
    end

    def user_ids=(ids)
      self.user_ids.each { |id| rollout.deactivate_user(name, User.new(id)) unless ids.include? id }
      ids.each { |id| rollout.activate_user(name, User.new(id)) }
    end

  private

    def rollout
      @wrapper.rollout
    end

    [:percentage_key, :group_key, :user_key].each do |method_name|
      define_method(method_name) {|name| rollout.send(method_name, name)}
    end


  end
end
