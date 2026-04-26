package terraform.policies.only_t2_micro

import rego.v1

# Tipos de instancia permitidos
allowed_instance_types := {"t2.micro"}

# Mensaje de error
deny contains msg if {
    some resource in input.resource_changes
    resource.type == "aws_instance"
    instance_type := resource.change.after.instance_type
    not instance_type in allowed_instance_types
    msg := sprintf(
        "ERROR: La instancia EC2 '%s' usa el tipo '%s'. Solo se permite el tipo 't2.micro'.",
        [resource.address, instance_type]
    )
}
