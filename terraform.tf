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

#Define the execution role for our lambda and its basic permissions
resource "aws_iam_role" "hello_world_lambda_execution_role" {
  name               = "terraform-practice-hello-world-role"
  assume_role_policy = "${file("lambda-assume-role-policy.json")}"
}

resource "aws_iam_role_policy_attachment" "hello_world_lambda_execution_role_policy_attachment" {
  role       = "${aws_iam_role.hello_world_lambda_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#Define the Hello World lambda
resource "aws_lambda_function" "hello_world_lambda" {
  function_name    = "terraform-practice-hello-world"
  s3_bucket        = "terraform-practice-builds-ap-southeast-2"
  s3_key           = "deploy.zip"
  source_code_hash = "${base64sha256(file("deploy/deploy.zip"))}"
  runtime          = "nodejs6.10"
  handler          = "index.helloWorld"
  role             = "${aws_iam_role.hello_world_lambda_execution_role.arn}"
}

#Define our API Gateway into the Lambda
resource "aws_api_gateway_rest_api" "terraform_practice_api" {
  name = "Terraform Practice API"
}

#Define a mock endpoint at the '/' root of our API to return a blank response
resource "aws_api_gateway_method" "root_mock_get_endpoint" {
  rest_api_id   = "${aws_api_gateway_rest_api.terraform_practice_api.id}"
  resource_id   = "${aws_api_gateway_rest_api.terraform_practice_api.root_resource_id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "root_mock_get_endpoint_integration" {
  rest_api_id   = "${aws_api_gateway_rest_api.terraform_practice_api.id}"
  resource_id   = "${aws_api_gateway_rest_api.terraform_practice_api.root_resource_id}"
  http_method = "GET"
  type = "MOCK"
}

resource "aws_api_gateway_integration_response" "root_mock_get_endpoint_integration_response" {
  rest_api_id   = "${aws_api_gateway_rest_api.terraform_practice_api.id}"
  resource_id   = "${aws_api_gateway_rest_api.terraform_practice_api.root_resource_id}"
  http_method = "GET"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "root_mock_get_endpoint_response" {
  rest_api_id   = "${aws_api_gateway_rest_api.terraform_practice_api.id}"
  resource_id   = "${aws_api_gateway_rest_api.terraform_practice_api.root_resource_id}"
  http_method = "GET"
  status_code = "200"
}