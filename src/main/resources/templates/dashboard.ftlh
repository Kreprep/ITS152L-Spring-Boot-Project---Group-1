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
            <div class="card h-100">
                <div class="card-body text-center">
                    <h6 class="text-muted mb-2">Quick Actions</h6>
                    <div class="d-flex flex-column gap-2">
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