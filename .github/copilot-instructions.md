# AI Coding Agent Instructions - locationAPI (Inventory Management System)

## Project Overview
A Spring Boot 3.5.6 inventory management system named "DELAWARE" that tracks products, sales, and purchase orders across multiple branches. Built with JPA/Hibernate, MySQL, and FreeMarker templates.

## Architecture & Data Flow

### Application Layers (MVC + REST)
The system has **two parallel controller architectures**:
- **MVC Controllers** (`@Controller`) → Return FreeMarker view names → Server-rendered HTML pages for browser UI
- **REST Controllers** (`@RestController`) → Return JSON → For AJAX calls or external integrations

Example: `ProductController` handles page requests like `/manage-products`, while `ProductRestController` at `/api/products` serves JSON.

### Database Schema (see `schema.sql`)
- **products** → **sale_transactions** (FK product_id)
- **products** → **purchase_orders** (FK product_id)  
- **transaction_history** (audit log, no FKs - stores denormalized data)

When creating sales/orders, services automatically record entries in `transaction_history` for auditing. History records are intentionally fail-safe (wrapped in try-catch) to never block core transactions.

### Service Layer Pattern
All services follow interface-based design (`I*Service` interfaces). Key business logic:

- **SaleService.createTransaction()**: Validates stock, decrements product quantity, calculates discounts, saves transaction, records to history
- **PurchaseOrderService.receiveOrder()**: Changes order status to RECEIVED, increments product quantity, records to history
- **ProductService.adjustQuantity()**: Thread-safe quantity updates, prevents negative stock

### Request Flow Patterns

**Server-rendered page flow**:
1. Browser requests URL (e.g., `GET /manage-products`)
2. Controller method prepares Model and returns view name (`"manageProducts"`)
3. Spring MVC + FreeMarker renders `manageProducts.ftlh` with model attributes
4. Form submissions (`POST /add-product`) → Controller → Service → Repository → DB

**REST API flow**:
1. Client sends JSON request (e.g., `POST /api/products`)
2. `@RestController` method processes and returns JSON response
3. Example: `ProductRestController` handles CRUD at `/api/products/*`

**Business logic flow (Sale transaction example)**:
1. `ProductController.createSale` receives `POST /sales/create`
2. Calls `SaleService.createTransaction()` which:
   - Validates product stock
   - Calculates discounts and totals
   - Decrements quantity via `ProductService.adjustQuantity()`
   - Saves `SaleTransaction` entity
   - Records to `transaction_history` (fail-safe, never blocks main transaction)

### Controller Architecture
- **MVC Controllers** (`@Controller`): `ProductController`, `OrderController`, `DashboardController`, `TransactionHistoryController`, `OverviewController`
- **REST Controllers** (`@RestController`): `ProductRestController` (`/api/products/*`), `DbHealthController` (`/health/db`)
- **GlobalModelAttributes** (`@ControllerAdvice`): Intentionally returns empty strings for DB credentials to hide from templates

## Key Conventions

### Entity & Model Patterns
- All entities use `@GeneratedValue(strategy = GenerationType.IDENTITY)` for auto-increment IDs
- BigDecimal for all monetary values (price, discount, discountedPrice, totalPrice)
- Branch/company/itemType fields are nullable strings, inherited from product when creating transactions
- PurchaseOrder uses enum `Status { PENDING, RECEIVED }`

### Template Integration
FreeMarker templates in `src/main/resources/templates/` (`.ftlh` files). Controllers populate DTOs with formatted dates (`yyyy-MM-dd HH:mm`) and price strings:
```java
List<Map<String,Object>> dto = items.stream().map(item -> {
    Map<String,Object> m = new HashMap<>();
    m.put("timestampFormatted", item.getTimestamp().format(fmt));
    m.put("priceFormatted", "$" + item.getPrice().setScale(2, HALF_UP));
    return m;
}).collect(Collectors.toList());
```

**Key templates**: `manageProducts.ftlh`, `addProduct.ftlh`, `sales.ftlh`, `orders.ftlh`, `transaction_history.ftlh`, `overview.ftlh`, `dashboard.ftlh`, `showProducts.ftlh`

Template changes require server restart to take effect (loaded from classpath).

