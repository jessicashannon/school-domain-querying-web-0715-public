class Registration

  attr_accessor :id, :course_id, :student_id 

  def self.create_table
    sql = 'CREATE TABLE IF NOT EXISTS registrations (id INTEGER PRIMARY KEY, course_id INTEGER, student_id INTEGER)'
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = 'DROP TABLE IF EXISTS registrations'
    DB[:conn].execute(sql)
  end

end