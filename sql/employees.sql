/*
 Navicat Premium Dump SQL

 Source Server         : VM
 Source Server Type    : MySQL
 Source Server Version : 80040 (8.0.40-0ubuntu0.22.04.1)
 Source Host           : 172.168.0.124:40400
 Source Schema         : employees

 Target Server Type    : MySQL
 Target Server Version : 80040 (8.0.40-0ubuntu0.22.04.1)
 File Encoding         : 65001

 Date: 08/02/2025 10:13:37
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for departments
-- 部门表
-- ----------------------------
DROP TABLE IF EXISTS `departments`;
CREATE TABLE `departments` (
  `dept_no` char(4) NOT NULL, -- 部门编号列
  `dept_name` varchar(40) NOT NULL, -- 部门名称列，可选值：Customer Service, Development, Finance, Human Resources, Marketing, Production, Quality Management, Research, Sales
  PRIMARY KEY (`dept_no`),
  UNIQUE KEY `dept_name` (`dept_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for dept_emp
-- 部门员工表
-- ----------------------------
DROP TABLE IF EXISTS `dept_emp`;
CREATE TABLE `dept_emp` (
  `emp_no` int NOT NULL, -- 员工编号列
  `dept_no` char(4) NOT NULL, -- 部门编号列
  `from_date` date NOT NULL, -- 入职日期列
  `to_date` date NOT NULL, -- 合同终止日期列
  PRIMARY KEY (`emp_no`,`dept_no`),
  KEY `dept_no` (`dept_no`),
  CONSTRAINT `dept_emp_ibfk_1` FOREIGN KEY (`emp_no`) REFERENCES `employees` (`emp_no`) ON DELETE CASCADE,
  CONSTRAINT `dept_emp_ibfk_2` FOREIGN KEY (`dept_no`) REFERENCES `departments` (`dept_no`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for dept_manager
-- 部门经理表
-- ----------------------------
DROP TABLE IF EXISTS `dept_manager`;
CREATE TABLE `dept_manager` (
  `emp_no` int NOT NULL, -- 员工编号列
  `dept_no` char(4) NOT NULL, -- 部门编号列
  `from_date` date NOT NULL, -- 任职日期列
  `to_date` date NOT NULL, -- 离职日期列
  PRIMARY KEY (`emp_no`,`dept_no`),
  KEY `dept_no` (`dept_no`),
  CONSTRAINT `dept_manager_ibfk_1` FOREIGN KEY (`emp_no`) REFERENCES `employees` (`emp_no`) ON DELETE CASCADE,
  CONSTRAINT `dept_manager_ibfk_2` FOREIGN KEY (`dept_no`) REFERENCES `departments` (`dept_no`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for employees
-- 员工表
-- ----------------------------
DROP TABLE IF EXISTS `employees`;
CREATE TABLE `employees` (
  `emp_no` int NOT NULL, -- 员工编号列
  `birth_date` date NOT NULL, -- 出生日期列
  `first_name` varchar(14) NOT NULL, -- 名列
  `last_name` varchar(16) NOT NULL, -- 姓列
  `gender` enum('M','F') NOT NULL, -- 性别列
  `hire_date` date NOT NULL, -- 入职日期列
  PRIMARY KEY (`emp_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for salaries
-- 薪资记录表
-- ----------------------------
DROP TABLE IF EXISTS `salaries`;
CREATE TABLE `salaries` (
  `emp_no` int NOT NULL, -- 员工编号列
  `salary` int NOT NULL, -- 薪资列
  `from_date` date NOT NULL, -- 薪资周期起始日期列
  `to_date` date NOT NULL, -- 薪资周期结束日期列
  PRIMARY KEY (`emp_no`,`from_date`),
  CONSTRAINT `salaries_ibfk_1` FOREIGN KEY (`emp_no`) REFERENCES `employees` (`emp_no`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for titles
-- 职称表
-- ----------------------------
DROP TABLE IF EXISTS `titles`;
CREATE TABLE `titles` (
  `emp_no` int NOT NULL, -- 员工编号列
  `title` varchar(50) NOT NULL, -- 职称列
  `from_date` date NOT NULL, -- 职称生效日期列
  `to_date` date DEFAULT NULL, -- 职称失效日期列
  PRIMARY KEY (`emp_no`,`title`,`from_date`),
  CONSTRAINT `titles_ibfk_1` FOREIGN KEY (`emp_no`) REFERENCES `employees` (`emp_no`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- View structure for current_dept_emp
-- ----------------------------
DROP VIEW IF EXISTS `current_dept_emp`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `current_dept_emp` AS select `l`.`emp_no` AS `emp_no`,`d`.`dept_no` AS `dept_no`,`l`.`from_date` AS `from_date`,`l`.`to_date` AS `to_date` from (`dept_emp` `d` join `dept_emp_latest_date` `l` on(((`d`.`emp_no` = `l`.`emp_no`) and (`d`.`from_date` = `l`.`from_date`) and (`l`.`to_date` = `d`.`to_date`))));

-- ----------------------------
-- View structure for dept_emp_latest_date
-- ----------------------------
DROP VIEW IF EXISTS `dept_emp_latest_date`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `dept_emp_latest_date` AS select `dept_emp`.`emp_no` AS `emp_no`,max(`dept_emp`.`from_date`) AS `from_date`,max(`dept_emp`.`to_date`) AS `to_date` from `dept_emp` group by `dept_emp`.`emp_no`;

SET FOREIGN_KEY_CHECKS = 1;
