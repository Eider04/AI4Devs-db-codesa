# Migración y Actualizacón de Base de Datos

## Eider04: Convierteme el siguiente ERD a un script sql
```erDiagram
     COMPANY {
         int id PK
         string name
     }
     EMPLOYEE {
         int id PK
         int company_id FK
         string name
         string email
         string role
         boolean is_active
     }
     POSITION {
         int id PK
         int company_id FK
         int interview_flow_id FK
         string title
         text description
         string status
         boolean is_visible
         string location
         text job_description
         text requirements
         text responsibilities
         numeric salary_min
         numeric salary_max
         string employment_type
         text benefits
         text company_description
         date application_deadline
         string contact_info
     }
     INTERVIEW_FLOW {
         int id PK
         string description
     }
     INTERVIEW_STEP {
         int id PK
         int interview_flow_id FK
         int interview_type_id FK
         string name
         int order_index
     }
     INTERVIEW_TYPE {
         int id PK
         string name
         text description
     }
     CANDIDATE {
         int id PK
         string firstName
         string lastName
         string email
         string phone
         string address
     }
     APPLICATION {
         int id PK
         int position_id FK
         int candidate_id FK
         date application_date
         string status
         text notes
     }
     INTERVIEW {
         int id PK
         int application_id FK
         int interview_step_id FK
         int employee_id FK
         date interview_date
         string result
         int score
         text notes
     }

     COMPANY ||--o{ EMPLOYEE : employs
     COMPANY ||--o{ POSITION : offers
     POSITION ||--|| INTERVIEW_FLOW : assigns
     INTERVIEW_FLOW ||--o{ INTERVIEW_STEP : contains
     INTERVIEW_STEP ||--|| INTERVIEW_TYPE : uses
     POSITION ||--o{ APPLICATION : receives
     CANDIDATE ||--o{ APPLICATION : submits
     APPLICATION ||--o{ INTERVIEW : has
     INTERVIEW ||--|| INTERVIEW_STEP : consists_of
     EMPLOYEE ||--o{ INTERVIEW : conducts
```

CODEGPT: I'll help you create a SQL script based on the ERD diagram. Here's the SQL script to create all the tables with their relationships:

```sql


-- Create Company table
CREATE TABLE COMPANY (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Create Employee table
CREATE TABLE EMPLOYEE (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    role VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    FOREIGN KEY (company_id) REFERENCES COMPANY(id)
);

-- Create Interview Flow table
CREATE TABLE INTERVIEW_FLOW (
    id SERIAL PRIMARY KEY,
    description TEXT
);

-- Create Position table
CREATE TABLE POSITION (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL,
    interview_flow_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) NOT NULL,
    is_visible BOOLEAN DEFAULT true,
    location VARCHAR(255),
    job_description TEXT,
    requirements TEXT,
    responsibilities TEXT,
    salary_min NUMERIC,
    salary_max NUMERIC,
    employment_type VARCHAR(50),
    benefits TEXT,
    company_description TEXT,
    application_deadline DATE,
    contact_info VARCHAR(255),
    FOREIGN KEY (company_id) REFERENCES COMPANY(id),
    FOREIGN KEY (interview_flow_id) REFERENCES INTERVIEW_FLOW(id)
);

-- Create Interview Type table
CREATE TABLE INTERVIEW_TYPE (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Create Interview Step table
CREATE TABLE INTERVIEW_STEP (
    id SERIAL PRIMARY KEY,
    interview_flow_id INTEGER NOT NULL,
    interview_type_id INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    order_index INTEGER NOT NULL,
    FOREIGN KEY (interview_flow_id) REFERENCES INTERVIEW_FLOW(id),
    FOREIGN KEY (interview_type_id) REFERENCES INTERVIEW_TYPE(id)
);

-- Create Candidate table
CREATE TABLE CANDIDATE (
    id SERIAL PRIMARY KEY,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    address TEXT
);

-- Create Application table
CREATE TABLE APPLICATION (
    id SERIAL PRIMARY KEY,
    position_id INTEGER NOT NULL,
    candidate_id INTEGER NOT NULL,
    application_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    notes TEXT,
    FOREIGN KEY (position_id) REFERENCES POSITION(id),
    FOREIGN KEY (candidate_id) REFERENCES CANDIDATE(id)
);

-- Create Interview table
CREATE TABLE INTERVIEW (
    id SERIAL PRIMARY KEY,
    application_id INTEGER NOT NULL,
    interview_step_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    interview_date DATE NOT NULL,
    result VARCHAR(50),
    score INTEGER,
    notes TEXT,
    FOREIGN KEY (application_id) REFERENCES APPLICATION(id),
    FOREIGN KEY (interview_step_id) REFERENCES INTERVIEW_STEP(id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(id)
);

-- Add indexes for better performance
CREATE INDEX idx_employee_company ON EMPLOYEE(company_id);
CREATE INDEX idx_position_company ON POSITION(company_id);
CREATE INDEX idx_position_interview_flow ON POSITION(interview_flow_id);
CREATE INDEX idx_interview_step_flow ON INTERVIEW_STEP(interview_flow_id);
CREATE INDEX idx_interview_step_type ON INTERVIEW_STEP(interview_type_id);
CREATE INDEX idx_application_position ON APPLICATION(position_id);
CREATE INDEX idx_application_candidate ON APPLICATION(candidate_id);
CREATE INDEX idx_interview_application ON INTERVIEW(application_id);
CREATE INDEX idx_interview_step ON INTERVIEW(interview_step_id);
CREATE INDEX idx_interview_employee ON INTERVIEW(employee_id);
```


