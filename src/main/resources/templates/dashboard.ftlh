<#assign pageTitle = "Dashboard">
<#assign activePage = "dashboard">
<#include "base.ftlh">

<@page>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0"><i class="bi bi-speedometer2 me-2"></i>Dashboard</h2>
    </div>

    <!-- Statistics Cards -->
    <div class="row g-4 mb-4">
        <div class="col-md-6 col-lg-4">
            <div class="stat-card">
                <div class="stat-label">
                    <i class="bi bi-box-seam me-2"></i>Total Products
                </div>
                <div class="stat-value">${productCount?c}</div>
            </div>
        </div>
        <div class="col-md-6 col-lg-4">
            <div class="stat-card">
                <div class="stat-label">
                    <i class="bi bi-globe me-2"></i>Countries
                </div>
                <div class="stat-value">${countryCount?c}</div>
            </div>
        </div>
        <div class="col-md-12 col-lg-4">
            <div class="card quick-actions-card h-100">
                <div class="card-body">
                    <div class="d-flex align-items-center justify-content-between">
                        <h6 class="text-muted mb-0">Quick Actions</h6>
                        <i class="bi bi-lightning-charge text-primary"></i>
                    </div>
                    <div class="quick-actions-grid">
                        <a href="/manage-products" class="btn btn-primary btn-sm">
                            <i class="bi bi-plus-circle me-1"></i> Add Product
                        </a>
                        <a href="/sales" class="btn btn-outline-primary btn-sm">
                            <i class="bi bi-cart-check me-1"></i> Create Sale
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Inventory Alerts -->
    <div class="row g-4 mb-4">
        <div class="col-12">
            <div class="card border-warning">
                <div class="card-header bg-warning-subtle text-warning d-flex justify-content-between align-items-center">
                    <div>
                        <i class="bi bi-exclamation-triangle me-2"></i>Inventory Alerts
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge bg-danger-subtle text-danger">
                            <i class="bi bi-slash-circle me-1"></i>${(outOfStockCount!0)?c} out of stock
                        </span>
                        <span class="badge bg-warning text-dark">
                            <i class="bi bi-exclamation-circle me-1"></i>${(lowStockCount!0)?c} low stock
                        </span>
                    </div>
                </div>
                <div class="card-body">
                    <p class="text-muted small mb-3">Monitoring products at or below the ${(lowStockThreshold!0)} unit threshold.</p>
                    <#if lowStockPreview?? && lowStockPreview?has_content>
                        <div class="list-group list-group-flush">
                            <#list lowStockPreview as p>
                                <div class="list-group-item d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="fw-semibold">${p.name}</div>
                                        <small class="text-muted">
                                            <#if p.branch?? && p.branch?has_content>${p.branch}</#if>
                                            <#if p.itemType?? && p.itemType?has_content>
                                                <#if p.branch?? && p.branch?has_content> • </#if>${p.itemType}
                                            </#if>
                                        </small>
                                    </div>
                                    <span class="badge <#if (p.quantity?default(0) == 0)>bg-danger<#else>bg-warning text-dark</#if>">
                                        ${p.quantity?default(0)} units
                                    </span>
                                </div>
                            </#list>
                        </div>
                        <#if (lowStockExtraCount!0) gt 0>
                            <div class="text-muted small mt-3">
                                +${(lowStockExtraCount!0)} more items below threshold
                            </div>
                        </#if>
                    <#else>
                        <div class="alert alert-success mb-0">
                            <i class="bi bi-check-circle me-2"></i>All products are above the alert threshold.
                        </div>
                    </#if>
                    <div class="text-end mt-3">
                        <a href="/manage-products" class="btn btn-outline-warning btn-sm">
                            Manage inventory
                            <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Products Table -->
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0"><i class="bi bi-clock-history me-2"></i>Recent Products</h5>
        </div>
        <div class="card-body">
            <#if recentProducts?has_content>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th class="text-center">Quantity</th>
                                <th class="text-end">Price</th>
                                <th class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <#list recentProducts as p>
                                <tr>
                                    <td>
                                        <div class="fw-semibold">${p.name}</div>
                                        <#if p.itemType??>
                                            <small class="text-muted">${p.itemType}</small>
                                        </#if>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-info">${p.quantity}</span>
                                    </td>
                                    <td class="text-end fw-semibold">
                                        <#if p.price??>${"$"}${p.price?string["0.00"]}<#else>-</#if>
                                    </td>
                                    <td class="text-center">
                                        <a href="/edit-product/${p.id}" class="btn btn-sm btn-outline-primary" title="Edit">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                    </td>
                                </tr>
                            </#list>
                        </tbody>
                    </table>
                </div>
                <div class="text-center mt-3">
                    <a href="/manage-products" class="btn btn-outline-primary">
                        View All Products <i class="bi bi-arrow-right ms-1"></i>
                    </a>
                </div>
            <#else>
                <div class="text-center py-5">
                    <i class="bi bi-inbox text-muted" style="font-size: 3rem;"></i>
                    <p class="text-muted mt-3">No products yet.</p>
                    <a href="/manage-products" class="btn btn-primary">
                        <i class="bi bi-plus-circle me-1"></i> Add Your First Product
                    </a>
                </div>
            </#if>
        </div>
    </div>
</@page>