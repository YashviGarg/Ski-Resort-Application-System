# Skier Analytics API System

This Java application provides a suite of RESTful APIs for tracking and analyzing skier activities across multiple resorts. It consists of three core modules that handle different aspects of skier data, utilizing AWS DynamoDB for persistent storage and Java-based Redis client for caching to optimize performance.

## Features

- **High-Performance REST APIs**: Three specialized endpoints optimized for different skier analytics queries.
- **Multi-tiered Architecture**: Separation of concerns with distinct API, service, and data access layers.
- **Caching Implementation**: Redis-based caching to minimize database load and improve response times.
- **Cloud-based Storage**: AWS DynamoDB integration with optimized query patterns using secondary indexes.
- **Concurrent Request Handling**: Thread pooling for efficient processing of multiple simultaneous requests.
- **Standardized Response Formatting**: Consistent JSON response structure across all API endpoints.
- **Infrastructure as Code**: Basic AWS infrastructure defined using Terraform.
- **Performance Monitoring**: CloudWatch metrics and dashboards for operational visibility.

## Core Modules

### 1. Unique Skiers Counter API
- Tracks the count of distinct skiers at a resort for a specific season and day.
- Endpoint: `GET /resorts/{resortID}/seasons/{seasonID}/day/{dayID}/skiers`
- Response: `{"time": "Mission Ridge", "numSkiers": 1234}`

### 2. Skier Day Vertical API
- Calculates the total vertical distance traveled by a skier on a specific day.
- Endpoint: `GET /skiers/{resortID}/seasons/{seasonID}/days/{dayID}/skiers/{skierID}`
- Response: `{"TotalVertical": 56789}`

### 3. Skier Total Vertical API
- Aggregates vertical distances across multiple seasons for a skier at a specific resort.
- Endpoint: `GET /skiers/{skierID}/vertical?resort={resortID}&season={seasonID}`
- Response: `{"resorts": [{"seasonID": 2022, "totalVert": 24680}, {"seasonID": 2023, "totalVert": 13579}]}`

## Cloud Architecture

This application is deployed on AWS with core infrastructure defined in Terraform:

### Networking
- **VPC**: Isolated network environment with public and private subnets across availability zones
- **Internet Gateway**: For public internet access
- **Security Groups**: Precisely defined access controls for the application

### Database
- **DynamoDB**: NoSQL database with optimized indexes for skier analytics queries
  - Global Secondary Indexes for efficient query patterns
  - On-demand capacity to handle variable workloads

### Monitoring
- **CloudWatch Dashboards**: Visualize key application and infrastructure metrics
- **CloudWatch Alarms**: Automated alerting for performance issues
- **SNS Notifications**: Real-time alerts for critical events

## Dependencies

- [Java Servlet API](https://javaee.github.io/servlet-spec/): For handling HTTP requests and responses.
- [AWS SDK for Java](https://aws.amazon.com/sdk-for-java/): For DynamoDB integration.
- [Jedis](https://github.com/redis/jedis): Java client for Redis cache operations.
- [JSON-Java](https://github.com/stleary/JSON-java): For JSON parsing and generation.
- [Google Gson](https://github.com/google/gson): For JSON serialization/deserialization.
- [Terraform](https://www.terraform.io/): For infrastructure as code.

## Technical Architecture

### API Layer
- **Java Servlets**: Each module uses dedicated servlets to handle HTTP requests.
- **URL Pattern Validation**: Regular expressions to validate request URL patterns.
- **Request Handling**: Support for GET requests with path and query parameters.

### Service Layer
- **Business Logic**: Service classes implementing core functionality for each module.
- **Request Processing**: Orchestrates the flow between cache and database layers.
- **Data Transformation**: Converts database records to appropriate API response formats.

### Data Access Layer
- **Redis Cache**: First-level access for frequently requested data.
- **DynamoDB Client**: Secondary storage for persistent data.
- **Connection Pooling**: Efficient management of cache and database connections.

### Response Handling
- **Interface-based Design**: Standard response handling through shared interfaces.
- **JSON Formatting**: Consistent JSON response structure.
- **Error Handling**: Comprehensive exception management with appropriate HTTP status codes.

## Implementation Details

### Performance Optimization
- **Caching Strategy**: Check cache first, then query database if needed.
- **Thread Pooling**: Configurable thread pools for concurrent request processing.
- **DynamoDB Indexing**: Secondary indexes for efficient query patterns.

### Data Flow
1. Client makes HTTP request to an API endpoint.
2. Servlet validates the request and extracts parameters.
3. Service layer attempts to retrieve data from Redis cache.
4. If cache miss occurs, service queries DynamoDB.
5. Results are formatted as JSON and returned to the client.
6. If database query succeeded, results are stored in cache for future requests.
7. Key metrics are logged to CloudWatch for monitoring.

## Deployment

### Prerequisites
- AWS Account with appropriate permissions
- Terraform 1.0+ installed
- AWS CLI configured with appropriate credentials
- Java 11+ for application development

### Infrastructure Deployment
1. Navigate to the terraform directory
2. Initialize Terraform: `terraform init`
3. Review the deployment plan: `terraform plan`
4. Apply the infrastructure changes: `terraform apply`

### Application Deployment
1. Build the Java application using Maven: `mvn clean package`
2. Deploy the application to your preferred application server

## Monitoring

### CloudWatch Metrics
The application tracks key performance indicators:
- API request counts and latencies
- Cache hit/miss ratios
- DynamoDB read/write units consumed
- Business metrics (unique skiers, vertical distances)

### Dashboard
A CloudWatch dashboard provides visualization of:
- DynamoDB throughput and throttling events
- Custom business metrics for skier analytics

## Configuration

- **AWS DynamoDB**: Update credentials and region in `Constants.java`.
- **Redis Cache**: Configure host and port in `Constants.java`.
- **Thread Pooling**: Adjust thread pool sizes based on expected load.
- **Infrastructure**: Modify Terraform variables in `variables.tf` for environment-specific settings.

## Output

All APIs return standardized JSON responses with appropriate HTTP status codes:
- **200 OK**: Successful request with JSON data.
- **400 Bad Request**: Invalid URL pattern or parameters.
- **404 Not Found**: No data found for the specified parameters.
- **405 Method Not Allowed**: Using methods other than GET.
- **500 Internal Server Error**: Server-side errors with error message.

## Contributors

- Yashvi Garg (https://github.com/YashviGarg)
