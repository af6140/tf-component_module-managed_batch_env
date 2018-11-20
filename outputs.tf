output "ecs_cluster_arn" {
  value = "${aws_batch_compute_environment.managed.ecs_cluster_arn}"
}

output "arn" {
  value = "${aws_batch_compute_environment.managed.arn}"
}

output "ec2_instance_role" {
  value = "${aws_iam_role.ecs_instance_role.arn}"
}

output "service_role" {
  value = "${aws_iam_role.aws_batch_service_role}"
}
