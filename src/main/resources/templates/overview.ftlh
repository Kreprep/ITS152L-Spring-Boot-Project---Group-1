<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Overview</title>
    <style>
        body{font-family:Segoe UI, Roboto, Arial;margin:0;background:#f4f6f8}
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