# Eider04: Eres un experto arquitecto de software con certificación como DBA experto en el diseño de sistemas escalables usando DDD, Tengo un nuevo requerimiento con la siguiente Historia de usuario, sobre la cual necesito una solución.
```📌 Historia de Usuario: Actualización del modelo de base de datos para el flujo de aplicación

ID: HU-001
Título: Actualización del modelo de base de datos para el flujo de aplicación de posiciones

Descripción
Como desarrollador del sistema LTI, quiero actualizar la base de datos con las nuevas entidades necesarias para gestionar el flujo completo de aplicación a posiciones, asegurando que la estructura de datos sea óptima y escalable.

Criterios de Aceptación
✅ Convertir el diagrama ERD en formato Mermaid a un script SQL con las entidades y relaciones definidas.
✅ Analizar la base de datos actual del proyecto y el script SQL generado para garantizar coherencia.
✅ Implementar las nuevas estructuras de datos mediante migraciones de Prisma.
✅ Aplicar buenas prácticas de modelado, incluyendo normalización y definición de índices para optimizar consultas.

La actualizacion del actual esquema se hara con el script anterior -- 

-- Create Company table
CREATE TABLE COMPANY (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Create Employee table
CREATE TABLE EMPLOYEE (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    role VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    FOREIGN KEY (company_id) REFERENCES COMPANY(id)
);

-- Create Interview Flow table
CREATE TABLE INTERVIEW_FLOW (
    id SERIAL PRIMARY KEY,
    description TEXT
);

-- Create Position table
CREATE TABLE POSITION (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL,
    interview_flow_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) NOT NULL,
    is_visible BOOLEAN DEFAULT true,
    location VARCHAR(255),
    job_description TEXT,
    requirements TEXT,
    responsibilities TEXT,
    salary_min NUMERIC,
    salary_max NUMERIC,
    employment_type VARCHAR(50),
    benefits TEXT,
    company_description TEXT,
    application_deadline DATE,
    contact_info VARCHAR(255),
    FOREIGN KEY (company_id) REFERENCES COMPANY(id),
    FOREIGN KEY (interview_flow_id) REFERENCES INTERVIEW_FLOW(id)
);

-- Create Interview Type table
CREATE TABLE INTERVIEW_TYPE (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Create Interview Step table
CREATE TABLE INTERVIEW_STEP (
    id SERIAL PRIMARY KEY,
    interview_flow_id INTEGER NOT NULL,
    interview_type_id INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    order_index INTEGER NOT NULL,
    FOREIGN KEY (interview_flow_id) REFERENCES INTERVIEW_FLOW(id),
    FOREIGN KEY (interview_type_id) REFERENCES INTERVIEW_TYPE(id)
);

-- Create Candidate table
CREATE TABLE CANDIDATE (
    id SERIAL PRIMARY KEY,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    address TEXT
);

-- Create Application table
CREATE TABLE APPLICATION (
    id SERIAL PRIMARY KEY,
    position_id INTEGER NOT NULL,
    candidate_id INTEGER NOT NULL,
    application_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    notes TEXT,
    FOREIGN KEY (position_id) REFERENCES POSITION(id),
    FOREIGN KEY (candidate_id) REFERENCES CANDIDATE(id)
);

-- Create Interview table
CREATE TABLE INTERVIEW (
    id SERIAL PRIMARY KEY,
    application_id INTEGER NOT NULL,
    interview_step_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    interview_date DATE NOT NULL,
    result VARCHAR(50),
    score INTEGER,
    notes TEXT,
    FOREIGN KEY (application_id) REFERENCES APPLICATION(id),
    FOREIGN KEY (interview_step_id) REFERENCES INTERVIEW_STEP(id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(id)
);

-- Add indexes for better performance
CREATE INDEX idx_employee_company ON EMPLOYEE(company_id);
CREATE INDEX idx_position_company ON POSITION(company_id);
CREATE INDEX idx_position_interview_flow ON POSITION(interview_flow_id);
CREATE INDEX idx_interview_step_flow ON INTERVIEW_STEP(interview_flow_id);
CREATE INDEX idx_interview_step_type ON INTERVIEW_STEP(interview_type_id);
CREATE INDEX idx_application_position ON APPLICATION(position_id);
CREATE INDEX idx_application_candidate ON APPLICATION(candidate_id);
CREATE INDEX idx_interview_application ON INTERVIEW(application_id);
CREATE INDEX idx_interview_step ON INTERVIEW(interview_step_id);
CREATE INDEX idx_interview_employee ON INTERVIEW(employee_id);
```
CODEGPT: Como arquitecto de software y DBA, voy a ayudarte a implementar esta actualización siguiendo las mejores prácticas. Analizaré y ejecutaré cada tarea solicitada:

