-- Student Management Information System (SMIS) - MySQL Database Schema
-- Comprehensive database design for educational institutions

-- Create database
CREATE DATABASE IF NOT EXISTS smis_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE smis_db;

-- =====================================================
-- CORE USER AND AUTHENTICATION TABLES
-- =====================================================

-- Users table (base table for all user types)
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    user_type ENUM('student', 'teacher', 'admin', 'parent') NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender ENUM('male', 'female', 'other', 'prefer_not_to_say'),
    profile_picture VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    email_verified BOOLEAN DEFAULT FALSE,
    two_factor_enabled BOOLEAN DEFAULT FALSE,
    two_factor_secret VARCHAR(32),
    last_login DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_user_type (user_type),
    INDEX idx_username (username)
) ENGINE=InnoDB;

-- User sessions for security
CREATE TABLE user_sessions (
    session_id VARCHAR(128) PRIMARY KEY,
    user_id INT NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at)
) ENGINE=InnoDB;

-- Password reset tokens
CREATE TABLE password_resets (
    reset_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    reset_token VARCHAR(64) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_token (reset_token),
    INDEX idx_expires_at (expires_at)
) ENGINE=InnoDB;

-- =====================================================
-- INSTITUTIONAL STRUCTURE TABLES
-- =====================================================

-- Academic years/terms
CREATE TABLE academic_terms (
    term_id INT PRIMARY KEY AUTO_INCREMENT,
    term_name VARCHAR(100) NOT NULL,
    term_code VARCHAR(20) UNIQUE NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT FALSE,
    is_current BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_dates (start_date, end_date),
    INDEX idx_current (is_current)
) ENGINE=InnoDB;

-- Departments/Programs
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    department_code VARCHAR(20) UNIQUE NOT NULL,
    description TEXT,
    head_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (head_id) REFERENCES users(user_id) ON SET NULL,
    INDEX idx_department_code (department_code)
) ENGINE=InnoDB;

-- Grade levels
CREATE TABLE grade_levels (
    grade_level_id INT PRIMARY KEY AUTO_INCREMENT,
    grade_name VARCHAR(50) NOT NULL,
    grade_code VARCHAR(20) UNIQUE NOT NULL,
    grade_order INT NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_grade_order (grade_order)
) ENGINE=InnoDB;

-- Courses/Subjects
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(200) NOT NULL,
    course_code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    credits DECIMAL(3,1) DEFAULT 1.0,
    department_id INT,
    grade_level_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON SET NULL,
    FOREIGN KEY (grade_level_id) REFERENCES grade_levels(grade_level_id) ON SET NULL,
    INDEX idx_course_code (course_code),
    INDEX idx_department (department_id)
) ENGINE=InnoDB;

-- Course prerequisites
CREATE TABLE course_prerequisites (
    prerequisite_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    prerequisite_course_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (prerequisite_course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    UNIQUE KEY uk_course_prerequisite (course_id, prerequisite_course_id)
) ENGINE=InnoDB;

-- =====================================================
-- STUDENT-SPECIFIC TABLES
-- =====================================================

-- Students table (extends users)
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_number VARCHAR(50) UNIQUE NOT NULL,
    enrollment_date DATE NOT NULL,
    grade_level_id INT,
    department_id INT,
    guardian_name VARCHAR(100),
    guardian_phone VARCHAR(20),
    guardian_email VARCHAR(100),
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50) DEFAULT 'USA',
    enrollment_status ENUM('active', 'graduated', 'transferred', 'withdrawn', 'suspended') DEFAULT 'active',
    graduation_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (grade_level_id) REFERENCES grade_levels(grade_level_id) ON SET NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON SET NULL,
    INDEX idx_student_number (student_number),
    INDEX idx_enrollment_status (enrollment_status)
) ENGINE=InnoDB;

