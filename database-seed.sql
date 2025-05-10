-- Users Table (simplified for graders only)
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    lms_user_id VARCHAR(100) NOT NULL UNIQUE,  -- ID from the LMS if using OAuth
    email text NOT NULL,
    permissions JSONB,                         -- Flexible permissions structure 
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Schools Table (unchanged)
CREATE TABLE schools (
    school_id SERIAL PRIMARY KEY,
    school_name VARCHAR(100) NOT NULL,
    lms VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Departments Table
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    school_id INTEGER REFERENCES schools(school_id),
    department_name VARCHAR(100) NOT NULL,
    department_code VARCHAR(10),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Courses Table
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    department_id INTEGER REFERENCES departments(department_id),
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(20) NOT NULL,
    course_description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Course Sections Table
CREATE TABLE course_sections (
    section_id SERIAL PRIMARY KEY,
    course_id INTEGER REFERENCES courses(course_id),
    section_number VARCHAR(20) NOT NULL,
    term VARCHAR(50) NOT NULL,
    instructor_name VARCHAR(100), -- Just the name, since instructor isn't a user
    assigned_grader_id INTEGER REFERENCES users(user_id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(course_id, section_number, term)
);

-- Projects Table
CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    section_id INTEGER REFERENCES course_sections(section_id),
    project_name VARCHAR(100) NOT NULL,
    description TEXT,
    due_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Submissions Table
CREATE TABLE submissions (
    submission_id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(project_id),
    student_id VARCHAR(100) NOT NULL,  -- LMS student ID
    submission_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'submitted' CHECK (status IN ('submitted', 'grading', 'graded', 'returned')),
    is_late BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Submission_Files Table
CREATE TABLE submission_files (
    submission_file_id SERIAL PRIMARY KEY,
    submission_id INTEGER REFERENCES submissions(submission_id),
    filename VARCHAR(255) NOT NULL,
    file_content TEXT NOT NULL,
    file_path VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Test Results Table
CREATE TABLE test_results (
    result_id SERIAL PRIMARY KEY,
    submission_id INTEGER REFERENCES submissions(submission_id),
    test_file_id INTEGER REFERENCES test_files(test_file_id),
    test_method_name VARCHAR(255) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('pass', 'fail', 'error', 'skipped')),
    failure_message TEXT,
    execution_time INTEGER,
    stack_trace TEXT,
    execution_timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(submission_id, test_file_id, test_method_name)
);


-- Test Files Table
CREATE TABLE test_files (
    test_file_id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(project_id),
    filename VARCHAR(255) NOT NULL,
    file_content TEXT NOT NULL,
    test_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);



-- RAG Materials Table
CREATE TABLE rag_materials (
    material_id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(project_id),
    title VARCHAR(255) NOT NULL,
    material_type VARCHAR(50) NOT NULL,
    file_path VARCHAR(255),
    content TEXT NOT NULL,
    vector_embedding JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- LLM Grading Results Table
CREATE TABLE llm_grading_results (
    grading_id SERIAL PRIMARY KEY,
    submission_id INTEGER REFERENCES submissions(submission_id),
    overall_score DECIMAL(5,2),
    max_possible_score DECIMAL(5,2),
    overall_feedback TEXT,
    grading_completed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    finalized BOOLEAN DEFAULT FALSE, -- Indicates if grader has reviewed and finalized
    finalized_by INTEGER REFERENCES users(user_id),
    finalized_at TIMESTAMP WITH TIME ZONE
);

-- Grading Notes Table (for graders to add notes)
CREATE TABLE grading_notes (
    note_id SERIAL PRIMARY KEY,
    submission_id INTEGER REFERENCES submissions(submission_id),
    user_id INTEGER REFERENCES users(user_id),
    note_text TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Batch Operations Table (for tracking batch grading operations)
CREATE TABLE batch_operations (
    batch_id SERIAL PRIMARY KEY,
    operation_type VARCHAR(50) NOT NULL,
    section_id INTEGER REFERENCES course_sections(section_id),
    project_id INTEGER REFERENCES projects(project_id),
    user_id INTEGER REFERENCES users(user_id),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
    affected_submissions INTEGER,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE
);

-- Users table indexes
CREATE INDEX idx_users_lms_user_id ON users(lms_user_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_last_login ON users(last_login);

-- Schools table indexes
CREATE INDEX idx_schools_lms ON schools(lms);

-- Departments table indexes
CREATE INDEX idx_departments_school_id ON departments(school_id);
CREATE INDEX idx_departments_department_code ON departments(department_code);

-- Courses table indexes
CREATE INDEX idx_courses_department_id ON courses(department_id);
CREATE INDEX idx_courses_course_code ON courses(course_code);

-- Course Sections table indexes
CREATE INDEX idx_course_sections_course_id ON course_sections(course_id);
CREATE INDEX idx_course_sections_assigned_grader_id ON course_sections(assigned_grader_id);
CREATE INDEX idx_course_sections_term ON course_sections(term);

-- Projects table indexes
CREATE INDEX idx_projects_section_id ON projects(section_id);
CREATE INDEX idx_projects_due_date ON projects(due_date);

-- Submissions table indexes
CREATE INDEX idx_submissions_project_id ON submissions(project_id);
CREATE INDEX idx_submissions_student_id ON submissions(student_id);
CREATE INDEX idx_submissions_status ON submissions(status);
CREATE INDEX idx_submissions_submission_date ON submissions(submission_date);

-- Submission Files table indexes
CREATE INDEX idx_submission_files_submission_id ON submission_files(submission_id);
CREATE INDEX idx_submission_files_filename ON submission_files(filename);

-- Test Results table indexes
CREATE INDEX idx_test_results_submission_id ON test_results(submission_id);
CREATE INDEX idx_test_results_test_file_id ON test_results(test_file_id);
CREATE INDEX idx_test_results_status ON test_results(status);

-- Test Files table indexes
CREATE INDEX idx_test_files_project_id ON test_files(project_id);
CREATE INDEX idx_test_files_test_type ON test_files(test_type);

-- RAG Materials table indexes
CREATE INDEX idx_rag_materials_project_id ON rag_materials(project_id);
CREATE INDEX idx_rag_materials_material_type ON rag_materials(material_type);

-- LLM Grading Results table indexes
CREATE INDEX idx_llm_grading_results_submission_id ON llm_grading_results(submission_id);
CREATE INDEX idx_llm_grading_results_finalized ON llm_grading_results(finalized);
CREATE INDEX idx_llm_grading_results_finalized_by ON llm_grading_results(finalized_by);

-- Grading Notes table indexes
CREATE INDEX idx_grading_notes_submission_id ON grading_notes(submission_id);
CREATE INDEX idx_grading_notes_user_id ON grading_notes(user_id);

-- Batch Operations table indexes
CREATE INDEX idx_batch_operations_section_id ON batch_operations(section_id);
CREATE INDEX idx_batch_operations_project_id ON batch_operations(project_id);
CREATE INDEX idx_batch_operations_user_id ON batch_operations(user_id);
CREATE INDEX idx_batch_operations_status ON batch_operations(status);




















