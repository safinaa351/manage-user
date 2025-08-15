<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage User</title>

    @vite(['resources/css/app.css'])
</head>
<body>
    <h1>Welcome to Manage User Application</h1>
    <p>This is a simple application to manage your users.</p>

    <a href="users" class="btn">
        Show Dashboard
    </a>
</body>
</html>