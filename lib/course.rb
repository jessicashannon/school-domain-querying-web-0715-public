require 'pry'

class Course

  attr_accessor :id, :name, :department_id, :department, :students

 def self.create_table
  sql = 'CREATE TABLE IF NOT EXISTS courses (id INTEGER PRIMARY KEY, name TEXT, department_id INTEGER)'
  DB[:conn].execute(sql)
 end

 def self.drop_table
  sql = 'DROP TABLE IF EXISTS courses'
  DB[:conn].execute(sql)
 end

 def insert
  sql = "INSERT INTO courses (name, department_id) VALUES (?, ?)"
  DB[:conn].execute(sql, @name, @department_id)
  @id = DB[:conn].execute("SELECT last_insert_rowid() FROM courses").flatten.first
 end

 def self.new_from_db(row)
  course = Course.new
  course.id = row[0]
  course.name = row[1]
  course.department_id = row[2]
  course
 end

 def self.find_by_name(name)
  sql = "SELECT * FROM courses WHERE name=?"
  results = DB[:conn].execute(sql, name)
  results.map { |row| self.new_from_db(row) }.first 
  end

  def self.find_all_by_department_id(department_id)
  sql = "SELECT * FROM courses WHERE department_id=?"
  results = DB[:conn].execute(sql, department_id)
  results.map { |row| self.new_from_db(row)}
   end

  def department=(department_object)
    @department = department_object
    self.department_id = department_object.id
  end

  def department
    @department = Department.find_by_id(@department_id)
  end

  def add_student(student)
    sql = "INSERT INTO registrations (course_id, student_id) VALUES (?,?);"
    DB[:conn].execute(sql, student.id, self.id)
  end

  def students
    sql = <<-SQL
    SELECT students.*
    FROM students
    JOIN registrations
    ON students.id = registrations.student_id
    JOIN courses
    ON courses.id = registrations.course_id
    WHERE courses.id = ?
    SQL
    result = DB[:conn].execute(sql, self.id)
    result.map do |row|
     Course.new_from_db(row)
   end
  end

  def update
    sql = "UPDATE courses SET name = ?,department_id = ? WHERE id = ?"
    DB[:conn].execute(sql, name, department_id, id)
  end

  def persisted?
    !!self.id
  end

  def save
    if persisted? 
      update
    else 
      insert
    end
  end

end
