<#assign pageTitle = "Orders">
<#assign activePage = "orders">
<#include "base.ftlh">

<@page>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0"><i class="bi bi-truck me-2"></i>Orders</h2>
        <button class="btn btn-primary" data-bs-toggle="collapse" data-bs-target="#addOrderForm">
            <i class="bi bi-plus-circle me-1"></i> Add Order
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

    <!-- Add Order Form (Collapsible) -->
    <div class="collapse mb-4" id="addOrderForm">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0"><i class="bi bi-box-seam me-2"></i>Create Purchase Order</h5>
            </div>
            <div class="card-body">
                <form action="/orders/create" method="post">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Product <span class="text-danger">*</span></label>
                            <select id="orderProduct" name="productId" class="form-select" required onchange="onProductChange()">
                                <option value="">-- Choose Product --</option>
                                <#list products as p>
                                    <option value="${p.id}" data-brand="${p.company?if_exists}" data-type="${p.itemType?if_exists}">
                                        ${p.name} (Stock: ${p.quantity})
                                    </option>
                                </#list>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Quantity <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="quantity" placeholder="Quantity to Order" min="1" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Supplier <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="supplier" placeholder="Supplier Name" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Unit Price</label>
                            <input type="text" class="form-control" name="price" placeholder="0.00">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Discount</label>
                            <input type="text" class="form-control" name="discount" placeholder="0.00">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Brand (auto-filled)</label>
                            <input id="orderBrandDisplay" type="text" class="form-control" readonly>
                            <input id="orderBrand" type="hidden" name="brand">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Type (auto-filled)</label>
                            <input id="orderTypeDisplay" type="text" class="form-control" readonly>
                            <input id="orderType" type="hidden" name="itemType">
                        </div>
                        <div class="col-12">
                            <button type="submit" class="btn btn-success">
                                <i class="bi bi-check-circle me-1"></i> Create Order
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Orders List -->
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0"><i class="bi bi-list-check me-2"></i>Orders List</h5>
        </div>
        <div class="card-body">
            <#if orders?has_content>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th style="width: 60px;">ID</th>
                                <th>Product</th>
                                <th class="text-center" style="width: 80px;">Qty</th>
                                <th class="text-end" style="width: 100px;">Price</th>
                                <th style="width: 120px;">Supplier</th>
                                <th class="text-center" style="width: 100px;">Status</th>
                                <th style="width: 140px;">Ordered</th>
                                <th style="width: 140px;">Received</th>
                                <th class="text-center" style="width: 120px;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <#list orders as o>
                                <tr>
                                    <td><span class="badge bg-secondary">${o.id}</span></td>
                                    <td>
                                        <div class="fw-semibold">${o.product.name}</div>
                                        <#if o.product.itemType??>
                                            <small class="text-muted">${o.product.itemType}</small>
                                        </#if>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-info">${o.quantity}</span>
                                    </td>
                                    <td class="text-end fw-semibold">${o.priceFormatted}</td>
                                    <td>${o.supplier}</td>
                                    <td class="text-center">
                                        <#if o.status == "PENDING">
                                            <span class="badge bg-warning text-dark">
                                                <i class="bi bi-clock-history me-1"></i>Pending
                                            </span>
                                        <#else>
                                            <span class="badge bg-success">
                                                <i class="bi bi-check-circle me-1"></i>Received
                                            </span>
                                        </#if>
                                    </td>
                                    <td><small>${o.orderDateFormatted}</small></td>
                                    <td><small>${o.receivedDateFormatted}</small></td>
                                    <td class="text-center">
                                        <#if o.status == "PENDING">
                                            <form action="/orders/receive" method="post" class="d-inline">
                                                <input type="hidden" name="id" value="${o.id}">
                                                <button class="btn btn-sm btn-primary" type="submit">
                                                    <i class="bi bi-check2 me-1"></i>Mark Received
                                                </button>
                                            </form>
                                        <#else>
                                            <span class="text-muted">—</span>
                                        </#if>
                                    </td>
                                </tr>
                            </#list>
                        </tbody>
                    </table>
                </div>
            <#else>
                <div class="text-center py-5">
                    <i class="bi bi-inbox text-muted" style="font-size: 3rem;"></i>
                    <p class="text-muted mt-3">No orders yet.</p>
                </div>
            </#if>
        </div>
    </div>

