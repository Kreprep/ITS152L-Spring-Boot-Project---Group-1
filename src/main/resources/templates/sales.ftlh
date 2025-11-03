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
