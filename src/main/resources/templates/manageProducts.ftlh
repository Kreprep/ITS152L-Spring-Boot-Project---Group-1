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
