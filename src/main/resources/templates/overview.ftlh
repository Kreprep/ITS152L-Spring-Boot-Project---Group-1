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
        .top-header{background:rebeccapurple;color:#fff;padding:18px 20px;font-size:26px;font-weight:800;text-transform:uppercase}
        .app{display:flex;min-height:calc(100vh - 68px)}
        .sidebar{width:220px;background:#000;color:#fff;padding:20px}
        .nav{margin-top:18px}
        .nav a{display:block;padding:10px 8px;color:#fff;text-decoration:none;border-radius:4px}
        .nav a:hover{background:#2a2a2a}
        .content{flex:1;padding:28px;max-width:1400px}
        .card{background:#fff;padding:20px;border-radius:6px;margin-bottom:20px;box-shadow:0 1px 3px rgba(0,0,0,0.08)}
        .card h3{margin-top:0;margin-bottom:16px;font-size:18px;font-weight:600;color:#333}
        .stats-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:20px;margin-bottom:20px}
        .stat-card{background:#fff;padding:20px;border-radius:6px;box-shadow:0 1px 3px rgba(0,0,0,0.08)}
        .stat-card .label{font-size:14px;color:#666;margin-bottom:8px}
        .stat-card .value{font-size:32px;font-weight:700;color:#333}
        .charts-grid{display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:20px}
        .chart-card{background:#fff;padding:20px;border-radius:6px;box-shadow:0 1px 3px rgba(0,0,0,0.08)}
        .chart-card h4{margin:0 0 16px 0;font-size:16px;font-weight:600;color:#333}
        .chart-container{position:relative;height:280px}
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
            <h2 style="margin-bottom:24px">Overview</h2>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="label">Average Sale Amount</div>
                    <div class="value">${avgSaleFormatted}</div>
                </div>
                <div class="stat-card">
                    <div class="label">Average Order Cost</div>
                    <div class="value">${avgOrderFormatted}</div>
                </div>
            </div>

            <!-- Sales vs Orders Line Chart -->
            <div class="card">
                <h3>Sales vs Orders (by day)</h3>
                <div class="chart-container">
                    <canvas id="overviewChart"></canvas>
                </div>
            </div>

            <!-- Top Products Pie Charts -->
            <div class="charts-grid">
                <div class="chart-card">
                    <h4>Most Sold Products (by quantity)</h4>
                    <div class="chart-container">
                        <canvas id="soldPie"></canvas>
                    </div>
                </div>
                <div class="chart-card">
                    <h4>Most Ordered Products (by quantity)</h4>
                    <div class="chart-container">
                        <canvas id="orderedPie"></canvas>
                    </div>
                </div>
            </div>
        </main>
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
                        borderWidth: 2,
                        tension: 0.3,
                        fill: true
                    },
                    { 
                        label: 'Orders', 
                        data: ordersData, 
                        borderColor: '#ff6384', 
                        backgroundColor: 'rgba(255,99,132,0.1)', 
                        borderWidth: 2,
                        tension: 0.3,
                        fill: true
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
                        labels: { padding: 15, font: { size: 12 } }
                    }
                },
                scales: { 
                    y: { 
                        beginAtZero: true,
                        grid: { color: '#f0f0f0' }
                    },
                    x: {
                        grid: { display: false }
                    }
                }
            }
        });

        // pie charts for top products
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
                    backgroundColor: ['#36a2eb','#ff6384','#ffcd56','#4bc0c0','#9966ff','#ff9f40']
                }]
            },
            options: { 
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: { padding: 12, font: { size: 11 } }
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
                    backgroundColor: ['#ff6384','#36a2eb','#ffcd56','#4bc0c0','#9966ff','#ff9f40']
                }]
            },
            options: { 
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: { padding: 12, font: { size: 11 } }
                    }
                }
            }
        });
    </script>
</body>
</html>
