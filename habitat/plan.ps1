# The plan file tells Habitat how to build a package.
#
# In this plan, we're asking Habitat to provide us with Node.js and NPM
# (by declaring a dependency on the core/node package) so we can install our
# application's JavaScript dependencies (and ultimately run our app). Then we
# copy the files we'll need to run the package into a directory in the Habitat
# Studio that will become the resulting package.
#
# To learn more about writing Habitat plans, see Developing Packages
# in the Habitat docs at https://www.habitat.sh/docs/developing-packages.
#
# To explore all Habitat-maintained and community-contributed packages,
# visit the Habitat Builder depot at https://bldr.habitat.sh/#/pkgs.

$pkg_name="sample-node-app-windows"
$pkg_origin="gscho"
$pkg_version="1.0.0"
$pkg_deps=@("core/node")
$pkg_svc_user="root"

# Habitat provides you with a number of built-in "callbacks" to use
# in the course of your build, all of which are explained in the docs
# at https://habitat.sh/docs/reference/#reference-callbacks.
#
# Here, we're implementing the do_build and do_install callbacks
# to install dependencies and assemble the application package.

function Invoke-Build {
  Push-Location ${PLAN_CONTEXT}\..

  # By default, we're in the directory in which the Studio was entered
  # (in this case, presumably the project root), so we can run commands
  # as though we were in that same directory. By the time we reach this
  # callback, `npm` will have been installed for us.
  npm install foobar
  Pop-Location
}

function Invoke-Install{

  # The `pkg_prefix` variable contains the fully-qualified Studio-relative path to
  # a specific build run (e.g., /hab/pkgs/<YOUR_ORIGIN>/sample-node-app-windows/1.0.0/20190620174915).
  # In this callback, we copy the files that our application requires at runtime
  # into that directory, and once this step completes, Habitat will take
  # over to produce the finished package as a .hart file.
  mkdir -p "$pkg_prefix\app"

  Push-Location ${PLAN_CONTEXT}\..
  Copy-Item -Path node_modules,public,routes,views,package.json,app.js,index.js -Destination "$pkg_prefix\app" -Recurse -ErrorAction SilentlyContinue
  Pop-Location
}
