provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "us-east-1"
  alias = "us-east-1"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}
data "template_file" "ogp_function" {
  template = "${file("../lambda/ogp.js")}"
}

data "archive_file" "ogp_function" {
  type        = "zip"
  output_path = "lambda/ogp.zip"

  source {
    content  = "${data.template_file.ogp_function.rendered}"
    filename = "ogp.js"
  }
}

resource "aws_lambda_function" "ogp" {
  provider         = "aws.us-east-1"
  filename         = "lambda/ogp.zip"
  function_name    = "ogp"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "ogp.handler"
  source_code_hash = "${data.archive_file.ogp_function.output_base64sha256}"
  runtime          = "nodejs8.10"
  description      = "OGP"
  publish          = true
}