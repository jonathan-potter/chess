
class Employee
  attr_accessor :name, :title, :salary, :boss
  def bonus(multiplier)
    self.salary * multiplier
  end
end

class Manager < Employee
  attr_accessor :minions
  def initialize
    self.minions = []
  end

  def assign_employee(employee)
    employee.boss = self
    self.minions << employee
  end

  def bonus(multiplier)
    minion_salaries = self.minions.inject(:+) do |minion|
      minion.bonus(multiplier)
    end

    minion_salaries * multiplier
  end

end