-- Student medical records
CREATE TABLE student_medical_records (
    medical_record_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    blood_group VARCHAR(10),
    allergies TEXT,
    medications TEXT,
    medical_conditions TEXT,
    immunization_records TEXT,
    insurance_provider VARCHAR(100),
    insurance_policy_number VARCHAR(50),
    doctor_name VARCHAR(100),
    doctor_phone VARCHAR(20),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    INDEX idx_student_id (student_id)
) ENGINE=InnoDB;

-- =====================================================
-- TEACHER-SPECIFIC TABLES
-- =====================================================

-- Teachers table (extends users)
CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY,
    employee_id VARCHAR(50) UNIQUE NOT NULL,
    department_id INT,
    hire_date DATE NOT NULL,
    qualification TEXT,
    specialization TEXT,
    salary DECIMAL(10,2),
    is_active BOOLEAN DEFAULT TRUE,
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50) DEFAULT 'USA',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON SET NULL,
    INDEX idx_employee_id (employee_id),
    INDEX idx_department (department_id)
) ENGINE=InnoDB;

-- =====================================================
-- CLASS/COURSE SCHEDULING TABLES
-- =====================================================

-- Classes (course instances)
CREATE TABLE classes (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    term_id INT NOT NULL,
    teacher_id INT,
    class_name VARCHAR(100),
    section VARCHAR(20),
    capacity INT DEFAULT 30,
    room VARCHAR(50),
    schedule_days SET('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'),
    start_time TIME,
    end_time TIME,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (term_id) REFERENCES academic_terms(term_id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id) ON SET NULL,
    INDEX idx_course_term (course_id, term_id),
    INDEX idx_teacher (teacher_id)
) ENGINE=InnoDB;

-- Student enrollments
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    class_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    status ENUM('enrolled', 'completed', 'dropped', 'withdrawn') DEFAULT 'enrolled',
    final_grade DECIMAL(5,2),
    grade_letter VARCHAR(5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(class_id) ON DELETE CASCADE,
    UNIQUE KEY uk_student_class (student_id, class_id),
    INDEX idx_student (student_id),
    INDEX idx_class (class_id)
) ENGINE=InnoDB;

-- =====================================================
-- ATTENDANCE TABLES
-- =====================================================

-- Attendance records
CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    class_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('present', 'absent', 'late', 'excused') NOT NULL,
    check_in_time TIME,
    check_out_time TIME,
    notes TEXT,
    recorded_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(class_id) ON DELETE CASCADE,
    FOREIGN KEY (recorded_by) REFERENCES users(user_id) ON SET NULL,
    UNIQUE KEY uk_student_class_date (student_id, class_id, attendance_date),
    INDEX idx_student_date (student_id, attendance_date),
    INDEX idx_class_date (class_id, attendance_date)
) ENGINE=InnoDB;

-- =====================================================
-- GRADEBOOK TABLES
-- =====================================================

-- Assignment categories
CREATE TABLE assignment_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    weight DECIMAL(5,2) DEFAULT 100.00,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Assignments
CREATE TABLE assignments (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    class_id INT NOT NULL,
    category_id INT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    max_points DECIMAL(6,2) DEFAULT 100.00,
    due_date DATETIME,
    assignment_type ENUM('homework', 'quiz', 'exam', 'project', 'presentation', 'participation') DEFAULT 'homework',
    is_published BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(class_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES assignment_categories(category_id) ON SET NULL,
    INDEX idx_class_id (class_id),
    INDEX idx_due_date (due_date)
) ENGINE=InnoDB;

-- Student grades
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    assignment_id INT NOT NULL,
    points_earned DECIMAL(6,2),
    grade_letter VARCHAR(5),
    is_exempt BOOLEAN DEFAULT FALSE,
    is_missing BOOLEAN DEFAULT FALSE,
    is_late BOOLEAN DEFAULT FALSE,
    comments TEXT,
    graded_by INT,
    graded_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id) ON DELETE CASCADE,
    FOREIGN KEY (graded_by) REFERENCES users(user_id) ON SET NULL,
    UNIQUE KEY uk_student_assignment (student_id, assignment_id),
    INDEX idx_student (student_id),
    INDEX idx_assignment (assignment_id)
) ENGINE=InnoDB;

