terraform {
  backend "s3" {
    bucket = "chrislewisdev-terraform"
    key    = "terraform-practic/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

provider "aws" {
    region = "ap-southeast-2"
}

resource "aws_iam_role" "hello_world_lambda_execution_role" {
    name = "terraform-practice-hello-world-role"
    assume_role_policy = "${file("lambda-assume-role-policy.json")}"
}

resource "aws_iam_role_policy_attachment" "hello_world_lambda_execution_role_policy_attachment" {
    role = "${aws_iam_role.hello_world_lambda_execution_role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "hello_world_lambda" {
    function_name = "terraform-practice-hello-world"
    s3_bucket = "terraform-practice-builds-ap-southeast-2"
    s3_key = "deploy.zip"
    runtime = "nodejs6.10"
    handler = "index.helloWorld"
    role = "${aws_iam_role.hello_world_lambda_execution_role.arn}"
}