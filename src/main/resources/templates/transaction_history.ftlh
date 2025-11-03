<#assign pageTitle = "Transaction History">
<#assign activePage = "history">
<#assign includeCharts = true>
<#include "base.ftlh">

<@page>
    <h2 class="mb-4"><i class="bi bi-clock-history me-2"></i>Transaction History</h2>

    <!-- Top Products Charts -->
    <div class="row g-4 mb-4">
        <div class="col-lg-6">
            <div class="card h-100">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-bar-chart me-2"></i>Top 5 Sold Products</h5>
                </div>
                <div class="card-body">
                    <div style="position: relative; height: 250px;">
                        <canvas id="chartSold"></canvas>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="card h-100">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-bar-chart-fill me-2"></i>Top 5 Ordered Products</h5>
                </div>
                <div class="card-body">
                    <div style="position: relative; height: 250px;">
                        <canvas id="chartOrdered"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Filters and Search -->
    <div class="card mb-4">
        <div class="card-body">
            <div class="row g-3">
                <div class="col-12">
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-search"></i></span>
                        <input id="historySearch" type="text" class="form-control" placeholder="Search by product, type, brand, branch or ref id..." oninput="filterHistory()">
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <select id="hFilterType" class="form-select" onchange="filterHistory()">
                        <option value="">All types</option>
                        <#list types as t><option value="${t}">${t}</option></#list>
                    </select>
                </div>
                <div class="col-md-6 col-lg-3">
                    <select id="hFilterBrand" class="form-select" onchange="filterHistory()">
                        <option value="">All brands</option>
                        <#list brands as b><option value="${b}">${b}</option></#list>
                    </select>
                </div>
                <div class="col-md-6 col-lg-3">
                    <select id="hFilterBranch" class="form-select" onchange="filterHistory()">
                        <option value="">All branches</option>
                        <#list branches as br><option value="${br}">${br}</option></#list>
                    </select>
                </div>
                <div class="col-6 col-md-3 col-lg-1">
                    <input id="hMin" type="number" class="form-control" placeholder="Min $" oninput="filterHistory()">
                </div>
                <div class="col-6 col-md-3 col-lg-2">
                    <input id="hMax" type="number" class="form-control" placeholder="Max $" oninput="filterHistory()">
                </div>
            </div>
        </div>
    </div>

    <!-- Transaction History Table -->
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0"><i class="bi bi-list-ul me-2"></i>All Transactions</h5>
        </div>
        <div class="card-body">
            <#if history?has_content>
                <div class="table-responsive">
                    <table class="table table-hover align-middle" id="historyTable">
                        <thead>
                            <tr>
                                <th style="width: 60px;">Id</th>
                                <th style="width: 100px;">Type</th>
                                <th style="width: 80px;">Ref Id</th>
                                <th>Product</th>
                                <th class="text-center" style="width: 80px;">Qty</th>
                                <th class="text-end" style="width: 100px;">Total</th>
                                <th style="width: 150px;">When</th>
                                <th>Note</th>
                            </tr>
                        </thead>
                        <tbody>
                            <#list history as h>
                                <tr data-type="${h.itemType?if_exists}" data-brand="${h.brand?if_exists}" data-branch="${h.branch?if_exists}" data-total="${h.totalPrice?if_exists}">
                                    <td><span class="badge bg-secondary">${h.id}</span></td>
                                    <td>
                                        <#if h.type == "SALE">
                                            <span class="badge bg-success"><i class="bi bi-cart-check me-1"></i>${h.type}</span>
                                        <#else>
                                            <span class="badge bg-primary"><i class="bi bi-truck me-1"></i>${h.type}</span>
                                        </#if>
                                    </td>
                                    <td><span class="badge bg-info">${h.referenceId}</span></td>
                                    <td>
                                        <#assign pname = "(product:" + h.productId + ")">
                                        <#list products as p>
                                            <#if p.id == h.productId>
                                                <#assign pname = p.name />
                                                <#break>
                                            </#if>
                                        </#list>
                                        <div class="fw-semibold">${pname}</div>
                                        <#if h.itemType??>
                                            <small class="text-muted">${h.itemType}</small>
                                        </#if>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-secondary">${h.quantity}</span>
                                    </td>
                                    <td class="text-end fw-semibold">
                                        <#if h.totalPrice??>${"$"}${h.totalPrice?string["0.00"]}<#else>-</#if>
                                    </td>
                                    <td><small>${h.timestampFormatted}</small></td>
                                    <td><small class="text-muted">${h.note}</small></td>
                                </tr>
                            </#list>
                        </tbody>
                    </table>
                </div>
            <#else>
                <div class="text-center py-5">
                    <i class="bi bi-inbox text-muted" style="font-size: 3rem;"></i>
                    <p class="text-muted mt-3">No transaction history yet.</p>
                </div>
            </#if>
        </div>
    </div>

<script>
function filterHistory(){
    const q = document.getElementById('historySearch').value.trim().toLowerCase();
    const type = document.getElementById('hFilterType').value;
    const brand = document.getElementById('hFilterBrand').value;
    const branch = document.getElementById('hFilterBranch').value;
    const min = parseFloat(document.getElementById('hMin').value || '0');
    const maxRaw = document.getElementById('hMax').value;
    const max = maxRaw === '' ? Number.POSITIVE_INFINITY : parseFloat(maxRaw);
    const rows = document.querySelectorAll('#historyTable tbody tr');
    
    rows.forEach((r) => {
        const text = r.textContent.trim().toLowerCase();
        const rtype = r.getAttribute('data-type') || '';
        const rbrand = r.getAttribute('data-brand') || '';
        const rbranch = r.getAttribute('data-branch') || '';
        const total = parseFloat(r.getAttribute('data-total') || '0');
        
        const passesText = q === '' || text.indexOf(q) !== -1;
        const passesType = !type || rtype === type;
        const passesBrand = !brand || rbrand === brand;
        const passesBranch = !branch || rbranch === branch;
        const passesPrice = (!isNaN(min) ? total >= min : true) && (isFinite(max) ? total <= max : true);
        
        r.style.display = (passesText && passesType && passesBrand && passesBranch && passesPrice) ? '' : 'none';
    });
}

// Chart rendering
function renderBarChart(canvasId, dataArr, color){
    if(!document.getElementById(canvasId)) return;
    const ctx = document.getElementById(canvasId).getContext('2d');
    const labels = dataArr.map(d => d.name);
    const values = dataArr.map(d => d.quantity);
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Quantity',
                data: values,
                backgroundColor: color,
                borderColor: color,
                borderWidth: 1,
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { 
                legend: { display: false },
                tooltip: {
                    backgroundColor: 'rgba(0,0,0,0.8)',
                    padding: 12,
                    titleFont: { size: 13, weight: 'bold' },
                    bodyFont: { size: 12 }
                }
            },
            scales: { 
                y: { 
                    beginAtZero: true,
                    grid: { color: '#f0f0f0', drawBorder: false },
                    ticks: { font: { size: 11 } }
                },
                x: {
                    grid: { display: false },
                    ticks: { font: { size: 11 } }
                }
            }
        }
    });
}

document.addEventListener('DOMContentLoaded', function(){
    const topSold = ${topSoldJson?no_esc};
    const topOrdered = ${topOrderedJson?no_esc};
    renderBarChart('chartSold', topSold, '#667eea');
    renderBarChart('chartOrdered', topOrdered, '#36a2eb');
});
</script>
</@page>
