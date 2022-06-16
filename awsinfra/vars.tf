variable "region" {
    type    = string
    default = "ap-southeast-1"
  
}
variable "vpc_cidr" {
type =  string
default = "10.1.0.0/16"

}
variable "subnet_tags_name" {
type =  list(string)
default = [ "web1", "web2", "app1", "app2", "db1", "db2"]
}
variable "access_key" {
type =  string
default ="AKIAQ4RES4LWHOSGN7CH"
}
variable "secret_key" {
type =  string
default ="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"
}