-- =====================================================
-- FINANCIAL MANAGEMENT TABLES
-- =====================================================

-- Fee types
CREATE TABLE fee_types (
    fee_type_id INT PRIMARY KEY AUTO_INCREMENT,
    fee_name VARCHAR(100) NOT NULL,
    description TEXT,
    is_recurring BOOLEAN DEFAULT FALSE,
    recurrence_frequency ENUM('monthly', 'quarterly', 'semester', 'annual') DEFAULT 'annual',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Student fees
CREATE TABLE student_fees (
    fee_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    fee_type_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    due_date DATE,
    paid_amount DECIMAL(10,2) DEFAULT 0.00,
    status ENUM('pending', 'partial', 'paid', 'overdue', 'waived') DEFAULT 'pending',
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (fee_type_id) REFERENCES fee_types(fee_type_id) ON DELETE CASCADE,
    INDEX idx_student (student_id),
    INDEX idx_status (status),
    INDEX idx_due_date (due_date)
) ENGINE=InnoDB;

-- Payments
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    fee_id INT,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME NOT NULL,
    payment_method ENUM('cash', 'check', 'credit_card', 'debit_card', 'bank_transfer', 'online') DEFAULT 'cash',
    transaction_id VARCHAR(100),
    notes TEXT,
    recorded_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (fee_id) REFERENCES student_fees(fee_id) ON SET NULL,
    FOREIGN KEY (recorded_by) REFERENCES users(user_id) ON SET NULL,
    INDEX idx_student_date (student_id, payment_date),
    INDEX idx_transaction (transaction_id)
) ENGINE=InnoDB;

-- =====================================================
-- COMMUNICATION TABLES
-- =====================================================

