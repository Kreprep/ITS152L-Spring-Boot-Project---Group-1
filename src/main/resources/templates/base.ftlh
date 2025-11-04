<#macro page>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><#if pageTitle??>${pageTitle}<#else>DELAWARE</#if> - Inventory Management</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- Chart.js -->
    <#if includeCharts??>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.js"></script>
    </#if>
    
    <style>
        :root {
            --primary-color: #663399;
            --primary-dark: #552288;
            --sidebar-bg: #212529;
            --sidebar-hover: #2c3136;
        }
        
        body {
            font-family: 'Segoe UI', Roboto, -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        
        /* Top Header */
        .top-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 1rem 1.5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .brand-name {
            font-size: 1.75rem;
            font-weight: 800;
            letter-spacing: 0.5px;
            margin: 0;
        }
        
        /* Sidebar */
        .sidebar {
            background-color: var(--sidebar-bg);
            min-height: calc(100vh - 68px);
            padding: 1.5rem 0;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
        }
        
        .sidebar .nav-link {
            color: #adb5bd;
            padding: 0.75rem 1.5rem;
            border-left: 3px solid transparent;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .sidebar .nav-link:hover {
            background-color: var(--sidebar-hover);
            color: white;
            border-left-color: var(--primary-color);
        }
        
        .sidebar .nav-link.active {
            background-color: var(--sidebar-hover);
            color: white;
            border-left-color: var(--primary-color);
            font-weight: 600;
        }
        
        .sidebar .nav-link i {
            font-size: 1.1rem;
            width: 20px;
        }
        
        /* Main Content */
        .main-content {
            padding: 2rem;
            min-height: calc(100vh - 68px);
        }
        
        /* Cards */
        .card {
            border: none;
            border-radius: 0.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
            margin-bottom: 1.5rem;
            transition: box-shadow 0.3s ease;
        }
        
        .card:hover {
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.15);
        }
        
        .card-header {
            background-color: white;
            border-bottom: 2px solid #f8f9fa;
            font-weight: 600;
            padding: 1rem 1.25rem;
        }
        
        /* Stat Cards */
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 0.5rem;
            padding: 1.5rem;
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
            margin-bottom: 0.5rem;
        }
        
        .stat-card .stat-value {
            font-size: 2.5rem;
            font-weight: 700;
        }

        .quick-actions-card .card-body {
            padding: 1rem 1.25rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            gap: 0.75rem;
        }

        .quick-actions-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 0.5rem;
        }

        .quick-actions-card .btn {
            font-weight: 600;
            padding: 0.5rem 0.75rem;
        }

        @media (max-width: 991.98px) {
            .quick-actions-grid {
                grid-template-columns: 1fr;
            }
        }
        
        /* Tables */
        .table {
            background-color: white;
        }
        
        .table thead {
            background-color: #f8f9fa;
        }
        
        .table thead th {
            border-bottom: 2px solid #dee2e6;
            font-weight: 600;
            color: #495057;
            padding: 0.75rem;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .table tbody td {
            padding: 0.75rem;
            vertical-align: middle;
        }
        
        .table-hover tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        /* Buttons */
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
        }
        
        /* Forms */
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(102, 51, 153, 0.25);
        }
        
        /* Badges */
        .badge {
            padding: 0.35rem 0.65rem;
            font-weight: 600;
        }
        
        /* Alerts */
        .alert {
            border-left: 4px solid;
            border-radius: 0.375rem;
        }
        
        /* Mobile Responsive */
        @media (max-width: 768px) {
            .sidebar {
                min-height: auto;
            }
            
            .main-content {
                padding: 1rem;
            }
            
            .brand-name {
                font-size: 1.25rem;
            }
            
            .table {
                font-size: 0.875rem;
            }
            
            .btn {
                font-size: 0.875rem;
            }
        }
        
        /* Custom Scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }
        
        ::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        
        ::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 4px;
        }
        
        ::-webkit-scrollbar-thumb:hover {
            background: #555;
        }
        
        /* Mobile Offcanvas (improve button/tap targets) */
        .offcanvas .nav-link {
            padding: 0.9rem 1.25rem;
            font-size: 1.05rem; /* slightly larger for readability */
            height: 3.125rem; /* ~50px tap target */
            display: flex;
            align-items: center;
            gap: 0.75rem;
            width: 100%;
            border-left: none !important; /* remove desktop left bar for mobile drawer */
            color: #adb5bd;
            transition: background-color 0.15s ease, color 0.15s ease;
        }

        .offcanvas .nav-link i {
            font-size: 1.25rem;
            width: 28px;
            flex: 0 0 28px;
            text-align: center;
        }

        .offcanvas .nav-link span {
            display: block;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .offcanvas .nav-link:hover, .offcanvas .nav-link:focus {
            background-color: var(--sidebar-hover);
            color: white;
        }

        .offcanvas .offcanvas-body {
            padding-top: 0;
        }

        /* Improve actions/buttons in tables on small screens */
        @media (max-width: 576px) {
            /* Make the action buttons larger and easier to tap */
            .table tbody td .btn-group {
                display: flex;
                flex-direction: column; /* stack buttons vertically */
                align-items: flex-end; /* keep them on the right */
                gap: 0.4rem;
            }

            .table tbody td .btn-group .btn {
                min-width: 44px; /* ensure comfortable tap target */
                height: 44px;
                padding: 0;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border-radius: 0.5rem;
                font-size: 1.05rem;
            }

            /* If you prefer full-width actions, uncomment this block
            .table tbody td .btn-group .btn {
                width: 100%;
            }
            */

            /* Reduce horizontal padding so table fits better */
            .table thead th, .table tbody td {
                padding: 0.6rem;
            }

            /* Keep badges and IDs compact */
            .table td .badge {
                font-size: 0.85rem;
                padding: 0.35rem 0.55rem;
            }
        }

        <#if additionalStyles??>
        ${additionalStyles}
        </#if>
    </style>
</head>
<body>
    <!-- Top Header -->
    <header class="top-header">
        <div class="d-flex align-items-center justify-content-between gap-3">
            <h1 class="brand-name mb-0">DELAWARE</h1>
            <div class="d-flex align-items-center gap-3">
                <#if currentUserName??>
                    <div class="text-end d-none d-sm-block">
                        <div class="fw-semibold">${currentUserName}</div>
                        <small class="text-white-50">${(currentUserRole!"")?lower_case?cap_first}</small>
                    </div>
                    <a href="/logout" class="btn btn-outline-light btn-sm d-none d-md-inline-flex align-items-center gap-1">
                        <i class="bi bi-box-arrow-right"></i>
                        Logout
                    </a>
                </#if>
                <button class="btn btn-link text-white d-md-none" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarOffcanvas">
                    <i class="bi bi-list fs-3"></i>
                </button>
            </div>
        </div>
    </header>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar for Desktop -->
            <nav class="col-md-3 col-lg-2 d-none d-md-block sidebar px-0">
                <div class="position-sticky">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link <#if activePage?? && activePage == 'dashboard'>active</#if>" href="/dashboard">
                                <i class="bi bi-speedometer2"></i>
                                <span>Dashboard</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <#if activePage?? && activePage == 'overview'>active</#if>" href="/overview">
                                <i class="bi bi-graph-up"></i>
                                <span>Overview</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <#if activePage?? && activePage == 'products'>active</#if>" href="/manage-products">
                                <i class="bi bi-box-seam"></i>
                                <span>Manage Products</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <#if activePage?? && activePage == 'sales'>active</#if>" href="/sales">
                                <i class="bi bi-cart-check"></i>
                                <span>Sales</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <#if activePage?? && activePage == 'orders'>active</#if>" href="/orders">
                                <i class="bi bi-truck"></i>
                                <span>Orders</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <#if activePage?? && activePage == 'history'>active</#if>" href="/transaction-history">
                                <i class="bi bi-clock-history"></i>
                                <span>Transaction History</span>
                            </a>
                        </li>
                        <#if currentUserName??>
                        <li class="nav-item mt-4">
                            <a class="nav-link" href="/logout">
                                <i class="bi bi-box-arrow-right"></i>
                                <span>Logout</span>
                            </a>
                        </li>
                        </#if>
                    </ul>
                </div>
            </nav>

            <!-- Sidebar Offcanvas for Mobile -->
            <!-- Changed to offcanvas-end so the mobile drawer opens from the right (matches hamburger button on the right) -->
            <div class="offcanvas offcanvas-end bg-dark" tabindex="-1" id="sidebarOffcanvas" aria-labelledby="sidebarOffcanvasLabel">
                <div class="offcanvas-header">
                    <h5 class="offcanvas-title text-white" id="sidebarOffcanvasLabel">Menu</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Close"></button>
                </div>
                <div class="offcanvas-body px-0">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link <#if activePage?? && activePage == 'dashboard'>active</#if>" href="/dashboard">
                                <i class="bi bi-speedometer2"></i>
                                <span>Dashboard</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <#if activePage?? && activePage == 'overview'>active</#if>" href="/overview">
                                <i class="bi bi-graph-up"></i>
                                <span>Overview</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <#if activePage?? && activePage == 'products'>active</#if>" href="/manage-products">
                                <i class="bi bi-box-seam"></i>
                                <span>Manage Products</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <#if activePage?? && activePage == 'sales'>active</#if>" href="/sales">
                                <i class="bi bi-cart-check"></i>
                                <span>Sales</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <#if activePage?? && activePage == 'orders'>active</#if>" href="/orders">
                                <i class="bi bi-truck"></i>
                                <span>Orders</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <#if activePage?? && activePage == 'history'>active</#if>" href="/transaction-history">
                                <i class="bi bi-clock-history"></i>
                                <span>Transaction History</span>
                            </a>
                        </li>
                        <#if currentUserName??>
                        <li class="nav-item mt-4">
                            <a class="nav-link" href="/logout">
                                <i class="bi bi-box-arrow-right"></i>
                                <span>Logout</span>
                            </a>
                        </li>
                        </#if>
                    </ul>
                </div>
            </div>

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 main-content">
                <#nested>
            </main>
        </div>
    </div>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <#if additionalScripts??>
    ${additionalScripts}
    </#if>
</body>
</html>
</#macro>
