<#assign pageTitle = "Overview">
<#assign activePage = "overview">
<#assign includeCharts = true>
<#include "base.ftlh">

<@page>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0"><i class="bi bi-graph-up me-2"></i>Overview</h2>
    </div>

    <!-- Statistics Cards -->
    <div class="row g-4 mb-4">
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h6 class="text-muted text-uppercase mb-2" style="font-size: 0.875rem; letter-spacing: 0.5px;">
                        <i class="bi bi-currency-dollar me-1"></i>Average Sale Amount
                    </h6>
                    <h2 class="mb-0 fw-bold text-success">${avgSaleFormatted}</h2>
                    <small class="text-muted">Per transaction</small>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h6 class="text-muted text-uppercase mb-2" style="font-size: 0.875rem; letter-spacing: 0.5px;">
                        <i class="bi bi-cart me-1"></i>Average Order Cost
                    </h6>
                    <h2 class="mb-0 fw-bold text-primary">${avgOrderFormatted}</h2>
                    <small class="text-muted">Per order</small>
                </div>
            </div>
        </div>
    </div>

    <!-- Sales vs Orders Line Chart -->
    <div class="card mb-4">
        <div class="card-header">
            <h5 class="mb-0"><i class="bi bi-graph-up-arrow me-2"></i>Sales vs Orders (by day)</h5>
        </div>
        <div class="card-body">
            <div style="position: relative; height: 350px;">
                <canvas id="overviewChart"></canvas>
            </div>
        </div>
    </div>

    <!-- Top Products Pie Charts -->
    <div class="row g-4">
        <div class="col-lg-6">
            <div class="card h-100">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-pie-chart me-2"></i>Most Sold Products (by quantity)</h5>
                </div>
                <div class="card-body">
                    <div style="position: relative; height: 300px;">
                        <canvas id="soldPie"></canvas>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="card h-100">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-pie-chart-fill me-2"></i>Most Ordered Products (by quantity)</h5>
                </div>
                <div class="card-body">
                    <div style="position: relative; height: 300px;">
                        <canvas id="orderedPie"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

<script>
    const labels = [<#list labels as l>'${l}'<#if l_has_next>,</#if></#list>];
    const salesData = [<#list salesData as v>${v}<#if v_has_next>,</#if></#list>];
    const ordersData = [<#list ordersData as v>${v}<#if v_has_next>,</#if></#list>];

    const ctx = document.getElementById('overviewChart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [
                { 
                    label: 'Sales', 
                    data: salesData, 
                    borderColor: '#36a2eb', 
                    backgroundColor: 'rgba(54,162,235,0.1)', 
                    borderWidth: 3,
                    tension: 0.4,
                    fill: true,
                    pointRadius: 4,
                    pointHoverRadius: 6
                },
                { 
                    label: 'Orders', 
                    data: ordersData, 
                    borderColor: '#ff6384', 
                    backgroundColor: 'rgba(255,99,132,0.1)', 
                    borderWidth: 3,
                    tension: 0.4,
                    fill: true,
                    pointRadius: 4,
                    pointHoverRadius: 6
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: true,
                    position: 'top',
                    labels: { 
                        padding: 20, 
                        font: { size: 13, weight: '600' },
                        usePointStyle: true
                    }
                },
                tooltip: {
                    mode: 'index',
                    intersect: false,
                    backgroundColor: 'rgba(0,0,0,0.8)',
                    padding: 12,
                    titleFont: { size: 14, weight: 'bold' },
                    bodyFont: { size: 13 }
                }
            },
            scales: { 
                y: { 
                    beginAtZero: true,
                    grid: { 
                        color: '#f0f0f0',
                        drawBorder: false
                    },
                    ticks: {
                        font: { size: 12 }
                    }
                },
                x: {
                    grid: { display: false },
                    ticks: {
                        font: { size: 12 }
                    }
                }
            },
            interaction: {
                mode: 'nearest',
                axis: 'x',
                intersect: false
            }
        }
    });

    // Pie charts for top products
    const soldLabels = [<#list topSoldLabels as l>'${l}'<#if l_has_next>,</#if></#list>];
    const soldCounts = [<#list topSoldCounts as v>${v}<#if v_has_next>,</#if></#list>];
    const orderedLabels = [<#list topOrderedLabels as l>'${l}'<#if l_has_next>,</#if></#list>];
    const orderedCounts = [<#list topOrderedCounts as v>${v}<#if v_has_next>,</#if></#list>];

    const soldCtx = document.getElementById('soldPie').getContext('2d');
    new Chart(soldCtx, {
        type: 'pie',
        data: {
            labels: soldLabels,
            datasets: [{ 
                data: soldCounts, 
                backgroundColor: [
                    '#667eea',
                    '#764ba2',
                    '#f093fb',
                    '#4facfe',
                    '#43e97b',
                    '#fa709a'
                ],
                borderWidth: 2,
                borderColor: '#fff'
            }]
        },
        options: { 
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { 
                        padding: 15, 
                        font: { size: 12 },
                        usePointStyle: true
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0,0,0,0.8)',
                    padding: 12,
                    titleFont: { size: 13, weight: 'bold' },
                    bodyFont: { size: 12 }
                }
            }
        }
    });

    const orderedCtx = document.getElementById('orderedPie').getContext('2d');
    new Chart(orderedCtx, {
        type: 'pie',
        data: {
            labels: orderedLabels,
            datasets: [{ 
                data: orderedCounts, 
                backgroundColor: [
                    '#fa709a',
                    '#fee140',
                    '#30cfd0',
                    '#a8edea',
                    '#ff6b6b',
                    '#4ecdc4'
                ],
                borderWidth: 2,
                borderColor: '#fff'
            }]
        },
        options: { 
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { 
                        padding: 15, 
                        font: { size: 12 },
                        usePointStyle: true
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0,0,0,0.8)',
                    padding: 12,
                    titleFont: { size: 13, weight: 'bold' },
                    bodyFont: { size: 12 }
                }
            }
        }
    });
</script>
</@page>
