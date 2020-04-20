module "app_cluster" {
  source     = "./app_cluster"
  namespace  = var.namespace
  region     = var.region
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids
  tags       = var.tags
  enabled    = var.enabled
}
