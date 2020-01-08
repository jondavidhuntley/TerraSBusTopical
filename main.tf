provider "azurerm" {
  version = "=1.28.0"
}

// Existing Key Vault
data "azurerm_key_vault" "huntleywebKV" {
  name                = var.key_vault_name
  resource_group_name = var.hweb_resource_group_name
}

// Read Existing Key Vault Data
data "azurerm_key_vault_secret" "HollybeckDataBaseConnectionSecret" {
  name         = "HollybeckDatabaseConnection"
  key_vault_id = "${data.azurerm_key_vault.huntleywebKV.id}"
}

// Create Service Plan
resource "azurerm_app_service_plan" "service_plan" {
  name                = var.app_service_plan_name 
  location            = var.default_location
  resource_group_name = var.hweb_resource_group_name
  kind                = "Windows"

  sku {
    tier = var.app_service_plan_tier
    size = var.app_service_plan_size
  }

  tags = var.tags
}

// Create Application Insights
resource "azurerm_application_insights" "app_insights" {
  name                = "${var.prefix}-hollybeck-api-insights"
  location            = var.default_location
  resource_group_name = var.hweb_resource_group_name
  application_type    = "Web"
}

// Create App Service - Hollybeck API
resource "azurerm_app_service" "app_service" {
  name                = "${var.prefix}-hollybeck-api"
  location            = var.default_location
  resource_group_name = var.hweb_resource_group_name 
  app_service_plan_id =  "${azurerm_app_service_plan.service_plan.id}"
         
   site_config {
    //always_on                 = true
    http2_enabled             = var.https_only    
    use_32_bit_worker_process = true
    dotnet_framework_version = "v4.0"
  }

  connection_string {
    name  = "HollybeckDatabase"
    type  = "SQLServer"
    value = "${data.azurerm_key_vault_secret.HollybeckDataBaseConnectionSecret.value}"
  }

  tags = var.tags

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.app_insights.instrumentation_key}"
    "WEBSITE_WEBDEPLOY_USE_SCM" = "false"
    //"TokenServiceUri" = "https://em-si.eu.auth0.com/"
    //"Audience" = "${var.auth0AudienceHost}taa-airline-api/"
    "SwaggerTitle" = "Hollybeck API"
    "SwaggerDescription" = "RESTful Service API for consumption by Associated Garden Centres"
    "SwaggerVersion" = "v1"
  }  
}