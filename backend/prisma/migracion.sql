-- Create ENUM types
CREATE TYPE "Status" AS ENUM ('ACTIVE', 'INACTIVE', 'PENDING', 'DELETED');
CREATE TYPE "EmploymentType" AS ENUM ('FULL_TIME', 'PART_TIME', 'CONTRACT', 'TEMPORARY', 'INTERNSHIP');
CREATE TYPE "ApplicationStatus" AS ENUM ('SUBMITTED', 'REVIEWING', 'INTERVIEWING', 'ACCEPTED', 'REJECTED', 'WITHDRAWN');
CREATE TYPE "InterviewResult" AS ENUM ('PENDING', 'PASSED', 'FAILED', 'NO_SHOW', 'RESCHEDULED');

-- Create base tables
CREATE TABLE "Address" (
    "id" SERIAL PRIMARY KEY,
    "street" VARCHAR(255) NOT NULL,
    "city" VARCHAR(100) NOT NULL,
    "state" VARCHAR(100) NOT NULL,
    "country" VARCHAR(100) NOT NULL,
    "postalCode" VARCHAR(20) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE TABLE "ContactInfo" (
    "id" SERIAL PRIMARY KEY,
    "email" VARCHAR(255) NOT NULL UNIQUE,
    "phone" VARCHAR(15),
    "linkedin" VARCHAR(255),
    "website" VARCHAR(255),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- Create main tables
CREATE TABLE "Candidate" (
    "id" SERIAL PRIMARY KEY,
    "firstName" VARCHAR(100) NOT NULL,
    "lastName" VARCHAR(100) NOT NULL,
    "addressId" INTEGER REFERENCES "Address"(id),
    "contactInfoId" INTEGER NOT NULL REFERENCES "ContactInfo"(id),
    "status" "Status" NOT NULL DEFAULT 'ACTIVE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE TABLE "Education" (
    "id" SERIAL PRIMARY KEY,
    "institution" VARCHAR(100) NOT NULL,
    "degree" VARCHAR(100) NOT NULL,
    "field" VARCHAR(150) NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3),
    "gpa" DECIMAL(3,2),
    "candidateId" INTEGER NOT NULL REFERENCES "Candidate"(id),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE TABLE "WorkExperience" (
    "id" SERIAL PRIMARY KEY,
    "company" VARCHAR(100) NOT NULL,
    "position" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3),
    "isCurrent" BOOLEAN NOT NULL DEFAULT false,
    "candidateId" INTEGER NOT NULL REFERENCES "Candidate"(id),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE TABLE "Skill" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(100) NOT NULL UNIQUE,
    "category" VARCHAR(50) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE TABLE "CandidateSkill" (
    "id" SERIAL PRIMARY KEY,
    "candidateId" INTEGER NOT NULL REFERENCES "Candidate"(id),
    "skillId" INTEGER NOT NULL REFERENCES "Skill"(id),
    "level" SMALLINT NOT NULL,
    "yearsOfExp" DECIMAL(4,1),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    UNIQUE("candidateId", "skillId")
);

CREATE TABLE "Resume" (
    "id" SERIAL PRIMARY KEY,
    "filePath" VARCHAR(500) NOT NULL,
    "fileType" VARCHAR(50) NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "uploadDate" TIMESTAMP(3) NOT NULL,
    "candidateId" INTEGER NOT NULL REFERENCES "Candidate"(id),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE TABLE "Company" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL,
    "addressId" INTEGER REFERENCES "Address"(id),
    "status" "Status" NOT NULL DEFAULT 'ACTIVE',
    "industry" VARCHAR(100),
    "size" VARCHAR(50),
    "website" VARCHAR(255),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE TABLE "InterviewFlow" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE TABLE "Position" (
    "id" SERIAL PRIMARY KEY,
    "companyId" INTEGER NOT NULL REFERENCES "Company"(id),
    "interviewFlowId" INTEGER NOT NULL REFERENCES "InterviewFlow"(id),
    "title" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "status" "Status" NOT NULL DEFAULT 'ACTIVE',
    "isVisible" BOOLEAN NOT NULL DEFAULT true,
    "location" VARCHAR(255),
    "employmentType" "EmploymentType" NOT NULL DEFAULT 'FULL_TIME',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE TABLE "SalaryRange" (
    "id" SERIAL PRIMARY KEY,
    "positionId" INTEGER NOT NULL UNIQUE REFERENCES "Position"(id),
    "minimum" DECIMAL(10,2) NOT NULL,
    "maximum" DECIMAL(10,2) NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE TABLE "Requirements" (
    "id" SERIAL PRIMARY KEY,
    "positionId" INTEGER NOT NULL UNIQUE REFERENCES "Position"(id),
    "education" TEXT,
    "experience" TEXT,
    "other" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE TABLE "Benefits" (
    "id" SERIAL PRIMARY KEY,
    "positionId" INTEGER NOT NULL UNIQUE REFERENCES "Position"(id),
    "insurance" TEXT,
    "vacation" TEXT,
    "retirement" TEXT,
    "other" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE TABLE "Employee" (
    "id" SERIAL PRIMARY KEY,
    "companyId" INTEGER NOT NULL REFERENCES "Company"(id),
    "contactInfoId" INTEGER NOT NULL REFERENCES "ContactInfo"(id),
    "name" VARCHAR(255) NOT NULL,
    "role" VARCHAR(100) NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE TABLE "InterviewType" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE TABLE "InterviewStep" (
    "id" SERIAL PRIMARY KEY,
    "interviewFlowId" INTEGER NOT NULL REFERENCES "InterviewFlow"(id),
    "interviewTypeId" INTEGER NOT NULL REFERENCES "InterviewType"(id),
    "name" VARCHAR(100) NOT NULL,
    "orderIndex" INTEGER NOT NULL,
    "duration" SMALLINT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE TABLE "Application" (
    "id" SERIAL PRIMARY KEY,
    "positionId" INTEGER NOT NULL REFERENCES "Position"(id),
    "candidateId" INTEGER NOT NULL REFERENCES "Candidate"(id),
    "applicationDate" TIMESTAMP(3) NOT NULL,
    "status" "ApplicationStatus" NOT NULL DEFAULT 'SUBMITTED',
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

CREATE TABLE "Interview" (
    "id" SERIAL PRIMARY KEY,
    "applicationId" INTEGER NOT NULL REFERENCES "Application"(id),
    "interviewStepId" INTEGER NOT NULL REFERENCES "InterviewStep"(id),
    "employeeId" INTEGER NOT NULL REFERENCES "Employee"(id),
    "scheduledDate" TIMESTAMP(3) NOT NULL,
    "actualDate" TIMESTAMP(3),
    "result" "InterviewResult" NOT NULL DEFAULT 'PENDING',
    "score" SMALLINT,
    "feedback" TEXT,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- Create indexes
CREATE INDEX "idx_candidate_address" ON "Candidate"("addressId");
CREATE INDEX "idx_candidate_contact" ON "Candidate"("contactInfoId");
CREATE INDEX "idx_education_candidate" ON "Education"("candidateId");
CREATE INDEX "idx_work_experience_candidate" ON "WorkExperience"("candidateId");
CREATE INDEX "idx_candidate_skill_skill" ON "CandidateSkill"("skillId");
CREATE INDEX "idx_resume_candidate" ON "Resume"("candidateId");
CREATE INDEX "idx_company_address" ON "Company"("addressId");
CREATE INDEX "idx_position_company" ON "Position"("companyId");
CREATE INDEX "idx_position_interview_flow" ON "Position"("interviewFlowId");
CREATE INDEX "idx_employee_company" ON "Employee"("companyId");
CREATE INDEX "idx_employee_contact" ON "Employee"("contactInfoId");
CREATE INDEX "idx_interview_step_flow" ON "InterviewStep"("interviewFlowId");
CREATE INDEX "idx_interview_step_type" ON "InterviewStep"("interviewTypeId");
CREATE INDEX "idx_application_position" ON "Application"("positionId");
CREATE INDEX "idx_application_candidate" ON "Application"("candidateId");
CREATE INDEX "idx_interview_application" ON "Interview"("applicationId");
CREATE INDEX "idx_interview_step" ON "Interview"("interviewStepId");
CREATE INDEX "idx_interview_employee" ON "Interview"("employeeId");
