<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Transaction History</title>
    <style>
        body{font-family:Segoe UI, Roboto, Arial;margin:0;background:#f4f6f8}
        .top-header{background:rebeccapurple;color:#fff;padding:18px 20px;font-size:26px;font-weight:800;text-transform:uppercase}
        .app{display:flex;min-height:calc(100vh - 68px)}
        .sidebar{width:220px;background:#000;color:#fff;padding:20px}
        .nav{margin-top:18px}
        .nav a{display:block;padding:10px 8px;color:#fff;text-decoration:none;border-radius:4px}
        .nav a:hover{background:#2a2a2a}
        .content{flex:1;padding:28px;max-width:1200px}
    .panel{background:#fff;padding:12px;border-radius:6px;margin-bottom:12px}
    /* Ensure chart canvases have a fixed height to avoid layout jank */
    .panel canvas{height:200px !important; max-height:280px; width:100% !important;}
        .form-row{display:flex;gap:8px;align-items:center;flex-wrap:wrap}
        select,input[type=number],input[type=text]{padding:8px;border:1px solid #ddd;border-radius:4px}
        table{width:100%;border-collapse:collapse;background:#fff;margin-top:12px}
        td,th{padding:8px;border-bottom:1px solid #eee}
        .col-qty{width:80px;text-align:center}
        .col-price{width:120px;text-align:right}
        .btn{padding:8px 12px;border-radius:4px;border:none;cursor:pointer;background:#1565c0;color:#fff;font-weight:700}
    </style>
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
            <h2>Transaction History</h2>

            <div style="margin-bottom:16px">
                <div style="display:flex;gap:20px;align-items:stretch;margin-bottom:12px;flex-wrap:wrap">
                    <div class="panel" style="flex:1;min-width:320px">
                        <h3 style="margin-top:0;margin-bottom:8px;font-size:16px">Top 5 Sold Products</h3>
                        <canvas id="chartSold" style="height:200px;"></canvas>
                    </div>
                    <div class="panel" style="flex:1;min-width:320px">
                        <h3 style="margin-top:0;margin-bottom:8px;font-size:16px">Top 5 Ordered Products</h3>
                        <canvas id="chartOrdered" style="height:200px;"></canvas>
                    </div>
                </div>

                <div style="display:flex;gap:8px;margin-bottom:10px;align-items:center;flex-wrap:wrap">
                    <input id="historySearch" type="text" placeholder="Search by product, type, brand, branch or ref id..." style="width:360px;padding:8px;border:1px solid #ddd;border-radius:4px" oninput="filterHistory()" />
                    <select id="hFilterType" onchange="filterHistory()">
                        <option value="">All types</option>
                        <#list types as t><option value="${t}">${t}</option></#list>
                    </select>
                    <select id="hFilterBrand" onchange="filterHistory()">
                        <option value="">All brands</option>
                        <#list brands as b><option value="${b}">${b}</option></#list>
                    </select>
                    <select id="hFilterBranch" onchange="filterHistory()">
                        <option value="">All branches</option>
                        <#list branches as br><option value="${br}">${br}</option></#list>
                    </select>
                    <input id="hMin" type="number" placeholder="Min total" style="width:100px" oninput="filterHistory()"/>
                    <input id="hMax" type="number" placeholder="Max total" style="width:100px" oninput="filterHistory()"/>
                </div>
            </div>

            <section class="panel">
                <#if history?has_content>
                    <table id="historyTable">
                        <tr><th>Id</th><th>Type</th><th>Ref Id</th><th>Product</th><th>Qty</th><th>Total</th><th>When</th><th>Note</th></tr>
                        <#list history as h>
                            <tr data-type="${h.itemType?if_exists}" data-brand="${h.brand?if_exists}" data-branch="${h.branch?if_exists}" data-total="${h.totalPrice?if_exists}">
                                <td>${h.id}</td>
                                <td class="cell-action">${h.type}</td>
                                <td class="cell-ref">${h.referenceId}</td>
                                <td class="cell-product">
                                    <#assign pname = "(product:" + h.productId + ")">
                                    <#list products as p>
                                        <#if p.id == h.productId>
                                            <#assign pname = p.name />
                                            <#break>
                                        </#if>
                                    </#list>
                                    ${pname}
                                </td>
                                <td class="col-qty">${h.quantity}</td>
                                <td class="col-price">
                                    <#if h.totalPrice??>${"$"}${h.totalPrice?string["0.00"]}<#else>-</#if>
                                </td>
                                <td>${h.timestampFormatted}</td>
                                <td>${h.note}</td>
                            </tr>
                        </#list>
                    </table>
                <#else>
                    <div>No history yet.</div>
                </#if>
            </section>
        </main>
    </div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
function filterHistory(){
    const q = document.getElementById('historySearch').value.trim().toLowerCase();
    const type = document.getElementById('hFilterType').value;
    const brand = document.getElementById('hFilterBrand').value;
    const branch = document.getElementById('hFilterBranch').value;
    const min = parseFloat(document.getElementById('hMin').value || '0');
    const maxRaw = document.getElementById('hMax').value;
    const max = maxRaw === '' ? Number.POSITIVE_INFINITY : parseFloat(maxRaw);
    const rows = document.querySelectorAll('#historyTable tr');
    rows.forEach((r, idx) => {
        if(idx===0) return;
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
                backgroundColor: labels.map(()=>color),
                borderColor: labels.map(()=>color),
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            scales: { y: { beginAtZero:true } },
            plugins: { legend: { display: false } }
        }
    });
}

document.addEventListener('DOMContentLoaded', function(){
    // top data injected by controller as JSON strings
    const topSold = ${topSoldJson?no_esc};
    const topOrdered = ${topOrderedJson?no_esc};
    renderBarChart('chartSold', topSold, 'rgba(102,51,153,0.8)');
    renderBarChart('chartOrdered', topOrdered, 'rgba(54,162,235,0.8)');
});
</script>
</body>
</html>