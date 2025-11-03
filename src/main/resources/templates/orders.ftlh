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