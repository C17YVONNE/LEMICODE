-- 医師テーブルデータ作成
CREATE TABLE doctor (
    -- 医師ID
    doctor_id SERIAL PRIMARY KEY,
    -- 名前
    name VARCHAR(50) NOT NULL,
    -- 専門分野
    specialty VARCHAR(100),
    -- 資格
    qualification VARCHAR(50),
    -- 経験年数
    years_of_experience INT,
    -- 連絡先番号
    contact_number VARCHAR(15),
    -- 電子メール
    email VARCHAR(100),
    -- 勤務日
    work_days VARCHAR(50),
    -- 勤務時間
    office_hours VARCHAR(50),
    -- 所属部門
    department_id INT,
    -- 入職日
    joining_date DATE,
    -- 給与
    salary DECIMAL(10,2),
    -- 状態
    status VARCHAR(20),
    -- 削除フラグ
    del_flag VARCHAR(1) NOT NULL DEFAULT '0',
    -- 作成日時
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- 更新日時
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO doctor (doctor_id, name, specialty, qualification, years_of_experience, contact_number, email, work_days, office_hours, department_id, joining_date, salary, status, del_flag, created_at, updated_at)
VALUES 
(1, '山田太郎', '外科', 'MD', 15, '123-4567', 'yamada@example.com', '月-金', '9:00-17:00', 1, '2020-01-15', 1200000, 'active', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, '佐藤花子', '内科', 'MD', 10, '123-8901', 'sato@example.com', '月-金', '9:00-18:00', 2, '2018-03-20', 1000000, 'active', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 部門テーブルデータ作成
CREATE TABLE departments (
    -- 部門ID
    department_id SERIAL PRIMARY KEY,
    -- 部門名
    department_name VARCHAR(100) NOT NULL,
    -- 説明
    description TEXT
);

INSERT INTO departments (department_id, department_name, description)
VALUES 
(1, '外科', '手術を担当する部門'),
(2, '内科', '内科治療を担当する部門');

-- 患者テーブルデータ作成
CREATE TABLE patients (
    -- 患者ID
    patient_id SERIAL PRIMARY KEY,
    -- 名前
    name VARCHAR(50) NOT NULL,
    -- 性別
    gender VARCHAR(10),
    -- 生年月日
    date_of_birth DATE,
    -- 住所
    address VARCHAR(255),
    -- 連絡先番号
    contact_number VARCHAR(15),
    -- 緊急連絡先
    emergency_contact VARCHAR(15),
    -- 削除フラグ
    del_flag VARCHAR(1) NOT NULL DEFAULT '0',
    -- 作成日時
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- 更新日時
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO patients (patient_id, name, gender, date_of_birth, address, contact_number, emergency_contact, del_flag, created_at, updated_at)
VALUES 
(1, '田中一郎', '男性', '1985-04-12', '東京都', '987-6543', '987-6544', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, '鈴木二郎', '男性', '1990-07-20', '神奈川県', '987-1111', '987-2222', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, '高橋三郎', '男性', '1980-09-30', '大阪府', '987-3333', '987-4444', '1', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);  -- 削除フラグが「1」

-- 手術テーブルデータ作成
CREATE TABLE surgeries (
    -- 手術ID
    surgery_id SERIAL PRIMARY KEY,
    -- 手術名
    surgery_name VARCHAR(150) NOT NULL,
    -- 手術日
    surgery_date DATE NOT NULL,
    -- 医師ID
    doctor_id INT NOT NULL,
    -- 患者ID
    patient_id INT NOT NULL,
    -- 削除フラグ
    del_flag VARCHAR(1) NOT NULL DEFAULT '0',
    -- 作成日時
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- 更新日時
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO surgeries (surgery_id, surgery_name, surgery_date, doctor_id, patient_id, del_flag, created_at, updated_at)
VALUES 
(1, '心臓バイパス手術', '2023-03-15', 1, 1, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 削除フラグ「0」
(2, '胃切除手術', '2023-05-20', 1, 2, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),        -- 削除フラグ「0」
(3, '脳腫瘍摘出手術', '2023-10-10', 2, 3, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);   -- 削除フラグ「1」

SELECT 
    p.name AS 患者名,
    s.surgery_name AS 手術名,
    s.surgery_date AS 手術日,
    d.name AS 医師名,
    dep.department_name AS 部門名
FROM 
    surgeries s
JOIN
    patients p ON s.patient_id=p.patient_id
JOIN
    doctor d ON s.doctor_id=d.doctor_id
JOIN
    departments dep ON d.department_id=dep.department_id
WHERE
    s.surgery_date BETWEEN '2023-01-01' AND '2023-12-31'
    AND p.del_flag='0'
    AND s.doctor_id=1;
    
-- 診察記録テーブルデータ作成   
CREATE TABLE consultation_records (
    -- 診察ID
    consultation_id SERIAL PRIMARY KEY,
    -- 患者ID
    patient_id INT NOT NULL,
    -- 医師ID
    doctor_id INT NOT NULL,
    -- 診察日
    consultation_date DATE NOT NULL,
    -- 診察内容
    consultation_details TEXT,
    -- 削除フラグ
    del_flag VARCHAR(1) NOT NULL DEFAULT '0',
    -- 作成日時
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- 更新日時
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO consultation_records (consultation_id, patient_id, doctor_id, consultation_date, consultation_details, del_flag, created_at, updated_at)
VALUES 
(1, 1, 1, '2024-03-15', '風邪の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),   -- 田中一郎
(2, 1, 2, '2024-04-20', '高血圧の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- 田中一郎
(3, 2, 2, '2024-02-10', '胃痛の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),   -- 鈴木二郎
(4, 3, 1, '2024-01-05', '頭痛の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);   -- 高橋三郎, 削除フラグ「1」

SELECT
    p.name AS 患者名,
    c.consultation_date AS 診察日,
    c.consultation_details AS 診察内容,
    d.name AS 担当医師
FROM
    consultation_records c
JOIN
    patients p ON c.patient_id=p.patient_id
JOIN
    doctor d ON c.doctor_id=d.doctor_id
WHERE
    c.consultation_date=(
        SELECT MAX(c2.consultation_date)
        FROM consultation_records c2
        WHERE c2.patient_id=c.patient_id
            AND c2.del_flag='0'
    ) 
AND p.del_flag='0';


DELETE FROM doctor;
DELETE FROM patients;
DELETE FROM consultation_records ;

-- 医師テーブルデータ作成
INSERT INTO doctor (doctor_id, name, specialty, qualification, years_of_experience, contact_number, email, work_days, office_hours, department_id, joining_date, salary, status, del_flag, created_at, updated_at)
VALUES 
(1, '山田太郎', '外科', 'MD', 15, '123-4567', 'yamada@example.com', '月-金', '9:00-17:00', 1, '2020-01-15', 1200000, 'active', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, '佐藤花子', '内科', 'MD', 10, '123-8901', 'sato@example.com', '月-金', '9:00-18:00', 2, '2018-03-20', 1000000, 'active', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, '鈴木一郎', '外科', 'MD', 20, '123-9999', 'suzuki@example.com', '月-金', '9:00-17:00', 1, '2015-02-25', 1300000, 'active', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 患者テーブルデータ作成
INSERT INTO patients (patient_id, name, gender, date_of_birth, address, contact_number, emergency_contact, del_flag, created_at, updated_at)
VALUES 
(1, '田中一郎', '男性', '1985-04-12', '東京都', '987-6543', '987-6544', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, '鈴木二郎', '男性', '1990-07-20', '神奈川県', '987-1111', '987-2222', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, '高橋三郎', '男性', '1980-09-30', '大阪府', '987-3333', '987-4444', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 診察記録テーブルデータ作成
INSERT INTO consultation_records (consultation_id, patient_id, doctor_id, consultation_date, consultation_details, del_flag, created_at, updated_at)
VALUES 
(1, 1, 2, '2024-03-15', '高血圧の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 内科, 佐藤花子
(2, 2, 2, '2024-04-20', '糖尿病の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 内科, 佐藤花子
(3, 3, 1, '2024-02-10', '胃痛の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),   -- 外科, 山田太郎
(4, 1, 3, '2024-01-05', '頭痛の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);  -- 外科, 鈴木一郎

SELECT
    p.name AS 患者名,
    c.consultation_date AS 診察日,
    c.consultation_details AS 診察内容,
    d.name AS 担当医師
FROM
    consultation_records c
JOIN
    patients p ON c.patient_id=p.patient_id
JOIN
    doctor d ON c.doctor_id=d.doctor_id
WHERE
    d.specialty='内科'   
    AND p.del_flag='0';


