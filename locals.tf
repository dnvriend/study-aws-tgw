locals {
  # ---- network settings

  vpc = {
    vpc1 = {
      cidr      = "10.1.0.0/16"
      private_a = "10.1.0.0/24"
      public_a  = "10.1.1.0/24"
    }
    vpc2 = {
      cidr      = "10.2.0.0/16"
      private_a = "10.2.0.0/24"
      public_a  = "10.2.1.0/24"
    }
    vpc3 = {
      cidr      = "10.3.0.0/16"
      private_a = "10.3.0.0/24"
      public_a  = "10.3.1.0/24"
    }
  }

  ami      = "ami-006c19cfa0e8f4672" # AMZ Linux 2 ARM
  region   = "eu-west-1"
  instance = "t4g.nano"

  # ---- name and tags
  name = "study-aws-tgw"
}
