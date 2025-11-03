<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sales</title>
    <style>
        body{font-family:Segoe UI, Roboto, Arial;margin:0;background:#f4f6f8}
        .top-header{background:rebeccapurple;color:#fff;padding:18px 20px;font-size:26px;font-weight:800;text-transform:uppercase}
        .app{display:flex;min-height:calc(100vh - 68px)}
        .sidebar{width:220px;background:#000;color:#fff;padding:20px}
        .nav{margin-top:18px}
        .nav a{display:block;padding:10px 8px;color:#fff;text-decoration:none;border-radius:4px}
        .nav a:hover{background:#2a2a2a}
        .content{flex:1;padding:28px;max-width:1400px}
        h2{font-size:28px;font-weight:700;margin-bottom:20px}
        .msg{padding:12px 16px;border-radius:6px;margin-bottom:16px;font-size:14px}
        .msg.success{background:#d4edda;color:#155724;border-left:4px solid #28a745}
        .msg.error{background:#f8d7da;color:#721c24;border-left:4px solid #dc3545}
        .panel{background:#fff;padding:16px;border-radius:6px;box-shadow:0 1px 2px rgba(0,0,0,0.03);margin-bottom:16px}
        .panel h3{font-size:18px;font-weight:600;margin-bottom:14px}
        .toggle-btn{padding:10px 18px;background:rebeccapurple;color:#fff;border:none;border-radius:6px;font-size:14px;font-weight:600;cursor:pointer;margin-bottom:16px;font-family:Segoe UI, Roboto, Arial}
        .toggle-btn:hover{background:#7b4baa}
        #addSaleFormSection{display:none;overflow:hidden}
        #addSaleFormSection.show{display:block}
        .form-row{display:flex;gap:10px;align-items:center;flex-wrap:wrap;margin-bottom:10px}
        .form-row select,.form-row input[type=number],.form-row input[type=text]{flex:1;min-width:140px;padding:8px 12px;border:1px solid #ddd;border-radius:4px;font-size:14px;font-family:Segoe UI, Roboto, Arial}
        .form-row input[readonly]{background:#f8f9fa;color:#6c757d;cursor:not-allowed}
        .form-row button[type=submit]{padding:10px 20px;background:#28a745;color:#fff;border:none;border-radius:4px;font-weight:600;cursor:pointer;font-family:Segoe UI, Roboto, Arial;font-size:14px}
        .form-row button[type=submit]:hover{background:#218838}
        table{width:100%;border-collapse:collapse;margin-top:10px}
        th{background:#f8f9fa;padding:10px;text-align:left;font-weight:600;color:#495057;border-bottom:2px solid #dee2e6;font-size:14px}
        td{padding:10px;border-bottom:1px solid #e9ecef;vertical-align:middle;font-size:14px}
        .col-qty{width:80px;text-align:center}
        .col-price{width:120px;text-align:right;font-weight:500}
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
            <h2>Sales</h2>

            <#if message??><div class="msg success">${message}</div></#if>
            <#if error??><div class="msg error">${error}</div></#if>

            <button class="toggle-btn" onclick="toggleAddForm()">+ Add Sale</button>

            <section id="addSaleFormSection" class="panel">
                <h3>Sell Product</h3>
                <form action="/sales/create" method="post">
                    <div class="form-row">
                        <select id="saleProduct" name="productId" required onchange="onProductChange()" style="flex:2;min-width:200px">
                            <option value="">-- Choose Product --</option>
                            <#list products as p>
                                <option value="${p.id}" data-brand="${p.company?if_exists}" data-branch="${p.branch?if_exists}">${p.name} (Stock: ${p.quantity})</option>
                            </#list>
                        </select>
                        <input type="number" name="quantity" placeholder="Quantity to Sell" min="1" required style="flex:1;min-width:150px" />
                        <input type="text" name="discount" placeholder="Discount (absolute)" style="flex:1;min-width:150px" />
                    </div>
                    <div class="form-row">
                        <input id="saleBrandDisplay" type="text" placeholder="Brand (auto-filled)" readonly style="flex:1;min-width:180px" />
                        <input id="saleBranchDisplay" type="text" placeholder="Branch (auto-filled)" readonly style="flex:1;min-width:180px" />
                        <input id="saleBrand" type="hidden" name="brand" />
                        <input id="saleBranch" type="hidden" name="branch" />
                        <button type="submit">Create Sale</button>
                    </div>
                </form>
            </section>

            <section class="panel">
                <h3>Recent Sales</h3>
                <#if sales?has_content>
                    <table>
                        <tr><th>ID</th><th>Product</th><th class="col-qty">Quantity</th><th class="col-price">Total</th><th>Date</th></tr>
                        <#list sales as t>
                            <tr>
                                <td>${t.id}</td>
                                <td>${t.product.name}</td>
                                <td class="col-qty">${t.quantity}</td>
                                <td class="col-price">
                                    <#if t.totalPrice??>${"$"}${t.totalPrice?string["0.00"]}<#else>-</#if>
                                </td>
                                <td>${t.timestampFormatted}</td>
                            </tr>
                        </#list>
                    </table>
                <#else>
                    <div>No sales yet.</div>
                </#if>
            </section>
        </main>
    </div>

<script>
function toggleAddForm(){
    const section = document.getElementById('addSaleFormSection');
    section.classList.toggle('show');
}

function onProductChange(){
    const sel = document.getElementById('saleProduct');
    const opt = sel.selectedOptions[0];
    if(!opt || !opt.value) {
        document.getElementById('saleBrandDisplay').value = '';
        document.getElementById('saleBranchDisplay').value = '';
        document.getElementById('saleBrand').value = '';
        document.getElementById('saleBranch').value = '';
        return;
    }
    const brand = opt.getAttribute('data-brand') || '';
    const branch = opt.getAttribute('data-branch') || '';
    document.getElementById('saleBrandDisplay').value = brand;
    document.getElementById('saleBranchDisplay').value = branch;
    document.getElementById('saleBrand').value = brand;
    document.getElementById('saleBranch').value = branch;
}
document.addEventListener('DOMContentLoaded', onProductChange);
</script>
</body>
</html>