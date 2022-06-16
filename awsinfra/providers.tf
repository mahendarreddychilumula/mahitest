provider "aws" {
        region    = var.region 
       access_key = var.access_key
     secret_key   = var.secret_key

  
}
  resource "aws_vpc" "mahi" {
      cidr_block   = var.vpc_cidr
    tags           = {
      "name"       = "mahi"
    }
  }
  resource "aws_subnet" "subnet" {
      count        = length(var.subnet_tags_name)
      cidr_block   = cidrsubnet(var.vpc_cidr,8,count.index)
    tags           =  {
        name       = var.subnet_tags_name[count.index]
    }   
 availability_zone =    format("${var.region}%s", count.index%2==0?"a":"b")
 vpc_id            = aws_vpc.mahi.id
   }
   resource "aws_internet_gateway" "mahi_igw" {
       vpc_id      = aws_vpc.mahi.id
      tags = {name ="mahi_igw" }


   }

  resource "aws_security_group" "websg" {
    vpc_id              = aws_vpc.mahi.id
    description         = local.default_description
    ingress {
        from_port       = local.ssh_port
        to_port         = local.ssh_port
        protocol        = local.tcp
        cidr_blocks     = [local.any_where]
    } 
    ingress {
        from_port       = local.http_port
        to_port         = local.http_port
        protocol        = local.tcp
        cidr_blocks     = [local.any_where]
    }
    egress {
        from_port       = local.all_ports
        to_port         = local.all_ports
        protocol        = local.any_protocol
        cidr_blocks      = [var.vpc_cidr]
        ipv6_cidr_blocks = [local.any_where_ip6]
    }
    tags = {
        Name            = "Web Security"
    } 

}

resource "aws_security_group" "appsg" {
    vpc_id              = aws_vpc.mahi.id
    description         = local.default_description
    ingress {
        from_port       = local.ssh_port
        to_port         = local.ssh_port
        protocol        = local.tcp
        cidr_blocks     = [local.any_where]
    } 
    ingress {
        from_port       = local.app_port
        to_port         = local.app_port
        protocol        = local.tcp
        cidr_blocks     = [var.vpc_cidr]
    }
    egress {
        from_port       = local.all_ports
        to_port         = local.all_ports
        protocol        = local.any_protocol
        cidr_blocks      = [var.vpc_cidr]
        ipv6_cidr_blocks = [local.any_where_ip6]
    }
    tags = {
        Name            = "App Security Group"
    } 
}