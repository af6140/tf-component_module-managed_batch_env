resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.vpc_name}_${var.app_tier}_${var.service}_ecs_instance_role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "ec2.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role" {
  role       = "${aws_iam_role.ecs_instance_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.vpc_name}_${var.app_tier}_${var.service}_ecs_instance_profile"
  role = "${aws_iam_role.ecs_instance_role.name}"
}

resource "aws_iam_role" "aws_batch_service_role" {
  name = "${var.vpc_name}_${var.app_tier}_${var.service}_aws_batch_service_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "batch.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role" {
  role       = "${aws_iam_role.aws_batch_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_batch_compute_environment" "managed" {
  compute_environment_name = "${var.vpc_name}_${var.app_tier}_${var.service}_batch_env"
  service_role             = "${aws_iam_role.aws_batch_service_role.arn}"
  type                     = "MANAGED"
  depends_on               = ["aws_iam_role_policy_attachment.aws_batch_service_role"]
  compute_resources {
    instance_role = "${aws_iam_instance_profile.ecs_instance_profile.arn}"

    instance_type = [
      "${var.instance_types}",
    ]

    max_vcpus = "${var.max_vcpus}"
    min_vcpus = "${var.min_vcpus}"
    desired_vcpus = "${var.min_vcpus}"

    security_group_ids = [
      "${var.security_group_ids}"
    ]

    subnets = [
      "${var.subnet_ids}",
    ]

    type = "EC2"

    ec2_key_pair = "${var.ssh_key_name}"

    tags {
        app_tier = "${var.app_tier}"
        service = "${var.service}"
        role = "batch"
    }
  }

  lifecycle {
      # so when run terraform it will not scale up it when it automatically scaled down.
      ignore_changes = ["desired_vcpus"]
  }
}