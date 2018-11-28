locals {
  ecs_cluster_arn = "${element(concat(aws_batch_compute_environment.managed.*.ecs_cluster_arn, aws_batch_compute_environment.managed_spot.*.ecs_cluster_arn),0)}"
  arn             = "${element(concat(aws_batch_compute_environment.managed.*.arn ,aws_batch_compute_environment.managed_spot.*.arn),0)}"
  name            = "${element(concat(aws_batch_compute_environment.managed.*.compute_environment_name  ,aws_batch_compute_environment.managed_spot.*.compute_environment_name ),0)}"
}

output "ecs_cluster_arn" {
  value = "${local.ecs_cluster_arn}"
}

output "arn" {
  value = "${local.arn}"
}

output "name" {
  value = "${local.name}"
}
