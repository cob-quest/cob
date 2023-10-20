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

k8s_yaml("./secrets.yml")
k8s_yaml(helm("./k8s/mongodb-charts/helm/", name="mongodb"), allow_duplicates=True)
k8s_yaml(helm("./k8s/rabbitmq-charts/helm/", name="rabbitmq"), allow_duplicates=True)

# for each module, build and deploy them
for m in modules:
  image_tag = registry + '/' + m["image_repo"] + '/main'
  context = './' + m["image_repo"]
  dockerfile = './' + m["image_repo"] + '/docker/Dockerfile.dev'
  chart = 'k8s/' + m["chart_repo"] + '/helm/'

  docker_build(image_tag, context, dockerfile=dockerfile)
  k8s_yaml(helm(chart, name=m["image_repo"]), allow_duplicates=True)
