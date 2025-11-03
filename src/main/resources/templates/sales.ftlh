<#assign pageTitle = "Sales">
<#assign activePage = "sales">
<#include "base.ftlh">

<@page>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0"><i class="bi bi-cart-check me-2"></i>Sales</h2>
        <button class="btn btn-primary" data-bs-toggle="collapse" data-bs-target="#addSaleForm">
            <i class="bi bi-plus-circle me-1"></i> Add Sale
        </button>
    </div>

    <!-- Messages -->
    <#if message??>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </#if>
    <#if error??>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </#if>

    <!-- Add Sale Form (Collapsible) -->
    <div class="collapse mb-4" id="addSaleForm">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0"><i class="bi bi-cart-plus me-2"></i>Sell Product</h5>
            </div>
            <div class="card-body">
                <form action="/sales/create" method="post">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Product <span class="text-danger">*</span></label>
                            <select id="saleProduct" name="productId" class="form-select" required onchange="onProductChange()">
                                <option value="">-- Choose Product --</option>
                                <#list products as p>
                                    <option value="${p.id}" data-brand="${p.company?if_exists}" data-branch="${p.branch?if_exists}">
                                        ${p.name} (Stock: ${p.quantity})
                                    </option>
                                </#list>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Quantity <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="quantity" placeholder="Quantity to Sell" min="1" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Discount</label>
                            <input type="text" class="form-control" name="discount" placeholder="0.00">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Brand (auto-filled)</label>
                            <input id="saleBrandDisplay" type="text" class="form-control" readonly>
                            <input id="saleBrand" type="hidden" name="brand">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Branch (auto-filled)</label>
                            <input id="saleBranchDisplay" type="text" class="form-control" readonly>
                            <input id="saleBranch" type="hidden" name="branch">
                        </div>
                        <div class="col-md-4 d-flex align-items-end">
                            <button type="submit" class="btn btn-success w-100">
                                <i class="bi bi-check-circle me-1"></i> Create Sale
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Recent Sales Table -->
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0"><i class="bi bi-receipt me-2"></i>Recent Sales</h5>
        </div>
        <div class="card-body">
            <#if sales?has_content>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th style="width: 60px;">ID</th>
                                <th>Product</th>
                                <th class="text-center" style="width: 100px;">Quantity</th>
                                <th class="text-end" style="width: 120px;">Total</th>
                                <th style="width: 180px;">Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <#list sales as t>
                                <tr>
                                    <td><span class="badge bg-secondary">${t.id}</span></td>
                                    <td>
                                        <div class="fw-semibold">${t.product.name}</div>
                                        <#if t.product.itemType??>
                                            <small class="text-muted">${t.product.itemType}</small>
                                        </#if>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-info">${t.quantity}</span>
                                    </td>
                                    <td class="text-end fw-semibold text-success">
                                        <#if t.totalPrice??>${"$"}${t.totalPrice?string["0.00"]}<#else>-</#if>
                                    </td>
                                    <td>
                                        <small>${t.timestampFormatted}</small>
                                    </td>
                                </tr>
                            </#list>
                        </tbody>
                    </table>
                </div>
            <#else>
                <div class="text-center py-5">
                    <i class="bi bi-cart-x text-muted" style="font-size: 3rem;"></i>
                    <p class="text-muted mt-3">No sales yet.</p>
                </div>
            </#if>
        </div>
    </div>

<script>
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
</@page>
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