<#assign pageTitle = "Add / Edit Product">
<#assign activePage = "products">
<#include "base.ftlh">

<@page>
    <div class="mb-4">
        <a href="/manage-products" class="btn btn-outline-secondary mb-3">
            <i class="bi bi-arrow-left me-1"></i> Back to Products
        </a>
        <h2><i class="bi bi-pencil-square me-2"></i>Add / Edit Product</h2>
    </div>

    <div class="row">
        <div class="col-lg-8 col-xl-6">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="bi bi-box-seam me-2"></i>
                        <#if product.id??>Edit Product<#else>Add New Product</#if>
                    </h5>
                </div>
                <div class="card-body">
                    <form action="/add-product" method="post">
                        <input type="hidden" name="id" value="${product.id?if_exists}"/>
                        
                        <div class="mb-3">
                            <label for="name" class="form-label">Product Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="name" name="name" value="${product.name?if_exists}" placeholder="Enter product name" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="3" placeholder="Product description">${product.description?if_exists}</textarea>
                        </div>
                        
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="quantity" class="form-label">Quantity</label>
                                <input type="number" class="form-control" id="quantity" name="quantity" value="${product.quantity?if_exists?c}" min="0" placeholder="0">
                            </div>
                            <div class="col-md-6">
                                <label for="price" class="form-label">Price ($)</label>
                                <input type="text" class="form-control" id="price" name="price" value="${product.price?if_exists}" placeholder="0.00">
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="itemType" class="form-label">Type / Category</label>
                            <input type="text" class="form-control" id="itemType" name="itemType" value="${product.itemType?if_exists}" placeholder="e.g., furniture, electronics">
                        </div>
                        
                        <div class="mb-3">
                            <label for="company" class="form-label">Brand / Company</label>
                            <input type="text" class="form-control" id="company" name="company" value="${product.company?if_exists}" placeholder="Brand or manufacturer name">
                        </div>
                        
                        <div class="mb-4">
                            <label for="branch" class="form-label">Branch</label>
                            <input type="text" class="form-control" id="branch" name="branch" value="${product.branch?if_exists}" placeholder="Branch location">
                        </div>
                        
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <a href="/manage-products" class="btn btn-secondary">
                                <i class="bi bi-x-circle me-1"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-success">
                                <i class="bi bi-check-circle me-1"></i> Save Product
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="col-lg-4 col-xl-6">
            <div class="card bg-light">
                <div class="card-body">
                    <h6 class="card-title"><i class="bi bi-info-circle me-2"></i>Tips</h6>
                    <ul class="small mb-0">
                        <li class="mb-2">Fields marked with <span class="text-danger">*</span> are required.</li>
                        <li class="mb-2">Enter price without currency symbol (e.g., 99.99).</li>
                        <li class="mb-2">Use descriptive names to easily identify products.</li>
                        <li class="mb-0">Keep quantity accurate for inventory tracking.</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</@page>