<script>
function onProductChange(){
    const sel = document.getElementById('orderProduct');
    const opt = sel.selectedOptions[0];
    if(!opt || !opt.value) {
        document.getElementById('orderBrandDisplay').value = '';
        document.getElementById('orderTypeDisplay').value = '';
        document.getElementById('orderBrand').value = '';
        document.getElementById('orderType').value = '';
        return;
    }
    const brand = opt.getAttribute('data-brand') || '';
    const type = opt.getAttribute('data-type') || '';
    document.getElementById('orderBrandDisplay').value = brand;
    document.getElementById('orderTypeDisplay').value = type;
    document.getElementById('orderBrand').value = brand;
    document.getElementById('orderType').value = type;
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
        #addOrderFormSection{display:none;overflow:hidden}
        #addOrderFormSection.show{display:block}
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
        .badge{padding:4px 10px;border-radius:4px;font-weight:600;font-size:12px;text-transform:uppercase}
        .badge.pending{background:#fff3cd;color:#856404}
        .badge.received{background:#d4edda;color:#155724}
        .btn-action{padding:6px 12px;background:#007bff;color:#fff;border:none;border-radius:4px;font-size:13px;font-weight:600;cursor:pointer;font-family:Segoe UI, Roboto, Arial}
        .btn-action:hover{background:#0056b3}
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
            <h2>Orders</h2>

            <#if message??><div class="msg success">${message}</div></#if>
            <#if error??><div class="msg error">${error}</div></#if>

            <button class="toggle-btn" onclick="toggleAddForm()">+ Add Order</button>

            <section id="addOrderFormSection" class="panel">
                <h3>Create Purchase Order</h3>
                <form action="/orders/create" method="post">
                    <div class="form-row">
                        <select id="orderProduct" name="productId" required onchange="onProductChange()" style="flex:2;min-width:200px">
                            <option value="">-- Choose Product --</option>
                            <#list products as p>
                                <option value="${p.id}" data-brand="${p.company?if_exists}" data-type="${p.itemType?if_exists}">${p.name} (Stock: ${p.quantity})</option>
                            </#list>
                        </select>
                        <input type="number" name="quantity" placeholder="Quantity to Order" min="1" required style="flex:1;min-width:150px" />
                        <input type="text" name="supplier" placeholder="Supplier Name" required style="flex:1;min-width:150px" />
                    </div>
                    <div class="form-row">
                        <input type="text" name="price" placeholder="Unit Price (e.g. 12.50)" style="flex:1;min-width:140px" />
                        <input type="text" name="discount" placeholder="Discount (absolute)" style="flex:1;min-width:140px" />
                        <input id="orderBrandDisplay" type="text" placeholder="Brand (auto-filled)" readonly style="flex:1;min-width:140px" />
                        <input id="orderTypeDisplay" type="text" placeholder="Type (auto-filled)" readonly style="flex:1;min-width:140px" />
                        <input id="orderBrand" type="hidden" name="brand" />
                        <input id="orderType" type="hidden" name="itemType" />
                        <button type="submit">Create Order</button>
                    </div>
                </form>
            </section>

            <section class="panel">
                <h3>Orders List</h3>
                <#if orders?has_content>
                    <table>
                        <tr><th>ID</th><th>Product</th><th class="col-qty">Quantity</th><th class="col-price">Price</th><th>Supplier</th><th>Status</th><th>Ordered</th><th>Received</th><th>Action</th></tr>
                        <#list orders as o>
                            <tr>
                                <td>${o.id}</td>
                                <td>${o.product.name}</td>
                                <td class="col-qty">${o.quantity}</td>
                                <td class="col-price">${o.priceFormatted}</td>
                                <td>${o.supplier}</td>
                                <td>
                                    <#if o.status == "PENDING">
                                        <span class="badge pending">Pending</span>
                                    <#else>
                                        <span class="badge received">Received</span>
                                    </#if>
                                </td>
                                <td>${o.orderDateFormatted}</td>
                                <td>${o.receivedDateFormatted}</td>
                                <td>
                                    <#if o.status == "PENDING">
                                        <form action="/orders/receive" method="post" style="display:inline">
                                            <input type="hidden" name="id" value="${o.id}" />
                                            <button class="btn-action" type="submit">Mark Received</button>
                                        </form>
                                    <#else>
                                        <em>—</em>
                                    </#if>
                                </td>
                            </tr>
                        </#list>
                    </table>
                <#else>
                    <div>No orders yet.</div>
                </#if>
            </section>
        </main>
    </div>

<script>
function toggleAddForm(){
    const section = document.getElementById('addOrderFormSection');
    section.classList.toggle('show');
}

function onProductChange(){
    const sel = document.getElementById('orderProduct');
    const opt = sel.selectedOptions[0];
    if(!opt || !opt.value) {
        document.getElementById('orderBrandDisplay').value = '';
        document.getElementById('orderTypeDisplay').value = '';
        document.getElementById('orderBrand').value = '';
        document.getElementById('orderType').value = '';
        return;
    }
    const brand = opt.getAttribute('data-brand') || '';
    const type = opt.getAttribute('data-type') || '';
    document.getElementById('orderBrandDisplay').value = brand;
    document.getElementById('orderTypeDisplay').value = type;
    document.getElementById('orderBrand').value = brand;
    document.getElementById('orderType').value = type;
}
document.addEventListener('DOMContentLoaded', onProductChange);
</script>
</body>
</html>