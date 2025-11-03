<#assign pageTitle = "Manage Products">
<#assign activePage = "products">
<#include "base.ftlh">

<@page>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0"><i class="bi bi-box-seam me-2"></i>Manage Products</h2>
        <button class="btn btn-primary" data-bs-toggle="collapse" data-bs-target="#addProductForm">
            <i class="bi bi-plus-circle me-1"></i> Add New Product
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

    <!-- Add Product Form (Collapsible) -->
    <div class="collapse mb-4" id="addProductForm">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0"><i class="bi bi-plus-square me-2"></i>Add New Product</h5>
            </div>
            <div class="card-body">
                <form action="/add-product" method="post">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Product Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name" placeholder="Enter product name" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Description</label>
                            <input type="text" class="form-control" name="description" placeholder="Product description">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Quantity</label>
                            <input type="number" class="form-control" name="quantity" placeholder="0" min="0" value="0">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Price</label>
                            <input type="text" class="form-control" name="price" placeholder="0.00">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Type</label>
                            <input type="text" class="form-control" name="itemType" placeholder="e.g., furniture">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Brand / Company</label>
                            <input type="text" class="form-control" name="company" placeholder="Brand name">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Branch</label>
                            <input type="text" class="form-control" name="branch" placeholder="Branch location">
                        </div>
                        <div class="col-md-6 d-flex align-items-end">
                            <button type="submit" class="btn btn-success w-100">
                                <i class="bi bi-check-circle me-1"></i> Add Product
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Product Inventory -->
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0"><i class="bi bi-archive me-2"></i>Product Inventory</h5>
        </div>
        <div class="card-body">
            <!-- Search and Filters -->
            <div class="row g-3 mb-4">
                <div class="col-12">
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-search"></i></span>
                        <input id="productSearch" type="text" class="form-control" placeholder="Search by name, type, brand or description..." oninput="filterProducts()">
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <select id="filterType" class="form-select" onchange="filterProducts()">
                        <option value="">All types</option>
                        <#list types as t><option value="${t}">${t}</option></#list>
                    </select>
                </div>
                <div class="col-md-6 col-lg-3">
                    <select id="filterBrand" class="form-select" onchange="filterProducts()">
                        <option value="">All brands</option>
                        <#list brands as b><option value="${b}">${b}</option></#list>
                    </select>
                </div>
                <div class="col-md-6 col-lg-3">
                    <select id="filterBranch" class="form-select" onchange="filterProducts()">
                        <option value="">All branches</option>
                        <#list branches as br><option value="${br}">${br}</option></#list>
                    </select>
                </div>
                <div class="col-6 col-md-3 col-lg-1">
                    <input id="filterMin" type="number" class="form-control" placeholder="Min $" oninput="filterProducts()">
                </div>
                <div class="col-6 col-md-3 col-lg-2">
                    <input id="filterMax" type="number" class="form-control" placeholder="Max $" oninput="filterProducts()">
                </div>
            </div>

            <!-- Products Table -->
            <div class="table-responsive">
                <table class="table table-hover align-middle" id="productsTable">
                    <thead>
                        <tr>
                            <th style="width: 50px;">ID</th>
                            <th>Name</th>
                            <th class="d-none d-lg-table-cell">Description</th>
                            <th class="text-center" style="width: 80px;">Qty</th>
                            <th class="text-end" style="width: 100px;">Price</th>
                            <th class="d-none d-md-table-cell" style="width: 100px;">Type</th>
                            <th class="d-none d-xl-table-cell" style="width: 120px;">Brand</th>
                            <th class="d-none d-xl-table-cell" style="width: 120px;">Branch</th>
                            <th class="text-center" style="width: 200px;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <#list products as p>
                            <tr data-type="${p.itemType?if_exists}" data-brand="${p.company?if_exists}" data-branch="${p.branch?if_exists}" data-price="${p.price?if_exists}">
                                <td><span class="badge bg-secondary">${p.id}</span></td>
                                <td>
                                    <div class="fw-semibold">${p.name}</div>
                                    <small class="text-muted d-md-none">${p.itemType?if_exists}</small>
                                </td>
                                <td class="d-none d-lg-table-cell text-muted">${p.description}</td>
                                <td class="text-center">
                                    <span class="badge <#if p.quantity == 0>bg-danger<#elseif p.quantity < 10>bg-warning<#else>bg-success</#if>">
                                        ${p.quantity}
                                    </span>
                                </td>
                                <td class="text-end fw-semibold">
                                    <#if p.price??>${"$"}${p.price?string["0.00"]}<#else>-</#if>
                                </td>
                                <td class="d-none d-md-table-cell">${p.itemType?if_exists}</td>
                                <td class="d-none d-xl-table-cell">${p.company?if_exists}</td>
                                <td class="d-none d-xl-table-cell">${p.branch?if_exists}</td>
                                <td>
                                    <div class="btn-group btn-group-sm d-flex flex-wrap gap-1" role="group">
                                        <form action="/products/add-quantity" method="post" class="d-inline">
                                            <input type="hidden" name="id" value="${p.id}">
                                            <button class="btn btn-success" type="submit" title="Increase quantity">
                                                <i class="bi bi-plus-lg"></i>
                                            </button>
                                        </form>
                                        <form action="/products/subtract-quantity" method="post" class="d-inline">
                                            <input type="hidden" name="id" value="${p.id}">
                                            <button class="btn btn-warning" type="submit" title="Decrease quantity">
                                                <i class="bi bi-dash-lg"></i>
                                            </button>
                                        </form>
                                        <a class="btn btn-primary" href="/edit-product/${p.id}" title="Edit product">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <form action="/products/delete" method="post" class="d-inline" onsubmit="return confirm('Delete ${p.name}?')">
                                            <input type="hidden" name="id" value="${p.id}">
                                            <button class="btn btn-danger" type="submit" title="Delete product">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </#list>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

