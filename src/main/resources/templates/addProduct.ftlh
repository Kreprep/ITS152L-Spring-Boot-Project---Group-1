<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Add / Edit Product</title>
    <style>
        body{font-family:Segoe UI, Roboto, Arial;margin:0;background:#f4f6f8}
        .top-header{background:rebeccapurple;color:#fff;padding:14px 20px;font-size:22px;font-weight:700;text-transform:uppercase}
        .app{display:flex;min-height:calc(100vh - 58px)}
        .sidebar{width:220px;background:#000;color:#fff;padding:20px}
        .nav{margin-top:18px}
        .nav a{display:block;padding:8px 6px;color:#fff;text-decoration:none;border-radius:4px}
        .nav a:hover{background:#2a2a2a}
        .content{flex:1;padding:28px}
        form{background:#fff;padding:16px;border-radius:6px}
        label{font-weight:600}
        input[type=text],input[type=number]{width:100%;padding:8px;margin:6px 0 12px;border:1px solid #ddd;border-radius:4px}
        .actions{margin-top:12px}
    </style>
</head>
<body>
    <div class="top-header">DELAWARE</div>
    <div class="app">
         <aside class="sidebar">
            <nav class="nav">
                <a href="/dashboard">Dashboard</a>
                <a href="/overview">Overview</a>
                <a href="/manage-products">Manage Products</a>
                <a href="/sales">Sales</a>
                <a href="/orders">Orders</a>
                <a href="/transaction-history">Transaction History</a>
            </nav>
        </aside>
        <main class="content">
            <h2>Add / Edit Product</h2>
            <a href="/manage-products">Back</a>
            <form action="/add-product" method="post">
                <input type="hidden" name="id" value="${product.id?if_exists}"/>
                <label>Name:</label><br/>
                <input type="text" name="name" value="${product.name?if_exists}" required/><br/>
                <label>Description:</label><br/>
                <input type="text" name="description" value="${product.description?if_exists}"/><br/>
                <label>Quantity:</label><br/>
                <input type="number" name="quantity" value="${product.quantity?if_exists?c}" min="0" /><br/>
                <label>Price:</label><br/>
                <input type="text" name="price" value="${product.price?if_exists}"/><br/>
                <label>Type:</label><br/>
                <input type="text" name="itemType" value="${product.itemType?if_exists}"/><br/>
                <label>Brand / Company:</label><br/>
                <input type="text" name="company" value="${product.company?if_exists}"/><br/><br/>
                <div class="actions"><input type="submit" value="Save" class="btn add"/></div>
            </form>
        </main>
    </div>
</body>
</html>