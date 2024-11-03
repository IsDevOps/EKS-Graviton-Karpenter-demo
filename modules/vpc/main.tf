# Data block for the existing VPC
data "aws_vpc" "main" {
  id = var.existing_vpc_id
}

# Data block for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Resource to create subnets
# Using a custom CIDR block for subnets within the defined range
resource "aws_subnet" "main" {
  count                   = var.subnet_count
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = cidrsubnet("10.0.128.0/20", 4, count.index)  # Adjust the prefix length if necessary
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "my-subnet-${count.index + 1}"
  }
}


# Resource for Internet Gateway
# Data block to find the existing Internet Gateway
data "aws_internet_gateway" "existing_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.existing_vpc_id]
  }
}

# Use the existing Internet Gateway instead of creating a new one
resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.main.id

  route {
    cidr_block              = "0.0.0.0/0"
    gateway_id              = data.aws_internet_gateway.existing_igw.id
  }
}
