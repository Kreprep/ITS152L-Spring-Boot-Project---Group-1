<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Products</title>
    <style>
        body{font-family:Segoe UI, Roboto, Arial;margin:0;background:#f4f6f8}
        .top-header{background:rebeccapurple;color:#fff;padding:14px 20px;font-size:22px;font-weight:700;text-transform:uppercase}
        .app{display:flex;min-height:calc(100vh - 58px)}
        .sidebar{width:220px;background:#000;color:#fff;padding:20px}
        .nav{margin-top:18px}
        .nav a{display:block;padding:8px 6px;color:#fff;text-decoration:none;border-radius:4px}
        .nav a:hover{background:#2a2a2a}
        .content{flex:1;padding:28px}
    table{width:100%;border-collapse:collapse;background:#fff}
    td,th{padding:8px;border-bottom:1px solid #eee}
    .col-qty{width:80px;text-align:center}
    .col-price{width:120px;text-align:right}
        .actions form{display:inline;margin-right:6px}
        .topbar{display:flex;justify-content:space-between;align-items:center;margin-bottom:12px}
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
            <div class="topbar">
                <h2>Products</h2>
            </div>
            <table>
                <tr><th>Id</th><th>Name</th><th>Description</th><th class="col-qty">Qty</th><th class="col-price">Price$</th><th>Actions</th></tr>
                <#list products as p>
                    <tr>
                        <td>${p.id}</td>
                        <td>${p.name?html}</td>
                        <td>${p.description?html}</td>
                        <td class="col-qty">${p.quantity}</td>
                        <td class="col-price">
                            <#if p.price??>
                                ${"$"}${p.price?string["0.00"]}
                            <#else>
                                -
                            </#if>
                        </td>
                        <td class="actions">
                            <form action="/adjust-stock" method="post">
                                <input type="hidden" name="id" value="${p.id}"/>
                                <input type="hidden" name="delta" value="1"/>
                                <button type="submit">+1</button>
                            </form>
                            <form action="/adjust-stock" method="post">
                                <input type="hidden" name="id" value="${p.id}"/>
                                <input type="hidden" name="delta" value="-1"/>
                                <button type="submit">-1</button>
                            </form>
                            <a href="/edit-product/${p.id}">Edit</a>
                            <form action="/delete-product" method="post" style="display:inline">
                                <input type="hidden" name="id" value="${p.id}" />
                                <button type="submit">Delete</button>
                            </form>
                        </td>
                    </tr>
                </#list>
            </table>
        </main>
    </div>
</body>
</html>