<script>
function filterProducts(){
    const q = document.getElementById('productSearch').value.trim().toLowerCase();
    const type = document.getElementById('filterType').value;
    const brand = document.getElementById('filterBrand').value;
    const branch = document.getElementById('filterBranch').value;
    const min = parseFloat(document.getElementById('filterMin').value || '0');
    const maxRaw = document.getElementById('filterMax').value;
    const max = maxRaw === '' ? Number.POSITIVE_INFINITY : parseFloat(maxRaw);
    const rows = document.querySelectorAll('#productsTable tbody tr');
    
    rows.forEach((r) => {
        const text = r.textContent.trim().toLowerCase();
        const rtype = r.getAttribute('data-type') || '';
        const rbrand = r.getAttribute('data-brand') || '';
        const rbranch = r.getAttribute('data-branch') || '';
        const price = parseFloat(r.getAttribute('data-price') || '0');
        
        const passesText = q === '' || text.indexOf(q) !== -1;
        const passesType = !type || rtype === type;
        const passesBrand = !brand || rbrand === brand;
        const passesBranch = !branch || rbranch === branch;
        const passesPrice = (!isNaN(min) ? price >= min : true) && (isFinite(max) ? price <= max : true);
        
        r.style.display = (passesText && passesType && passesBrand && passesBranch && passesPrice) ? '' : 'none';
    });
}
</script>
</@page>
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
        #addProductFormSection{display:none;overflow:hidden}
        #addProductFormSection.show{display:block}
        .form-row{display:flex;gap:10px;align-items:center;flex-wrap:wrap;margin-bottom:10px}
        .form-row input[type=text],.form-row input[type=number]{flex:1;min-width:140px;padding:8px 12px;border:1px solid #ddd;border-radius:4px;font-size:14px;font-family:Segoe UI, Roboto, Arial}
        .form-row input[type=submit]{padding:10px 20px;background:#28a745;color:#fff;border:none;border-radius:4px;font-weight:600;cursor:pointer;font-family:Segoe UI, Roboto, Arial;font-size:14px}
        .form-row input[type=submit]:hover{background:#218838}
        .search-filter-row{display:flex;gap:10px;margin-bottom:14px;flex-wrap:wrap;align-items:center}
        #productSearch{flex:1;min-width:300px;padding:8px 12px;border:1px solid #ddd;border-radius:4px;font-size:14px;font-family:Segoe UI, Roboto, Arial}
        select{padding:8px 12px;border:1px solid #ddd;border-radius:4px;font-size:14px;background:#fff;cursor:pointer;font-family:Segoe UI, Roboto, Arial}
        .filter-group{display:flex;gap:8px;flex-wrap:wrap}
        input[type=number].filter-input{width:110px;padding:8px 12px;border:1px solid #ddd;border-radius:4px;font-size:14px;font-family:Segoe UI, Roboto, Arial}
        table{width:100%;border-collapse:collapse;margin-top:10px}
        th{background:#f8f9fa;padding:10px;text-align:left;font-weight:600;color:#495057;border-bottom:2px solid #dee2e6;font-size:14px}
        td{padding:10px;border-bottom:1px solid #e9ecef;vertical-align:middle;font-size:14px}
        .cell-name{font-weight:600}
        .col-qty{width:80px;text-align:center}
        .col-price{width:120px;text-align:right;font-weight:500}
        .col-actions{width:200px;text-align:right}
        .action-group{display:flex;gap:6px;justify-content:flex-end;align-items:center;flex-wrap:wrap}
        .qty-controls{display:flex;gap:4px}
        .btn{padding:6px 12px;border:none;border-radius:4px;font-size:13px;font-weight:600;cursor:pointer;font-family:Segoe UI, Roboto, Arial}
        .btn.add-qty{background:#28a745;color:#fff}
        .btn.add-qty:hover{background:#218838}
        .btn.sub-qty{background:#ffc107;color:#212529}
        .btn.sub-qty:hover{background:#e0a800}
        .btn.edit{background:#007bff;color:#fff;text-decoration:none;display:inline-block}
        .btn.edit:hover{background:#0056b3}
        .btn.delete{background:#dc3545;color:#fff}
        .btn.delete:hover{background:#c82333}
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
            <h2>Manage Products</h2>

            <#if message??><div class="msg success">${message}</div></#if>
            <#if error??><div class="msg error">${error}</div></#if>

            <button class="toggle-btn" onclick="toggleAddForm()">+ Add New Product</button>

            <section class="panel" id="addProductFormSection">
                <h3>Add New Product</h3>
                <form action="/add-product" method="post">
                    <div class="form-row">
                        <input type="text" name="name" placeholder="Product Name" required />
                        <input type="text" name="description" placeholder="Description" />
                        <input type="number" name="quantity" placeholder="Quantity" min="0" />
                        <input type="text" name="price" placeholder="Price" />
                    </div>
                    <div class="form-row">
                        <input type="text" name="itemType" placeholder="Type (e.g. furniture)" />
                        <input type="text" name="company" placeholder="Brand / Company" />
                        <input type="text" name="branch" placeholder="Branch" />
                        <input type="submit" value="Add Product" />
                    </div>
                </form>
            </section>

            <section class="panel">
                <h3>Product Inventory</h3>

                <div class="search-filter-row">
                    <input id="productSearch" type="text" placeholder="Search by name, type, brand or description..." oninput="filterProducts()" />
                </div>

                <div class="filter-group">
                    <select id="filterType" onchange="filterProducts()">
                        <option value="">All types</option>
                        <#list types as t><option value="${t}">${t}</option></#list>
                    </select>
                    <select id="filterBrand" onchange="filterProducts()">
                        <option value="">All brands</option>
                        <#list brands as b><option value="${b}">${b}</option></#list>
                    </select>
                    <select id="filterBranch" onchange="filterProducts()">
                        <option value="">All branches</option>
                        <#list branches as br><option value="${br}">${br}</option></#list>
                    </select>
                    <input id="filterMin" type="number" class="filter-input" placeholder="Min price" oninput="filterProducts()"/>
                    <input id="filterMax" type="number" class="filter-input" placeholder="Max price" oninput="filterProducts()"/>
                </div>

                <table id="productsTable">
                    <tr>
                        <th style="width:50px">Id</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th class="col-qty">Qty</th>
                        <th class="col-price">Price</th>
                        <th style="width:100px">Type</th>
                        <th style="width:120px">Brand</th>
                        <th style="width:120px">Branch</th>
                        <th class="col-actions">Actions</th>
                    </tr>
                    <#list products as p>
                        <tr data-type="${p.itemType?if_exists}" data-brand="${p.company?if_exists}" data-branch="${p.branch?if_exists}" data-price="${p.price?if_exists}">
                            <td>${p.id}</td>
                            <td class="cell-name" style="font-weight:500">${p.name}</td>
                            <td class="cell-desc">${p.description}</td>
                            <td class="col-qty">${p.quantity}</td>
                            <td class="col-price">
                                <#if p.price??>${"$"}${p.price?string["0.00"]}<#else>-</#if>
                            </td>
                            <td class="cell-type">${p.itemType?if_exists}</td>
                            <td class="cell-brand">${p.company?if_exists}</td>
                            <td class="cell-branch">${p.branch?if_exists}</td>
                            <td class="col-actions">
                                <div class="action-group">
                                    <div class="qty-controls">
                                        <form action="/products/add-quantity" method="post" style="display:inline">
                                            <input type="hidden" name="id" value="${p.id}"/>
                                            <button class="btn add-qty" type="submit" title="Increase quantity">+1</button>
                                        </form>
                                        <form action="/products/subtract-quantity" method="post" style="display:inline">
                                            <input type="hidden" name="id" value="${p.id}"/>
                                            <button class="btn sub-qty" type="submit" title="Decrease quantity">-1</button>
                                        </form>
                                    </div>
                                    <a class="btn edit" href="/edit-product/${p.id}" title="Edit product">Edit</a>
                                    <form action="/products/delete" method="post" style="display:inline" onsubmit="return confirm('Delete ${p.name}?')">
                                        <input type="hidden" name="id" value="${p.id}" />
                                        <button class="btn delete" type="submit" title="Delete product">Delete</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </#list>
                </table>
            </section>
        </main>
    </div>

<script>
function toggleAddForm() {
    const form = document.getElementById('addProductFormSection');
    form.classList.toggle('show');
}

function filterProducts(){
    const q = document.getElementById('productSearch').value.trim().toLowerCase();
    const type = document.getElementById('filterType').value;
    const brand = document.getElementById('filterBrand').value;
    const branch = document.getElementById('filterBranch').value;
    const min = parseFloat(document.getElementById('filterMin').value || '0');
    const maxRaw = document.getElementById('filterMax').value;
    const max = maxRaw === '' ? Number.POSITIVE_INFINITY : parseFloat(maxRaw);
    const rows = document.querySelectorAll('#productsTable tr');
    rows.forEach((r, idx) => {
        if(idx===0) return;
        const text = r.textContent.trim().toLowerCase();
        const rtype = r.getAttribute('data-type') || '';
        const rbrand = r.getAttribute('data-brand') || '';
        const rbranch = r.getAttribute('data-branch') || '';
        const price = parseFloat(r.getAttribute('data-price') || '0');
        const passesText = q === '' || text.indexOf(q) !== -1;
        const passesType = !type || rtype === type;
        const passesBrand = !brand || rbrand === brand;
        const passesBranch = !branch || rbranch === branch;
        const passesPrice = (!isNaN(min) ? price >= min : true) && (isFinite(max) ? price <= max : true);
        r.style.display = (passesText && passesType && passesBrand && passesBranch && passesPrice) ? '' : 'none';
    });
}
</script>
</body>
</html>