```Primero, actualizaremos el schema.prisma incorporando las nuevas entidades y manteniendo las existentes:
prisma


// Existing models
model Candidate {
  id              Int           @id @default(autoincrement())
  firstName       String        @db.VarChar(100)
  lastName        String        @db.VarChar(100)
  email           String        @unique @db.VarChar(255)
  phone           String?       @db.VarChar(15)
  address         String?       @db.VarChar(100)
  educations      Education[]
  workExperiences WorkExperience[]
  resumes         Resume[]
  applications    Application[] // New relation
}

// New models
model Company {
  id        Int        @id @default(autoincrement())
  name      String     @db.VarChar(255)
  employees Employee[]
  positions Position[]
  createdAt DateTime   @default(now())
  updatedAt DateTime   @updatedAt
}

model Employee {
  id         Int         @id @default(autoincrement())
  companyId  Int
  name       String      @db.VarChar(255)
  email      String      @unique @db.VarChar(255)
  role       String      @db.VarChar(100)
  isActive   Boolean     @default(true)
  company    Company     @relation(fields: [companyId], references: [id])
  interviews Interview[]
  createdAt  DateTime    @default(now())
  updatedAt  DateTime    @updatedAt

  @@index([companyId])
}

model InterviewFlow {
  id           Int            @id @default(autoincrement())
  description  String?
  positions    Position[]
  steps        InterviewStep[]
  createdAt    DateTime       @default(now())
  updatedAt    DateTime       @updatedAt
}

model Position {
  id                 Int           @id @default(autoincrement())
  companyId          Int
  interviewFlowId    Int
  title              String        @db.VarChar(255)
  description        String?       @db.Text
  status            String        @db.VarChar(50)
  isVisible         Boolean       @default(true)
  location          String?       @db.VarChar(255)
  jobDescription    String?       @db.Text
  requirements      String?       @db.Text
  responsibilities  String?       @db.Text
  salaryMin         Decimal?      @db.Decimal(10,2)
  salaryMax         Decimal?      @db.Decimal(10,2)
  employmentType    String?       @db.VarChar(50)
  benefits          String?       @db.Text
  companyDescription String?      @db.Text
  applicationDeadline DateTime?
  contactInfo       String?       @db.VarChar(255)
  company           Company       @relation(fields: [companyId], references: [id])
  interviewFlow     InterviewFlow @relation(fields: [interviewFlowId], references: [id])
  applications      Application[]
  createdAt         DateTime      @default(now())
  updatedAt         DateTime      @updatedAt

  @@index([companyId])
  @@index([interviewFlowId])
}

model InterviewType {
  id          Int            @id @default(autoincrement())
  name        String         @db.VarChar(100)
  description String?        @db.Text
  steps       InterviewStep[]
  createdAt   DateTime       @default(now())
  updatedAt   DateTime       @updatedAt
}

model InterviewStep {
  id              Int           @id @default(autoincrement())
  interviewFlowId Int
  interviewTypeId Int
  name            String        @db.VarChar(100)
  orderIndex      Int
  interviewFlow   InterviewFlow @relation(fields: [interviewFlowId], references: [id])
  interviewType   InterviewType @relation(fields: [interviewTypeId], references: [id])
  interviews      Interview[]
  createdAt       DateTime      @default(now())
  updatedAt       DateTime      @updatedAt

  @@index([interviewFlowId])
  @@index([interviewTypeId])
}

model Application {
  id              Int         @id @default(autoincrement())
  positionId      Int
  candidateId     Int
  applicationDate DateTime
  status          String      @db.VarChar(50)
  notes           String?     @db.Text
  position        Position    @relation(fields: [positionId], references: [id])
  candidate       Candidate   @relation(fields: [candidateId], references: [id])
  interviews      Interview[]
  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt

  @@index([positionId])
  @@index([candidateId])
}

model Interview {
  id              Int           @id @default(autoincrement())
  applicationId   Int
  interviewStepId Int
  employeeId      Int
  interviewDate   DateTime
  result          String?       @db.VarChar(50)
  score           Int?
  notes           String?       @db.Text
  application     Application   @relation(fields: [applicationId], references: [id])
  interviewStep   InterviewStep @relation(fields: [interviewStepId], references: [id])
  employee        Employee      @relation(fields: [employeeId], references: [id])
  createdAt       DateTime      @default(now())
  updatedAt       DateTime      @updatedAt

  @@index([applicationId])
  @@index([interviewStepId])
  @@index([employeeId])
}
```

