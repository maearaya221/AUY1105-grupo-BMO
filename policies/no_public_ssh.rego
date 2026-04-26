package terraform.policies.no_public_ssh

import rego.v1

# Mensaje de error
deny contains msg if {
    some resource in input.resource_changes
    resource.type == "aws_security_group"
    some change in resource.change.after.ingress
    change.from_port <= 22
    change.to_port >= 22
    "0.0.0.0/0" in change.cidr_blocks
    msg := sprintf(
        "ERROR: El Security Group '%s' permite acceso SSH publico desde 0.0.0.0/0. Restrinja el acceso SSH a un CIDR especifico.",
        [resource.address]
    )
}
