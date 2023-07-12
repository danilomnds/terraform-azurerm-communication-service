resource "azurerm_communication_service" "communication_service" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  data_location = var.data_location
  tags                               = local.tags
  lifecycle {
    ignore_changes = [
      tags["create_date"]
    ]
  }
}

resource "azurerm_role_assignment" "rg_scope_contributor" {
  depends_on = [ azurerm_communication_service.communication_service ]
  for_each             = var.azure_ad_groups != [] ? toset(var.azure_ad_groups) : []
  scope                = azurerm_communication_service.communication_service.id
  role_definition_name = "Communication Service Custom"
  principal_id         = each.value
  lifecycle {
    ignore_changes = [
      scope
    ]
  }
}