output "ecs_cluster_arn" {
    value = "${aws_batch_compute_environment.managed.ecs_cluster_arn}"
}