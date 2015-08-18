class Department

  attr_accessor :id, :name, :courses

  def self.create_table
  sql = 'CREATE TABLE IF NOT EXISTS departments (id INTEGER PRIMARY KEY, name TEXT, department_id INTEGER)'
  DB[:conn].execute(sql)
 end

 def self.drop_table
  sql = 'DROP TABLE IF EXISTS departments'
  DB[:conn].execute(sql)
 end

 def insert
  sql = "INSERT INTO departments (name) VALUES (?)"
  DB[:conn].execute(sql, @name)
  @id = DB[:conn].execute("SELECT last_insert_rowid() FROM departments").flatten.first
 end

 def self.new_from_db(row)
  department = Department.new
  department.id = row[0]
  department.name = row[1]
  department
 end

 def self.find_by_name(name)
  sql = "SELECT * FROM departments WHERE name=?"
  results = DB[:conn].execute(sql, name)
  results.map { |row| self.new_from_db(row) }.first 
  end

   def self.find_by_id(id)
  sql = "SELECT * FROM departments WHERE id=?"
  results = DB[:conn].execute(sql, id)
  results.map { |row| self.new_from_db(row) }.first 
  end

  def update
    sql = "UPDATE departments SET name = ? WHERE id = ?"
    DB[:conn].execute(sql, name, id)
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

  def courses
    Course.find_all_by_department_id(self.id)

  end

  def add_course(course_to_add)
    course_to_add.department = (self)
    course_to_add.save
    self.save
  end


	 
end
