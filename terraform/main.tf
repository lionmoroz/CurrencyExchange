resource "aws_instance" "my_instance" {
  ami           = var.instance_ami
  instance_type = var.instance_type

  key_name  = var.instance_key_name
  user_data = file("startup_script.sh")


  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name = var.instance_tag
  }
}


resource "aws_security_group" "my_security_group" {
  name        = var.secure_group_name
  description = "Security group for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.secure_group_name
  }
}

resource "aws_iam_user" "example_user" {
  name = var.user_name
}

resource "aws_iam_user_policy" "example_user_policy" {
  name   = var.user_policy_name
  user   = aws_iam_user.example_user.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:DescribeInstances",
      "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "ec2:StartInstances",
            "ec2:StopInstances",
            "ec2:RebootInstances",
            "ec2-instance-connect:SendSSHPublicKey"
           ],
            "Resource": ["arn:aws:ec2:eu-north-1:${data.aws_caller_identity.current.account_id}:instance/${aws_instance.my_instance.id}"]
    },
    {
         "Effect": "Allow",
         "Action": [
           "ec2:DescribeSecurityGroupRules",
           "ec2:DescribeTags",
           "ec2:DescribeSecurityGroups"
         ],
         "Resource": "*"
       },
       {
         "Effect": "Allow",
         "Action": [
           "ec2:RevokeSecurityGroupIngress",
           "ec2:AuthorizeSecurityGroupIngress",
           "ec2:ModifySecurityGroupRules"
        ],
        "Resource": [
          "arn:aws:ec2:eu-north-1:${data.aws_caller_identity.current.account_id}:security-group/${aws_security_group.my_security_group.id}",
          "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:security-group-rule/*"
        ]
    }
  ]
}
EOF
}

data "aws_caller_identity" "current" {}