### SQL Initialization
`spring.sql.init.mode=always` in `application.properties` means `schema.sql` runs on startup with DROP TABLE statements. **Do not rely on persistent data in local dev** - `data.sql` seeds initial products.

## Development Workflows

### Build & Run
```powershell
# Package application (skip tests for faster builds)
mvn -DskipTests package

# Run application - server runs continuously in terminal (port 18080)
mvn spring-boot:run

# Access at http://localhost:18080 in browser
# Server must stay running in terminal - press Ctrl+C to stop
```

**Note**: The application runs as a blocking process. Keep the terminal open while developing/testing. When you make changes, restart the server to see updates.

### Database Setup
MySQL required at `localhost:3306/Products_IMS`. Connection configured in `application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/Products_IMS?useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=7)qHeEU=/@
```

### Testing
Use Maven test lifecycle:
```powershell
.\mvnw.cmd test
```
Tests in `src/test/java/com/grp1/locationAPI/LocationApiApplicationTests.java`.

## Adding New Features

### New Entity/Table
1. Add CREATE TABLE in `schema.sql` (include DROP TABLE at top)
2. Create entity class in `model/` with `@Entity`, `@Table(name="...")`
3. Create repository interface extending `CrudRepository<Entity, Long>`
4. Create service interface + implementation following `I*Service` pattern
5. Wire with `@Autowired` in controllers

### New MVC Endpoint
Add to appropriate controller with model population pattern:
```java
@GetMapping("/new-page")
public String newPage(Model model) {
    model.addAttribute("items", service.findAll());
    // Add filters if needed
    return "templateName"; // matches src/main/resources/templates/templateName.ftlh
}
```

### New REST API Endpoint
Add to `ProductRestController` or create new `@RestController`:
```java
@GetMapping("/api/products/filter")
public List<Product> filterProducts(@RequestParam String itemType) {
    return productService.findAll().stream()
        .filter(p -> itemType.equals(p.getItemType()))
        .collect(Collectors.toList());
}
```

## Important Gotchas

1. **Server runs continuously**: `mvn spring-boot:run` blocks terminal - keep it running, use Ctrl+C to stop
2. **Template changes need restart**: FreeMarker templates loaded from classpath - restart server after editing `.ftlh` files
3. **Quantity cannot go negative**: `ProductService.adjustQuantity()` enforces `newQty >= 0`
4. **Sale transactions check stock**: `SaleService` throws exception if `quantity > product.quantity`
5. **History logging never fails operations**: All `historyService` calls wrapped in try-catch
6. **Schema resets on startup**: Development mode drops/recreates tables - back up data before restart
7. **Branch inheritance**: Sales/orders inherit branch from product unless explicitly overridden
8. **Date formatting**: Controllers format LocalDateTime for templates - raw entities have LocalDateTime objects
9. **Form 404 errors**: Check template form `action` path matches controller `@PostMapping` (common in `manageProducts.ftlh` vs `ProductController`)

## File Organization
```
controller/    - Web & REST controllers
  ProductController.java       - MVC endpoints for product pages
  ProductRestController.java   - REST API at /api/products
  OrderController.java         - Purchase order pages
  DashboardController.java     - Main dashboard (/ and /dashboard)
  TransactionHistoryController.java - Audit log view
  DbHealthController.java      - Health check JSON endpoint
model/         - JPA entities (Product, SaleTransaction, PurchaseOrder, TransactionHistory)
repository/    - Spring Data interfaces (extends CrudRepository)
service/       - Business logic (interface + implementation pairs)
  I*Service.java    - Interface definitions
  *Service.java     - Implementations with @Service
templates/     - FreeMarker .ftlh views (server-rendered HTML)
schema.sql     - DDL (runs on startup, drops/creates tables)
data.sql       - Initial seed data (6 sample products)
```

## Quick Reference: Key Files to Open
- **Entry point**: `LocationApiApplication.java`
- **Main MVC controller**: `ProductController.java`
- **Main REST API**: `ProductRestController.java`
- **Core business logic**: `SaleService.java`, `PurchaseOrderService.java`
- **Main templates**: `manageProducts.ftlh`, `sales.ftlh`, `transaction_history.ftlh`
- **DB setup**: `schema.sql`, `data.sql`
- **Config**: `application.properties`