-- Messages
CREATE TABLE messages (
    message_id INT PRIMARY KEY AUTO_INCREMENT,
    sender_id INT NOT NULL,
    recipient_id INT NOT NULL,
    subject VARCHAR(200),
    content TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    parent_message_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (recipient_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (parent_message_id) REFERENCES messages(message_id) ON SET NULL,
    INDEX idx_sender (sender_id),
    INDEX idx_recipient (recipient_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB;

-- Announcements
CREATE TABLE announcements (
    announcement_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    priority ENUM('low', 'normal', 'high', 'urgent') DEFAULT 'normal',
    target_audience ENUM('all', 'students', 'teachers', 'parents', 'admins') DEFAULT 'all',
    department_id INT,
    grade_level_id INT,
    is_published BOOLEAN DEFAULT FALSE,
    published_at TIMESTAMP NULL,
    expires_at TIMESTAMP NULL,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON SET NULL,
    FOREIGN KEY (grade_level_id) REFERENCES grade_levels(grade_level_id) ON SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_target_audience (target_audience),
    INDEX idx_published_at (published_at),
    INDEX idx_expires_at (expires_at)
) ENGINE=InnoDB;

-- =====================================================
-- BEHAVIOR AND DISCIPLINE TABLES
-- =====================================================

-- Behavior incidents
CREATE TABLE behavior_incidents (
    incident_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    reported_by INT NOT NULL,
    incident_type ENUM('positive', 'negative', 'neutral') DEFAULT 'neutral',
    category VARCHAR(100),
    description TEXT NOT NULL,
    location VARCHAR(100),
    incident_date DATE NOT NULL,
    action_taken TEXT,
    severity ENUM('minor', 'moderate', 'major', 'severe') DEFAULT 'minor',
    is_resolved BOOLEAN DEFAULT FALSE,
    resolved_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (reported_by) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_student (student_id),
    INDEX idx_incident_date (incident_date),
    INDEX idx_severity (severity)
) ENGINE=InnoDB;

-- =====================================================
-- SYSTEM LOGS AND AUDIT TABLES
-- =====================================================

-- Activity logs
CREATE TABLE activity_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    resource_type VARCHAR(50),
    resource_id INT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_action (action),
    INDEX idx_created_at (created_at),
    INDEX idx_resource (resource_type, resource_id)
) ENGINE=InnoDB;

-- System settings
CREATE TABLE system_settings (
    setting_id INT PRIMARY KEY AUTO_INCREMENT,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    setting_type ENUM('string', 'number', 'boolean', 'json') DEFAULT 'string',
    description TEXT,
    is_editable BOOLEAN DEFAULT TRUE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by INT,
    FOREIGN KEY (updated_by) REFERENCES users(user_id) ON SET NULL
) ENGINE=InnoDB;

-- =====================================================
-- INSERT DEFAULT DATA
-- =====================================================

-- Default grade levels
INSERT INTO grade_levels (grade_name, grade_code, grade_order) VALUES
('Kindergarten', 'K', 1),
('1st Grade', 'G1', 2),
('2nd Grade', 'G2', 3),
('3rd Grade', 'G3', 4),
('4th Grade', 'G4', 5),
('5th Grade', 'G5', 6),
('6th Grade', 'G6', 7),
('7th Grade', 'G7', 8),
('8th Grade', 'G8', 9),
('9th Grade', 'G9', 10),
('10th Grade', 'G10', 11),
('11th Grade', 'G11', 12),
('12th Grade', 'G12', 13),
('Freshman', 'FR', 14),
('Sophomore', 'SO', 15),
('Junior', 'JR', 16),
('Senior', 'SR', 17);

-- Default assignment categories
INSERT INTO assignment_categories (category_name, weight, description) VALUES
('Homework', 20.00, 'Regular homework assignments'),
('Quizzes', 15.00, 'Short quizzes and tests'),
('Exams', 35.00, 'Major examinations'),
('Projects', 20.00, 'Course projects and presentations'),
('Participation', 10.00, 'Class participation and attendance');

-- Default fee types
INSERT INTO fee_types (fee_name, description, is_recurring, recurrence_frequency) VALUES
('Tuition Fee', 'Annual tuition fee', TRUE, 'annual'),
('Registration Fee', 'One-time registration fee', FALSE, 'annual'),
('Library Fee', 'Annual library access fee', TRUE, 'annual'),
('Laboratory Fee', 'Science laboratory usage fee', TRUE, 'annual'),
('Sports Fee', 'Annual sports and activities fee', TRUE, 'annual'),
('Examination Fee', 'End of term examination fee', TRUE, 'semester');

-- Default system settings
INSERT INTO system_settings (setting_key, setting_value, setting_type, description) VALUES
('school_name', 'SMIS Educational Institution', 'string', 'Name of the institution'),
('school_address', '123 Education Street, Learning City', 'string', 'Institution address'),
('school_phone', '+1 (555) 123-4567', 'string', 'Institution contact phone'),
('school_email', 'info@smis.edu', 'string', 'Institution contact email'),
('default_grade_scale', '{"A": 90, "B": 80, "C": 70, "D": 60, "F": 0}', 'json', 'Default grading scale'),
('attendance_alert_threshold', '5', 'number', 'Number of absences before alert is sent'),
('max_file_upload_size', '10485760', 'number', 'Maximum file upload size in bytes (10MB)'),
('password_min_length', '8', 'number', 'Minimum password length requirement'),
('session_timeout_minutes', '30', 'number', 'User session timeout in minutes');

-- Create admin user (password: Admin123!)
INSERT INTO users (username, email, password_hash, user_type, first_name, last_name, phone, date_of_birth, gender, is_active, email_verified) VALUES
('admin', 'admin@smis.edu', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/J9eHCOwOOa', 'admin', 'System', 'Administrator', '+1 (555) 000-0001', '1990-01-01', 'other', TRUE, TRUE);

-- Create sample teacher
INSERT INTO users (username, email, password_hash, user_type, first_name, last_name, phone, date_of_birth, gender, is_active, email_verified) VALUES
('teacher1', 'teacher1@smis.edu', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/J9eHCOwOOa', 'teacher', 'John', 'Smith', '+1 (555) 000-0002', '1985-05-15', 'male', TRUE, TRUE);

-- Create sample student
INSERT INTO users (username, email, password_hash, user_type, first_name, last_name, phone, date_of_birth, gender, is_active, email_verified) VALUES
('student1', 'student1@smis.edu', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/J9eHCOwOOa', 'student', 'Jane', 'Doe', '+1 (555) 000-0003', '2008-03-22', 'female', TRUE, TRUE);

-- Insert into teacher and student tables
INSERT INTO teachers (teacher_id, employee_id, department_id, hire_date, qualification, specialization) VALUES
(2, 'TCH001', NULL, '2020-08-15', 'M.Ed. Mathematics', 'Mathematics Education');

INSERT INTO students (student_id, student_number, enrollment_date, grade_level_id, department_id, enrollment_status) VALUES
(3, 'STU001', '2023-09-01', 10, NULL, 'active');

DELIMITER //

-- Trigger to update updated_at timestamp
CREATE TRIGGER update_users_timestamp 
    BEFORE UPDATE ON users
    FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END//

-- Trigger to log user actions
CREATE TRIGGER log_user_update
    AFTER UPDATE ON users
    FOR EACH ROW
BEGIN
    INSERT INTO activity_logs (user_id, action, resource_type, resource_id, details)
    VALUES (NEW.user_id, 'UPDATE', 'users', NEW.user_id, CONCAT('Updated user: ', NEW.username));
END//

DELIMITER ;

-- Create views for common queries
CREATE VIEW student_overview AS
SELECT 
    s.student_id,
    u.first_name,
    u.last_name,
    u.email,
    s.student_number,
    s.enrollment_date,
    s.enrollment_status,
    gl.grade_name,
    d.department_name,
    COUNT(DISTINCT e.class_id) as enrolled_classes,
    AVG(g.points_earned) as average_grade
FROM students s
JOIN users u ON s.student_id = u.user_id
LEFT JOIN grade_levels gl ON s.grade_level_id = gl.grade_level_id
LEFT JOIN departments d ON s.department_id = d.department_id
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id;

CREATE VIEW teacher_overview AS
SELECT 
    t.teacher_id,
    u.first_name,
    u.last_name,
    u.email,
    t.employee_id,
    d.department_name,
    t.hire_date,
    COUNT(DISTINCT c.class_id) as teaching_classes,
    COUNT(DISTINCT e.student_id) as total_students
FROM teachers t
JOIN users u ON t.teacher_id = u.user_id
LEFT JOIN departments d ON t.department_id = d.department_id
LEFT JOIN classes c ON t.teacher_id = c.teacher_id
LEFT JOIN enrollments e ON c.class_id = e.class_id
GROUP BY t.teacher_id;

-- Create indexes for performance optimization
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_students_grade_level ON students(grade_level_id);
CREATE INDEX idx_enrollments_student ON enrollments(student_id);
CREATE INDEX idx_enrollments_class ON enrollments(class_id);
CREATE INDEX idx_attendance_student_date ON attendance(student_id, attendance_date);
CREATE INDEX idx_grades_student ON grades(student_id);
CREATE INDEX idx_grades_assignment ON grades(assignment_id);
CREATE INDEX assignments_class_id ON assignments(class_id);
CREATE INDEX idx_student_fees_student ON student_fees(student_id);
CREATE INDEX idx_payments_student ON payments(student_id);
CREATE INDEX idx_messages_sender ON messages(sender_id);
CREATE INDEX idx_messages_recipient ON messages(recipient_id);