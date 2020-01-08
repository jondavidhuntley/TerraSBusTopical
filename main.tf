provider "azurerm" {
  version = "=1.28.0"
}

// Create ServiceBus Namespace
resource "azurerm_servicebus_namespace" "hweb_sbus_ns" {
  name                = "${var.prefix}-servicebus-namespace"
  location            = var.default_location
  resource_group_name = var.hweb_resource_group_name
  sku                 = var.poc_sbus_ns_sku
  tags = var.tags
}

// Create Topic
resource "azurerm_servicebus_topic" "sbus_topic" {
  name                = "hweb_poc_passage_published_topic"
  resource_group_name = var.hweb_resource_group_name
  namespace_name      = "${azurerm_servicebus_namespace.hweb_sbus_ns.name}"

  enable_partitioning = true
}

// Create Subscriptions
// Passage Listener
resource "azurerm_servicebus_subscription" "sbus_sub_passage_processor" {
  name                = "hweb_sbus_subscription_passage_processor"
  resource_group_name = var.hweb_resource_group_name
  namespace_name      = "${azurerm_servicebus_namespace.hweb_sbus_ns.name}"
  topic_name          = "${azurerm_servicebus_topic.sbus_topic.name}"
  max_delivery_count  = 1
}