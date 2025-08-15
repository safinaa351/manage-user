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
git clone <repository-url>
cd user-management-system
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

### 5. Jalankan Migration
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

## 🌐 Deployment ke Railway

### 1. Install Railway CLI
```bash
npm install -g @railway/cli
```

### 2. Login dan Setup
```bash
railway login
railway init
railway add mysql
```

### 3. Set Environment Variables
```bash
railway variables set APP_KEY=$(php artisan key:generate --show)
railway variables set APP_ENV=production
railway variables set APP_DEBUG=false
```

### 4. Deploy
```bash
railway up
```

## 📱 Interface Web

Akses aplikasi melalui browser untuk menggunakan interface web:

- **Dashboard**: `/users` - Daftar semua user
- **Tambah User**: `/users/create` - Form tambah user baru
- **Edit User**: `/users/{id}/edit` - Form edit user
- **Delete User**: Tombol delete pada dashboard

## 🔌 API Documentation

Base URL: `http://localhost:8000/api` (development) atau `https://your-app.up.railway.app/api` (production)

### Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/users` | Ambil semua user | ❌ |
| POST | `/users` | Buat user baru | ❌ |
| GET | `/users/{id}` | Ambil user berdasarkan ID | ❌ |
| PUT | `/users/{id}` | Update user | ❌ |
| DELETE | `/users/{id}` | Hapus user | ❌ |
