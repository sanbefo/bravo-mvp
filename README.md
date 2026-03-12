# 🚀 Bravo MVP – Fintech Credit Platform

## 🧾 Overview

**Bravo MVP** is a simplified **multi-country fintech credit platform** built with Ruby on Rails.

The system allows users to:

* 👤 Register and authenticate
* 💳 Submit credit applications
* 📊 Track the status of their applications

Administrators can monitor platform activity and access system-wide data.

Although intentionally scoped as an **MVP**, the architecture demonstrates production-ready patterns such as:

* ⚙️ Service objects
* 🔄 Background job processing
* ⚡ Redis caching
* 🔐 Encrypted sensitive data
* 🔔 External integrations
* 🐳 Containerization
* ☸️ Kubernetes deployment configuration

---

# 🧰 Tech Stack

## 🖥 Backend

* Ruby **3.3.0**
* Rails **7.1.x**
* PostgreSQL
* Redis

## 🔑 Authentication

* Devise
* JWT tokens

## 🎨 Frontend

* Turbo
* Stimulus
* TailwindCSS
* HAML templates

## 🔄 Background Processing

* Sidekiq

## ☁️ Infrastructure

* Docker
* Kubernetes

## 🔗 Integrations

* Slack (Incoming Webhooks)

---

# 🏗 Architecture Overview

The project follows common **Rails architectural patterns** designed to keep the codebase maintainable and scalable.

Key principles used in the application:

* 🧠 **Service Objects** for business logic
* 🔄 **Background Jobs** for asynchronous tasks
* ⚡ **Redis Caching** for frequently accessed resources
* 🔐 **Active Record Encryption** for sensitive data
* 🧩 **Separation of concerns** between controllers, services, and models

---

# 👥 User Roles

The system differentiates between **two user types**.

## 👑 Admin Users

Users with emails ending in:

```
@bravo.com
```

Admins can:

* 👀 View all users
* 📄 View all credit applications
* 📊 Monitor platform activity

---

## 🙋 Regular Users

Regular users can:

* 📝 Register on the platform
* 💳 Submit credit applications
* 📄 View their own applications
* 📊 Track application status

---

# 💳 Credit Applications

Users can submit credit requests including:

* Personal information
* Country
* Requested loan amount
* Identification document

Each request starts with the status: pending

Users can only access **their own applications**, while admins can access **all applications**.

---

# 🏦 Banking Validation

Bank accounts are validated based on the user's country.

Validation logic is implemented using **service objects** located at:

```
app/services/accounts/validators
```

### Validators Implemented

* `BaseValidator`
* `MexicoValidator`
* `PortugalValidator`

### 🇲🇽 Mexico

Validates **CLABE numbers**

Requirements:

* 18 digits

### 🇵🇹 Portugal

Basic validation for **NIB format**

---

# 🔐 Data Security

Sensitive data is encrypted using **Rails Active Record Encryption**.

Encrypted fields include:

* 📄 User identification document

Encryption ensures:

* Data stored in the database is **encrypted**
* Rails automatically **decrypts values when accessed**

# 🔄 Background Jobs

Asynchronous processing is handled by **Sidekiq**.

Examples of jobs:

* 🔔 Sending Slack notifications when a new user registers

---

# 🔔 Slack Integration

The application integrates with Slack using **Incoming Webhooks**.

When a new user registers, the system sends a notification.

---

# ⚡ Caching Strategy

Redis is used as a **cache layer** to reduce database load.

Cached endpoints include:

* 👥 Users index
* 💳 Credit applications index
---

# 🌱 Data Seeding

The project includes a seed script for generating test data.

Creates:

* 👥 100 fake users
* 💳 multiple credit applications

The dataset is generated using **Faker**.

To test validation behavior:

```
10% of generated documents are intentionally invalid
```
---

# 🎨 Frontend

The frontend is built using:

* ⚡ Turbo
* 🎨 TailwindCSS
* 🧾 HAML templates

Current UI includes:

* Responsive header
* Login button
* User navigation
* Credit applications list
* Credit application detail view

---

# 📂 Project Structure

```
app
├── controllers
│   ├── accounts_controller.rb
│   ├── credit_applications_controller.rb
│   └── users_controller.rb
│
├── models
│   ├── account.rb
│   ├── credit_application.rb
│   └── user.rb
│
├── services
│   ├── accounts
│   │   └── validators
│   │       ├── base_validator.rb
│   │       ├── mexico_validator.rb
│   │       └── portugal_validator.rb
│   │
│   └── slack_notifier.rb
│
├── jobs
│   └── user_created_job.rb
│
├── views
│   ├── shared
│   │   └── _header.html.haml
│   └── credit_applications
```

---

# ⚙️ Running the Application

```
git clone https://github.com/sanbefo/bravo-mvp
cd bravo-mvp
```

You need to have `minikube` installed and `kubectl`
in order to run the application you should execute the following command

```
minikube start (if not already done)
make run-bravo-mvp
```
This will eventually open the browser with the app running
To login you need to use the following credentials
email: `santiago@bravo.com`
password: `muybravo`

---

# ☸️ Kubernetes Deployment

Basic Kubernetes configuration is included in:

```
/k8s
```

Structure:

```
k8s
├── namespace.yaml
├── postgres.yaml
├── redis.yaml
├── rails.yaml
├── sidekiq.yaml
└── ingress.yaml
```

These files define:

* namespace
* PostgreSQL database
* Redis instance
* Rails web application
* Sidekiq worker
* ingress routing
---

# 🚧 Future Improvements

Potential improvements include:

* 🕵️ fraud detection rules
* 🚦 rate limiting
* 📊 observability (Prometheus / Grafana)
* 🧾 audit logs
* 🔄 CI/CD pipelines

---

# 👨‍💻 Santiago

Developed as part of a **fintech backend engineering technical assessment** demonstrating Rails architecture, background processing, caching, security, and infrastructure deployment.
