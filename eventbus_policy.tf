##############################################
# Default Event Bus Policy - Restrict Access #
##############################################

# This policy restricts who can put events on the default event bus.
# Only AWS services (via service principals) and the management account itself
# are allowed to publish events. This prevents unauthorized IAM entities
# from injecting spoofed events that could trigger the automation Lambda.

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_cloudwatch_event_bus_policy" "default_bus_policy" {
  event_bus_name = "default"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowAWSServicesOnly"
        Effect    = "Allow"
        Principal = "*"
        Action    = "events:PutEvents"
        Resource  = "arn:aws:events:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:event-bus/default"
        Condition = {
          StringEquals = {
            "aws:PrincipalIsAWSService" = "true"
          }
        }
      },
      {
        Sid       = "DenyNonServicePutEvents"
        Effect    = "Deny"
        Principal = "*"
        Action    = "events:PutEvents"
        Resource  = "arn:aws:events:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:event-bus/default"
        Condition = {
          StringNotEquals = {
            "aws:PrincipalIsAWSService" = "true"
          }
        }
      }
    ]
  })
}
