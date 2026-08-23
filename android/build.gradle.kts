allprojects {
    repositories {
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/central") }
        maven { url = uri("https://maven.aliyun.com/repository/public") }
        maven { url = uri("https://maven.aliyun.com/repository/gradle-plugin") }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    afterEvaluate {
        if (project.hasProperty("android")) {
            val android = project.extensions.findByName("android")
            if (android != null) {
                try {
                    val compileSdkMethod = android.javaClass.getMethod("setCompileSdk", Integer::class.java)
                    compileSdkMethod.invoke(android, 36)
                } catch (e: Exception) {
                    try {
                        val compileSdkMethod2 = android.javaClass.getMethod("setCompileSdkVersion", Integer::class.java)
                        compileSdkMethod2.invoke(android, 36)
                    } catch (e2: Exception) {
                        try {
                            val compileSdkMethod3 = android.javaClass.getMethod("compileSdkVersion", Int::class.javaPrimitiveType)
                            compileSdkMethod3.invoke(android, 36)
                        } catch (e3: Exception) {}
                    }
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}