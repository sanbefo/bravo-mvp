class AccountPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def index?
    user.present?
  end

  def show?
    owner?
  end

  def create?
    user.present?
  end

  private

  def owner?
    record.user_id == user.id
  end
end
