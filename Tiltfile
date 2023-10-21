# namespace plugin
load('ext://namespace', 'namespace_inject', 'namespace_create')
trigger_mode(TRIGGER_MODE_MANUAL)

namespace = "platform"

registry = "registry.gitlab.com/cs302-2023/g3-team8/project"
modules = [
  {
      "image_repo": "assignment-service",
      "chart_repo": "assignment-charts",
  },
  {
      "image_repo": "platform-api",
      "chart_repo": "platform-api-charts",
  },
  {
      "image_repo": "platform-frontend",
      "chart_repo": "platform-frontend-charts",
  },
  {
      "image_repo": "process-engine",
      "chart_repo": "process-engine-charts",
  },
  {
      "image_repo": "trigger-api",
      "chart_repo": "trigger-api-charts",
  },
]

# create the namespace
namespace_create(namespace)

# deploy secrets first
k8s_yaml(namespace_inject(read_file("./secrets.yml"), namespace))

# deploy mongodb and rabbitmq
k8s_yaml(namespace_inject(helm("./k8s/mongodb-charts/helm/", name="mongodb"), namespace ), allow_duplicates=False)
k8s_yaml(namespace_inject(helm("./k8s/rabbitmq-charts/helm/", name="rabbitmq"), namespace ), allow_duplicates=False)

# for each module
for m in modules:
  image_tag = registry + '/' + m["image_repo"] + '/main'
  context = './' + m["image_repo"]
  dockerfile = './' + m["image_repo"] + '/docker/Dockerfile.dev'
  chart = 'k8s/' + m["chart_repo"] + '/helm/'

  # build it
  docker_build(
  image_tag, 
  context, 
  dockerfile=dockerfile,
  live_update=[
    sync('./' + m["image_repo"], '/app')
  ], 
  extra_tag=["latest"])

  # and deploy it with helm
  k8s_yaml(namespace_inject(helm(chart, name=m["image_repo"]), namespace), allow_duplicates=False)

# create traefik last
k8s_yaml(namespace_inject(helm("./k8s/traefik-charts/helm/", name="traefik"), namespace), allow_duplicates=False)