# Eider04: Muestrame un ERD de la BD con la actualización.
schema.prisma

CODEGPT: Aquí está el ERD en formato Mermaid que representa el schema.prisma actualizado:
```
mermaid


erDiagram
    CANDIDATE ||--o{ EDUCATION : has
    CANDIDATE ||--o{ WORK_EXPERIENCE : has
    CANDIDATE ||--o{ RESUME : has
    CANDIDATE ||--o{ APPLICATION : submits

    COMPANY ||--o{ EMPLOYEE : employs
    COMPANY ||--o{ POSITION : offers

    POSITION ||--|| INTERVIEW_FLOW : uses
    POSITION ||--o{ APPLICATION : receives

    INTERVIEW_FLOW ||--o{ INTERVIEW_STEP : contains
    INTERVIEW_TYPE ||--o{ INTERVIEW_STEP : defines

    APPLICATION ||--o{ INTERVIEW : schedules
    INTERVIEW_STEP ||--o{ INTERVIEW : conducts
    EMPLOYEE ||--o{ INTERVIEW : performs

    CANDIDATE {
        int id PK
        string firstName
        string lastName
        string email UK
        string phone
        string address
    }

    EDUCATION {
        int id PK
        string institution
        string title
        datetime startDate
        datetime endDate
        int candidateId FK
    }

    WORK_EXPERIENCE {
        int id PK
        string company
        string position
        string description
        datetime startDate
        datetime endDate
        int candidateId FK
    }

    RESUME {
        int id PK
        string filePath
        string fileType
        datetime uploadDate
        int candidateId FK
    }

    COMPANY {
        int id PK
        string name
        datetime createdAt
        datetime updatedAt
    }

    EMPLOYEE {
        int id PK
        int companyId FK
        string name
        string email UK
        string role
        boolean isActive
        datetime createdAt
        datetime updatedAt
    }

    POSITION {
        int id PK
        int companyId FK
        int interviewFlowId FK
        string title
        string description
        string status
        boolean isVisible
        string location
        string jobDescription
        string requirements
        string responsibilities
        decimal salaryMin
        decimal salaryMax
        string employmentType
        string benefits
        string companyDescription
        datetime applicationDeadline
        string contactInfo
        datetime createdAt
        datetime updatedAt
    }

    INTERVIEW_FLOW {
        int id PK
        string description
        datetime createdAt
        datetime updatedAt
    }

    INTERVIEW_TYPE {
        int id PK
        string name
        string description
        datetime createdAt
        datetime updatedAt
    }

    INTERVIEW_STEP {
        int id PK
        int interviewFlowId FK
        int interviewTypeId FK
        string name
        int orderIndex
        datetime createdAt
        datetime updatedAt
    }

    APPLICATION {
        int id PK
        int positionId FK
        int candidateId FK
        datetime applicationDate
        string status
        string notes
        datetime createdAt
        datetime updatedAt
    }

    INTERVIEW {
        int id PK
        int applicationId FK
        int interviewStepId FK
        int employeeId FK
        datetime interviewDate
        string result
        int score
        string notes
        datetime createdAt
        datetime updatedAt
    }

```

