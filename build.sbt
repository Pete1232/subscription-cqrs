val projectName = "subscription-cqrs"

val sharedSettings = Seq(
  organization := "com.pete1232",
  scalaVersion := "2.13.8",
  scmInfo := Some(
    ScmInfo(
      url("https://github.com/pete1232/subscription-cqrs"),
      "https://github.com/pete1232/subscription-cqrs.git"
    )
  )
)

lazy val root = (project in file("."))
  .settings(
    name := projectName,
    Global / onChangedBuildSource := ReloadOnSourceChanges,
    addCommandAlias(
      "runCore",
      "core/run"
    )
  )
  .settings(sharedSettings)
  .aggregate(core)

lazy val core = (project in file("core"))
  .enablePlugins(JavaAppPackaging)
  .enablePlugins(DockerPlugin)
  .settings(
    name := s"${projectName}-core"
  )
  .settings(sharedSettings)
