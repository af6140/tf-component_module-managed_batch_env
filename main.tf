resource "random_id" "compute_env" {
  keepers = {
    # Generate a new id each time we switch to a new AMI id
    instance_types        = "${join(",",var.instance_types)}"
    security_group_ids    = "${join(",",var.security_group_ids)}"
    subnet_ids            = "${join(",",var.subnet_ids)}"
    ecs_instance_role_arn = "${var.instance_role_arn}"
    ec2_key_pair          = "${var.ssh_key_name}"
  }

  byte_length = 8
}

resource "aws_batch_compute_environment" "managed" {
  compute_environment_name = "${var.vpc_name}_${var.app_tier}_${var.service}_batch_env_${random_id.compute_env.hex}"
  service_role             = "${var.service_role_arn}"
  type                     = "MANAGED"

  #depends_on               = ["aws_iam_role_policy_attachment.aws_batch_service_role"]

  depends_on = "${random_id.compute_env}"
  compute_resources {
    instance_role = "${random_id.compute_env.keepers.ecs_instance_role_arn}"

    instance_type = [
      "${split(",",random_id.compute_env.keepers.instance_types)}",
    ]

    max_vcpus     = "${var.max_vcpus}"
    min_vcpus     = "${var.min_vcpus}"
    desired_vcpus = "${var.min_vcpus}"

    security_group_ids = [
      "${split(",",random_id.compute_env.keepers.security_group_ids)}",
    ]

    subnets = [
      "${split(",",random_id.compute_env.keepers.subnet_ids)}",
    ]

    type         = "EC2"
    ec2_key_pair = "${random_id.compute_env.keepers.ec2_key_pair}"

    tags {
      app_tier = "${var.app_tier}"
      service  = "${var.service}"
      role     = "batch"
    }
  }
  lifecycle {
    # so when run terraform it will not scale up it when it automatically scaled down.
    ignore_changes        = ["desired_vcpus", "compute_resources.0.desired_vcpus", "tags"]
    create_before_destroy = true
  }
  count = "${var.compute_resource_type == "EC2" ? 1 :0 }"
}

resource "aws_batch_compute_environment" "managed_spot" {
  compute_environment_name = "${var.vpc_name}_${var.app_tier}_${var.service}_batch_spotenv_${random_id.compute_env.hex}"
  service_role             = "${var.service_role_arn}"
  type                     = "MANAGED"

  #depends_on               = ["aws_iam_role_policy_attachment.aws_batch_service_role"]

  compute_resources {
    instance_role = "${var.instance_role_arn}"

    instance_type = [
      "${split(",",random_id.compute_env.keepers.instance_types)}",
    ]

    max_vcpus = "${var.max_vcpus}"
    min_vcpus = "${var.min_vcpus}"

    desired_vcpus = "${var.min_vcpus}"

    security_group_ids = [
      "${split(",",random_id.compute_env.keepers.security_group_ids)}",
    ]

    subnets = [
      "${split(",",random_id.compute_env.keepers.subnet_ids)}",
    ]

    type         = "SPOT"
    ec2_key_pair = "${var.ssh_key_name}"

    tags {
      app_tier = "${var.app_tier}"
      service  = "${var.service}"
      role     = "batch"
    }
  }
  lifecycle {
    # so when run terraform it will not scale up it when it automatically scaled down.
    ignore_changes        = ["desired_vcpus", "compute_resources.0.desired_vcpus", "tags"]
    create_before_destroy = true
  }
  count               = "${var.compute_resource_type == "SPOT" ? 1 :0 }"
  spot_iam_fleet_role = "${var.spot_fleet_role_arn}"
}
