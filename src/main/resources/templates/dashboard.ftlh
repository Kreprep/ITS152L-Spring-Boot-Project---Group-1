<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dashboard</title>
    <style>
        body{font-family:Segoe UI, Roboto, Arial;margin:0;background:#f4f6f8}
        .top-header{background:rebeccapurple;color:#fff;padding:18px 20px;font-size:26px;font-weight:800;text-transform:uppercase}
        .app{display:flex;min-height:calc(100vh - 68px)}
        .sidebar{width:220px;background:#000;color:#fff;padding:20px}
        .nav{margin-top:18px}
        .nav a{display:block;padding:10px 8px;color:#fff;text-decoration:none;border-radius:4px}
        .nav a:hover{background:#2a2a2a}
        .content{flex:1;padding:28px}
        .card{background:#fff;padding:16px;border-radius:6px;box-shadow:0 1px 2px rgba(0,0,0,0.03);margin-bottom:16px}
        .cards{display:flex;gap:16px}
    .card .num{font-size:28px;font-weight:700}
    .col-qty{width:80px;text-align:center}
    .col-price{width:120px;text-align:right}
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
            <h2>Dashboard</h2>
            <div class="cards">
                <div class="card" style="flex:1">
                    <div>Products</div>
                    <div class="num">${productCount?c}</div>
                </div>
                <div class="card" style="flex:1">
                    <div>Countries</div>
                    <div class="num">${countryCount?c}</div>
                </div>
            </div>

            <div class="card">
                <h3>Recent products</h3>
                <#if recentProducts?has_content>
                    <table style="width:100%;border-collapse:collapse">
                        <tr><th style="text-align:left;padding:6px">Name</th><th class="col-qty" style="padding:6px">Qty</th><th class="col-price" style="padding:6px">Price$</th></tr>
                            <#list recentProducts as p>
                                <tr><td style="padding:6px">${p.name}</td><td class="col-qty" style="padding:6px">${p.quantity}</td><td class="col-price" style="padding:6px">
                                    <#if p.price??>${"$"}${p.price?string["0.00"]}<#else>-</#if>
                                </td></tr>
                        </#list>
                    </table>
                <#else>
                    <div>No products yet. <a href="/manage-products">Manage Products</a></div>
                </#if>
            </div>
        </main>
    </div>
</body>
</html>