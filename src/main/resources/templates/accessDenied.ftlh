<#assign activePage = "">
<#include "base.ftlh">

<@page>
    <div class="d-flex flex-column align-items-center justify-content-center" style="min-height: 60vh;">
        <div class="text-center">
            <div class="mb-3 text-warning"><i class="bi bi-shield-lock" style="font-size: 3rem;"></i></div>
            <h2 class="mb-3">Access Restricted</h2>
            <p class="text-muted mb-4">You do not have permission to view this section. Please contact an administrator if you believe this is a mistake.</p>
            <a href="/dashboard" class="btn btn-primary">
                <i class="bi bi-arrow-left me-1"></i> Return to Dashboard
            </a>
        </div>
    </div>
</@page>