# Eider04: Agrega normalización y mejora la estructura
schema.prisma

CODEGPT: Aquí está el schema.prisma mejorado y normalizado, con mejores prácticas y estructuras adicionales:

```prisma


generator client {
  provider      = "prisma-client-js"
  binaryTargets = ["native", "debian-openssl-3.0.x"]
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// Base entity for audit fields
enum Status {
  ACTIVE
  INACTIVE
  DELETED
}

// Common address fields normalized
model Address {
  id           Int       @id @default(autoincrement())
  street       String    @db.VarChar(255)
  city         String    @db.VarChar(100)
  state        String    @db.VarChar(100)
  country      String    @db.VarChar(100)
  postalCode   String    @db.VarChar(20)
  candidates   Candidate[]
  companies    Company[]
  createdAt    DateTime  @default(now())
  updatedAt    DateTime  @updatedAt
}

// Normalized contact information
model ContactInfo {
  id         Int      @id @default(autoincrement())
  email      String   @unique @db.VarChar(255)
  phone      String?  @db.VarChar(15)
  candidates Candidate[]
  employees  Employee[]
  createdAt  DateTime @default(now())
  updatedAt  DateTime @updatedAt
}

model Candidate {
  id              Int              @id @default(autoincrement())
  firstName       String           @db.VarChar(100)
  lastName        String           @db.VarChar(100)
  addressId       Int?
  contactInfoId   Int
  status         Status           @default(ACTIVE)
  address         Address?         @relation(fields: [addressId], references: [id])
  contactInfo     ContactInfo      @relation(fields: [contactInfoId], references: [id])
  educations      Education[]
  workExperiences WorkExperience[]
  resumes         Resume[]
  applications    Application[]
  skills          CandidateSkill[]
  createdAt       DateTime         @default(now())
  updatedAt       DateTime         @updatedAt

  @@index([addressId])
  @@index([contactInfoId])
}

// Normalized skills
model Skill {
  id              Int              @id @default(autoincrement())
  name            String           @unique @db.VarChar(100)
  category        String           @db.VarChar(50)
  candidates      CandidateSkill[]
  positions       PositionSkill[]
  createdAt       DateTime         @default(now())
  updatedAt       DateTime         @updatedAt
}

model CandidateSkill {
  id          Int       @id @default(autoincrement())
  candidateId Int
  skillId     Int
  level       Int       @db.SmallInt // 1-5 skill level
  candidate   Candidate @relation(fields: [candidateId], references: [id])
  skill       Skill     @relation(fields: [skillId], references: [id])
  createdAt   DateTime  @default(now())
  updatedAt   DateTime  @updatedAt

  @@unique([candidateId, skillId])
  @@index([skillId])
}

model Education {
  id            Int       @id @default(autoincrement())
  institution   String    @db.VarChar(100)
  degree        String    @db.VarChar(100)
  field         String    @db.VarChar(150)
  startDate     DateTime
  endDate       DateTime?
  candidateId   Int
  candidate     Candidate @relation(fields: [candidateId], references: [id])
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt

  @@index([candidateId])
}

model WorkExperience {
  id          Int       @id @default(autoincrement())
  company     String    @db.VarChar(100)
  position    String    @db.VarChar(100)
  description String?   @db.Text
  startDate   DateTime
  endDate     DateTime?
  candidateId Int
  candidate   Candidate @relation(fields: [candidateId], references: [id])
  createdAt   DateTime  @default(now())
  updatedAt   DateTime  @updatedAt

  @@index([candidateId])
}

model Resume {
  id          Int       @id @default(autoincrement())
  filePath    String    @db.VarChar(500)
  fileType    String    @db.VarChar(50)
  isActive    Boolean   @default(true)
  uploadDate  DateTime
  candidateId Int
  candidate   Candidate @relation(fields: [candidateId], references: [id])
  createdAt   DateTime  @default(now())
  updatedAt   DateTime  @updatedAt

  @@index([candidateId])
}

model Company {
  id              Int        @id @default(autoincrement())
  name            String     @db.VarChar(255)
  addressId       Int?
  status          Status     @default(ACTIVE)
  address         Address?   @relation(fields: [addressId], references: [id])
  employees       Employee[]
  positions       Position[]
  industry        String?    @db.VarChar(100)
  size            String?    @db.VarChar(50)
  website         String?    @db.VarChar(255)
  createdAt       DateTime   @default(now())
  updatedAt       DateTime   @updatedAt

  @@index([addressId])
}

// Normalized employment types
enum EmploymentType {
  FULL_TIME
  PART_TIME
  CONTRACT
  TEMPORARY
  INTERNSHIP
}

model Position {
  id                 Int            @id @default(autoincrement())
  companyId          Int
  interviewFlowId    Int
  title              String         @db.VarChar(255)
  description        String?        @db.Text
  status             String         @db.VarChar(50)
  isVisible          Boolean        @default(true)
  location           String?        @db.VarChar(255)
  employmentType     EmploymentType @default(FULL_TIME)
  salaryRange        SalaryRange?
  requirements       Requirements?
  benefits          Benefits?
  applications      Application[]
  skills            PositionSkill[]
  company           Company         @relation(fields: [companyId], references: [id])
  interviewFlow     InterviewFlow  @relation(fields: [interviewFlowId], references: [id])
  createdAt         DateTime       @default(now())
  updatedAt         DateTime       @updatedAt

  @@index([companyId])
  @@index([interviewFlowId])
}

// Normalized salary information
model SalaryRange {
  id         Int      @id @default(autoincrement())
  positionId Int      @unique
  minimum    Decimal  @db.Decimal(10,2)
  maximum    Decimal  @db.Decimal(10,2)
  currency   String   @db.VarChar(3)
  position   Position @relation(fields: [positionId], references: [id])
  createdAt  DateTime @default(now())
  updatedAt  DateTime @updatedAt
}

// Normalized position requirements
model Requirements {
  id          Int      @id @default(autoincrement())
  positionId  Int      @unique
  education   String?  @db.Text
  experience  String?  @db.Text
  skills      String?  @db.Text
  other       String?  @db.Text
  position    Position @relation(fields: [positionId], references: [id])
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}

model PositionSkill {
  id          Int      @id @default(autoincrement())
  positionId  Int
  skillId     Int
  isRequired  Boolean  @default(true)
  position    Position @relation(fields: [positionId], references: [id])
  skill       Skill    @relation(fields: [skillId], references: [id])
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  @@unique([positionId, skillId])
  @@index([skillId])
}

// Normalized benefits
model Benefits {
  id          Int      @id @default(autoincrement())
  positionId  Int      @unique
  insurance   String?  @db.Text
  vacation    String?  @db.Text
  retirement  String?  @db.Text
  other       String?  @db.Text
  position    Position @relation(fields: [positionId], references: [id])
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}

// ... (resto del código continúa igual para Interview, InterviewFlow, etc.)
```

