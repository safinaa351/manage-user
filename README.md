# User Management System

Aplikasi manajemen user yang dibangun dengan Laravel. Aplikasi ini menyediakan interface web dan API untuk mengelola data pengguna.

## 🚀 Fitur

- ✅ CRUD (Create, Read, Update, Delete) User
- ✅ Interface Web dengan Bootstrap
- ✅ RESTful API
- ✅ Validasi data
- ✅ Status aktif/non-aktif user
- ✅ Manajemen departemen

## 📋 Requirements

- PHP >= 8.1
- Composer
- Node.js & NPM
- MySQL (untuk production)
- SQLite (untuk development)

## 🛠 Instalasi & Menjalankan Aplikasi

### 1. Clone Repository
```bash
git clone <https://github.com/safinaa351/manage-user.git>
```

### 2. Install Dependencies
```bash
# Install PHP dependencies
composer install

# Install Node.js dependencies
npm install
```

### 3. Konfigurasi Environment
```bash
# Copy file environment
cp .env.example .env

# Generate application key
php artisan key:generate
```

### 4. Konfigurasi Database

#### Untuk Development (SQLite):
```env
DB_CONNECTION=sqlite
DB_DATABASE=database/database.sqlite
```

#### Untuk Production (MySQL):
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=user_management
DB_USERNAME=root
DB_PASSWORD=
```

### 5. Setup Database
```bash
# Buat database SQLite (jika menggunakan SQLite)
touch database/database.sqlite

# Jalankan migration
php artisan migrate
```

### 6. Build Assets
```bash
npm run build
```

### 7. Jalankan Aplikasi
```bash
# Jalankan server development
php artisan serve
```

Aplikasi akan tersedia di: `http://localhost:8000`

## 📱 Interface Web

Akses aplikasi melalui browser untuk menggunakan interface web:

- **Dashboard**: `/users` - Daftar semua user
- **Tambah User**: `/users/create` - Form tambah user baru
- **Edit User**: `/users/{id}/edit` - Form edit user
- **Delete User**: Tombol delete pada dashboard

## 🔌 API Documentation

Base URL: `http://localhost:8000/api`

### Postman Collection Link
