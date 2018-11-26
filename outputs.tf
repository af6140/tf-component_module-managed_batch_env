output "ecs_cluster_arn" {
  value = "${var.compute_resource_type == "EC2" ?  aws_batch_compute_environment.managed.ecs_cluster_arn : aws_batch_compute_environment.managed_spot.ecs_cluster_arn}"
}

output "arn" {
  value = "${var.compute_resource_type == EC2 ? aws_batch_compute_environment.managed.arn : aws_batch_compute_environment.managed_spot.arn}"
}
