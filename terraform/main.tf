provider "aws" {
  region = var.aws_region
}

# VPC and Basic Networking
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

# Public subnet for API Gateway and Load Balancer
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

# Private subnet for application instances
resource "aws_subnet" "private" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index + 2)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-private-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-igw"
    Environment = var.environment
  }
}

# Route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.project_name}-public-route-table"
    Environment = var.environment
  }
}

# Route table association for public subnets
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Security group for application
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-app-sg"
  description = "Security group for Skier Analytics API application"
  vpc_id      = aws_vpc.main.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Application port access from VPC
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  # Outbound access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-app-sg"
    Environment = var.environment
  }
}

# DynamoDB table for skier data
resource "aws_dynamodb_table" "skier_data" {
  name         = "${var.project_name}-skier-data"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "skierID"
  range_key    = "dayID"

  attribute {
    name = "skierID"
    type = "N"
  }

  attribute {
    name = "dayID"
    type = "N"
  }

  attribute {
    name = "resortID"
    type = "N"
  }

  attribute {
    name = "seasonID"
    type = "N"
  }

  # Global Secondary Index for resort-specific queries
  global_secondary_index {
    name               = "ResortSeasonDayIndex"
    hash_key           = "resortID"
    range_key          = "seasonID"
    projection_type    = "INCLUDE"
    non_key_attributes = ["dayID", "verticalMeters"]
  }

  # Global Secondary Index for skier total vertical per resort queries
  global_secondary_index {
    name               = "SkierResortIndex"
    hash_key           = "skierID"
    range_key          = "resortID"
    projection_type    = "INCLUDE"
    non_key_attributes = ["seasonID", "verticalMeters"]
  }

  tags = {
    Name        = "${var.project_name}-skier-data"
    Environment = var.environment
  }
}

# CloudWatch dashboard for monitoring
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-dashboard"
  
  dashboard_body = jsonencode({
    widgets = [
      # DynamoDB Metrics
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/DynamoDB", "ConsumedReadCapacityUnits", "TableName", aws_dynamodb_table.skier_data.name],
            ["AWS/DynamoDB", "ConsumedWriteCapacityUnits", "TableName", aws_dynamodb_table.skier_data.name]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "DynamoDB Capacity Usage"
        }
      },
      
      # Custom Business Metrics
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["${var.project_name}", "UniqueSkiersCount", "ResortId", "ALL"],
            ["${var.project_name}", "TotalVerticalMeters", "ResortId", "ALL"]
          ]
          period = 3600
          stat   = "Sum"
          region = var.aws_region
          title  = "Skier Activity Metrics"
        }
      }
    ]
  })
}

# SNS Topic for Monitoring Alerts
resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-alerts"
}

# DynamoDB Throttling Alarm
resource "aws_cloudwatch_metric_alarm" "dynamodb_throttles" {
  alarm_name          = "${var.project_name}-dynamodb-throttles"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ReadThrottleEvents"
  namespace           = "AWS/DynamoDB"
  period              = 300
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "This alarm monitors DynamoDB read throttling"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  dimensions = {
    TableName = aws_dynamodb_table.skier_data.name
  }
}
