rootProject.name = "tbankDataEngineering"

include("L01")
include("L02")
include("L03")
include("L04")
include("L05")
include("L06")
include("L07")
include("L08")
include("L09")
include("L10")

pluginManagement {
    val dependencyManagement: String by settings
    val springframeworkBoot: String by settings

    plugins {
        id("io.spring.dependency-management") version dependencyManagement
        id("org.springframework.boot") version springframeworkBoot
    }
}