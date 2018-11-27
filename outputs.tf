locals {
  ecs_cluster_arn = "${var.compute_resource_type == "EC2" ?  aws_batch_compute_environment.managed.0.ecs_cluster_arn : aws_batch_compute_environment.managed_spot.0.ecs_cluster_arn}"
  arn             = "${var.compute_resource_type == "EC2" ? aws_batch_compute_environment.managed.0.arn : aws_batch_compute_environment.managed_spot.0.arn}"
}

output "ecs_cluster_arn" {
  value = "${local.ecs_cluster_arn}"
}

output "arn" {
  value = "${local.arn}"
}
