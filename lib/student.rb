class Student
  attr_accessor :id, :name, :grade
  
  # saves an instance of the Student class to the database
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  # creates a student table
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  # drops the student table
  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  # creates an instance with corresponding attribute values
  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end
  
  # returns an instance of student that matches name from DB
  def self.find_by_name(name)
    sql = <<-SQL
    Select * 
    from Students
    where name = ?
    limit 1
    SQL
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
     end.first
  end

  # returns an array of all students in grades 9
  def self.all_students_in_grade_9
    sql = <<-SQL
    Select * 
    from Students
    where grade = '9'
    SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  # returns an array of all students in grades 11 or below
  def self.students_below_12th_grade
    sql = <<-SQL
    Select * 
    from Students
    where grade <= '11'
    SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.all 
    sql = <<-SQL
    Select * 
    from Students
    SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
    Select *
    from Students
    where grade = '10'
    SQL
     DB[:conn].execute(sql).select do |row|
      self.new_from_db(row)
     end.first(x)
  end

  # returns the first student in grade 10
  def self.first_student_in_grade_10 
    sql = <<-SQL
    Select *
    from Students
    where grade = '10'
    SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end

  # returns an array of all students in a given grade X
  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    Select *
    from Students 
    where grade = grade
    SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end


end
