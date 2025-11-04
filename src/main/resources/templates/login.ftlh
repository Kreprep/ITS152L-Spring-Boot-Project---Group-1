<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - DELAWARE Inventory</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Roboto, -apple-system, BlinkMacSystemFont, sans-serif;
        }
        .login-card {
            background-color: white;
            border-radius: 0.75rem;
            padding: 2.5rem;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 1.5rem 3rem rgba(0,0,0,0.2);
        }
        .brand-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .brand-header h1 {
            font-weight: 800;
            letter-spacing: 1px;
            color: #552288;
        }
        .form-control:focus {
            border-color: #552288;
            box-shadow: 0 0 0 0.25rem rgba(102, 51, 153, 0.25);
        }
        .btn-primary {
            background-color: #663399;
            border-color: #663399;
            font-weight: 600;
        }
        .btn-primary:hover {
            background-color: #552288;
            border-color: #552288;
        }
        .helper-text {
            font-size: 0.85rem;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="brand-header">
            <div class="mb-2 text-secondary"><i class="bi bi-box-seam fs-1"></i></div>
            <h1 class="mb-0">DELAWARE</h1>
            <p class="text-muted mb-0">Inventory Management System</p>
        </div>
        <#if error??>
            <div class="alert alert-danger" role="alert">
                ${error}
            </div>
        </#if>
        <form method="post" action="/login">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username" value="${username!""}" required autofocus>
            </div>
            <div class="mb-4">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            <div class="d-grid">
                <button type="submit" class="btn btn-primary">Sign In</button>
            </div>
        </form>
        <div class="helper-text mt-4">
            <p class="mb-1"><strong>Default credentials:</strong></p>
            <p class="mb-0">Admin - <code>admin / admin123</code></p>
            <p class="mb-0">Employee - <code>employee / employee123</code></p>
        </div>
    </div>
</body>
</html>
