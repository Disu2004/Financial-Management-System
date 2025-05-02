# Financial-Management-System
# 💰 Financial Management System

A Java-based web application for personal financial management. The app enables users to track their **income** and **expenses**, categorize them, and visualize their financial activity through **pie charts** (daily, monthly, and yearly) on the homepage.

---

## 📌 Features

- ✅ **Home Dashboard**
  - Pie chart visualization for:
    - Daily income vs expense
    - Monthly income vs expense
    - Yearly income vs expense

- ➕ **Add Income**
  - Input amount, category, date, and description

- ➖ **Add Expense**
  - Input amount, category, date, and description

- 📂 **Add Income Category**
  - Create custom categories for incomes (e.g., Salary, Freelance, Investment)

- 📂 **Add Expense Category**
  - Create custom categories for expenses (e.g., Food, Bills, Entertainment)

---

## 🛠️ Tech Stack

- **Frontend:** JSP, HTML, CSS, JavaScript
- **Backend:** Java Servlets, JDBC
- **Database:** MySQL (via **XAMPP**)
- **Web Server:** Apache Tomcat

---

---

## 🗄️ Database Configuration (MySQL via XAMPP)

1. Start **Apache** and **MySQL** from XAMPP.
2. Go to `http://localhost/phpmyadmin`.
3. Create a database:  
   ```sql
   CREATE DATABASE financial_db;
4. Run the following table creation queries:
```sql
 Users Table
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(100),
  password VARCHAR(100)
);

-- Income Category Table
CREATE TABLE income_categories (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  user_id INT
);

-- Expense Category Table
CREATE TABLE expense_categories (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  user_id INT
);

-- Income Table
CREATE TABLE income (
  id INT PRIMARY KEY AUTO_INCREMENT,
  amount DOUBLE,
  category_id INT,
  date DATE,
  description TEXT,
  user_id INT
);

-- Expense Table
CREATE TABLE expense (
  id INT PRIMARY KEY AUTO_INCREMENT,
  amount DOUBLE,
  category_id INT,
  date DATE,
  description TEXT,
  user_id INT
);
```
### 📊 Visualization
Charts are rendered using Chart.js on the home page  to show:
Daily income vs expense pie chart<br/>
Monthly income vs expense pie chart
Yearly income vs expense pie chart

# ✍️ Author
Dishant Upadhyay
