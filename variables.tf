variable "businesses" {
  type = map(object({
    vpc_cidr           = string
    public_subnet_cidr = string
  }))
}