# Eider04: muestrame todo las tablas con las mejoras anteriores
schema.prisma

CODEGPT: Aquí está el schema.prisma completamente mejorado y normalizado:

```prisma


generator client {
  provider      = "prisma-client-js"
  binaryTargets = ["native", "debian-openssl-3.0.x"]
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// Enums
enum Status {
  ACTIVE
  INACTIVE
  PENDING
  DELETED
}

enum EmploymentType {
  FULL_TIME
  PART_TIME
  CONTRACT
  TEMPORARY
  INTERNSHIP
}

enum ApplicationStatus {
  SUBMITTED
  REVIEWING
  INTERVIEWING
  ACCEPTED
  REJECTED
  WITHDRAWN
}

enum InterviewResult {
  PENDING
  PASSED
  FAILED
  NO_SHOW
  RESCHEDULED
}

// Base Models
model Address {
  id           Int        @id @default(autoincrement())
  street       String     @db.VarChar(255)
  city         String     @db.VarChar(100)
  state        String     @db.VarChar(100)
  country      String     @db.VarChar(100)
  postalCode   String     @db.VarChar(20)
  candidates   Candidate[]
  companies    Company[]
  createdAt    DateTime   @default(now())
  updatedAt    DateTime   @updatedAt
}

model ContactInfo {
  id         Int        @id @default(autoincrement())
  email      String     @unique @db.VarChar(255)
  phone      String?    @db.VarChar(15)
  linkedin   String?    @db.VarChar(255)
  website    String?    @db.VarChar(255)
  candidates Candidate[]
  employees  Employee[]
  createdAt  DateTime   @default(now())
  updatedAt  DateTime   @updatedAt
}

// Main Models
model Candidate {
  id              Int              @id @default(autoincrement())
  firstName       String           @db.VarChar(100)
  lastName        String           @db.VarChar(100)
  addressId       Int?
  contactInfoId   Int
  status         Status           @default(ACTIVE)
  address         Address?         @relation(fields: [addressId], references: [id])
  contactInfo     ContactInfo      @relation(fields: [contactInfoId], references: [id])
  educations      Education[]
  workExperiences WorkExperience[]
  skills          CandidateSkill[]
  resumes         Resume[]
  applications    Application[]
  createdAt       DateTime         @default(now())
  updatedAt       DateTime         @updatedAt

  @@index([addressId])
  @@index([contactInfoId])
}

model Education {
  id            Int       @id @default(autoincrement())
  institution   String    @db.VarChar(100)
  degree        String    @db.VarChar(100)
  field         String    @db.VarChar(150)
  startDate     DateTime
  endDate       DateTime?
  gpa          Decimal?  @db.Decimal(3,2)
  candidateId   Int
  candidate     Candidate @relation(fields: [candidateId], references: [id])
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt

  @@index([candidateId])
}

model WorkExperience {
  id          Int       @id @default(autoincrement())
  company     String    @db.VarChar(100)
  position    String    @db.VarChar(100)
  description String?   @db.Text
  startDate   DateTime
  endDate     DateTime?
  isCurrent   Boolean   @default(false)
  candidateId Int
  candidate   Candidate @relation(fields: [candidateId], references: [id])
  createdAt   DateTime  @default(now())
  updatedAt   DateTime  @updatedAt

  @@index([candidateId])
}

model Skill {
  id              Int              @id @default(autoincrement())
  name            String           @unique @db.VarChar(100)
  category        String           @db.VarChar(50)
  candidates      CandidateSkill[]
  positions       PositionSkill[]
  createdAt       DateTime         @default(now())
  updatedAt       DateTime         @updatedAt
}

model CandidateSkill {
  id          Int       @id @default(autoincrement())
  candidateId Int
  skillId     Int
  level       Int       @db.SmallInt
  yearsOfExp  Decimal?  @db.Decimal(4,1)
  candidate   Candidate @relation(fields: [candidateId], references: [id])
  skill       Skill     @relation(fields: [skillId], references: [id])
  createdAt   DateTime  @default(now())
  updatedAt   DateTime  @updatedAt

  @@unique([candidateId, skillId])
  @@index([skillId])
}

model Resume {
  id          Int       @id @default(autoincrement())
  filePath    String    @db.VarChar(500)
  fileType    String    @db.VarChar(50)
  isActive    Boolean   @default(true)
  uploadDate  DateTime
  candidateId Int
  candidate   Candidate @relation(fields: [candidateId], references: [id])
  createdAt   DateTime  @default(now())
  updatedAt   DateTime  @updatedAt

  @@index([candidateId])
}

model Company {
  id          Int        @id @default(autoincrement())
  name        String     @db.VarChar(255)
  addressId   Int?
  status      Status     @default(ACTIVE)
  address     Address?   @relation(fields: [addressId], references: [id])
  industry    String?    @db.VarChar(100)
  size        String?    @db.VarChar(50)
  website     String?    @db.VarChar(255)
  employees   Employee[]
  positions   Position[]
  createdAt   DateTime   @default(now())
  updatedAt   DateTime   @updatedAt

  @@index([addressId])
}

model Employee {
  id           Int         @id @default(autoincrement())
  companyId    Int
  contactInfoId Int
  name         String      @db.VarChar(255)
  role         String      @db.VarChar(100)
  isActive     Boolean     @default(true)
  company      Company     @relation(fields: [companyId], references: [id])
  contactInfo  ContactInfo @relation(fields: [contactInfoId], references: [id])
  interviews   Interview[]
  createdAt    DateTime    @default(now())
  updatedAt    DateTime    @updatedAt

  @@index([companyId])
  @@index([contactInfoId])
}

model Position {
  id                 Int            @id @default(autoincrement())
  companyId          Int
  interviewFlowId    Int
  title              String         @db.VarChar(255)
  description        String?        @db.Text
  status             Status         @default(ACTIVE)
  isVisible          Boolean        @default(true)
  location           String?        @db.VarChar(255)
  employmentType     EmploymentType @default(FULL_TIME)
  salaryRange        SalaryRange?
  requirements       Requirements?
  benefits           Benefits?
  skills             PositionSkill[]
  applications       Application[]
  company            Company        @relation(fields: [companyId], references: [id])
  interviewFlow      InterviewFlow  @relation(fields: [interviewFlowId], references: [id])
  createdAt          DateTime       @default(now())
  updatedAt          DateTime       @updatedAt

  @@index([companyId])
  @@index([interviewFlowId])
}

model SalaryRange {
  id         Int      @id @default(autoincrement())
  positionId Int      @unique
  minimum    Decimal  @db.Decimal(10,2)
  maximum    Decimal  @db.Decimal(10,2)
  currency   String   @db.VarChar(3)
  position   Position @relation(fields: [positionId], references: [id])
  createdAt  DateTime @default(now())
  updatedAt  DateTime @updatedAt
}

model Requirements {
  id          Int      @id @default(autoincrement())
  positionId  Int      @unique
  education   String?  @db.Text
  experience  String?  @db.Text
  other       String?  @db.Text
  position    Position @relation(fields: [positionId], references: [id])
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}

model Benefits {
  id          Int      @id @default(autoincrement())
  positionId  Int      @unique
  insurance   String?  @db.Text
  vacation    String?  @db.Text
  retirement  String?  @db.Text
  other       String?  @db.Text
  position    Position @relation(fields: [positionId], references: [id])
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}

model PositionSkill {
  id          Int      @id @default(autoincrement())
  positionId  Int
  skillId     Int
  isRequired  Boolean  @default(true)
  position    Position @relation(fields: [positionId], references: [id])
  skill       Skill    @relation(fields: [skillId], references: [id])
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  @@unique([positionId, skillId])
  @@index([skillId])
}

model InterviewFlow {
  id           Int            @id @default(autoincrement())
  name         String         @db.VarChar(100)
...72 lines truncated
```

# Eider04: Creame un script sql con la estuctura final de la BD para la migración
schema.prisma

CODEGPT: Aquí está el script SQL completo para crear la base de datos basada en el schema.prisma proporcionado:

```sql


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
...11 lines truncated
```

